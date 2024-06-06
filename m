Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353819AD8B;
	Thu,  6 Jun 2024 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683355; cv=none; b=mo9UCZ79TQcb6xY1y+ng0BBcyULBEGycvL/72icdzlwSJUd/RyK4fzwyZgqvpvPmAABIYV+jg6oP8fqRZEnZbIc3FAZ3mB7F8krBKaNs9Pti/6AWYay79NRbzS0kP+ZvcESvIlVV55g3vKENpSWtmLakwehCqyd6dwVJpE0eRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683355; c=relaxed/simple;
	bh=TCU1rN5FoD7IxvYAjzBbfwDVI7mIZhBCFqNwokoxr9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z185TvrGbUmRyk3Lqq8cNoA0PiO6knTgDgdWIkGhs+hdw9Jrsd/v6aCiLg74vFs+zDAc8B0T45UbKKLEoijoet4o7zuf/JcS/vK5p5X83wp4/cRoVIbF+biRkaj0Yhbc2iT1+DRhpim1uxiUIzb0cWnGqTZThqQKqkGIIYvsK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPRpnAE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPRpnAE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F8FC2BD10;
	Thu,  6 Jun 2024 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683355;
	bh=TCU1rN5FoD7IxvYAjzBbfwDVI7mIZhBCFqNwokoxr9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPRpnAE+1FrW5QdHLZ1g6PhYAaNJ1ux5/G6kqmxx5hjAPOPF7aX0R9SQAHexFN7bA
	 M7lwkxLWsP+6/DStCiVuiG/jTNH3rzubSDEtRlmfusCT9eztrDD2SSghU/5ok72VaW
	 aT1OwU6NCPxrwSMSCI9bb3LMQ0dbVhGbUk/ekzAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <helen.koike@collabora.com>,
	David Heidelberg <david.heidelberg@collabora.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/744] drm/ci: add subset-1-gfx to LAVA_TAGS and adjust shards
Date: Thu,  6 Jun 2024 15:59:01 +0200
Message-ID: <20240606131741.005232238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Helen Koike <helen.koike@collabora.com>

[ Upstream commit 68a3f17732d1d72be958576b6ce0e6c29686a40b ]

The Collabora Lava farm added a tag called `subset-1-gfx` to half of
devices the graphics community use.

Lets use this tag so we don't occupy all the resources.

This is particular important because Mesa3D shares the resources with
DRM-CI and use them to do pre-merge tests, so it can block developers
from getting their patches merged.

Signed-off-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: David Heidelberg <david.heidelberg@collabora.com>
Link: https://lore.kernel.org/r/20231024004525.169002-7-helen.koike@collabora.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: a2c71b711e7e ("drm/ci: update device type for volteer devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ci/gitlab-ci.yml |  2 +-
 drivers/gpu/drm/ci/test.yml      | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/ci/gitlab-ci.yml b/drivers/gpu/drm/ci/gitlab-ci.yml
index 452b9c2532ae5..3694924367480 100644
--- a/drivers/gpu/drm/ci/gitlab-ci.yml
+++ b/drivers/gpu/drm/ci/gitlab-ci.yml
@@ -26,7 +26,7 @@ variables:
   JOB_ARTIFACTS_BASE: ${PIPELINE_ARTIFACTS_BASE}/${CI_JOB_ID}
   # default kernel for rootfs before injecting the current kernel tree
   KERNEL_IMAGE_BASE: https://${S3_HOST}/mesa-lava/gfx-ci/linux/v6.4.12-for-mesa-ci-f6b4ad45f48d
-
+  LAVA_TAGS: subset-1-gfx
   LAVA_JOB_PRIORITY: 30
 
 default:
diff --git a/drivers/gpu/drm/ci/test.yml b/drivers/gpu/drm/ci/test.yml
index e5b7d309ca186..7b5c5fe121d9d 100644
--- a/drivers/gpu/drm/ci/test.yml
+++ b/drivers/gpu/drm/ci/test.yml
@@ -86,7 +86,7 @@ msm:sc7180:
   extends:
     - .lava-igt:arm64
   stage: msm
