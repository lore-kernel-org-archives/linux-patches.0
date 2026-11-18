Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039459;
	b=c3VFABuWFjlZhPT8z2wep66eOCggecRwD6ptUI2ye+R/H7pU7xSc2RffCW3T3IydyRAv
	 5r2kzLuiUx/rhqxX2SyDyPjbPCiKccbhzbhKpoGGWx0ycD7PUo3nOspNpcR+VZWE1Av7o
	 hZyofeI6r2sMcxIkJEEHII6lNdWdnZQa38ANbNlrW9kFbNKsWf1jfpapY4GtELevNVWwR
	 LZduhQXb21L/ZPqrCqXyQx6oD9ofRsyKEvir18glw2lR7HdOUBWR08bv2wk805KuKTR94
	 B88gxip1X1y6SCPx3agWoQk7MqkwscsNJnOVa7CK0RvSXM6GXi06QIMF9BeL3iDMbXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b6tYahDvILr8l4Hbub0uOvJTtgwI/yNUzvHib1ND2k4=;
	b=befdAvn6FnCCq4aU6ZWFTu3khqjlJqFnhJLn/c1DeorQpmAW6c1FGj5TzR/xZUPb+ROR
	 fz0tE1La6njqZGEpg7+s4yphQMtyP2r+ct/T4uQjOnaPHdqslo42RLVkvZHt5wJU0XaJK
	 wZ51iVgZ+k6/xN2SzsuJraQQnpDaYGAlewgSgqitFSR1U/9pR7ZDE79yOCutM5EafYTZb
	 d/jdWgqFO0hyrfjs5g2D2HbLwshqCTVoIa/Ud9BxLPqNUH8SWjNw7r/HSDRZiDug+S3ni
	 ia/w4W/Hup2/wD5oCd7w8tjEKAY2BjswHCbPilNikYRCwe9tdVcsn1ssCKI+ypiqonA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4y237Ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1708606A320;
	Wed, 18 Nov 2026 22:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4y237Ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7801F000C5;
	Wed, 18 Nov 2026 22:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039459;
	bh=b6tYahDvILr8l4Hbub0uOvJTtgwI/yNUzvHib1ND2k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4y237AyX0Ph333UvTkGRhviwSx5fuRPHAXSPfRrZAEFGYyqbqF0ZfYlwOcIUDPTR
	 bVorAASHXbze1r9NJheYuMGIqqLYfxxhEzePI14qmgeJP3IGb4VhhZ7oZg3HYy43M5
	 WHx2eEsJB0E/Va9ZITQ4wn+3oWo93OaZk3a834M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2109/3318] wifi: ath12k: allocate dummy net_device dynamically
Date: Wed, 18 Nov 2026 15:45:31 +0100
Message-ID: <20261118150425.343287996@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4f9206e8c2c15a3770e3eb0b9755a05d559fecea ]

Embedding net_device into structures prohibits the usage of flexible
arrays in the net_device structure. For more details, see the discussion
at [1].

Un-embed the net_device from struct ath12k_ext_irq_grp by converting it
into a pointer. Then use the leverage alloc_netdev_dummy() to allocate
the net_device object at ath12k_pci_ext_irq_config().

The free of the device occurs at ath12k_pci_free_ext_irq().

Link: https://lore.kernel.org/all/20240229225910.79e224cf@kernel.org/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240508095410.1923198-1-leitao@debian.org
Stable-dep-of: 9a78703ec4a8 ("wifi: ath12k: Free allocated external IRQs on request_irq() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.h |  2 +-
 drivers/net/wireless/ath/ath12k/pci.c  | 27 +++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 18dfd7aab610c..8f26d8ec789a8 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -127,7 +127,7 @@ struct ath12k_ext_irq_grp {
 	u64 timestamp;
 	bool napi_enabled;
 	struct napi_struct napi;
-	struct net_device napi_ndev;
+	struct net_device *napi_ndev;
 };
 
 #define HEHANDLE_CAP_PHYINFO_SIZE       3
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index df5469ce498f3..3121c67ee16d2 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -353,6 +353,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
 
 		netif_napi_del(&irq_grp->napi);
+		free_netdev(irq_grp->napi_ndev);
 	}
 }
 
@@ -552,8 +553,9 @@ static irqreturn_t ath12k_pci_ext_interrupt_handler(int irq, void *arg)
 static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 {
 	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
-	int i, j, ret, num_vectors = 0;
+	int i, j, n, ret, num_vectors = 0;
 	u32 user_base_data = 0, base_vector = 0, base_idx;
+	struct ath12k_ext_irq_grp *irq_grp;
 
 	base_idx = ATH12K_PCI_IRQ_CE0_OFFSET + CE_COUNT_MAX;
 	ret = ath12k_pci_get_user_msi_assignment(ab, "DP",
@@ -564,13 +566,18 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 		return ret;
 
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
-		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
+		irq_grp = &ab->ext_irq_grp[i];
 		u32 num_irq = 0;
 
 		irq_grp->ab = ab;
 		irq_grp->grp_id = i;
-		init_dummy_netdev(&irq_grp->napi_ndev);
-		netif_napi_add(&irq_grp->napi_ndev, &irq_grp->napi,
+		irq_grp->napi_ndev = alloc_netdev_dummy(0);
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			goto fail_allocate;
+		}
+
+		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath12k_pci_ext_grp_napi_poll);
 
 		if (ab->hw_params->ring_mask->tx[i] ||
@@ -603,13 +610,23 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 			if (ret) {
 				ath12k_err(ab, "failed request irq %d: %d\n",
 					   vector, ret);
-				return ret;
+				goto fail_request;
 			}
 		}
 		ath12k_pci_ext_grp_disable(irq_grp);
 	}
 
 	return 0;
+
+fail_request:
+	/* i ->napi_ndev was properly allocated. Free it also */
+	i += 1;
+fail_allocate:
+	for (n = 0; n < i; n++) {
+		irq_grp = &ab->ext_irq_grp[n];
+		free_netdev(irq_grp->napi_ndev);
+	}
+	return ret;
 }
 
 static int ath12k_pci_config_irq(struct ath12k_base *ab)
-- 
2.53.0



