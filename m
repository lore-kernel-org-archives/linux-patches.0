Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A5611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA996C433EF;
	Sun, 28 May 2023 19:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302987;
	bh=KTq+I1tuZnWMeNLGjXwYZtuOuz+tONiQr7XI1hTGv30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xT5IkAMCIDftWgcI5/HdQjKon3SjUtuln1wEzsUrzn6+1de72XjS8l8Wt/3d7He3A
	 Z30i/loUHeeR+cr/394oP4fmtrv1wA+njlkce2rAM5Wbd3AhjTMHkddi0ZIAQOl0iV
	 NBdCmZAcroXPccu2jBRkIY2o173scKwpsUqdlYMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/211] drm/exynos: fix g2d_open/close helper function definitions
Date: Sun, 28 May 2023 20:10:28 +0100
Message-Id: <20230528190846.237271562@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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

[ Upstream commit 2ef0785b30bd6549ddbc124979f1b6596e065ae2 ]

The empty stub functions are defined as global functions, which
causes a warning because of missing prototypes:

drivers/gpu/drm/exynos/exynos_drm_g2d.h:37:5: error: no previous prototype for 'g2d_open'
drivers/gpu/drm/exynos/exynos_drm_g2d.h:42:5: error: no previous prototype for 'g2d_close'

Mark them as 'static inline' to avoid the warning and to make
them behave as intended.

Fixes: eb4d9796fa34 ("drm/exynos: g2d: Convert to driver component API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.h b/drivers/gpu/drm/exynos/exynos_drm_g2d.h
index 74ea3c26deadc..1a5ae781b56c6 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.h
@@ -34,11 +34,11 @@ static inline int exynos_g2d_exec_ioctl(struct drm_device *dev, void *data,
 	return -ENODEV;
 }
 
-int g2d_open(struct drm_device *drm_dev, struct drm_file *file)
+static inline int g2d_open(struct drm_device *drm_dev, struct drm_file *file)
 {
 	return 0;
 }
 
-void g2d_close(struct drm_device *drm_dev, struct drm_file *file)
+static inline void g2d_close(struct drm_device *drm_dev, struct drm_file *file)
 { }
 #endif
-- 
2.39.2