-  parallel: 2
+  parallel: 4
   variables:
     DRIVER_NAME: msm
     DEVICE_TYPE: sc7180-trogdor-lazor-limozeen
@@ -158,7 +158,7 @@ rockchip:rk3399:
   extends:
     - .lava-igt:arm64
   stage: rockchip
-  parallel: 3
+  parallel: 2
   variables:
     DRIVER_NAME: rockchip
     DEVICE_TYPE: rk3399-gru-kevin
@@ -181,7 +181,7 @@ rockchip:rk3399:
 i915:apl:
   extends:
     - .i915
-  parallel: 12
+  parallel: 3
   variables:
     DEVICE_TYPE: asus-C523NA-A20057-coral
     GPU_VERSION: apl
@@ -190,7 +190,7 @@ i915:apl:
 i915:glk:
   extends:
     - .i915
-  parallel: 5
+  parallel: 2
   variables:
     DEVICE_TYPE: hp-x360-12b-ca0010nr-n4020-octopus
     GPU_VERSION: glk
@@ -199,7 +199,7 @@ i915:glk:
 i915:amly:
   extends:
     - .i915
-  parallel: 8
+  parallel: 2
   variables:
     DEVICE_TYPE: asus-C433TA-AJ0005-rammus
     GPU_VERSION: amly
@@ -208,7 +208,7 @@ i915:amly:
 i915:kbl:
   extends:
     - .i915
-  parallel: 5
+  parallel: 3
   variables:
     DEVICE_TYPE: hp-x360-14-G1-sona
     GPU_VERSION: kbl
@@ -217,7 +217,7 @@ i915:kbl:
 i915:whl:
   extends:
     - .i915
-  parallel: 8
+  parallel: 2
   variables:
     DEVICE_TYPE: dell-latitude-5400-8665U-sarien
     GPU_VERSION: whl
@@ -226,7 +226,7 @@ i915:whl:
 i915:cml:
   extends:
     - .i915
-  parallel: 6
+  parallel: 2
   variables:
     DEVICE_TYPE: asus-C436FA-Flip-hatch
     GPU_VERSION: cml
@@ -235,7 +235,7 @@ i915:cml:
 i915:tgl:
   extends:
     - .i915
-  parallel: 6
+  parallel: 8
   variables:
     DEVICE_TYPE: asus-cx9400-volteer
     GPU_VERSION: tgl
@@ -254,6 +254,7 @@ i915:tgl:
 amdgpu:stoney:
   extends:
     - .amdgpu
+  parallel: 2
   variables:
     DEVICE_TYPE: hp-11A-G6-EE-grunt
     GPU_VERSION: stoney
@@ -272,6 +273,7 @@ amdgpu:stoney:
 mediatek:mt8173:
   extends:
     - .mediatek
+  parallel: 4
   variables:
     DEVICE_TYPE: mt8173-elm-hana
     GPU_VERSION: mt8173
@@ -283,6 +285,7 @@ mediatek:mt8173:
 mediatek:mt8183:
   extends:
     - .mediatek
+  parallel: 3
   variables:
     DEVICE_TYPE: mt8183-kukui-jacuzzi-juniper-sku16
     GPU_VERSION: mt8183
@@ -292,6 +295,7 @@ mediatek:mt8183:
 .mediatek:mt8192:
   extends:
     - .mediatek
+  parallel: 3
   variables:
     DEVICE_TYPE: mt8192-asurada-spherion-r0
     GPU_VERSION: mt8192
@@ -310,6 +314,7 @@ mediatek:mt8183:
 meson:g12b:
   extends:
     - .meson
+  parallel: 3
   variables:
     DEVICE_TYPE: meson-g12b-a311d-khadas-vim3
     GPU_VERSION: g12b
-- 
2.43.0



