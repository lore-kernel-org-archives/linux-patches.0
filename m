Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210547;
	b=EwEp8jyGxezSJZY18PRKYCMuwGGx5A2iGyJjRtDBx9hZohEu2KiqwNfSvsvLmNf59xRu
	 HtJ6di9/+V8YaVxFQOliUywLQQLS8VCAmAIez/viNoB7xVJS2ef07qnppw2z/h2f4i9ts
	 Jf53NA0vRPeV/ysdQaV4J+3U4atRxF05Pd2buP/HSMSlJmeBUuFoa383M0nA1cet56oUF
	 eGOM+jwcc2LaxUcP+1LV59G2bV8/LmzM7vZZtxf3YHfoForabK0QWte//jS3TAhn038n+
	 OvOfOzb2mV6Z9aVD1m6ggieFJMlc+QNkG3cpS/6q4tmCP1hd6KPNK9YNUshGfeBQj5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0862+1uuXoBl9cPbTlP9LewAJauUHSlUXJJy7/vpmEc=;
	b=NauhVzWyY29xNwi8d3RLRRmxb1TYs7KRaFEo7EQld11pcQxPuMtSWvwNIcRc1b1E3XgA
	 Ieny5muRzoc6utQNPHgbI7K64jHmmc2xaNz+lo0qx12o0OWu6HzwyvGe0wfZ86wfFSGBc
	 +IW1cYVwQKydGtwDp33Cg+0s5+nVG7gGpLkPdUfzs2/k2urPPHzHeAzphq2uCHrbfTmsU
	 774DhRGBk97ghmMwJwzT0lXGXO76LcCVQ/YGNC4PvYti9Nackyd9oaI+EH0q/fXVPhIbi
	 evFWN9dYX3jctwqqSlTHst2JeYoxEvZwbPhghFaO/xGnaFY/rGvrXwbdNZ9aiftvb0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/TS+9Vm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F5A606A31A;
	Wed, 28 Oct 2026 18:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/TS+9Vm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11C41F01825;
	Wed, 28 Oct 2026 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210546;
	bh=0862+1uuXoBl9cPbTlP9LewAJauUHSlUXJJy7/vpmEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/TS+9VmC0LXii+biMMtstRLknmpzqeRAgAOj5rD0CdgveTLC436urpCedAfxE9n7
	 IHls11roflX8+sUQjavA47gTb29BDpJWZQlCZQrs53LySnRFzDdCbsxHETZTm7hEvA
	 010tHkq28Zbn2s4ML8xLzI4EmJTtiAkwAyLFyE/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/571] dmaengine: Add devm_dma_request_chan()
Date: Wed, 28 Oct 2026 17:53:30 +0100
Message-ID: <20261028170009.521977419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 04826a7930392..e4f4838f3b7b6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1486,6 +1486,7 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 
 struct dma_chan *dma_request_chan(struct device *dev, const char *name);
 struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);
+struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name);
 
 void dma_release_channel(struct dma_chan *chan);
 int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps);
@@ -1522,6 +1523,12 @@ static inline struct dma_chan *dma_request_chan_by_mask(
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



