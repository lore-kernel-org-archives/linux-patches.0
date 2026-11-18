Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054200;
	b=ZdNmrie73D7LJunbW8dHIkHBLvKR1Ey75ksJrKbiVTvAfceq94wYSuaWC7AnuV3M+RWn
	 xyg6SfIOubE5KOz8UA9kMC72NawNz0YrglZ7cbqrO3p4lrzb6cfAP0ZPqloxTtU48D3YP
	 oRfWm2bS7KJhP1EoobRmMgph0fgrkFf50E63cjXywNlemdY6FKMOHPe1rQor08HBgPg1b
	 SiINoZrkEDltDgRs+QkgiqGA1IvX2KttPN3b7USWPblSfD1iqA7OhaR6WVGRwTPv/3Vna
	 u7+ILi/VcNJWxy6kYenhG5iRC56Vpxn4IMFpaHNaZXtAMgsmSG6hY8jOVjSUYBA+XpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8BL/FfMZbV5LmogBIzMzuXh1lpk95T0E9mKKoGKUY6A=;
	b=wnlurM+PtnKHO4wtw4Go9n4ZRUDymQXzFxDfRGPDf5XZOHfgwtQwl5zpZYj0KD/uYSzj
	 0+q+DHJnrJyy48ywCozdYfn4wjXWKO4l3mHFpL91DOqiuKNBCx6ulBTY1fYtL/x8NS97j
	 0eO6Fvkr8tNBhwKDK+H42hqM4SgunkN6SSS2L3FsL4BooniCcGc1V6wtZY+lNecgiSfSU
	 bx8llkRH7n2mOGXZvm1gaN4AuwAbgq5iwPDFezwnYMA+fx9Jx78D1URDhHq2DORuj0DPw
	 c7ZHcNRLT+N9dYhoaBZ0u8RHReTsh1S85ciiQh9SNxmXeDMfPaBEcVHLSbwIrubZ1QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxy6FLPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443D606A320;
	Thu, 19 Nov 2026 02:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxy6FLPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC79D1F000C4;
	Thu, 19 Nov 2026 02:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054200;
	bh=8BL/FfMZbV5LmogBIzMzuXh1lpk95T0E9mKKoGKUY6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxy6FLPTFbINMg0fLYPmkK2gYzoBHxQe7cHd0KjkNH0GTsU6iZoEg29vTJN9brPQc
	 bcBddBihyFvRLGylXm1kDTn2D+EVM/Yht85+B9d4kOeBrbuKcz9xvVO0FXCfh7XaIB
	 5zg+MA8ZZWCpiBQwQzNU/jDzqENPZqd7P7cv4HHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1189/2214] fbdev: nvidia: Release write-combining handle on probe failure
Date: Wed, 18 Nov 2026 15:47:45 +0100
Message-ID: <20261118150059.471697952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 8710af6a35201a6d01b5af8f7e4bad29cc40467f ]

Failures in nvidia_set_fbinfo() or register_framebuffer() leave the handle
from arch_phys_wc_add() allocated. Release it in the shared error path,
as nvidiafb_remove() already does on normal removal.

The missing cleanup was already present in the initial Git import,
when the driver used mtrr_add() directly.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: adjusted error-path context to account for the existing iounmap(info->screen_base) call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index ecf07b598453e..05d3d1fcd81d7 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1408,6 +1408,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
-- 
2.53.0



