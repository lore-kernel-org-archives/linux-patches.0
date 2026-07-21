Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FB946D096;
	Tue, 21 Jul 2026 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656085; cv=none; b=jw9/3q8U04mutBroQLwiLvcWhBmMq4yIeFHoLaPTa9Ej36Ym2vKYegBv2Je6Hcq7iuwjYHOEIuitC5pfha33tvoXvVGJe8U+wDp3Jn4VvAqXJfwrbY4++8vj7NNh1VmvpJnyGxG9iWBHFaMhZILNvK5qqwSbPWdMKtG00P4dE3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656085; c=relaxed/simple;
	bh=ZP0tvIVIs4uAcN4Yj6Kf+im2w3PyaOaaG+21InABXqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuhcyLdWBn4AwOq++3bbr1cuQwQju6/u1+SrhlY2bgW7w6QUD1QqmB7J/gmg4zu4AXYY0UXwxoZsO+J6p1fGnFcIY00kHxLohtykGwj694b44+UwvWvEOhfutUFh40C3U4+89FNBOBIlkWCHvp+3zvU7P4DOu3qWgNDRy/rCXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKR8D9yK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKR8D9yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC01F000E9;
	Tue, 21 Jul 2026 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656078;
	bh=6SaAmPU4awrgUi06PLV/MSQfIzzCd2Oxjz9Gyz68bOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKR8D9yKchr7H39d7UcKyuWlQzyE024poFPjFU5rVD4cfW03fTQ/7obOL0kZA7yVg
	 x6pOkEJYMPTCHyTMnNBh4JJuApf0IMAon14zKUO2PuKhBV9Q4WSpJUunJ7aRvyuXDC
	 /qjj/H5Fcd0WKxMfKWdKXQJKgJPUpusKwl0Gsiu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0252/1611] drm/nouveau/bios: specify correct display fuse register for Ampere and Ada
Date: Tue, 21 Jul 2026 17:06:08 +0200
Message-ID: <20260721152520.706095715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit c1cf2d5db80ce91a85855bbaf4da85ff603e089a ]

The NV_FUSE_STATUS_OPT_DISPLAY register is used to determine whether
the GPU has display hardware.  The current code that normally reads
this register is instead hard-coded to check for GA100 vs later GPUs.
Since this function is called only on pre-Hopper GPUs, and this
if-statement applies only to GA100 and later, the check works
because GA100 is the only non-display Ampere and Ada GPU.

However, there actually is a register that can be read, so we should
use it.

Fixes: a34632482f1e ("drm/nouveau/bios/ga10[024]: initial support")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260430223838.2530778-8-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c
index 023ddc7c5399a4..a295e94e4cb88d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c
@@ -65,13 +65,14 @@ pramin_init(struct nvkm_bios *bios, const char *name)
 
 	/* we can't get the bios image pointer without PDISP */
 	if (device->card_type >= GA100)
-		addr = device->chipset == 0x170; /*XXX: find the fuse reg for this */
+		addr = nvkm_rd32(device, 0x820c04);
 	else
 	if (device->card_type >= GM100)
 		addr = nvkm_rd32(device, 0x021c04);
 	else
 	if (device->card_type >= NV_C0)
 		addr = nvkm_rd32(device, 0x022500);
+
 	if (addr & 0x00000001) {
 		nvkm_debug(subdev, "... display disabled\n");
 		return ERR_PTR(-ENODEV);
-- 
2.53.0



