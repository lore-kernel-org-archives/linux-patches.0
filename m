Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327AC14A08E;
	Thu,  5 Sep 2024 09:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530007; cv=none; b=uZ/kqLOnG5UYhepVBouNE4OXfAVKRr4LSTQc2qMlFvLuJGoLue+XBdXuGVPLThVbw21OnBv0OOq88vApgRwXHI6sypsAGxOE0b2rqJIxk0vrm1PlDE5lYnhHsZo+kg4+v+FRh4zvZ8oLZvPivh4lyR+whcMxyya4wsQ+azW9ekE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530007; c=relaxed/simple;
	bh=qH+t1RXfGg1D7/b3igWvgGTkfzAP6mrIDiLpCsZ2WLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmMdy3nAD2M9Q7xKYxHAH1fJlPO3tYTLhdwVfhIeT8bJuxj9yC8Da7QQxFSgH+cAu9o6z9hDxSQDKT+0tz8oDx6djJAJ+OUEa3QKXfEgMYKdkp7CM9zcilrvZX99ebwYhKxUlvmKjqblo4RfC4uDMvrod6gZ/WU+T2rme02ZmME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lffRQ2DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lffRQ2DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90309C4CEC3;
	Thu,  5 Sep 2024 09:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530007;
	bh=qH+t1RXfGg1D7/b3igWvgGTkfzAP6mrIDiLpCsZ2WLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lffRQ2DYMAOPgmBK3f/aa/BdyCKUHxPsY02Ndg2bI5TQch/RqRRmOQA0Jp3rgQ5zg
	 1EZ+cXo80Ptc40l0IDyxlx7v+Vst8Af//i3CHInVlZDE/jK4o9tF1EbVwqU68213uH
	 FEENVVQ9C2MI2v7xdQ2TlMFUV0yGstjKtJ4sTL64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/132] selftests: mptcp: dump userspace addrs list
Date: Thu,  5 Sep 2024 11:40:12 +0200
Message-ID: <20240905093723.215114082@linuxfoundation.org>
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

[ Upstream commit 38f027fca1b724c6814fff4b8ad16b59c14a3e2a ]

This patch adds a new helper userspace_pm_dump() to dump addresses
for the userspace PM. Use this helper to check whether an ID 0 subflow
is listed in the output of dump command after creating an ID 0 subflow
in "userspace pm create id 0 subflow" test. Dump userspace PM addresses
list in "userspace pm add & remove address" test and in "userspace pm
create destroy subflow" test.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e93681afcb96 ("selftests: mptcp: join: cannot rm sf if closed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index d378f23bb31a6..df071b8c675fb 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -21,6 +21,7 @@ cinfail=""
 cinsent=""
 tmpfile=""
 cout=""
+err=""
 capout=""
 ns1=""
 ns2=""
@@ -187,6 +188,7 @@ init() {
 	cin=$(mktemp)
 	cinsent=$(mktemp)
 	cout=$(mktemp)
+	err=$(mktemp)
 	evts_ns1=$(mktemp)
 	evts_ns2=$(mktemp)
 
@@ -202,6 +204,7 @@ cleanup()
 	rm -f "$sin" "$sout" "$cinsent" "$cinfail"
 	rm -f "$tmpfile"
 	rm -rf $evts_ns1 $evts_ns2
+	rm -f "$err"
 	cleanup_partial
 }
 
@@ -3422,6 +3425,50 @@ userspace_pm_rm_sf()
 	wait_rm_sf $1 "${cnt}"
 }
 
+check_output()
+{
+	local cmd="$1"
+	local expected="$2"
+	local msg="$3"
+	local rc=0
+
+	mptcp_lib_check_output "${err}" "${cmd}" "${expected}" || rc=${?}
+	if [ ${rc} -eq 2 ]; then
+		fail_test "fail to check output # error ${rc}"
+	elif [ ${rc} -eq 0 ]; then
+		print_ok
+	elif [ ${rc} -eq 1 ]; then
+		fail_test "fail to check output # different output"
+	fi
+}
+
+# $1: ns
+userspace_pm_dump()
+{
+	local evts=$evts_ns1
+	local tk
+
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	tk=$(mptcp_lib_evts_get_info token "$evts")
+
+	ip netns exec $1 ./pm_nl_ctl dump token $tk
+}
+
+userspace_pm_chk_dump_addr()
+{
+	local ns="${1}"
+	local exp="${2}"
+	local check="${3}"
+
+	print_check "dump addrs ${check}"
+
+	if mptcp_lib_kallsyms_has "mptcp_userspace_pm_dump_addr$"; then
+		check_output "userspace_pm_dump ${ns}" "${exp}"
+	else
+		print_skip
+	fi
+}
+
 userspace_tests()
 {
 	# userspace pm type prevents add_addr
@@ -3513,10 +3560,16 @@ userspace_tests()
 		chk_mptcp_info subflows 2 subflows 2
 		chk_subflows_total 3 3
 		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
+		userspace_pm_chk_dump_addr "${ns1}" \
+			$'id 10 flags signal 10.0.2.1\nid 20 flags signal 10.0.3.1' \
+			"signal"
 		userspace_pm_rm_addr $ns1 10
 		userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $SUB_ESTABLISHED
+		userspace_pm_chk_dump_addr "${ns1}" \
+			"id 20 flags signal 10.0.3.1" "after rm_addr 10"
 		userspace_pm_rm_addr $ns1 20
 		userspace_pm_rm_sf $ns1 10.0.3.1 $SUB_ESTABLISHED
+		userspace_pm_chk_dump_addr "${ns1}" "" "after rm_addr 20"
 		chk_rm_nr 2 2 invert
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
@@ -3537,8 +3590,14 @@ userspace_tests()
 		chk_join_nr 1 1 1
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
+		userspace_pm_chk_dump_addr "${ns2}" \
+			"id 20 flags subflow 10.0.3.2" \
+			"subflow"
 		userspace_pm_rm_addr $ns2 20
 		userspace_pm_rm_sf $ns2 10.0.3.2 $SUB_ESTABLISHED
+		userspace_pm_chk_dump_addr "${ns2}" \
+			"" \
+			"after rm_addr 20"
 		chk_rm_nr 1 1
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
@@ -3558,6 +3617,8 @@ userspace_tests()
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
 		userspace_pm_add_sf $ns2 10.0.3.2 0
+		userspace_pm_chk_dump_addr "${ns2}" \
+			"id 0 flags subflow 10.0.3.2" "id 0 subflow"
 		chk_join_nr 1 1 1
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
-- 
2.43.0



