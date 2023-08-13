Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43189446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B165C433C8;
	Sun, 13 Aug 2023 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962675;
	bh=TZqAcznvCqCvpUicTpX3fxdcny3QexH2xqVkMvJHJUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLrjr2hjsnH+hEFPa5tXXhTrSmi+VR7d77GY4VHRlMHJDoPpbIfm2Bfuze+NduNjB
	 evL3/mhMoqE2aum3d8rQMY8FWhz23CuvSsiBTZ2zY3StVaPCrWaBCH4c7qib7Ka+GQ
	 bfFII5vJw9gF5Qr0cfmRiYEHVUhX+3JPqy8vzqpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jianhua <chris.zjh@huawei.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 115/149] dmaengine: owl-dma: Modify mismatched function name
Date: Sun, 13 Aug 2023 23:19:20 +0200
Message-ID: <20230813211722.186736789@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Jianhua <chris.zjh@huawei.com>

commit 74d7221c1f9c9f3a8c316a3557ca7dca8b99d14c upstream.

No functional modification involved.

drivers/dma/owl-dma.c:208: warning: expecting prototype for struct owl_dma_pchan. Prototype was for struct owl_dma_vchan instead HDRTEST usr/include/sound/asequencer.h

Fixes: 47e20577c24d ("dmaengine: Add Actions Semi Owl family S900 DMA driver")
Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20230722153244.2086949-1-chris.zjh@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/owl-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -192,7 +192,7 @@ struct owl_dma_pchan {
 };
 
 /**
- * struct owl_dma_pchan - Wrapper for DMA ENGINE channel
+ * struct owl_dma_vchan - Wrapper for DMA ENGINE channel
  * @vc: wrapped virtual channel
  * @pchan: the physical channel utilized by this channel
  * @txd: active transaction on this channel


