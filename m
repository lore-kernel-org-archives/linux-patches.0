Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60C26B0BC;
	Thu, 13 Feb 2025 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458190; cv=none; b=NXW6IqD813dxQRkQFROQOmdznWwr3TOnjS7U2cEWOUBTBDe763AvK2/UCwdYhAlr6C/998WOgBW1NBAXH4LpZtCouXjDCVheSCj3WIawZ5DZctBdEc5d36La+4E320ssuMIQlqxINvUxe4jfnJyXbURB2PDTBeGSXkn8LMEMKOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458190; c=relaxed/simple;
	bh=eeT6p9EAZyZhMylQdQtrn/ltZ4IzbLBrxZz8opNizrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srLzmOcY1n10z9E04XZA9wssAiPbTSEvEQSu7OQsArEO5WSlZ+q2sYvga3AqnZDpFdAOgIhGHa3u8mbngdKdNMeZXi/Yae0R5yfFMbuhSRn+xMZ907hjN7oCNYw8vSaj5a6SHAdbG/8n2u9KmdTRzxpi7Y9jXy1HbF/i54Fs1RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFst8eXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFst8eXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21D7C4CEE4;
	Thu, 13 Feb 2025 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458190;
	bh=eeT6p9EAZyZhMylQdQtrn/ltZ4IzbLBrxZz8opNizrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFst8eXOu/sseUDaXvufN3rW7nI4KFKFH8HXPTy94Q1XzoXq2T8Oqe2otbxy18nj9
	 smamZ2/VLw1cwTGm+ugOQPMd7O1f7pFpRpL+SIKRg/nzmIPm+8IfxV3AQKKSSuHRUZ
	 jTPlA2XhE6ow7kW+dTfFhjjytasnw7SelFsQiMgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 327/422] media: stm32: dcmipp: correct dma_set_mask_and_coherent mask value
Date: Thu, 13 Feb 2025 15:27:56 +0100
Message-ID: <20250213142449.175029349@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

commit b36077ba289b827b4e76e25e8d8e0cc90fa09186 upstream.

Correct the call to dma_set_mask_and_coherent which should be set
to DMA_BIT_MASK(32).

Fixes: 28e0f3772296 ("media: stm32-dcmipp: STM32 DCMIPP camera interface driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
@@ -893,7 +893,7 @@ struct dcmipp_ent_device *dcmipp_bytecap
 	q->dev = dev;
 
 	/* DCMIPP requires 16 bytes aligned buffers */
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32) & ~0x0f);
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(dev, "Failed to set DMA mask\n");
 		goto err_mutex_destroy;


