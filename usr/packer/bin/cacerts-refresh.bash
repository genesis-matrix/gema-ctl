#!/bin/bash -u

##- <global_variables>
export uri_cacert_localfs=""
export uri_cacert_upstream="http://curl.haxx.se/ca/cacert.pem"
export uri_bundle_prefix="/usr/share/pki/ca-trust-source"
##- </global_variables>
##- <functions>
fn_lsb_bootstrap(){
    [[ -f /etc/redhat-release ]] \
	|| [[ -f /etc/centos-release ]] \
	&& yum -y install redhat-lsb-core
    [[ -f /etc/debian-release ]] \
	&& apt-get -y install lsb-release
}
fn_upd_cacerts_opt_00(){
    # update CA bundle using `update-ca-trust` tool and 
    mkdir -p "${uri_bundle_prefix}"
    curl "${uri_cacert_upstream}" -o "${uri_bundle_prefix}/ca-bundle_curl-upstream.$(date --rfc-3339=seconds | sed -ne 's/ /T/;s/://gp').crt" \
	&& update-ca-trust force-enable \
	&& update-ca-trust extract
}
fn_upd_cacerts_opt_01(){
    # update CA bundle using `update-ca-trust` tool and 
    local tmp_uri="/etc/pki/tls/certs/ca-bundle.crt"
    curl -L --insecure "${uri_cacert_upstream}" >> "${tmp_uri}"
}

##- </functions>
##- <Main>

fn_lsb_bootstrap ; sleep 5
osdistro=$(lsb_release -is 2>/dev/null)
osversion=$(lsb_release -rs 2>/dev/null)
echo "nfo: osdistro=${osdistro} ,, osversion=${osversion}"

case ${osdistro} in
    CentOS|RedHat)
	case ${osversion} in
	    5*)
		echo "dbg: match cent5"
		fn_upd_cacerts_opt_01
		;;
	    6*)
		echo "dbg: match cent6"
		fn_upd_cacerts_opt_00
		;;
	    7*)
		echo "dbg: match cent7"
		fn_upd_cacerts_opt_00
		;;
	    *)
		echo "wrn: no match, cent ?version?"
		fn_upd_cacerts_opt_00
		;;
	esac
	;;
    Ubuntu|Debian)
	echo "nfo: osdistro Ubuntu a/o Debian"
	echo "wrn: not implemented yet"
	;;
    *)
	echo "wrn: no match on osdistro"
	echo "wrn: not implemented yet"
	;;
esac	    
##- </Main>
