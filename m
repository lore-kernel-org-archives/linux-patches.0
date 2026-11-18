Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050261;
	b=mkhkmitvfjlevHBGmj1Xv6YRt8fF6OCQq7BnZBMFCbuhLT/P5bHeiZr40ZB8LOQFz3im
	 lWa5I74NQX3Uqw6qdc5bZZE+qUk0Bwf+/7ndFZ7KHtxtKPB8ojKLAev+jNQZNmcCkoxqC
	 LravFzHagATKKqre+GxkpeY9ckWbKtCHM5BOT5dnQr6jbNaDaTy8riWY92f9uGb8BxSeP
	 uGLNc3P2KxGollorhrsoSS/ZpEQ66qGDdVsoxbr9aX9lQvqE6Kvw9AH2ldZvxZZeSdnra
	 ozZvfd2e6yHVSsg1fAp9rqWQH9f5tQQ9tbeSWjXp6TLXwcq5unKWPWyxVAlRtY/H/Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l4IatCM1b0Q6IZubgs+D5q0Fyk/tK6h/3yv6eCJc2fQ=;
	b=0nZs+2WUVWmslcbPSSBfVTw6gsfwWEDgDmffUApF++rCFteWK/gAxqR+iFjFl/VNJ2AE
	 yGx+LK/R7rW0cDHlekg5frCfD9cSbMWOOarCeDS+7BrcH85zyzfpEQfpaVXIoF8XGWR/w
	 bUtubsTP5NEK8uQpf4zEPyY/n+tguq/Q7A/7lQ8EpeSO61j1L6ku9fbKWG76W+vPRTqkS
	 /UivBPPUr/0q8N1tsPo8wNaPcDFKMGkltohms6idaLPrphhXqSMfnFz13slqrCP680X0Y
	 b7mJH+qiJgy+qw+RTki77fAWVMvmVD2BOdObpHTZLcNvvmXJutNZ1GlMk5zpxejD0uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QTiQnllz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028B3606A32C;
	Thu, 19 Nov 2026 01:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QTiQnllz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598E91F000C5;
	Thu, 19 Nov 2026 01:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050260;
	bh=l4IatCM1b0Q6IZubgs+D5q0Fyk/tK6h/3yv6eCJc2fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTiQnllzda9S1Slq8bPjbUz0+vA8xt7ZnCAZhqw5drkUDon7E3iAtkCFqy0DP9S9N
	 +X3FdUheLeS+UQT37EpjclnPLDsUR/XqnQSRt3RZi1+BEmVzaVRWtCHuZ7tG3UDxNk
	 4I6K1JLsU5Qh0lLArmLLugc33S+F1ftY43AOyc8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2645/2857] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 16:01:19 +0100
Message-ID: <20261118150336.821882488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14c0350142ab0a10ebeefed03b779df23749e16a ]

An IPv4 later fragment carries no L4 header, but key extraction leaves
ip.proto set to the real protocol and the flow may wildcard the frag
field, so validate_set() accepts such packets. set_tcp() and set_udp()
then treat the first bytes of the fragment payload as an L4 header,
rewrite them as ports and patch the bytes at the checksum offset,
corrupting the packet.

Skip these actions for OVS_FRAG_TYPE_LATER. IPv6 later fragments are not
affected, since their ip.proto is NEXTHDR_FRAGMENT and validate_set()
rejects L4 set actions for them.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 00a3e0af95658..1eab2a43f7cec 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -617,6 +617,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -660,6 +663,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct tcphdr));
 	if (unlikely(err))
-- 
2.53.0



