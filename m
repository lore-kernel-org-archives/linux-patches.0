Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A9870838;
	Mon, 23 Jun 2025 21:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713039; cv=none; b=kMyDqR3rHtx3DRzIqOUFLmsupTjaNvqzGFEj42eO/wx6Sy8j/aAbn/ltUbCQKLQkPEWYW0Kmxfx4+FsxDJ79i0qveD3qMjXfNJylPH5/Ppm9nRJtsRAuuxieHBVy5QotS5Bnc4VMExEXgiFjSbKBu4wWXMfCg9oyYbGs7A2Jg9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713039; c=relaxed/simple;
	bh=kQ9Z8Bt2O24Vv6w9hidDUWF3wx7XHb/9YNwRDeyMFRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LndrnhVS8Vi89RAaAkCiSAx4E4TZ3QpfZJJdu8AD03KjTC89jBndv85rDqapfu2cJcTk8aokAvukayvludmktbDCNIrvaFvsBZeOmZ4/ePHMJ4v+SJkH+ALNfROUePdVi9D+loRuWLKUoxQC7KdAlxW/fAgEhcLXxeIYpdfGYLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH9b2/XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH9b2/XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B59BC4CEEA;
	Mon, 23 Jun 2025 21:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713039;
	bh=kQ9Z8Bt2O24Vv6w9hidDUWF3wx7XHb/9YNwRDeyMFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH9b2/XHSA5EXOxmuhh8OM8bwHgnnJgL0vY5bM4r909oHZtYDJHd545Czd7qLYyKG
	 0pxfFWc8tmPyYWYaAAs+scnAPjjK1lqo+VBUUXakAJJDuTXyHYkXM1zkNB6PzMBP/i
	 Vx8UT0ftCVMO0RhZfMV2ZVxs+Phu9NBg663/JnOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/411] net: dsa: tag_brcm: legacy: fix pskb_may_pull length
Date: Mon, 23 Jun 2025 15:04:25 +0200
Message-ID: <20250623130636.599200822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ed5f68c4f1dad..3c681d174c58b 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -253,7 +253,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	int source_port;
 	u8 *brcm_tag;
 
-	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN + VLAN_HLEN)))
 		return NULL;
 
 	brcm_tag = dsa_etype_header_pos_rx(skb);
-- 
2.39.5



