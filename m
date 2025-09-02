Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B732833471B;
	Tue,  2 Sep 2025 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820197; cv=none; b=HhqKiE/vr/uCwHL9MJjCgoVsc1ZzC9EkBKSWblqKqEE/NNXJZElGaTA3joVxbU9d44R6aTB5WP+MDbqJSpqgzcRJD8o1fKSus0BwuIX5oEextG1Wv2PCc8UglqxFCHeqUQ9uuilucdZPhtvDnMytOnTESK/uNr28FIUA8lPYzsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820197; c=relaxed/simple;
	bh=v1JUP+4mFnRJ0eh6lh3KVOaIU9Pk3FYi2CXfcA6419s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzexsE0szY6orArJVZyT7Oeydut86TrRZp5ljviBLp00/tmz1BnqpkB0xYk9Y19NhiZO2vYAthzjquci6TbBIe2vFgnXjxtJIRAIR2W3zfD4Z0Sg193OmdjB/LVc27oCQ1/b9mJ+DJrJy4OJXgIF1dcCxJz5gIZVfNUySiRaCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnDh81Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnDh81Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FE5C4CEED;
	Tue,  2 Sep 2025 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820197;
	bh=v1JUP+4mFnRJ0eh6lh3KVOaIU9Pk3FYi2CXfcA6419s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnDh81Q81gFK8QkKcYMubrldmp6HqndwygvcGetkQdRHk/tRRkPZpfiN4BFINH73P
	 ce7ZmOZMQGoMmq7cL1yaRBryc8vr3L4Wk+Bpnb0WoenIQlwU9zFgzDe/jE6X+ibZ5m
	 ojCkamUMNEQU2t0oD/nYdpUNQymsPFOx2eETLGS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/75] drm/nouveau: remove unused memory target test
Date: Tue,  2 Sep 2025 15:20:40 +0200
Message-ID: <20250902131936.221380445@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 64c722b5e7f6b909b0e448e580f64628a0d76208 ]

The memory target check is a hold-over from a refactor.  It's harmless
but distracting, so just remove it.

Fixes: 2541626cfb79 ("drm/nouveau/acr: use common falcon HS FW code for ACR FWs")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://lore.kernel.org/r/20250813001004.2986092-3-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c b/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
index 6a004c6e67425..7c43397c19e61 100644
--- a/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
@@ -249,9 +249,11 @@ int
 gm200_flcn_fw_load(struct nvkm_falcon_fw *fw)
 {
 	struct nvkm_falcon *falcon = fw->falcon;
-	int target, ret;
+	int ret;
 
 	if (fw->inst) {
+		int target;
+
 		nvkm_falcon_mask(falcon, 0x048, 0x00000001, 0x00000001);
 
 		switch (nvkm_memory_target(fw->inst)) {
@@ -285,15 +287,6 @@ gm200_flcn_fw_load(struct nvkm_falcon_fw *fw)
 	}
 
 	if (fw->boot) {
-		switch (nvkm_memory_target(&fw->fw.mem.memory)) {
-		case NVKM_MEM_TARGET_VRAM: target = 4; break;
-		case NVKM_MEM_TARGET_HOST: target = 5; break;
-		case NVKM_MEM_TARGET_NCOH: target = 6; break;
-		default:
-			WARN_ON(1);
-			return -EINVAL;
-		}
-
 		ret = nvkm_falcon_pio_wr(falcon, fw->boot, 0, 0,
 					 IMEM, falcon->code.limit - fw->boot_size, fw->boot_size,
 					 fw->boot_addr >> 8, false);
-- 
2.50.1



