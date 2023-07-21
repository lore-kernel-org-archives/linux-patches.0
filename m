Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5EB1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5240C433C7;
	Fri, 21 Jul 2023 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955979;
	bh=CS2SUpJ/ngDLi/pnKdsX8S9b4bO9oH6TKFS2jvJgbQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6FqbriVW8rqjTUbo51PKojiAjnAITOdJ+w/Zsy+1DmMmyAcNk8+TMuyuvjyMcGZS
	 vyQuN5evsslDLY8TVL4Yubgn7SDz0UWGMW60qvlt/Rxahx7BFMdq4qNRWo+mnHU9DZ
	 dcUga+A1tyBU3Nnkfj4NVsjVkhICRQM7+Ws8d4sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 097/292] drm/nouveau/disp: fix HDMI on gt215+
Date: Fri, 21 Jul 2023 18:03:26 +0200
Message-ID: <20230721160532.965978332@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Herbst <kherbst@redhat.com>

[ Upstream commit d94303699921bda8141ad33554ae55b615ddd149 ]

Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Fixes: f530bc60a30b ("drm/nouveau/disp: move HDMI config into acquire + infoframe methods")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230628212248.3798605-1-kherbst@redhat.com
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gt215.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gt215.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gt215.c
index a2c7c6f83dcdb..506ffbe7b8421 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gt215.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gt215.c
@@ -125,7 +125,7 @@ gt215_sor_hdmi_infoframe_avi(struct nvkm_ior *ior, int head, void *data, u32 siz
 	pack_hdmi_infoframe(&avi, data, size);
 
 	nvkm_mask(device, 0x61c520 + soff, 0x00000001, 0x00000000);
-	if (size)
+	if (!size)
 		return;
 
 	nvkm_wr32(device, 0x61c528 + soff, avi.header);
-- 
2.39.2



