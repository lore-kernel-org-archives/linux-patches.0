Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CF61A2547;
	Thu,  6 Jun 2024 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683743; cv=none; b=pPrgrK0+vbjrniLqxy0IEX5ddyJVgLtxIbbKoJdGkZfWPrDNWY9CJsB3VhwznjaQFd24r4jRq77dN/mZXg46+hhGMDoJs/VgWrTLnlhCgWktiEGoZEfScfXqUiAg/y0KZHgu2OMudYWio9C6A8poY9DOiUpDPkmCppdZxckdMPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683743; c=relaxed/simple;
	bh=yU7SSr68LF3dDs8wr4ABVquhtL18Y021AyWNpxoOfVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t515wW5WvAR/w4H7hyJ7tR180dw9KtKSb6Tp9aeCl+0+3T5GS3icVhZgF+uyrtZKVgRSRWlwtOavk/45lyMIiWDy7XVHjeHx3j0OIvqBBwqPjZN03ZdLoiHm5PgL/CgV7LwbV+p0aghKNthzwDhAqOQ5ySuluOzQZ1zTUo927Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfgj1gWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfgj1gWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEE7C32781;
	Thu,  6 Jun 2024 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683743;
	bh=yU7SSr68LF3dDs8wr4ABVquhtL18Y021AyWNpxoOfVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfgj1gWxgC3EN7HF0N9WqebNZxc0Bih1D8ZMl9bkaCnr4Qf/dnYKfCZuDt6iVkpeQ
	 LLtGmTvBJ6CdR80SUZm8Ml1KTtwW09kjT9vWXj7fhg+2iwqxPmZo7TBWhGcjM6n0dA
	 uetcvlJvnTu3F6D2b8HZWXSKv22ou+6X0O5em5Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 707/744] selftests: mptcp: add ms units for tc-netem delay
Date: Thu,  6 Jun 2024 16:06:19 +0200
Message-ID: <20240606131755.149251488@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 9109853a388b7b2b934f56f4ddb250d72e486555 ]

'delay 1' in tc-netem is confusing, not sure if it's a delay of 1 second or
1 millisecond. This patch explicitly adds millisecond units to make these
commands clearer.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 38af56e6668b ("selftests: mptcp: join: mark 'fail' tests as flaky")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh   | 6 +++---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 371583009a662..60bf8c1fb5007 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -133,8 +133,8 @@ init_shapers()
 {
 	local i
 	for i in $(seq 1 4); do
-		tc -n $ns1 qdisc add dev ns1eth$i root netem rate 20mbit delay 1
-		tc -n $ns2 qdisc add dev ns2eth$i root netem rate 20mbit delay 1
+		tc -n $ns1 qdisc add dev ns1eth$i root netem rate 20mbit delay 1ms
+		tc -n $ns2 qdisc add dev ns2eth$i root netem rate 20mbit delay 1ms
 	done
 }
 
@@ -3269,7 +3269,7 @@ fail_tests()
 
 	# multiple subflows
 	if reset_with_fail "MP_FAIL MP_RST" 2; then
-		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5
+		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5ms
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 6afc3ea211fc0..be97a7ed09503 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -235,8 +235,8 @@ run_test()
 	shift 4
 	local msg=$*
 
-	[ $delay1 -gt 0 ] && delay1="delay $delay1" || delay1=""
-	[ $delay2 -gt 0 ] && delay2="delay $delay2" || delay2=""
+	[ $delay1 -gt 0 ] && delay1="delay ${delay1}ms" || delay1=""
+	[ $delay2 -gt 0 ] && delay2="delay ${delay2}ms" || delay2=""
 
 	for dev in ns1eth1 ns1eth2; do
 		tc -n $ns1 qdisc del dev $dev root >/dev/null 2>&1
-- 
2.43.0



