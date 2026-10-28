Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215870;
	b=FG2CBsxzhnwnttbxjSfU4gmeIq20smO47R61bc8bg+AhgkvLJ7s95Kuo2Ep6gMgahWZc
	 5S+utOczS7T/sco1DBAZTeDvChwSD372n2mnui96XYzYOONlqwGC2mhfopKrUa1mdnyEU
	 5SQ9cQbhvl2muSNFEaACRWnxsjBqnlA4x2Fzkfd4+2R5ZWmCV81qxrIhE4haNp8dIfSfz
	 U8DaoDVUx/pyOf9T/LLARg42rMaRZkF4mG7NrchKCMwVvLpBG97h/YUu8CKHVQHfg7Zh5
	 CKm1H9Trs7vrJICWgkPKkUbk2g9sXTgLxKpRiH1XixZJZHXfREhBtKdw6S81Sq72d8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcbQirSaY0uPdo217HLZLNOw7Q1n7xv84EQFHrjRGI8=;
	b=5cSqOkfLMPd2pwUe1agEQxAgm6oNlHV090/ySeHLU8vOY5AwLszdnEaI+WR/FiaRYHqd
	 UXQG0c1C1fd3PvP6NCoiVDkq+7qcaAZJFnjBCSYzIdy8Fz8o8YLzleJCzSodwmd4eEQM1
	 JBFxUWxqElVdxU95YFdetv/fL+GUcmXyGsA+JuDK7/44DnNVP2CeBWoE/u/4R+2KtSk86
	 kOIxacTa2oQAYF3x9bgFeRAu6gSbYewPwgtmFfv7nGvH2Qfy+ob/0NLeeULTSxguUWdlE
	 TAduBHrmYU3NoBYzSqixxAVTXvr//WphHIf/zjMiRIRZlihO6by8JzT4Bp421TE6Vog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKS8jv+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568F2606A325;
	Wed, 28 Oct 2026 19:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dKS8jv+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3861F01828;
	Wed, 28 Oct 2026 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215870;
	bh=DcbQirSaY0uPdo217HLZLNOw7Q1n7xv84EQFHrjRGI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKS8jv+3VsUS5Ht1xmmIK5ckHEb89I+glQFETBsI/6T8DTJQq4PJ27jxOY1oPY9Qk
	 rRXYCanxxvdnETvHPv36hYTrR9BfbfOE5s/aTl9xjqgyjet4fdKvkAZaF9UEqG5itv
	 sXcojIZcFiOuRZNi7hcbOcYDDF4TDrpEVh3DCznY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1359/1887] NTB: core: Add .get_dma_dev() callback to ntb_dev_ops
Date: Wed, 28 Oct 2026 17:57:35 +0100
Message-ID: <20261028170530.370043353@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 362a4549f2acfb03390ddfcd91041e65a11a739f ]

Some NTB implementations are backed by a PCI function that is not the right
struct device to use with DMA API helpers (e.g. due to IOMMU topology, or
because the NTB device is virtual).

Add an optional .get_dma_dev() callback to struct ntb_dev_ops and provide a
helper, ntb_get_dma_dev(), so NTB clients can use the appropriate struct
device for DMA allocations and mappings.

If the callback is not implemented, ntb_get_dma_dev() returns the current
default (ntb->dev.parent). Drivers that implement .get_dma_dev() must
return a non-NULL device.

Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: format doc]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260306031443.1911860-2-den@valinux.co.jp
Stable-dep-of: da6d997ac556 ("ntb: Store original DMA address for future release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ntb.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/ntb.h b/include/linux/ntb.h
index 191b524e5c0dc..5c29e904a9c52 100644
--- a/include/linux/ntb.h
+++ b/include/linux/ntb.h
@@ -256,6 +256,7 @@ static inline int ntb_ctx_ops_is_valid(const struct ntb_ctx_ops *ops)
  * @msg_clear_mask:	See ntb_msg_clear_mask().
  * @msg_read:		See ntb_msg_read().
  * @peer_msg_write:	See ntb_peer_msg_write().
+ * @get_dma_dev:	See ntb_get_dma_dev().
  */
 struct ntb_dev_ops {
 	int (*port_number)(struct ntb_dev *ntb);
@@ -329,6 +330,7 @@ struct ntb_dev_ops {
 	int (*msg_clear_mask)(struct ntb_dev *ntb, u64 mask_bits);
 	u32 (*msg_read)(struct ntb_dev *ntb, int *pidx, int midx);
 	int (*peer_msg_write)(struct ntb_dev *ntb, int pidx, int midx, u32 msg);
+	struct device *(*get_dma_dev)(struct ntb_dev *ntb);
 };
 
 static inline int ntb_dev_ops_is_valid(const struct ntb_dev_ops *ops)
@@ -391,6 +393,8 @@ static inline int ntb_dev_ops_is_valid(const struct ntb_dev_ops *ops)
 		/* !ops->msg_clear_mask == !ops->msg_count	&& */
 		!ops->msg_read == !ops->msg_count		&&
 		!ops->peer_msg_write == !ops->msg_count		&&
+
+		/* ops->get_dma_dev is optional */
 		1;
 }
 
@@ -1563,6 +1567,26 @@ static inline int ntb_peer_msg_write(struct ntb_dev *ntb, int pidx, int midx,
 	return ntb->ops->peer_msg_write(ntb, pidx, midx, msg);
 }
 
+/**
+ * ntb_get_dma_dev() - get the device to use for DMA allocations/mappings
+ * @ntb:	NTB device context.
+ *
+ * Return a struct device suitable for DMA API allocations and mappings.
+ * This is typically the parent of the NTB device, but may be overridden by a
+ * driver by implementing .get_dma_dev().
+ *
+ * Drivers that implement .get_dma_dev() must return a non-NULL pointer.
+ *
+ * Return: device pointer to use for DMA operations.
+ */
+static inline struct device *ntb_get_dma_dev(struct ntb_dev *ntb)
+{
+	if (!ntb->ops->get_dma_dev)
+		return ntb->dev.parent;
+
+	return ntb->ops->get_dma_dev(ntb);
+}
+
 /**
  * ntb_peer_resource_idx() - get a resource index for a given peer idx
  * @ntb:	NTB device context.
-- 
2.53.0



