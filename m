Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC6FDDA9;
	Tue, 20 May 2025 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749600; cv=none; b=lhuCzU0fu55AFZ0ityCOWdedm+o6C32riLynNrqmOoEkS4uC0iIfwgDg/H/WnIaHZYATA5vdWdNc3yIwvpjZLVteQP5ryQXY/xbOrUaVr/Y9PIBR51fwDmI6webWs/5RZCKw0FoJOxXio6iRie3tNuCTVqaB34RJBFNl1uMPIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749600; c=relaxed/simple;
	bh=uCTzTRDQnVHWPrFlgnb3i/cxn/T6gdhLKwnHvu0wZG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SenIZtHuqfbRSIcIi9pDIco+P9ionYCtAgmO4I0RL15LIq0yTNzC+kHOhfa4kaVRHyacKZeDtZ10ZrcfhVHSfY3hUxxRDpUmvPGnwG9ymF4CE+wNPsT+OmTMkKwj8x2Am6ugJ5761lX4188fuv/tFi8tUcjfXOO/UqGqe8GuNfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8FF93rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8FF93rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5590DC4CEE9;
	Tue, 20 May 2025 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749600;
	bh=uCTzTRDQnVHWPrFlgnb3i/cxn/T6gdhLKwnHvu0wZG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8FF93rwfLaqIXk0CuokncivqIbAASkaT1dOycDRRNBRPY1Ws61tzFWsuRly4T2lL
	 WSiuOi35Dx+N47vbmF4cHDx2VdDHBFjHYo1hA8YXS09dAWXbtca8Dv7MilXudTXW/L
	 Ehun8GuiOOXZPSj8EjDbZPhZk8yqm7pq6UyovYu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 66/97] dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
Date: Tue, 20 May 2025 15:50:31 +0200
Message-ID: <20250520125803.238315352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit 8ca9590c39b69b55a8de63d2b21b0d44f523b43a upstream.

Currently, a local dma_cap_mask_t variable is used to store device
cap_mask within udma_of_xlate(). However, the DMA_PRIVATE flag in
the device cap_mask can get cleared when the last channel is released.
This can happen right after storing the cap_mask locally in
udma_of_xlate(), and subsequent dma_request_channel() can fail due to
mismatch in the cap_mask. Fix this by removing the local dma_cap_mask_t
variable and directly using the one from the dma_device structure.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Cc: stable@vger.kernel.org
Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Link: https://lore.kernel.org/r/20250417075521.623651-1-y-abhilashchandra@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4216,7 +4216,6 @@ static struct dma_chan *udma_of_xlate(st
 				      struct of_dma *ofdma)
 {
 	struct udma_dev *ud = ofdma->of_dma_data;
-	dma_cap_mask_t mask = ud->ddev.cap_mask;
 	struct udma_filter_param filter_param;
 	struct dma_chan *chan;
 
@@ -4248,7 +4247,7 @@ static struct dma_chan *udma_of_xlate(st
 		}
 	}
 
-	chan = __dma_request_channel(&mask, udma_dma_filter_fn, &filter_param,
+	chan = __dma_request_channel(&ud->ddev.cap_mask, udma_dma_filter_fn, &filter_param,
 				     ofdma->of_node);
 	if (!chan) {
 		dev_err(ud->dev, "get channel fail in %s.\n", __func__);


