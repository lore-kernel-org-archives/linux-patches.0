Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD0D7A
	for <patches@lists.linux.dev>; Tue, 31 May 2022 02:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Iki+vUqxCzZFZz+MEnp3w8RvTEkALE2JfdH+6mCRn+I=; b=jNjYFRrIMfh6rFL5PCCpcHmFmv
	tIHKVXIkNZQQXt8i1bHhVcBjYJxvvFZJWc2ZdD5g+jbEl7t2J8hdC40E/ZsfAVtGWIv4SPTuVGo/H
	BulZUWPUiOnHkNGjVqduntBc7/ENks8G9W+kDsCT2javp8eTv9MppRYe+Z7OgWW3adiX7fcaQRLdG
	Yflj87wp2Hr9E0BmER043RUhGWf7nv95S3Ma8pXj9dsNQapEL0ISEJoHG16RZQUKEhtb+gHyitj7W
	ZMtFwjxwbZWIImD/OTgAQtaMGaZ0N9bNP3xtvDyhdmatf4ue+BfTmYzRBMqwiV/Cz7dWpm6E5jiyj
	k9rbgv+A==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=casper.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nvs3B-004zuf-Al; Tue, 31 May 2022 02:56:05 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Xinliang Liu <xinliang.liu@linaro.org>,
	Tian Tao <tiantao6@hisilicon.com>,
	John Stultz <jstultz@google.com>,
	Xinwei Kong <kong.kongxinwei@hisilicon.com>,
	Chen Feng <puck.chen@hisilicon.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH] drm: hisilicon: depends on MMU
Date: Mon, 30 May 2022 19:55:57 -0700
Message-Id: <20220531025557.29593-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent a kconfig warning when MMU is not enabled by making
DRM_HISI_HIBMC depend on MMU.

WARNING: unmet direct dependencies detected for DRM_TTM
  Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && MMU [=n]
  Selected by [m]:
  - DRM_TTM_HELPER [=m] && HAS_IOMEM [=y] && DRM [=m]
  - DRM_HISI_HIBMC [=m] && HAS_IOMEM [=y] && DRM [=m] && PCI [=y] && (ARM64 || COMPILE_TEST [=y])

Fixes: 4f7f1973b0c8 ("drm/vram: fix Kconfig")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Xinliang Liu <xinliang.liu@linaro.org>
Cc: Tian Tao  <tiantao6@hisilicon.com>
Cc: John Stultz <jstultz@google.com>
Cc: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Cc: Chen Feng <puck.chen@hisilicon.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
---
 drivers/gpu/drm/hisilicon/hibmc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/hisilicon/hibmc/Kconfig
+++ b/drivers/gpu/drm/hisilicon/hibmc/Kconfig
@@ -2,6 +2,7 @@
 config DRM_HISI_HIBMC
 	tristate "DRM Support for Hisilicon Hibmc"
 	depends on DRM && PCI && (ARM64 || COMPILE_TEST)
+	depends on MMU
 	select DRM_KMS_HELPER
 	select DRM_VRAM_HELPER
 	select DRM_TTM
