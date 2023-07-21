Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECF01F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30412C433C7;
	Fri, 21 Jul 2023 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956132;
	bh=UOC4YaUSp80zDPImaHYO9dyBUubaKOKNwNkGhjaZnds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ktCm3Hjam9NblzJ3hQH7OxhFZyTW4vlMEWjjYOb0ddvkyHW9D2eaIOH1zvM5J3va
	 xEWjuuYT0x1o5K2rmzqGMN/DDe/wAgRwzp+ISlrsDyhSuhcqO49T9aX0svLYYzwGg3
	 J6uItrbUBCk+l8me7DzEnrKNVYyxWLl75l2a5qPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 098/292] drm/nouveau/disp/g94: enable HDMI
Date: Fri, 21 Jul 2023 18:03:27 +0200
Message-ID: <20230721160533.008045537@linuxfoundation.org>
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

[ Upstream commit c177872cb056e0b499af4717d8d1977017fd53df ]

Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Fixes: f530bc60a30b ("drm/nouveau/disp: move HDMI config into acquire + infoframe methods")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230630160645.3984596-1-kherbst@redhat.com
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/g94.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/g94.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/g94.c
index a4853c4e5ee3a..67ef889a0c5f4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/g94.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/g94.c
@@ -295,6 +295,7 @@ g94_sor = {
 	.clock = nv50_sor_clock,
 	.war_2 = g94_sor_war_2,
 	.war_3 = g94_sor_war_3,
+	.hdmi = &g84_sor_hdmi,
 	.dp = &g94_sor_dp,
 };
 
-- 
2.39.2



