Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF71957F8;
	Thu,  5 Sep 2024 09:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530035; cv=none; b=QPWMcqqOAHy83Vs19Iy6Qefdo3g9jeeQYp+451W8LuT+npG9/1IizRTioe5qjy7SFcDKQki3tB01AkJ51kyQUVIvks8T4K4lsrnl7JJ8zhRcrodXQjiOTKJatK2mFpr/YJSvUfEmFDnjOhqWvDa0EhZLoCdye6mOseudALbE6E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530035; c=relaxed/simple;
	bh=1NMql0+E29iTov+TGDnVz6gbRIKmwot9slCD+q2x7RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLwtEzAFHVhd80bGv4ls/EGs+Q6YqV/neWLlIYObI/zAm4VRTVFB0j4wVlyRMxGPSzbiMJVnmzBH3iN5KWFqVZLcgg201M0qZ01AI0N6R3XyGBHs0tje09P55ZEVRVXvlXhqGLAhq+ZTf/2FrOalTV16DIBkjW3REbFEcvnZFC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bU726aAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bU726aAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28754C4CEC4;
	Thu,  5 Sep 2024 09:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530035;
	bh=1NMql0+E29iTov+TGDnVz6gbRIKmwot9slCD+q2x7RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bU726aAFaeoJYdrzTCNMUFxHOIgr5trtNwcH0fQ9tEgmO8mp/kAqGHBsbpdQg/08q
	 +mpC/Z6byrdfOWuCjbUnJWFBnhvhG2iCRA2ulBuiSBeR1R9SyD20Mfd6r5bUV0lvUt
	 85Ae37FWf9UjhHZXttDkK7DGuy3PR8Uq89CzkTS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/132] selftests: mptcp: declare event macros in mptcp_lib
Date: Thu,  5 Sep 2024 11:40:14 +0200
Message-ID: <20240905093723.293395102@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 23a0485d1c0491a3044026263cf9a0acd33d30a2 ]

MPTCP event macros (SUB_ESTABLISHED, LISTENER_CREATED, LISTENER_CLOSED),
and the protocol family macros (AF_INET, AF_INET6) are defined in both
mptcp_join.sh and userspace_pm.sh. In order not to duplicate code, this
patch declares them all in mptcp_lib.sh with MPTCP_LIB_ prefixs.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240308-upstream-net-next-20240308-selftests-mptcp-unification-v1-14-4f42c347b653@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e93681afcb96 ("selftests: mptcp: join: cannot rm sf if closed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 23 ++++++++-----------
 .../testing/selftests/net/mptcp/mptcp_lib.sh  | 11 +++++++++
 .../selftests/net/mptcp/userspace_pm.sh       | 18 +++++++--------
 3 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f03df10947c15..71404a4241f4a 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2894,13 +2894,6 @@ backup_tests()
 	fi
 }
 
