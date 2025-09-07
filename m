Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A5A1CDFAC;
	Sun,  7 Sep 2025 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275864; cv=none; b=KlC3FCxh77UDByy2E/8xsf26OtLMIaHrYWCBFea3rgAxDr1H8U+K3FZ5GFzLGHefVGQJG7GjV1YThY5IpCwCLnCGrHhskdqksQB1RtxJeptwo5oB0LarL0eWYUfjTH3WS0KLx84XP4u5RmLfp+b5fdk8kJxw9lzi8UauKVYfnf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275864; c=relaxed/simple;
	bh=elX7YnwNj4uNlcwep6VqeW+BWHU00Z7Yab6eOs51XgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ0jP0aA31oC2pNEB8Q3k2KNRdKSNG6xFSOTxLXTqCNOblY8XyvdJalIMafk/QE2f8ftRX96JMXYsWN2PByeOFXIEkaTY0PQHc+0Z4hJcKyP2A9RAIt+1cTy6w6j/apeiNafdo2O2lpJZ/tMeIlrRj6L1q0rW84tP3n8eadWxyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hcb2mef/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hcb2mef/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D75C4CEF0;
	Sun,  7 Sep 2025 20:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275864;
	bh=elX7YnwNj4uNlcwep6VqeW+BWHU00Z7Yab6eOs51XgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hcb2mef/HJsp08XvWRyZBMC1jYuApx6lCE8QCOJM4fJcvvsZqH1LB+2Gtqn6c3jlw
	 sKpqoxkTfvR2T5DWtbpzGGxfcTAaF6fGltIR7rqfy0ixAHTKsCBJCj2mQ6UFf4/QlA
	 UGgvSRnVeN+Qf4NfGVB2HwIqih/guWlOdvUA7NjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pieter Van Trappen <pieter.van.trappen@cern.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/45] net: dsa: microchip: update tag_ksz masks for KSZ9477 family
Date: Sun,  7 Sep 2025 21:58:20 +0200
Message-ID: <20250907195601.976101315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pieter Van Trappen <pieter.van.trappen@cern.ch>

[ Upstream commit 3f464b193d40e49299dcd087b10cc3b77cbbea68 ]

Remove magic number 7 by introducing a GENMASK macro instead.
Remove magic number 0x80 by using the BIT macro instead.

Signed-off-by: Pieter Van Trappen <pieter.van.trappen@cern.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240909134301.75448-1-vtpieter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ba54bce747fa ("net: dsa: microchip: linearize skb for tail-tagging switches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_ksz.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -149,8 +149,9 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROT
 
 #define KSZ9477_INGRESS_TAG_LEN		2
 #define KSZ9477_PTP_TAG_LEN		4
-#define KSZ9477_PTP_TAG_INDICATION	0x80
+#define KSZ9477_PTP_TAG_INDICATION	BIT(7)
 
+#define KSZ9477_TAIL_TAG_EG_PORT_M	GENMASK(2, 0)
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
@@ -185,7 +186,7 @@ static struct sk_buff *ksz9477_rcv(struc
 {
 	/* Tag decoding */
 	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
-	unsigned int port = tag[0] & 7;
+	unsigned int port = tag[0] & KSZ9477_TAIL_TAG_EG_PORT_M;
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */


