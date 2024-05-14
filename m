Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FDB4F88C;
	Tue, 14 May 2024 10:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683910; cv=none; b=sHn0drZ8zJb4H3dWfAwKCfuiPA0SKn8eejnn0VG//gAO8l56GcdQzA+pmypftF2ttatF0R32b3gEu7j5jVp0pyhSOdQoRmjmsKn+XZB5PaMEVElrySqzEsxGmSsA52S2Aj+w2jQefLIbCkEotm811CsUGqz/h+QiYY3sCFYgPW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683910; c=relaxed/simple;
	bh=Dy5P42AEA19ZUcwM61o7FAvDX4/JLXRcq3HhAvsENU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNNsfkchh071IECduiydBtDdGiiSGu7tu1ucaZfIiPD78jmN/qbCCRazfh49SR59ZZRU1LzPdhhCgIz6zgZkgQrIyvYQ0hDyvge9RaNnoWhi/vtYULLp/6aUhKlZJ91oBaghAPOagW6gUWBPyLy0EKesUG7NeJcSIAL8a1tFPWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ0uqWcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ0uqWcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EDFC2BD10;
	Tue, 14 May 2024 10:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683910;
	bh=Dy5P42AEA19ZUcwM61o7FAvDX4/JLXRcq3HhAvsENU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQ0uqWcLKmzuninFWyDyoc2zVS5xvG8tIB7nMIUSojKgoBji85E9CJgHwxulPWSy4
	 zKdrgtTVcXyYIefQPSYR2sMWIlIeIRehZKh3dre3lRIPLs4QtXT5n0MQtaiR6om7ut
	 MY9v1SG7WMtWnGzOrqVhNUgcwu2H870kvvV/3OGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Moulding <dan@danm.net>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.8 294/336] Revert "drm/nouveau/firmware: Fix SG_DEBUG error with nvkm_firmware_ctor()"
Date: Tue, 14 May 2024 12:18:18 +0200
Message-ID: <20240514101049.714793491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit a222a6470d7eea91193946e8162066fa88da64c2 upstream.

This reverts commit 52a6947bf576b97ff8e14bb0a31c5eaf2d0d96e2.

This causes loading failures in
[    0.367379] nouveau 0000:01:00.0: NVIDIA GP104 (134000a1)
[    0.474499] nouveau 0000:01:00.0: bios: version 86.04.50.80.13
[    0.474620] nouveau 0000:01:00.0: pmu: firmware unavailable
[    0.474977] nouveau 0000:01:00.0: fb: 8192 MiB GDDR5
[    0.484371] nouveau 0000:01:00.0: sec2(acr): mbox 00000001 00000000
[    0.484377] nouveau 0000:01:00.0: sec2(acr):load: boot failed: -5
[    0.484379] nouveau 0000:01:00.0: acr: init failed, -5
[    0.484466] nouveau 0000:01:00.0: init failed with -5
[    0.484468] nouveau: DRM-master:00000000:00000080: init failed with -5
[    0.484470] nouveau 0000:01:00.0: DRM-master: Device allocation failed: -5
[    0.485078] nouveau 0000:01:00.0: probe with driver nouveau failed with error -50

I tried tracking it down but ran out of time this week, will revisit next week.

Reported-by: Dan Moulding <dan@danm.net>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/firmware.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/core/firmware.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/firmware.c
@@ -205,9 +205,7 @@ nvkm_firmware_dtor(struct nvkm_firmware
 		break;
 	case NVKM_FIRMWARE_IMG_DMA:
 		nvkm_memory_unref(&memory);
-		dma_unmap_single(fw->device->dev, fw->phys, sg_dma_len(&fw->mem.sgl),
-				 DMA_TO_DEVICE);
-		kfree(fw->img);
+		dma_free_coherent(fw->device->dev, sg_dma_len(&fw->mem.sgl), fw->img, fw->phys);
 		break;
 	case NVKM_FIRMWARE_IMG_SGT:
 		nvkm_memory_unref(&memory);
@@ -237,17 +235,14 @@ nvkm_firmware_ctor(const struct nvkm_fir
 		fw->img = kmemdup(src, fw->len, GFP_KERNEL);
 		break;
 	case NVKM_FIRMWARE_IMG_DMA: {
+		dma_addr_t addr;
+
 		len = ALIGN(fw->len, PAGE_SIZE);
 
-		fw->img = kmalloc(len, GFP_KERNEL);
-		if (!fw->img)
-			return -ENOMEM;
-
-		memcpy(fw->img, src, fw->len);
-		fw->phys = dma_map_single(fw->device->dev, fw->img, len, DMA_TO_DEVICE);
-		if (dma_mapping_error(fw->device->dev, fw->phys)) {
-			kfree(fw->img);
-			return -EFAULT;
+		fw->img = dma_alloc_coherent(fw->device->dev, len, &addr, GFP_KERNEL);
+		if (fw->img) {
+			memcpy(fw->img, src, fw->len);
+			fw->phys = addr;
 		}
 
 		sg_init_one(&fw->mem.sgl, fw->img, len);


