Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6887619B3FE;
	Thu,  6 Jun 2024 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683067; cv=none; b=RgOxagDb6UPgdL8DZ6Z/x5Y1s++qe5ftkTgbJ0dJYSI5DOykIUO9TukNblsTTP/qmZ0qXfdB8GxEEYrQycOkDA5F2qR9sk+0Rn33F5tEybox2ZRiJiHrM7Ze6hUaHSdZifHuSahwEuIt7hHQVBOPuxHGxAk9os3enqXYlmR3BMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683067; c=relaxed/simple;
	bh=S93IoNEefqzFCFChWXHc8lIboDd9ic4V5NGLfy6Y4Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyExkK9UeLJ42o+wgN1DvCY4sYB0r2xf1HL7obolrjuJQogyftcgCKVxbUO9VEz1QkJ/ahBe+R8kxUBERHBRgyB7mEOU18ec46Y2tWrUGip37Rcre++dRSr6JMCJdI0G1Qp0+zwlIL8oNNk/eCOsdNCsOhCyhKDrOJNmNtp4OZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5SPaM1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5SPaM1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E17C4AF0D;
	Thu,  6 Jun 2024 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683067;
	bh=S93IoNEefqzFCFChWXHc8lIboDd9ic4V5NGLfy6Y4Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5SPaM1x7pqHUMlVXxLWl90sXV+QpZSTxMZic8oRltMJuVziR3KxbLNpNXJOlZxO0
	 nMAsHgzjktRoSJ2sAgOoZ34TT4hEe2RRrX3k9AUeakBwwcg6ARZCwpUBeEDGifwbeG
	 knQEX5QD2+qE8QLsEV55Vc4wsjQXSefL9bsfsPbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 325/374] selftests: mptcp: join: mark fail tests as flaky
Date: Thu,  6 Jun 2024 16:05:04 +0200
Message-ID: <20240606131702.749516709@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 8d16f37cd67f8..1b5722e6166e5 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3210,6 +3210,7 @@ fail_tests()
 {
 	# single subflow
 	if reset_with_fail "Infinite map" 1; then
+		MPTCP_LIB_SUBTEST_FLAKY=1
 		test_linkfail=128 \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 0 0 0 +1 +0 1 0 1 "$(pedit_action_pkts)"
@@ -3218,6 +3219,7 @@ fail_tests()
 
 	# multiple subflows
 	if reset_with_fail "MP_FAIL MP_RST" 2; then
+		MPTCP_LIB_SUBTEST_FLAKY=1
 		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5ms
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
-- 
2.43.0



