Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF816248886;
	Wed, 25 Feb 2026 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983911; cv=none; b=XSH+pg4PrLDZ5dXh8mx1PrULguxdaWUbkUDk8q2pPoCswG9XehAEFE/Y/N/jRalAFRZIkqrus7I2SgHZ1u6emN53JNfgYHdgN0dHLykLwNNEno7A6WfNAjMhf/qq7p+cHCZOZJ3enQt0vYhBw2dELn+VUBFmMC5oEEIBXA35Ciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983911; c=relaxed/simple;
	bh=VsUfBk/UoikmCiA00wgiyF8n68aHggChgeWQeOw8MMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJPvSj8hlE3suYGvhMWXi8u6FOgzCcoGSi/U1Jm+/9RQfelnLHiuBksCIoIKcKL0/gkC2PxzPlDRP3VqvzcNBRtb0zBZGFscww9ElhDsxhLskhFN5SfVeCHWp1D7yr20A2eTWHXEsEkp93oGzmM3w+UewL/Kxq5y59Th9vMy3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLbptksR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLbptksR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA35C116D0;
	Wed, 25 Feb 2026 01:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983910;
	bh=VsUfBk/UoikmCiA00wgiyF8n68aHggChgeWQeOw8MMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLbptksR+NI2sLPSbByb/WbEOLdlank4HlE81KMBzLmYuGW1D0HsNKgVtcLQeJvFM
	 96eEke6FVY/sF4cwvTBrsVG0GrRnYfMpJekcCWp/pjRPCUwzbajoF3Trh+u/dbpUdy
	 G5BBKKD+ydlAQDrtGeKeRMJUeAV6UmJ3pc8CEujQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/641] drm/panthor: Fix panthor_gpu_coherency_set()
Date: Tue, 24 Feb 2026 17:18:23 -0800
Message-ID: <20260225012353.320438531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 9beb8dca9e749e9983e70b22e9823e6fcd519f91 ]

GPU_COHERENCY_PROTOCOL takes one of GPU_COHERENCY_xx
not BIT(GPU_COHERENCY_xx).

v3:
- New commit

v4:
- Add Steve's R-b

v5:
- No changes

v6:
- No changes

v7:
- No changes

v8:
- No changes

Cc: Akash Goel <akash.goel@arm.com>
Fixes: dd7db8d911a1 ("drm/panthor: Explicitly set the coherency mode")
Reported-by: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251208100841.730527-3-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index b92c9e738dbfa..77d0f4ced1206 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -49,7 +49,7 @@ struct panthor_gpu {
 static void panthor_gpu_coherency_set(struct panthor_device *ptdev)
 {
 	gpu_write(ptdev, GPU_COHERENCY_PROTOCOL,
-		ptdev->coherent ? GPU_COHERENCY_PROT_BIT(ACE_LITE) : GPU_COHERENCY_NONE);
+		  ptdev->coherent ? GPU_COHERENCY_ACE_LITE : GPU_COHERENCY_NONE);
 }
 
 static void panthor_gpu_irq_handler(struct panthor_device *ptdev, u32 status)
-- 
2.51.0



