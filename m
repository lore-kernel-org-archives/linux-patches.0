Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538936CE19;
	Wed, 20 May 2026 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297768; cv=none; b=W6L5goRC3Uv4CM/1teIgwSG2WM+j3rSMW9LoLD4S0Ki1/CPMuOIA91rGf4O+RwEfx3BeioDJRF1jizTxzHoZHmHIDorJcE3SxM52MqMIJ4xckv/VJB4qixNPmJJG03slOcrpK3bBXN3eUqCzrnJF6NIWlTmyccatO9BDQTZs4cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297768; c=relaxed/simple;
	bh=LTZgsMQZpoBvrc7OITAV/bSLjoXP65E9yh+8ouC2B34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1TaVcFqiu+vsaLtqpIz1gGJ5g0SKVmbXPZPnzbTliPDA2fjJ/TYQA5L4ySIK/x9lMGzEwigAj09KxtFrNLyKPBGNPp7FImng755fs+1tN2mQ761O/z7nC7amHVWRoR+jDFM5vcvUBc8PXb5GoiLsJpAgxbIKHNHv7VjHbrxtX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+xp2B8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+xp2B8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26191F000E9;
	Wed, 20 May 2026 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297767;
	bh=bmPkycYHr6JWYgOd6kAD5ttJDSwx3hcFMW+5wTJlkBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+xp2B8hcfTBrJ0X6lUjYHTRCOWckuiKxy95txcxSw2JScTeks+L6nb6qPRLmqqRd
	 9wT55OaWOj082AsksOhlTB6FYIRyOMKm58O8Y3vx/WzSmgOP+6uoUDWrmxaXUrqP5v
	 nMl6CycL1YGMZ8TpJ33ANiVVYYowPmguIIdNJ5+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/957] selftests: netfilter: nft_tproxy.sh: adjust to socat changes
Date: Wed, 20 May 2026 18:10:39 +0200
Message-ID: <20260520162137.933865338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 61119542663cac70898aef532eb57ee41ea9b477 ]

Like e65d8b6f3092 ("selftests: drv-net: adjust to socat changes") we
need to add shut-none for this test too.

The extra 0-packet can trigger a second (unexpected) reply from the server.

Fixes: 7e37e0eacd22 ("selftests: netfilter: nft_tproxy.sh: add tcp tests")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260408152432.24b8ad0d@kernel.org/
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/20260409224506.27072-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/netfilter/nft_tproxy_udp.sh      | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh b/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh
index d16de13fe5a75..1dc7b04501459 100755
--- a/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh
+++ b/tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh
@@ -190,13 +190,13 @@ table inet filter {
 }
 EOF
 
-	timeout "$timeout" ip netns exec "$nsrouter" socat -u "$socat_ipproto" udp-listen:12345,fork,ip-transparent,reuseport udp:"$ns1_ip_port",ip-transparent,reuseport,bind="$ns2_ip_port" 2>/dev/null &
+	timeout "$timeout" ip netns exec "$nsrouter" socat -u "$socat_ipproto" udp-listen:12345,fork,ip-transparent,reuseport,shut-none udp:"$ns1_ip_port",ip-transparent,reuseport,bind="$ns2_ip_port",shut-none 2>/dev/null &
 	local tproxy_pid=$!
 
-	timeout "$timeout" ip netns exec "$ns2" socat "$socat_ipproto" udp-listen:8080,fork SYSTEM:"echo PONG_NS2" 2>/dev/null &
+	timeout "$timeout" ip netns exec "$ns2" socat "$socat_ipproto" udp-listen:8080,fork,shut-none SYSTEM:"echo PONG_NS2" 2>/dev/null &
 	local server2_pid=$!
 
-	timeout "$timeout" ip netns exec "$ns3" socat "$socat_ipproto" udp-listen:8080,fork SYSTEM:"echo PONG_NS3" 2>/dev/null &
+	timeout "$timeout" ip netns exec "$ns3" socat "$socat_ipproto" udp-listen:8080,fork,shut-none SYSTEM:"echo PONG_NS3" 2>/dev/null &
 	local server3_pid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$nsrouter" 12345 "-u"
@@ -205,7 +205,7 @@ EOF
 
 	local result
 	# request from ns1 to ns2 (forwarded traffic)
-	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO udp:"$ns2_ip_port",sourceport=18888)
+	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO udp:"$ns2_ip_port",sourceport=18888,shut-none)
 	if [ "$result" == "$expect_ns1_ns2" ] ;then
 		echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns2"
 	else
@@ -214,7 +214,7 @@ EOF
 	fi
 
 	# request from ns1 to ns3 (forwarded traffic)
-	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO udp:"$ns3_ip_port")
+	result=$(echo I_M_PROXIED | ip netns exec "$ns1" socat -t 2 -T 2 STDIO udp:"$ns3_ip_port",shut-none)
 	if [ "$result" = "$expect_ns1_ns3" ] ;then
 		echo "PASS: tproxy test $testname: ns1 got reply \"$result\" connecting to ns3"
 	else
@@ -223,7 +223,7 @@ EOF
 	fi
 
 	# request from nsrouter to ns2 (localy originated traffic)
-	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO udp:"$ns2_ip_port")
+	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO udp:"$ns2_ip_port",shut-none)
 	if [ "$result" == "$expect_nsrouter_ns2" ] ;then
 		echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns2"
 	else
@@ -232,7 +232,7 @@ EOF
 	fi
 
 	# request from nsrouter to ns3 (localy originated traffic)
-	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO udp:"$ns3_ip_port")
+	result=$(echo I_M_PROXIED | ip netns exec "$nsrouter" socat -t 2 -T 2 STDIO udp:"$ns3_ip_port",shut-none)
 	if [ "$result" = "$expect_nsrouter_ns3" ] ;then
 		echo "PASS: tproxy test $testname: nsrouter got reply \"$result\" connecting to ns3"
 	else
-- 
2.53.0



