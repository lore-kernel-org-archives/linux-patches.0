Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031287;
	b=jXqY7BIUcABl6bzEdnCxqf/TbqE/Ipl1ciuqq3yqrzoOnOwfC+BmQc6/LXmSVJk9mF25
	 rhqrYy1MGZl+dDTh99P4cSRBm7jazcxZSE6yDcm+aNbdIBPKV7rrdnCWLB4c2ytshB6gC
	 4fAYDcy5VZGE0NmF6MN9OHpbclv/ItPENijl65AUjlvRotqvypQQgjo6iGuV9h1Loeq+/
	 wiF/vLsePFcf0cK2/ntjVXVmQ0q0UrpFo0zIAEYVvlRzVSQ85l+Kj/pnFkDZWlbw5VJYg
	 OmPcs6Cp6KYozmv5Bagfe50RYelwlTelAXbUBJaKO0LxJ2D/LkT37oeZ/Fit10ScCQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EqcGl3vj3Yhio0/IvwUU1eKOdnSvsEO+LaYniIDxlnk=;
	b=WiP9IHB6PsNF7uh64veZIgV1bUnpfyx6jdAe/zsdN5Z9V7GTRf9Ey894cCGAGYtsxaMF
	 AIQN4Cm8g7rbddhCUQph3eAFT3lPYLgTbVd9Df1m3Qo8oxrax1yDj8AYlo2yyQeMRVRmy
	 axUggQl5QBEQlUTbzQShLmq1SCXCWf7521iP0s1lnWyYM51fwBZ9+PnooNPhWuPaA4NE/
	 38s2U7mOOITMqtSOzPB8acC84XBcMQQ81BhSFdBLtL3BAbW6khy5qLdx7xq2Xgxvouv8X
	 Ptr9CdpoHYAjlYCte4Fg5/2nMTEIrM7G6L48YwbGHhhl++jCgVFlMA6uxmCS5fOiYOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqlSBQEV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80049606A32A;
	Wed, 18 Nov 2026 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqlSBQEV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3C01F000C5;
	Wed, 18 Nov 2026 19:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031287;
	bh=EqcGl3vj3Yhio0/IvwUU1eKOdnSvsEO+LaYniIDxlnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqlSBQEVVv/kN6QJKSPH5ZK30wJd/her0J6RqWnF3q63UBc5uZzmhRusxB4lw+GCp
	 wSnumIggywJUQiQzvLSOVmKrFbVyZFxLob5cWlHG8fXNoqRbreXlQ0iIAy5PuJ7kK0
	 kGkRKAmoMsY2oACecEwRSx9WLtEQD+K2i6k8nZAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1004/1756] crypto: talitos - Use platform_get_irq() to retrieve interrupt
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150050.115552427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 4a1c7518cc31430b96458202b6a5b4064ff0cfa0 ]

Remove the need to call irq_dispose_mapping as needed by
irq_of_parse_and_map().

Simplify the function as a result. No need for gotos anymore.

Add a missing free_irq.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 666d66df2525 ("crypto: talitos - init tasklets before requesting IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 335a0ccc63e01..cba54966add7b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -192,7 +192,7 @@ static int reset_device(struct device *dev)
 	       && --timeout)
 		cpu_relax();
 
-	if (priv->irq[1]) {
+	if (priv->irq[1] > 0) {
 		mcr = TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3;
 		setbits32(priv->reg + TALITOS_MCR, mcr);
 	}
@@ -3242,13 +3242,11 @@ static void talitos_remove(struct platform_device *ofdev)
 		talitos_unregister_rng(dev);
 
 	for (i = 0; i < 2; i++)
-		if (priv->irq[i]) {
+		if (priv->irq[i] > 0)
 			free_irq(priv->irq[i], dev);
-			irq_dispose_mapping(priv->irq[i]);
-		}
 
 	tasklet_kill(&priv->done_task[0]);
-	if (priv->irq[1])
+	if (priv->irq[1] > 0)
 		tasklet_kill(&priv->done_task[1]);
 }
 
@@ -3354,26 +3352,26 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 static int talitos_probe_irq(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
-	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = irq_of_parse_and_map(np, 0);
-	if (!priv->irq[0]) {
-		dev_err(dev, "failed to map irq\n");
-		return -EINVAL;
-	}
+	priv->irq[0] = platform_get_irq(ofdev, 0);
+	if (priv->irq[0] < 0)
+		return priv->irq[0];
+
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
 	}
 
-	priv->irq[1] = irq_of_parse_and_map(np, 1);
+	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
+	if (priv->irq[1] == -EPROBE_DEFER)
+		return priv->irq[1];
 
 	/* get the primary irq line */
-	if (!priv->irq[1]) {
+	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
@@ -3389,7 +3387,6 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 			  dev_driver_string(dev), dev);
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
-		irq_dispose_mapping(priv->irq[1]);
 		priv->irq[1] = 0;
 	}
 
@@ -3398,7 +3395,6 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
-		irq_dispose_mapping(priv->irq[0]);
 		priv->irq[0] = 0;
 	}
 
@@ -3499,7 +3495,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
-		if (priv->irq[1]) {
+		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
 			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
@@ -3517,7 +3513,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	for (i = 0; i < priv->num_channels; i++) {
 		priv->chan[i].reg = priv->reg + stride * (i + 1);
-		if (!priv->irq[1] || !(i & 1))
+		if (priv->irq[1] < 0 || !(i & 1))
 			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
 
 		spin_lock_init(&priv->chan[i].head_lock);
-- 
2.53.0



