Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031282;
	b=Is/+1s9r8/bdY4J3JAelQ/tczIVOXtCS8fyRkvZn7Rj4bgHzpMwfFw2GNqf3jHV9n9+l
	 qR7O0xzd2jkvprj75F09u92FlVPkQR3JSGwRnumIK1bbol7QKuNXSZKok9GfpNTW6ExAT
	 Lpx2NHFbdleOAfYV4z+xj+oLocZnMWVg0nEPB0Yw1AnKdA9tYoHtyAtNhha1Aj5AkDc2V
	 oe0lAiCjBkqiUi4iN4jf5bZb1EJ5BYMXbiSGu+puiiNB5n5K+QM/eaVdxzfNC96/sRIBT
	 1GanrylAOmJsrA+xOTUK50Q2sywXFLRl9qxEpzgbZgjQqc7Ho45MoiMNSajdyU9gFsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pv05tw+Y0BMPHsUe7en4Yh4mkDWPuuAlXHQFrV8r/g4=;
	b=ATXo9M9LsNGWf9oNmx2CbMGnf9rEk6+K7rWXnLy9Gvk+58pTEgijLbtbWhnM72xY+Fbs
	 lCi47uqZwHZ2VgZmzYRTnElS2u9dyb8t8ZSKLoHXlZMKJOSXF2jIltDW8eX00z+lC+bSO
	 /7I3yt3jmpo2DecyIhsRzmKIhVeUsBoPmKIcLLKuzrQHczTOjGenGVvNP56Vv5JAqF2vL
	 eMJKIOezNsHgWHaQlFnNKvwgjPIeQ8TM+mxXgljPzGUdfxB4J+xOoehNca/ka345HQRwt
	 Y8baWOZ6QbCqxk/jCW3vIIElfduAPpozNv1eCh3Q/z2o6VqzN5wOicpG1TSN7wmiUcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xt7ZqRUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EAC606A325;
	Wed, 18 Nov 2026 19:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xt7ZqRUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C99C1F000C4;
	Wed, 18 Nov 2026 19:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031281;
	bh=pv05tw+Y0BMPHsUe7en4Yh4mkDWPuuAlXHQFrV8r/g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xt7ZqRUp8B9kbdBqBn0cBur/Uv3IESqkhEy3AtrRKOsgYEOrA3l8pD8F7w2C7bWBb
	 XTzPwyLXkPmQb0wPrbgZt62TYKys7PfYmyaCTx1XiLEdDtnTh0XKR3VuN9cV3eZyH9
	 MDMc/AZhAEoRos0uKfQMRhHQytqLApIi+h4Mg3FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1002/1756] crypto: talitos - allocate channels with main struct
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150050.048485839@linuxfoundation.org>
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

[ Upstream commit 24818f77603b3fcb7f3da5802b28bcc5ac7604aa ]

Use a flexible array member to combine allocations.

Add __counted_by for extra runtime analysis.

Error in case of no channels as they are required.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 666d66df2525 ("crypto: talitos - init tasklets before requesting IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 19 +++++++------------
 drivers/crypto/talitos.h |  5 +++--
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dc4cbd0decfa3..b121b009a13e6 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3410,14 +3410,20 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
+	unsigned int num_channels;
 	int i, err;
 	int stride;
 	struct resource *res;
 
-	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
+	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
+		return -EINVAL;
+
+	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->num_channels = num_channels;
+
 	INIT_LIST_HEAD(&priv->alg_list);
 
 	dev_set_drvdata(dev, priv);
@@ -3437,7 +3443,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3512,16 +3517,6 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 	}
 
-	priv->chan = devm_kcalloc(dev,
-				  priv->num_channels,
-				  sizeof(struct talitos_channel),
-				  GFP_KERNEL);
-	if (!priv->chan) {
-		dev_err(dev, "failed to allocate channel management space\n");
-		err = -ENOMEM;
-		goto err_out;
-	}
-
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 11f0eb6a41db6..d4ff8d589f461 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -151,8 +151,6 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	struct talitos_channel *chan;
-
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
 
@@ -165,6 +163,9 @@ struct talitos_private {
 	/* hwrng device */
 	struct hwrng rng;
 	bool rng_registered;
+
+	struct talitos_channel chan[] __counted_by(num_channels);
+
 };
 
 /* .features flag */
-- 
2.53.0



