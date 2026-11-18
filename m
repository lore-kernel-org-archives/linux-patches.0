Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041120;
	b=se+HKl/VHyEGla34RX8aNFPkbtcxwG5aJ5Yiq8rAFVAKzYlVnnHM8cJZvVV1rMSyrZ8b
	 bESSWcRQzz66oGkZqz0wdLbI3d3RRuECZwiJZYSk+f9kAd38eq1a+EfcnCztJqZ6B7MDf
	 4hg/3OrVfKZ5fo+X/LID22aDL3PciFSpWWirYTIG18ynCl7HnSbkzAJha4N3hwpc8hg1h
	 pOn1thlnHmoJKTNuxlSATeBGeEMMCP8RMoFV2EB5cmmZfzNG5tR2lXxR4r4Ci310iiXel
	 UufApDIdXfZ2a1lNRaErKkKJAoFZD/0ZDeywB99Bz3+Q+4yByxkepW58Twzd/CIUkWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xCKb7o4oyAMzneGbwd+DhNnxVomrVSewMUFekA3gi6o=;
	b=IGlAWAalh1PDcJpMSh7p4vjnVGESvw5B9CmLJnuoyKHd7NUU9fGGmJmR5IFcMawwOZ8b
	 0cG2X1+vUgCZcAvYjtKgcQDd529t8J22T33YKpwDQ9gCE5uu1bhkT3U0yNE9nn/fAyWS4
	 xDdWfllK07Rv6AW8f5k0LIloBxX2K+HkM17oGOKufvf4CHDG86D4xWWb2fR9nhMZkkZnn
	 /5+Ti0FeGYV0ocVXN2de/oekfUqpG7lp+HrpXGMnNxAjn6N3bX0zhpKplRYil70NNuFLN
	 l5EyhqKo82rF5qI4m0k17A5rLdn0sX/S3CB7SxVLF8ERu4d1b1e2Vy50HCu94neT0yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpAlsdys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939BD606A31C;
	Wed, 18 Nov 2026 22:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpAlsdys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EA71F000C4;
	Wed, 18 Nov 2026 22:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041120;
	bh=xCKb7o4oyAMzneGbwd+DhNnxVomrVSewMUFekA3gi6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpAlsdysQXNkccJYXqGFF12nGdFY5GyiD388VVsXZaZ8G0NQQNj2P0IVXJoKqIjj+
	 ozOytaPjeZcsPSe52D+5iJf932bDS+OWJAOWEjRTxXP1cXNoSeXlkbqxVn65kWEZ2f
	 X4RIMKQmxafpfL4v8U+/uHrALu07/bb0CcoGQMi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2699/3318] crypto: talitos - Use platform_get_irq() to retrieve interrupt
Date: Wed, 18 Nov 2026 15:55:21 +0100
Message-ID: <20261118150441.892504718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aaac6594147b9..be758b98135fc 100644
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
@@ -3242,13 +3242,11 @@ static int talitos_remove(struct platform_device *ofdev)
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
 
 	return 0;
@@ -3356,26 +3354,26 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
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
@@ -3391,7 +3389,6 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 			  dev_driver_string(dev), dev);
 	if (err) {
 		dev_err(dev, "failed to request secondary irq\n");
-		irq_dispose_mapping(priv->irq[1]);
 		priv->irq[1] = 0;
 	}
 
@@ -3400,7 +3397,6 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
-		irq_dispose_mapping(priv->irq[0]);
 		priv->irq[0] = 0;
 	}
 
@@ -3501,7 +3497,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
-		if (priv->irq[1]) {
+		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
 			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
@@ -3519,7 +3515,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	for (i = 0; i < priv->num_channels; i++) {
 		priv->chan[i].reg = priv->reg + stride * (i + 1);
-		if (!priv->irq[1] || !(i & 1))
+		if (priv->irq[1] < 0 || !(i & 1))
 			priv->chan[i].reg += TALITOS_CH_BASE_OFFSET;
 
 		spin_lock_init(&priv->chan[i].head_lock);
-- 
2.53.0



