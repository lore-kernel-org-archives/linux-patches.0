Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212572;
	b=wDTNl55HFl56OzdkvKOzfrl0a6OGT2B2VayRnvyuHc6EKUeYYOLwC3fW6mBniRpSgF52
	 lb2bt8k1ltR1sV+mDUxd+Sy89R6VcHrw03tFllnkUKKFI+pYH+ougAcaUzr5xxdXmzhxx
	 HsF/XJgPIxrgrJrYWL7FyTUIFciut7BLp7XR2iwJDFq84NwJYJEE2Wo7vZkQH27CLGJq7
	 CRcV8ZEWZp0QYhypnBTAcQUDgy1DZo9fSlKbUirKDdJPLYprmm139lXpnt1iNdjS4pIX1
	 qMbKshjZWae+5G1tiyIAmIkPsUqTFUMfkTKSlCjHDK9CMTLQzczLpEFVqIUpn7R67Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pB7fZlAnMoesB+xNUsKXx3X60tINj5DNS2UTz7j8DJ8=;
	b=Btq4VeX2ZTbu/LrnAuhXa6XHzC59BL6FKxmgIpP8pQNeSdaOruoqY+GutXvDjCPTD6lC
	 k/18tMHsccAqKWpPuVt3Xs09ARJb3Sy41Vk2DnJBD+3pLeRC1TTDyrL2/bwNH2GjTDgZl
	 rYtvPVfHc4qjCnL/4rkJ7Kgi8tbSbi9cFRu3tZnI64yKUyb2nKyUypKoUkUh5nxZZVk7V
	 FFBT9en+IxyBlir79FwnPuM5w5zPiYAz3d7jLnbME3P9mMeoW0NLcxeff4bxDxF42esCC
	 14McSXxFerJMz6awicc1Ckam3H0SdvbgtOMzI0lrSpNcyTx36uw4wX1hfaivt2yf/nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYDeHnxd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FB606A31A;
	Wed, 28 Oct 2026 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYDeHnxd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C127E1F01825;
	Wed, 28 Oct 2026 18:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212572;
	bh=pB7fZlAnMoesB+xNUsKXx3X60tINj5DNS2UTz7j8DJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYDeHnxdsib05SHN1cLUcshNy7PBY1KjhdiwmCaWj3LIgy093AVABtiVTeX0ngyEV
	 fzuEkl2O5IllTprbmoFfsHMbSEwILESdYKILBZ5zVo0yPx1RBKszzQQp8phve2NJcc
	 ldSM6cuuTJ05SZs4R1d+VCHoWUX+5/avM4gf7Ses=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0199/1887] of/irq: add missing of_node_put() for interrupt parent node
Date: Wed, 28 Oct 2026 17:38:15 +0100
Message-ID: <20261028170503.764503551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit eb2b4ecf7299ee39ee9cecc4d3f2633aeb10cefb ]

After calling of_irq_parse_one(), the node provided in the of_phandle_args
has a refcount increment by one. Add missing of_node_put in of_irq_get()
to decrement the refcount once used.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Link: https://lore.kernel.org/r/20230117144929.423089-1-clement.leger@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index f066d48ca3d48..1e093400bd1a9 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -467,10 +467,16 @@ int of_irq_get(struct device_node *dev, int index)
 		return rc;
 
 	domain = irq_find_host(oirq.np);
-	if (!domain)
-		return -EPROBE_DEFER;
+	if (!domain) {
+		rc = -EPROBE_DEFER;
+		goto out;
+	}
+
+	rc = irq_create_of_mapping(&oirq);
+out:
+	of_node_put(oirq.np);
 
-	return irq_create_of_mapping(&oirq);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(of_irq_get);
 
-- 
2.53.0



