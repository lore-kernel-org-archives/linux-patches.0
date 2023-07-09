Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8568A5232
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00141C433C8;
	Sun,  9 Jul 2023 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901970;
	bh=j97IC3UZTTirl69QGwvmrQh8aZGq4tIqkya9dvtFx1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+pkgKreRvNm6KhTLh4FhfP1Z+01IRn2r2y/XIWDsYbfZur5eGKWe2H7ugtJAL/yy
	 QiyOZiw2j6Sy3O0HnDMLWp7u1Km7ShSEGV5DOONOuRQxjhr2T9kLOwALtyV4jVN6EG
	 NChHgSv/EtEnMDne6lVqVBz722U44bQQrSaHZzqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Karol Herbst <kherbst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 209/431] drm/nouveau: dispnv50: fix missing-prototypes warning
Date: Sun,  9 Jul 2023 13:12:37 +0200
Message-ID: <20230709111456.068771983@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 504e72ed3a1b1c0d4450712a42ae6070d3a05a8e ]

nv50_display_create() is declared in another header, along with
a couple of declarations that are now outdated:

drivers/gpu/drm/nouveau/dispnv50/disp.c:2517:1: error: no previous prototype for 'nv50_display_create'

Fixes: ba801ef068c1 ("drm/nouveau/kms: display destroy/init/fini hooks can be static")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230417210329.2469722-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 1 +
 drivers/gpu/drm/nouveau/nv50_display.h  | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 5bb777ff13130..9b6824f6b9e4b 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -64,6 +64,7 @@
 #include "nouveau_connector.h"
 #include "nouveau_encoder.h"
 #include "nouveau_fence.h"
+#include "nv50_display.h"
 
 #include <subdev/bios/dp.h>
 
diff --git a/drivers/gpu/drm/nouveau/nv50_display.h b/drivers/gpu/drm/nouveau/nv50_display.h
index fbd3b15583bc8..60f77766766e9 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.h
+++ b/drivers/gpu/drm/nouveau/nv50_display.h
@@ -31,7 +31,5 @@
 #include "nouveau_reg.h"
 
 int  nv50_display_create(struct drm_device *);
-void nv50_display_destroy(struct drm_device *);
-int  nv50_display_init(struct drm_device *);
-void nv50_display_fini(struct drm_device *);
+
 #endif /* __NV50_DISPLAY_H__ */
-- 
2.39.2



