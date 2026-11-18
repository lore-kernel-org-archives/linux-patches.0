Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025980;
	b=5rQlgRy+DMMtJ+BHCfRBJyxeGkwVzckxzWpYN++di561wzCKLUw/pwtqbogWwnPzbSJv
	 6Y5YsaL30KHIXZxTC7kwPgY+0HuQncbFy78Y+ISX+uyibLza2Dk/ciQmJ4twIiRvJ0B6Z
	 RJ8qbW/EPLYlQ13VQrhBGmrZJu1+UjTrKVeZzHkktdtXhAy3sYgfUhpAnAO/kE3pqdaNC
	 RSPJB59630mIP4gN/exYAt4akd8vBPkITWotVpKV9qJChDB0L78wPnmVK33ww7wRXBzjd
	 zo/mvRRBajxoOppk+OX1bbopikXa90m3YVzFk201UHPY9pQCHAFy1gq7iDG3awwMH1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OVap8kdMAOYTlWwVfp7kgef28e7Ic4EGYVBZNrB9Hlw=;
	b=sLOZeDuEi7Itev2dTSN590MjQqGgHO9F0lFcvbuqbgaa42/CNUiZ9bEKg4w7e5qMkA3a
	 YH7Uy1GEAbAqPqr+5AEfxWMYIW9UE91OnTZ7eurfeKiDF2HjyHyejgDzsfcNrpKuVMTH8
	 yvoLdUvqUH/tM0rwJTzXEslVLbEQqG7fKzIuUQz2A7r6MIBmZmiV3EXdlcj5ukmLsRksU
	 /3wiH4BtKiwOBcR+ttN7BZL5/o6uWAOFyXf/IOjMHmqgI+cp6gpRpowFeuKQ4rlr1Uy+3
	 luzeZI3GEhgUeGbA3KYlXG6ioMvNhP5NjRGXzdypdI0iQGzDLJ13qpk2YWTlErbNcbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywsHLEmc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71A606A336;
	Wed, 18 Nov 2026 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywsHLEmc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB43F1F000C4;
	Wed, 18 Nov 2026 18:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025980;
	bh=OVap8kdMAOYTlWwVfp7kgef28e7Ic4EGYVBZNrB9Hlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywsHLEmcVmjvwHqy1SPOQC9rs+3Ee8WrHkcnZKC3jFwjjRuelVW22Fg+7NcQDw+0E
	 NdvEW+bHBs69qhitw0ChitXMjCWI9eABMAx3BXq7rD4lL7L0Qviw7ShXOW1CpquVAL
	 4Lw8KJ8EoROeNMbUmUVw4S5GNtWFO+xqZm8+m7SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1271/2151] crypto: talitos - Use platform_get_irq() to retrieve interrupt
Date: Wed, 18 Nov 2026 15:50:06 +0100
Message-ID: <20261118150208.433372435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 584508963241c..eca4d7f46f11f 100644
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



