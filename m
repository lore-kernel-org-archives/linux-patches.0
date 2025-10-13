Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AE424A044;
	Mon, 13 Oct 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369590; cv=none; b=iILAsju0+zAXbtgDr17GDAwFoZRs2qDwtWxtIjRYCm5AI+EsYdpH/R+qMNNilx4BNJjzuBmNvOkCnl3yMSq18sXyKlzN19cLuQAWrBxKjxPjf0IWToivDZ0rZmE1e0F2JuOdY170Kfkpp9qZusj7W049lJVVD85VOIKWJshWg8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369590; c=relaxed/simple;
	bh=bfB99mAZX8l2s98dIiJ/zpECEec+WZoHaUDw9qqV6uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikw1U3SE5BDRewSYBtZ7omcYB5sAIp+R5pC4iaJB9OAR7dlqWX6IxoHpeb0Ck5s1WfUH7UbvQOjffpZmHfXRg54YF272wk1OaGieTxxXifNTBghz1WAs7oregjNcHvzHji+ufM0C2cnIbsrBj6QrbP9ByEYyVFRkflm07OUeM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdGiUivq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdGiUivq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62738C4CEE7;
	Mon, 13 Oct 2025 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369588;
	bh=bfB99mAZX8l2s98dIiJ/zpECEec+WZoHaUDw9qqV6uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdGiUivqGPQrr1vrHgMLxudfJwm/kPbOkOyDOPCEbobvWNTVWMLLeAe/KZdf+Iffp
	 jN36F60iJvgm0+c1xdkH1HG9IgotSkuY+X681XhGYQeahr2oD2Zj434eiHN1vQwd5m
	 Z2qJcLuOPn1NEh0CTp7Wyjg6YI+q+7XmFLoEgfgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 298/563] dmaengine: Fix dma_async_tx_descriptor->tx_submit documentation
Date: Mon, 13 Oct 2025 16:42:39 +0200
Message-ID: <20251013144422.064297207@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan.lynch@amd.com>

[ Upstream commit 7ea95d55e63176899eb96f7aaa34a5646f501b2c ]

Commit 790fb9956eea ("linux/dmaengine.h: fix a few kernel-doc
warnings") inserted new documentation for @desc_free in the middle of
@tx_submit's description.

Put @tx_submit's description back together, matching the indentation
style of the rest of the documentation for dma_async_tx_descriptor.

Fixes: 790fb9956eea ("linux/dmaengine.h: fix a few kernel-doc warnings")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Nathan Lynch <nathan.lynch@amd.com>
Link: https://lore.kernel.org/r/20250826-dma_async_tx_desc-tx_submit-doc-fix-v1-1-18a4b51697db@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dmaengine.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 6de7c05d6bd8c..99efe2b9b4ea9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -594,9 +594,9 @@ struct dma_descriptor_metadata_ops {
  * @phys: physical address of the descriptor
  * @chan: target channel for this operation
  * @tx_submit: accept the descriptor, assign ordered cookie and mark the
+ *	descriptor pending. To be pushed on .issue_pending() call
  * @desc_free: driver's callback function to free a resusable descriptor
  *	after completion
- * descriptor pending. To be pushed on .issue_pending() call
  * @callback: routine to call after this operation is complete
  * @callback_result: error result from a DMA transaction
  * @callback_param: general parameter to pass to the callback routine
-- 
2.51.0



