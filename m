Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B02237701A;
	Sat, 17 Oct 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259815; cv=none; b=tlT8Skz5+yzYgdomnx+e9gaubdYOGwkKVhGEhiAAttbwkJQg9+doS2/cVdN2I35/NpcOOvsbimeKj12MdPqE6v6lmiRLdZktS/l7QSM1w/2VoT4x/l0h/xnLH3H6daO9eramZuO9ktBVUSdR322EK2XT3x8QNbuK7/RJrogVrpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259815; c=relaxed/simple;
	bh=2Jn/R2Hcio4rIE+6MOlhHWBNoqV4DpXIRBlMtKNKH+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxwbOtyoEBTy3FG1++9hG1uE2TEx7igYgDyViDLz10M3c3DfPTlR6U3Ssd/ybrvnXL760Uon8Z4Xy1YdbfsfjxRxGvZs5U0RypXt6Q19OyzVlw4uZZ7V9v6AfBo4tk4Pyb5VtSPKH/ZEJpUTBosktruC5TUcGJUwTUC+7akvcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQhcaaTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQhcaaTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E071F000C4;
	Sat, 17 Oct 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259814;
	bh=7CyeEIWwaVKzBDrXonkteoD0bCUPAaONJkiH9BjHO+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQhcaaTtP3SXrtJbCbyoWidL1WxKw5SjkYElpDs5HGP0a7s+dJ1VhBHMz/PIpA7yM
	 NVw3MRSQJjP272bdrly/KcAIyalkfyZT5rrb8urBXS2WanKs69/uczWbuVOULP+Xw4
	 1NAdOct+Kq+z+N3fiTT6+Epax/xkUckmkMSeJjaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1339/1674] drm/nouveau: remove nouveau_chan.device
Date: Sat, 17 Oct 2026 18:00:11 +0200
Message-ID: <20261017160505.514744547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@nvidia.com>

[ Upstream commit 2eb58f22e2761b75e4f35847be03ddd425ae2b5e ]

nouveau_chan.device is always the same as nouveau_chan.cli.device,
so there's no need to store it separately.

Signed-off-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240726043828.58966-33-bskeggs@nvidia.com
Stable-dep-of: 511585987d27 ("drm/nouveau: unsubscribe the channel-kill event before the fence context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_chan.c | 6 +++---
 drivers/gpu/drm/nouveau/nouveau_chan.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index cee36b1efd391..db2d01d013138 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -157,7 +157,6 @@ nouveau_channel_prep(struct nouveau_cli *cli,
 		return -ENOMEM;
 
 	chan->cli = cli;
-	chan->device = device;
 	chan->drm = drm;
 	chan->vmm = nouveau_cli_vmm(cli);
 	atomic_set(&chan->killed, 0);
@@ -365,8 +364,9 @@ nouveau_channel_ctor(struct nouveau_cli *cli, bool priv, u64 runm,
 static int
 nouveau_channel_init(struct nouveau_channel *chan, u32 vram, u32 gart)
 {
-	struct nvif_device *device = chan->device;
-	struct nouveau_drm *drm = chan->drm;
+	struct nouveau_cli *cli = chan->cli;
+	struct nouveau_drm *drm = cli->drm;
+	struct nvif_device *device = &cli->device;
 	struct nv_dma_v0 args = {};
 	int ret, i;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.h b/drivers/gpu/drm/nouveau/nouveau_chan.h
index 260febd634ee2..18a9cbfef8ca3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.h
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.h
@@ -13,7 +13,6 @@ struct nouveau_channel {
 	} chan;
 
 	struct nouveau_cli *cli;
-	struct nvif_device *device;
 	struct nouveau_drm *drm;
 	struct nouveau_vmm *vmm;
 
-- 
2.53.0



