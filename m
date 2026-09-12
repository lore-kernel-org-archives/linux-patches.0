Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B208B2737FC;
	Sat, 12 Sep 2026 07:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198678; cv=none; b=ho+097anR8pofNpw38ueWPMLdmDvPIsnoQlZuQ00ldOiaEUVTFi9hvpGMttE11rw5EqZpS9KEmMjDkfj6xJF43N70m/oVFJmsKesaUmhNaC2p1Vtbbqz3iFVVkYasp36CWAt9Jlbfzfva7qljgeF08DSvofP4YAPycWxBGC2aSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198678; c=relaxed/simple;
	bh=V5a2htPZ/xi2NyTlejX0/1uhtdQ28TyyL+DQOa3MqjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOksEuTaEx+jAckADnE2Zd8//8WaouUglqgKnLrux0zIjnyVHaBs+k6ZXBj0kWHT8GxV1z0Iejq5i8LP1TiwWHw2cqDVF+A97XYFNcvVTcnPNG9qH4b5DtbhYm239FuGNJpZ6E9i2j09JYXTgmo07lvAVUmGxL3Q+5cFypPDZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfM7+c7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfM7+c7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ED71F000FF;
	Sat, 12 Sep 2026 07:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198677;
	bh=yI4OeTvenhlkx9IgBAAgporyIg88o9bLRHJVN9qvork=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfM7+c7mrnscdRaT+C56qp8JyrtnslqETVsI4/rK+61cbPZHTyTYVMoVzWAnK+gJF
	 4Hq73V6G4J3PT6WpKqE1ll+YAFLJ3Ej00f1pAwlVBlniL2xgm9bxaquAeu0QbeMud1
	 Xxnhp5F0p+AT32rXKB8y/Di6xyy4YPOl/z5rmumw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Bin Du <bin.du@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0430/1815] media: platform: amd: fix unmet dependency for VIDEO_V4L2_SUBDEV_API
Date: Sat, 12 Sep 2026 08:36:20 +0200
Message-ID: <20260912065658.989910802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 95a99456ff354a1bad4b4032ed1d044d608bd438 ]

Currently, VIDEO_AMD_ISP4_CAPTURE selects VIDEO_V4L2_SUBDEV_API without
ensuring MEDIA_CONTROLLER is enabled, causing an unmet dependency:

WARNING: unmet direct dependencies detected for VIDEO_V4L2_SUBDEV_API
  Depends on [n]: MEDIA_SUPPORT [=m] && VIDEO_DEV [=m] && MEDIA_CONTROLLER [=n]
  Selected by [m]:
  - VIDEO_AMD_ISP4_CAPTURE [=m] && MEDIA_SUPPORT [=m] && MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] && DRM_AMDGPU [=m] && DRM_AMD_ISP [=y] && HAS_DMA [=y] && VIDEO_DEV [=m]

Many other options in this subsystem select MEDIA_CONTROLLER, let's do the
same here.

This unmet dependency bug was detected by kconfirm, a static analysis tool
for Kconfig.

Fixes: 9a54c285630c ("media: platform: amd: Introduce amd isp4 capture driver")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Bin Du <bin.du@amd.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amd/isp4/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/amd/isp4/Kconfig b/drivers/media/platform/amd/isp4/Kconfig
index 9d1927af1cb8c..77b61fae82bab 100644
--- a/drivers/media/platform/amd/isp4/Kconfig
+++ b/drivers/media/platform/amd/isp4/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_AMD_ISP4_CAPTURE
 	depends on DRM_AMDGPU && DRM_AMD_ISP
 	depends on HAS_DMA
 	depends on VIDEO_DEV
+	select MEDIA_CONTROLLER
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	select VIDEOBUF2_V4L2
-- 
2.53.0



