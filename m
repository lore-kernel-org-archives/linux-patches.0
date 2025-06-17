Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15750216E2A;
	Tue, 17 Jun 2025 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176437; cv=none; b=DbWNJpVdzzzWhUlaHJ2+LmV8T1sLzd0tfVD3RhlHLWhHY9U51B9n+3Nu7Q6el2U+BOmDSQBRG+EyMaY0Fp70QSt6oizL1RCHoCLtDoDQV8+BQBzKHILfuXHHbP8rO/lKAjKKTtIPJ8l7o55NS3voXVG4wd/vhTu+sxhvdmAXGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176437; c=relaxed/simple;
	bh=970jrK8NtBAntskZlQX7wSZQxygWsvVdkUVPV1h5ZZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3jpkpxRZUiOt9BF9Z4nKAhvUm7Lw85LgTJNF6r8Fe0DbUVV6tXuMpFYe+rzwMsgWmxIGt9EQzZ8MQD6omPJxHmNcnCoyGr3jAixBq84yeyiJYhQSnufdGXcdm583hJ01ZnLkP1IOpnC4LFAWB5JnV+TbPOygCL8q0U2qyD3z0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gd/tWQYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gd/tWQYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E375C4CEE3;
	Tue, 17 Jun 2025 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176437;
	bh=970jrK8NtBAntskZlQX7wSZQxygWsvVdkUVPV1h5ZZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gd/tWQYmw6U8zcoZLye0mrIITgTQobIASq4tjDP+m+s14ER2PzUiEhUdHZ+h+5avn
	 e4UXfl4+p/9SuhX06M/DlDm5aICnlHphHBjdd8NGdCBRiT/eMVcYkOdyI7v+qI79rF
	 cB1Qwuw9mjCEbJYxNF4dbzs1i6YWFSmMJeqExiGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pieter Van Trappen <pieter.van.trappen@cern.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/356] net: dsa: microchip: update tag_ksz masks for KSZ9477 family
Date: Tue, 17 Jun 2025 17:26:32 +0200
Message-ID: <20250617152349.344636049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/dsa/tag_ksz.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index ea100bd25939b..7bf87fa471a0c 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -176,8 +176,9 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 
 #define KSZ9477_INGRESS_TAG_LEN		2
 #define KSZ9477_PTP_TAG_LEN		4
-#define KSZ9477_PTP_TAG_INDICATION	0x80
+#define KSZ9477_PTP_TAG_INDICATION	BIT(7)
 
+#define KSZ9477_TAIL_TAG_EG_PORT_M	GENMASK(2, 0)
 #define KSZ9477_TAIL_TAG_PRIO		GENMASK(8, 7)
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
@@ -302,7 +303,7 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	/* Tag decoding */
 	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
-	unsigned int port = tag[0] & 7;
+	unsigned int port = tag[0] & KSZ9477_TAIL_TAG_EG_PORT_M;
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-- 
2.39.5



