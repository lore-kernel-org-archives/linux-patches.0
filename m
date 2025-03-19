Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F3C1C862A;
	Wed, 19 Mar 2025 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394872; cv=none; b=O69BPiZsrjG+S4tnPhhnCHOEo+2lw3eQe4dyiygIC9JEHSh8ohd26jIR2QwwU4MCCDtTyudtHBPIO+NetY5u5K/HIAJRWZq2AJL2BXyqeYC/Zhk6lK5AVHAyDyQ05Z2DCU3YVNlNbcw8XGpbWKrVmqtPw4bHiH6aeYwS6puCI5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394872; c=relaxed/simple;
	bh=r5LNANF1ks16OjJ3A4D/EPJR/hDO5ZRQsdXlklv++1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiYz8zyoR0Q7Def79jxGkdHEInoABDE4NtBTY/q4VJODTFwkXn5YAWIjiTY28TF4PT5RFiDxZu9/CS83sv8bBUEjXi7rEEXNMoahgNgX9UxIRjVKPjfZizeVweBT6vFMvK9Ml0s1AiFm+hQjZ778YIeoQzyLOYCWP8vurxjCyKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dl3HOUqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dl3HOUqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E88C4CEEC;
	Wed, 19 Mar 2025 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394872;
	bh=r5LNANF1ks16OjJ3A4D/EPJR/hDO5ZRQsdXlklv++1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dl3HOUqIGUCqgH97aHq7fHxAYqn31w3gbRQVp1Ks6/QXEVvBvmgU+Hkti6qv5IW21
	 uyfcE74KByE/H3IKKgA+gTszgXUVT5UZDoqNGZvafKmzvvE48wGYHKbWbHtCc9Vi/R
	 elBZkOKOVQPGxOGoZGxHREC2A5vtO5zLGpJ0+3oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/241] fbdev: hyperv_fb: Simplify hvfb_putmem
Date: Wed, 19 Mar 2025 07:28:18 -0700
Message-ID: <20250319143028.408888564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit f5e728a50bb17336a20803dde488515b833ecd1d ]

The device object required in 'hvfb_release_phymem' function
for 'dma_free_coherent' can also be obtained from the 'info'
pointer, making 'hdev' parameter in 'hvfb_putmem' redundant.
Remove the unnecessary 'hdev' argument from 'hvfb_putmem'.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1740845791-19977-2-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1740845791-19977-2-git-send-email-ssengar@linux.microsoft.com>
Stable-dep-of: ea2f45ab0e53 ("fbdev: hyperv_fb: Allow graceful removal of framebuffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index ce23d0ef5702a..9798a34ac571f 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -952,7 +952,7 @@ static phys_addr_t hvfb_get_phymem(struct hv_device *hdev,
 }
 
 /* Release contiguous physical memory */
-static void hvfb_release_phymem(struct hv_device *hdev,
+static void hvfb_release_phymem(struct device *device,
 				phys_addr_t paddr, unsigned int size)
 {
 	unsigned int order = get_order(size);
@@ -960,7 +960,7 @@ static void hvfb_release_phymem(struct hv_device *hdev,
 	if (order <= MAX_PAGE_ORDER)
 		__free_pages(pfn_to_page(paddr >> PAGE_SHIFT), order);
 	else
-		dma_free_coherent(&hdev->device,
+		dma_free_coherent(device,
 				  round_up(size, PAGE_SIZE),
 				  phys_to_virt(paddr),
 				  paddr);
@@ -1080,7 +1080,7 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 }
 
 /* Release the framebuffer */
-static void hvfb_putmem(struct hv_device *hdev, struct fb_info *info)
+static void hvfb_putmem(struct fb_info *info)
 {
 	struct hvfb_par *par = info->par;
 
@@ -1089,7 +1089,7 @@ static void hvfb_putmem(struct hv_device *hdev, struct fb_info *info)
 		iounmap(par->mmio_vp);
 		vmbus_free_mmio(par->mem->start, screen_fb_size);
 	} else {
-		hvfb_release_phymem(hdev, info->fix.smem_start,
+		hvfb_release_phymem(info->device, info->fix.smem_start,
 				    screen_fb_size);
 	}
 
@@ -1203,7 +1203,7 @@ static int hvfb_probe(struct hv_device *hdev,
 
 error:
 	fb_deferred_io_cleanup(info);
-	hvfb_putmem(hdev, info);
+	hvfb_putmem(info);
 error2:
 	vmbus_close(hdev->channel);
 error1:
@@ -1232,7 +1232,7 @@ static void hvfb_remove(struct hv_device *hdev)
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
 
-	hvfb_putmem(hdev, info);
+	hvfb_putmem(info);
 	framebuffer_release(info);
 }
 
-- 
2.39.5



