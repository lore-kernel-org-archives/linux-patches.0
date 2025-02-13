Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7134126B091;
	Thu, 13 Feb 2025 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459783; cv=none; b=VCGeSZmXSZ/md16J2Z20IPT+E2423Uc/sdR6FROyg36ENkzspIYgNBv7nlIHiE85HZ7fRtIQK3qBvA4BVjwKvnBIf4alt0dKGtwgLK7Sno4b+kqRO10MkMcU74ipnSzq91lNtGVEHtz4bux7zpRZUKkC+98sLZs2IUJ7qZ8ct2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459783; c=relaxed/simple;
	bh=t5WvL20Bb/dnT2bvoL2/IbUyVGrzzcoFxXaw2YsTVWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Evf5GbSa1rInLxpPFo5+Agw76s/n/8Trtra75NLUAduD5YyO/Jurf2w0EMx/Ut8uiVVHEUMhZZEzNeAVOo1XwAwZQQu3DzzZlHAoKrHJaDUXpf0h2wtEpJZskUllAWPBywGeiuQNJR5jrnItg5QDCY2cxWWRH1Z3vow/ZPIfWBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujablTpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujablTpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62332C4CED1;
	Thu, 13 Feb 2025 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459782;
	bh=t5WvL20Bb/dnT2bvoL2/IbUyVGrzzcoFxXaw2YsTVWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujablTpT3C+lqNsQ4bopw5w90eBax0Mi5z1pZ/FbT66f2Ba0NkK9udNqSoVmJXHUm
	 G6V3IRmfEkXuW5+Q4acpfmYtpzb+eOsZj/CLCxtxej0S9L3i/mk0dTIaO6sAEkXXhB
	 wmtyHJ9DeRvxQ3a5NlzR++ZiYfTedpb8hOKmmEp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 363/443] media: stm32: dcmipp: correct dma_set_mask_and_coherent mask value
Date: Thu, 13 Feb 2025 15:28:48 +0100
Message-ID: <20250213142454.619278651@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -887,7 +887,7 @@ struct dcmipp_ent_device *dcmipp_bytecap
 	q->dev = dev;
 
 	/* DCMIPP requires 16 bytes aligned buffers */
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32) & ~0x0f);
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(dev, "Failed to set DMA mask\n");
 		goto err_mutex_destroy;


