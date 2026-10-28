Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208263;
	b=MeiUgrbmLwFB9Sw6z9i5Chjp1lpExD0Yrf04FGuByQDZn3xKCAFVAQsLXPH13eJ9bKHj
	 W+rBOqjOXBCZNjtXBdGL2PVsdx1NQSZH2Jrd9BeUvKt3BTD4Lkn/hVIQCEmhBHdoLbP/J
	 fP8f0TAV1JULiq8zulUNAqr6BxAR8KoFLBj+f/NlAwOverf9MgR1rWKNjlBbbWcCUqJhR
	 f3guy34k0GNn/nD7zDTcqMCNEQLTLTsSTtWb6YV3eeqd++GlRXMi8BWNA51bdgia3zt8J
	 1MjeBbbrzzyr3lafvlATgUQeVKDOLky9eOkK1oHz9gYNU2dJgv9hP97OkBg4zy7Olow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sAxCv85Z4VC4bGAWQ3uicUdRwjZr7scFfgAvySA2ca8=;
	b=wct4EOR7miJRs3XqLQ4b9hJUTpQNeIrk3h/JpbzW+OQKdlDUjZwFZBPOQ2BeaMAQK28O
	 UboaexPlrkXKAPG/Th45Va4GgBnWSkBIDeXJ53Uw7WzWvu4P89qJP7Hh3Q0f3n/6y/6VN
	 kUfR+bbMu8/SvX+CvxjBR7XjDt6wIpi0IpNt0g2gXvYmS3YpdwJ8eDNsfJGVUC83Ru+xY
	 fM8rwCd5IX713koA0K59jcxXmq23YO8CNc8Ad9zjoTERU/2fP7bRh0BM85H6TmoLej8W9
	 8zpu5rfDQaBZdbzyga997rlm6d0tM2k3+Su7Yyg2s14uSwkdwIIDY+yLxzLhh0RdBZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmPVkRkt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306F4606A31A;
	Wed, 28 Oct 2026 17:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmPVkRkt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852481F01825;
	Wed, 28 Oct 2026 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208263;
	bh=sAxCv85Z4VC4bGAWQ3uicUdRwjZr7scFfgAvySA2ca8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmPVkRktptAQSmrInf6WH0ofa2clsR7fncgAmAAK42HmfbQ+TcE07RkDqIM92tI18
	 FkB8wfe6AJEnFBOdZDrFKyuG854Ed52X8PHd5y1ql/8FMk9pf6+0+0MoI9LqUrNL6k
	 NqY40qIWKiNviWNLk/7tMFSxHnn9hZVqpJ94+y0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/516] dmaengine: Add devm_dma_request_chan()
Date: Wed, 28 Oct 2026 17:53:31 +0100
Message-ID: <20261028170004.925992036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bence Csókás <csokas.bence@prolan.hu>

[ Upstream commit 08bf1663c21a3e815eda28fa242d84c945ca3b94 ]

Expand the arsenal of devm functions for DMA devices, this time for
requesting channels.

Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Link: https://lore.kernel.org/r/20250610082256.400492-2-csokas.bence@prolan.hu
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 777979e62711 ("i2c: mxs: fix DMA channel leak on probe error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c   | 30 ++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |  7 +++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 41a677a82ed41..fe148431ad9cf 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -934,6 +934,36 @@ void dma_release_channel(struct dma_chan *chan)
 }
 EXPORT_SYMBOL_GPL(dma_release_channel);
 
+static void dmaenginem_release_channel(void *chan)
+{
+	dma_release_channel(chan);
+}
+
+/**
+ * devm_dma_request_chan - try to allocate an exclusive slave channel
+ * @dev:	pointer to client device structure
+ * @name:	slave channel name
+ *
+ * Returns pointer to appropriate DMA channel on success or an error pointer.
+ *
+ * The operation is managed and will be undone on driver detach.
+ */
+
+struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name)
+{
+	struct dma_chan *chan = dma_request_chan(dev, name);
+	int ret = 0;
+
+	if (!IS_ERR(chan))
+		ret = devm_add_action_or_reset(dev, dmaenginem_release_channel, chan);
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	return chan;
+}
+EXPORT_SYMBOL_GPL(devm_dma_request_chan);
+
 /**
  * dmaengine_get - register interest in dma_channels
  */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 4e4cce0ad4d79..0f3a35da0c99c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1476,6 +1476,7 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 
 struct dma_chan *dma_request_chan(struct device *dev, const char *name);
 struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);
+struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name);
 
 void dma_release_channel(struct dma_chan *chan);
 int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps);
@@ -1512,6 +1513,12 @@ static inline struct dma_chan *dma_request_chan_by_mask(
 {
 	return ERR_PTR(-ENODEV);
 }
+
+static inline struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline void dma_release_channel(struct dma_chan *chan)
 {
 }
-- 
2.53.0



