Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54C18E025;
	Tue, 17 Jun 2025 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178955; cv=none; b=rhkkHLLr8DMmi6jVOH6KXp4O2eELxPjL8agVJmLr42x9Ur2npWWgo9QUMQv133VRWDbOa0CB+hm4jb/CDJdIRhG4g5k6DQhefflcKa+Mns9Irxprdl62wRTAL4zk8qbLw2YLW11wwqk3Hx3xJ9XXWUp0/PEy5JUgVI+AG6GR31U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178955; c=relaxed/simple;
	bh=PYy94iyQ//WLbpayI9YRfkg/2XTpufnni3+8RGMtDuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7wo1nIaSxsLb3qYtb4EBdeWDtIJRaaZIica4vVL40ATs+bYtEkJsLtjrNV0hD02UMNb/AYTIlIvj9LwD2x8AmqEJnlCUUeELIaQl9p6crafKu1ROPWPxoNDMqQqvabJIhNCiyrUQQm6i4j6a48S//Q79mS/pUDd+QlLlcG5wwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUr+phUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUr+phUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4947C4CEE3;
	Tue, 17 Jun 2025 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178955;
	bh=PYy94iyQ//WLbpayI9YRfkg/2XTpufnni3+8RGMtDuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUr+phUbMNH4UtSTFaeBVCywjNpQkSHYz1P0ohIszqG3UdOzSct8s1XL3vxyPoA3P
	 Deqljd4NSxpJowm/DwuyfUd4Mn0ZxdHFpWDL0svObKX7IrwQeHPe1q6Zdn6EvgiLdT
	 o/ZrNxllbKlui9U/SdPF8cNs06TeldTAMthdUz+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 576/780] net: dsa: tag_brcm: legacy: fix pskb_may_pull length
Date: Tue, 17 Jun 2025 17:24:44 +0200
Message-ID: <20250617152514.934054089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit efdddc4484859082da6c7877ed144c8121c8ea55 ]

BRCM_LEG_PORT_ID was incorrectly used for pskb_may_pull length.
The correct check is BRCM_LEG_TAG_LEN + VLAN_HLEN, or 10 bytes.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529124406.2513779-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 8c3c068728e51..fe75821623a4f 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -257,7 +257,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	int source_port;
 	u8 *brcm_tag;
 
-	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN + VLAN_HLEN)))
 		return NULL;
 
 	brcm_tag = dsa_etype_header_pos_rx(skb);
-- 
2.39.5



