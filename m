Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40411A2547;
	Thu,  6 Jun 2024 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683744; cv=none; b=tv6uJs9x0heLqqALTg/naTj0QxAjFx7FOedzpuqjVgJTD85FpTFNyrmAO7OTmH0b14Z2bXAdQkJKDff8OOrs3+VyB7ibuSzBd/2BqIr4cAUrOR3QNK2HFlMlL9LZgz4O3hFCFjfytdpzHGJJXFaoagR/8hxxZv4THTUbjqPrxww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683744; c=relaxed/simple;
	bh=3dX/W7+HLrE82EmUJ1+m0FXExJwsbLysmT7mRPdWZp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxkkNC53XQuTMt5aTBI7um3h3uQb3YSWFpG6JK+NkJEmnsHn2dyCS4qWdyuN9JWa6paoJ7rfHj9CjKTNRmo8A3BnS4/U19aaaXFiY9INMjYF+cJoI5pRoVVcPqyXwp9m3CuylElePGze+xQUwmPWSzl140RTkP1UFC61zzyNIFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccAnkPyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccAnkPyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD90C32782;
	Thu,  6 Jun 2024 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683744;
	bh=3dX/W7+HLrE82EmUJ1+m0FXExJwsbLysmT7mRPdWZp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccAnkPyuGQwdaW5XvBA+CQPakjNZB4ZttV6P+pFebQXFMJcjwV/KvtMsIBwZMVhQd
	 1hh9Yd4c8Mj82m7GSXFPGSlCYiyzE5kQC1GuJ8S5OM4USIS/8d2ZSXlh4pVa4ClWfi
	 fiu8f6sDM1E/7HFbkrs4HdmG6+Cho288GeuJkN9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 708/744] selftests: mptcp: join: mark fail tests as flaky
Date: Thu,  6 Jun 2024 16:06:20 +0200
Message-ID: <20240606131755.180152027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 38af56e6668b455f7dd0a8e2d9afe74100068e17 ]

These tests are rarely unstable. It depends on the CI running the tests,
especially if it is also busy doing other tasks in parallel, and if a
debug kernel config is being used.

It looks like this issue is sometimes present with the NetDev CI. While
this is being investigated, the tests are marked as flaky not to create
noises on such CIs.

Fixes: b6e074e171bc ("selftests: mptcp: add infinite map testcase")
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/491
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240524-upstream-net-20240524-selftests-mptcp-flaky-v1-4-a352362f3f8e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 60bf8c1fb5007..6e684a9a3c616 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3261,6 +3261,7 @@ fail_tests()
 {
 	# single subflow
 	if reset_with_fail "Infinite map" 1; then
+		MPTCP_LIB_SUBTEST_FLAKY=1
 		test_linkfail=128 \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 0 0 0 +1 +0 1 0 1 "$(pedit_action_pkts)"
@@ -3269,6 +3270,7 @@ fail_tests()
 
 	# multiple subflows
 	if reset_with_fail "MP_FAIL MP_RST" 2; then
+		MPTCP_LIB_SUBTEST_FLAKY=1
 		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5ms
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
-- 
2.43.0



