Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96D719B59D;
	Thu,  6 Jun 2024 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683066; cv=none; b=lzrY5OdoewUhr9kU4jvAOAT4YMY1K+aD+r50yhioumjsAjWFRBsTFz75qGlbGVR+8jxFzT9wpJ6LECmLwJCUcY/+MPeq3ZUNIKITWrx9HhJM/5zvJXf7XnGY+ViguYdyHv8DaTG6zk6igOG0g78tPUfXqNSDT99Zh/Q12UT5/dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683066; c=relaxed/simple;
	bh=Nclb+sSaf0Dt0vhxIvQnFO/vXeRXt3m2LkDtoTr4V0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=po7Y1/pc1SgFH1OpSERTUE96a6iI/fB1IWoAny3FqytPWAgiqJEf9ospAR/n5EQ1rXnu2hvWl+sOodVH2kzTNKKYe/FTDeiyX2RzsVFExvaTM12e0++XzDgYeykHQuyZgFqezGKpAlKj8mpmW57c8GC1MmR+6dh+y7iyiuK/Ua4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jteg06Ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jteg06Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF31C32786;
	Thu,  6 Jun 2024 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683066;
	bh=Nclb+sSaf0Dt0vhxIvQnFO/vXeRXt3m2LkDtoTr4V0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jteg06MsHy2fyjJ6CFWHV7yPESnO76KEZ10iIaC6MiZZdA3lTFzXNaLl/PIUM4zl7
	 HroPOGqObO9/Wa3tsNUKIctOUojg5nW8oYxU3cLKkwNxLCqqDMGFImRXOWrR7F4oQh
	 hs6wx/dFmrD0xMKbdHNLqs0V/TYmac2AEydFI0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 324/374] selftests: mptcp: add ms units for tc-netem delay
Date: Thu,  6 Jun 2024 16:05:03 +0200
Message-ID: <20240606131702.721740457@linuxfoundation.org>
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
index 908ef799b13a0..8d16f37cd67f8 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -125,8 +125,8 @@ init_shapers()
 {
 	local i
 	for i in $(seq 1 4); do
-		tc -n $ns1 qdisc add dev ns1eth$i root netem rate 20mbit delay 1
-		tc -n $ns2 qdisc add dev ns2eth$i root netem rate 20mbit delay 1
+		tc -n $ns1 qdisc add dev ns1eth$i root netem rate 20mbit delay 1ms
+		tc -n $ns2 qdisc add dev ns2eth$i root netem rate 20mbit delay 1ms
 	done
 }
 
@@ -3218,7 +3218,7 @@ fail_tests()
 
 	# multiple subflows
 	if reset_with_fail "MP_FAIL MP_RST" 2; then
-		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5
+		tc -n $ns2 qdisc add dev ns2eth1 root netem rate 1mbit delay 5ms
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index dfdb7031c187a..7322e1e4e5db6 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -216,8 +216,8 @@ run_test()
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



