Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212226;
	b=GdBdWtDSLmRIFUmj88JnB7RFzCJZOJ6VhN/U22DgCTI+5kqpHsXlITL1/VjbFJ4eR9k+
	 wfFQOyVy+5Rm/UlEmGUDy64l7rwAGF32yqUEs3euODOByef322UU2EFM42coAn3yht6ux
	 wK/v4J+7cL+UuMLH8mABbB7kYGDrcI7OaexpotsIEPnY0NgE6ndDwHqT3P83FH00quxNM
	 QDdzQjF0EXK1Q1sKdIrDe6kuAmrhonr3y+whQBP+577GxAKab6qpfY1fYbN1LjnZkFTIm
	 8Stf5Vf/UkorJyuX0rf69wp1JFEycETW9oKD73MNHuwtTDDMZaIv1FYM/nzYR5vg+cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hU5s2u0QZDewYZMtFXuvXoMD/tH+PhHTFPj6IBVGKYo=;
	b=rB6/R6gOiU4rM52+s4wi2qHls8zOLu3S/10TbtN75nCpXpRa2FJjBPId146d8PPlvGdY
	 EGqU7W5aVkTvDnh6oGm6G5yjXmxHZhoTrR1/m1p/KHaQWrAZ7zHOVnnwUL49NAC64UI5E
	 6Mdkn75V4dEtqI/31astuQWBY0DHkiH+bg+4UYV/B3rGhqF/vYDO/emK6wpeCNAh/BBwB
	 JjSe80rrUjj22Do0C2BVZbg3RCxiG4rl1oDPYB+h9JuDmXZdujN0BY49XfQT/4zEMjx9a
	 3UtVeVQhNnQgTG5KJXlcCZ5RlQCayGJPQdtiHE7tyWpl2CXH8wQf4Ss4jqOZ3LB+xzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HobVY59v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E61606A31A;
	Wed, 28 Oct 2026 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HobVY59v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B821F01825;
	Wed, 28 Oct 2026 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212226;
	bh=hU5s2u0QZDewYZMtFXuvXoMD/tH+PhHTFPj6IBVGKYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HobVY59vXh/Ub6DpD0VhTdxg1EsaF8LtypzNfkcYUSsr/WcPw+f/VseITBrkht5xX
	 8yUE0R0KGwSVlPGO8G0mLDqJzpSLr6pXDSlg9PCZGqZX3rihvL0krKT8ggs9Ktt8/j
	 79b9gG8toYrEJBsy/J05JXHNgwvjSRoVpazpK8zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0082/1887] dmaengine: Add devm_dma_request_chan()
Date: Wed, 28 Oct 2026 17:36:18 +0100
Message-ID: <20261028170501.101455520@linuxfoundation.org>
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
index 53e755c03f414..96c3f455b7bd7 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -933,6 +933,36 @@ void dma_release_channel(struct dma_chan *chan)
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
index 3576c6e89fea4..368a03920c928 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1489,6 +1489,7 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 
 struct dma_chan *dma_request_chan(struct device *dev, const char *name);
 struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);
+struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name);
 
 void dma_release_channel(struct dma_chan *chan);
 int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps);
@@ -1525,6 +1526,12 @@ static inline struct dma_chan *dma_request_chan_by_mask(
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