-SUB_ESTABLISHED=10 # MPTCP_EVENT_SUB_ESTABLISHED
-LISTENER_CREATED=15 #MPTCP_EVENT_LISTENER_CREATED
-LISTENER_CLOSED=16  #MPTCP_EVENT_LISTENER_CLOSED
-
-AF_INET=2
-AF_INET6=10
-
 verify_listener_events()
 {
 	local evt=$1
@@ -2914,9 +2907,9 @@ verify_listener_events()
 	local sport
 	local name
 
-	if [ $e_type = $LISTENER_CREATED ]; then
+	if [ $e_type = $MPTCP_LIB_EVENT_LISTENER_CREATED ]; then
 		name="LISTENER_CREATED"
-	elif [ $e_type = $LISTENER_CLOSED ]; then
+	elif [ $e_type = $MPTCP_LIB_EVENT_LISTENER_CLOSED ]; then
 		name="LISTENER_CLOSED "
 	else
 		name="$e_type"
@@ -2983,8 +2976,10 @@ add_addr_ports_tests()
 		chk_add_nr 1 1 1
 		chk_rm_nr 1 1 invert
 
-		verify_listener_events $evts_ns1 $LISTENER_CREATED $AF_INET 10.0.2.1 10100
-		verify_listener_events $evts_ns1 $LISTENER_CLOSED $AF_INET 10.0.2.1 10100
+		verify_listener_events $evts_ns1 $MPTCP_LIB_EVENT_LISTENER_CREATED \
+				       $MPTCP_LIB_AF_INET 10.0.2.1 10100
+		verify_listener_events $evts_ns1 $MPTCP_LIB_EVENT_LISTENER_CLOSED \
+				       $MPTCP_LIB_AF_INET 10.0.2.1 10100
 		kill_events_pids
 	fi
 
@@ -3593,11 +3588,11 @@ userspace_tests()
 		userspace_pm_chk_get_addr "${ns1}" "10" "id 10 flags signal 10.0.2.1"
 		userspace_pm_chk_get_addr "${ns1}" "20" "id 20 flags signal 10.0.3.1"
 		userspace_pm_rm_addr $ns1 10
-		userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $SUB_ESTABLISHED
+		userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $MPTCP_LIB_EVENT_SUB_ESTABLISHED
 		userspace_pm_chk_dump_addr "${ns1}" \
 			"id 20 flags signal 10.0.3.1" "after rm_addr 10"
 		userspace_pm_rm_addr $ns1 20
-		userspace_pm_rm_sf $ns1 10.0.3.1 $SUB_ESTABLISHED
+		userspace_pm_rm_sf $ns1 10.0.3.1 $MPTCP_LIB_EVENT_SUB_ESTABLISHED
 		userspace_pm_chk_dump_addr "${ns1}" "" "after rm_addr 20"
 		chk_rm_nr 2 2 invert
 		chk_mptcp_info subflows 0 subflows 0
@@ -3624,7 +3619,7 @@ userspace_tests()
 			"subflow"
 		userspace_pm_chk_get_addr "${ns2}" "20" "id 20 flags subflow 10.0.3.2"
 		userspace_pm_rm_addr $ns2 20
-		userspace_pm_rm_sf $ns2 10.0.3.2 $SUB_ESTABLISHED
+		userspace_pm_rm_sf $ns2 10.0.3.2 $MPTCP_LIB_EVENT_SUB_ESTABLISHED
 		userspace_pm_chk_dump_addr "${ns2}" \
 			"" \
 			"after rm_addr 20"
diff --git a/tools/testing/selftests/net/mptcp/mptcp_lib.sh b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
index 8939d5c135a0e..d8766b270f307 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -8,6 +8,17 @@ readonly KSFT_SKIP=4
 # shellcheck disable=SC2155 # declare and assign separately
 readonly KSFT_TEST="${MPTCP_LIB_KSFT_TEST:-$(basename "${0}" .sh)}"
 
+# These variables are used in some selftests, read-only
+declare -rx MPTCP_LIB_EVENT_ANNOUNCED=6         # MPTCP_EVENT_ANNOUNCED
+declare -rx MPTCP_LIB_EVENT_REMOVED=7           # MPTCP_EVENT_REMOVED
+declare -rx MPTCP_LIB_EVENT_SUB_ESTABLISHED=10  # MPTCP_EVENT_SUB_ESTABLISHED
+declare -rx MPTCP_LIB_EVENT_SUB_CLOSED=11       # MPTCP_EVENT_SUB_CLOSED
+declare -rx MPTCP_LIB_EVENT_LISTENER_CREATED=15 # MPTCP_EVENT_LISTENER_CREATED
+declare -rx MPTCP_LIB_EVENT_LISTENER_CLOSED=16  # MPTCP_EVENT_LISTENER_CLOSED
+
+declare -rx MPTCP_LIB_AF_INET=2
+declare -rx MPTCP_LIB_AF_INET6=10
+
 MPTCP_LIB_SUBTESTS=()
 
 # only if supported (or forced) and not disabled, see no-color.org
diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 4e58291550498..59bdb17b2b7f4 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -23,15 +23,15 @@ if ! ip -Version &> /dev/null; then
 	exit ${KSFT_SKIP}
 fi
 
-ANNOUNCED=6        # MPTCP_EVENT_ANNOUNCED
-REMOVED=7          # MPTCP_EVENT_REMOVED
-SUB_ESTABLISHED=10 # MPTCP_EVENT_SUB_ESTABLISHED
-SUB_CLOSED=11      # MPTCP_EVENT_SUB_CLOSED
-LISTENER_CREATED=15 #MPTCP_EVENT_LISTENER_CREATED
-LISTENER_CLOSED=16  #MPTCP_EVENT_LISTENER_CLOSED
-
-AF_INET=2
-AF_INET6=10
+ANNOUNCED=${MPTCP_LIB_EVENT_ANNOUNCED}
+REMOVED=${MPTCP_LIB_EVENT_REMOVED}
+SUB_ESTABLISHED=${MPTCP_LIB_EVENT_SUB_ESTABLISHED}
+SUB_CLOSED=${MPTCP_LIB_EVENT_SUB_CLOSED}
+LISTENER_CREATED=${MPTCP_LIB_EVENT_LISTENER_CREATED}
+LISTENER_CLOSED=${MPTCP_LIB_EVENT_LISTENER_CLOSED}
+
+AF_INET=${MPTCP_LIB_AF_INET}
+AF_INET6=${MPTCP_LIB_AF_INET6}
 
 file=""
 server_evts=""
-- 
2.43.0



