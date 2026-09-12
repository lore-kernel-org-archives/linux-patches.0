Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B22D412BED;
	Sat, 12 Sep 2026 09:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206544; cv=none; b=o9ZqVbIE7wi4n0PD25y5yh0houekfBXfz5/d8RXraIhGUywChwEIoNWkRaOv7t5zV2y48P+aHEboIrZPJXeoZTm2MODK1W4WvSkUvnmQOstk5YK0hCLqkHBRW8Bi5oEF2IphPsEowNxYWQLafUbrwboyxwJEkwrvvO9f8rVxu2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206544; c=relaxed/simple;
	bh=J9BnH3b/R1+pMrZjD8q3K+nITV1CmUO5c2CxPp1O99k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCu/oo/rLdvHnMBd/FdW9QY04tkcK6Bvmxe0cOZ8gCGEDqdg5jvQ/3npUcYK2BlGaeWuqLBkhS7EKjPZeKxj5s9qOa2BwBE0Mq573h1ZBw4rkKYZ+LsrAZWk7dnj4xMHKHuyieYB9wCQwajmhcOMGTxM1hKRYTENxtG5fv19Btw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVLa+EYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVLa+EYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CF61F000FF;
	Sat, 12 Sep 2026 09:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206543;
	bh=HLfkGGH4XwtHQxVBuPYuV9IOJlf+YvbOtG/uGNp0sUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVLa+EYFWQDags99jDTz0psOtKeF+M+Ha1lOQDO4GNGftBHdcu+WnH9lbrWj+z1tY
	 oS8F703Yfn3BpmwEJFqibrjd9b9cHlAQdykW/kUfYeDh24ll0QYvDZJ/OSfiTBv8Uk
	 9U7/tarJpnI0A8AsM5ZpBy4NRfWI8/YkpsRhtsVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0227/1518] staging: sm750fb: Add missing Kconfig dependency
Date: Sat, 12 Sep 2026 08:39:56 +0200
Message-ID: <20260912065628.624612646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

[ Upstream commit da8fd33e7d6af4c069668c2d42234b969f706885 ]

The sm750 frame buffer driver depends on FB_IOMEM_FOPS, but its Kconfig
somehow misses it.

Fix it by making FB_SM750 select FB_IOMEM_FOPS, as other frame buffer
drivers do.

Fixes: dc0ad215e5d8 ("staging/sm750fb: Initialize fb_ops with fbdev macros")
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260603-sm750-fb-iomem-kconfig-v1-1-7f6a3046cce2@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/sm750fb/Kconfig b/drivers/staging/sm750fb/Kconfig
index 08bcccdd0f1c4..25fe422f55f2c 100644
--- a/drivers/staging/sm750fb/Kconfig
+++ b/drivers/staging/sm750fb/Kconfig
@@ -6,6 +6,7 @@ config FB_SM750
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 	help
 	  Frame buffer driver for the Silicon Motion SM750 chip
 	  with 2D acceleration and dual head support.
-- 
2.53.0



