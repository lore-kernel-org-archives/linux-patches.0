Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A369443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47813C433C8;
	Sun, 13 Aug 2023 21:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962188;
	bh=2Uuap0Ar7cCOFh98ujYt39M20xBeNGWH1AleXlA5Hws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wj+HP1R9uGHqLf7opf5Exfwoagz/cilkllsesu0G8t4WmQXsSZg3kxCAX1Kua4Dre
	 PF0G6EwX51g54z9KEVaeQQqsZLfwkVaeOamhj1nk8uIQKlLRy9DL4eqGPXynvUeW36
	 zV3qrfSpv8M0HOYrHXhrG8RKTYJIALAki7rr/ggU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 6.4 145/206] drm/nouveau: remove unused tu102_gr_load() function
Date: Sun, 13 Aug 2023 23:18:35 +0200
Message-ID: <20230813211729.188234447@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit 421dabcad1c69e02a41c0d601aefbc29ee3f5368 upstream.

tu102_gr_load() is completely unused and can be removed to address
this warning:

drivers/gpu/drm/nouveau/dispnv50/disp.c:2517:1: error: no previous prototype for 'nv50_display_create'

Another patch was sent in the meantime to mark the function static but
that would just cause a different warning about an unused function.

Fixes: 1cd97b5490c8 ("drm/nouveau/gr/tu102-: use sw_veid_bundle_init from firmware")
Link: https://lore.kernel.org/all/CACO55tuaNOYphHyB9+ygi9AnXVuF49etsW7x2X5K5iEtFNAAyw@mail.gmail.com/
Link: https://lore.kernel.org/all/20230417210310.2443152-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230803143358.13563-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/gr/tu102.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/tu102.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/tu102.c
index 3b6c8100a242..a7775aa18541 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/tu102.c
@@ -206,19 +206,6 @@ tu102_gr_av_to_init_veid(struct nvkm_blob *blob, struct gf100_gr_pack **ppack)
 	return gk20a_gr_av_to_init_(blob, 64, 0x00100000, ppack);
 }
 
-int
-tu102_gr_load(struct gf100_gr *gr, int ver, const struct gf100_gr_fwif *fwif)
-{
-	int ret;
-
-	ret = gm200_gr_load(gr, ver, fwif);
-	if (ret)
-		return ret;
-
-	return gk20a_gr_load_net(gr, "gr/", "sw_veid_bundle_init", ver, tu102_gr_av_to_init_veid,
-				 &gr->bundle_veid);
-}
-
 static const struct gf100_gr_fwif
 tu102_gr_fwif[] = {
 	{  0, gm200_gr_load, &tu102_gr, &gp108_gr_fecs_acr, &gp108_gr_gpccs_acr },
-- 
2.41.0



