Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB91158A2E;
	Mon, 16 Sep 2024 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488268; cv=none; b=jySKU4GHFRDq0XN3bVXk0/rC/wP6KdNfaKEfLYNIWWqox/3tVp4Xtz8idkk26eELTtPIDt5y4ADqdiwIgpTUngb2jWbfzaJy+GU1jfCy2H9bwYbsqySUqVFxZb6ZCQptyyFljM1hsswFdv7iRO+zaZS9KHTANFHmTJsLO5zoIiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488268; c=relaxed/simple;
	bh=LL2XRhdaXDoLsVr8NZANiq3U1j8vdif2ejgLRtzur3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt0+nuF/8Ur/rWVnWbz7GSn8vbB1ow+2VcSrp07i78bogpFMQrZYvLGppzPFzB10I2ppQQE6enS5k0Gm04QINWMSN2xNdjeFTseSBWFS/C7xYKOSMk8zFdwSh11iMmkpT68UDeMtODvByGIvbXK4Y3yP/CmDV1UMKDm8/e5DQpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QF1NUD5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF1NUD5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B850C4CEC7;
	Mon, 16 Sep 2024 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488267;
	bh=LL2XRhdaXDoLsVr8NZANiq3U1j8vdif2ejgLRtzur3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QF1NUD5wl/4WBt98RQIpvDYtpukfU4NZPIc4rI4vZc+7T2Q//wIKX7BIsEvYUPzvz
	 zxvYAz6+ibOLUNpTLZ9Ajaf0mCPYenlAPlIkloXABn/+lrK+3qC4/51BXbZF6Btiu9
	 YPQ6XIkm0m1KDWFasE7Bl4madoF38MKLM5bu4fbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 036/121] drm/xe: fix WA 14018094691
Date: Mon, 16 Sep 2024 13:43:30 +0200
Message-ID: <20240916114230.322373869@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit f5cb1275c8ce56c7583cb323cfa08a820a7ef6b4 ]

This WA is applied while initializing the media GT, but it a primary
GT WA (because it modifies a register on the primary GT), so the XE_WA
macro is returning false even when the WA should be applied.
Fix this by using the primary GT in the macro.

Note that this WA only applies to PXP and we don't yet support that in
Xe, so there are no negative effects to this bug, which is why we didn't
see any errors in testing.

v2: use the primary GT in the macro instead of marking the WA as
platform-wide (Lucas, Matt).

Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240807235333.1370915-1-daniele.ceraolospurio@intel.com
(cherry picked from commit e422c0bfd9e47e399e86bcc483f49d8b54064fc2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gsc.c b/drivers/gpu/drm/xe/xe_gsc.c
index 95c17b72fa57..c9a4ffcfdcca 100644
--- a/drivers/gpu/drm/xe/xe_gsc.c
+++ b/drivers/gpu/drm/xe/xe_gsc.c
@@ -256,7 +256,7 @@ static int gsc_upload_and_init(struct xe_gsc *gsc)
 	struct xe_tile *tile = gt_to_tile(gt);
 	int ret;
 
-	if (XE_WA(gt, 14018094691)) {
+	if (XE_WA(tile->primary_gt, 14018094691)) {
 		ret = xe_force_wake_get(gt_to_fw(tile->primary_gt), XE_FORCEWAKE_ALL);
 
 		/*
@@ -274,7 +274,7 @@ static int gsc_upload_and_init(struct xe_gsc *gsc)
 
 	ret = gsc_upload(gsc);
 
-	if (XE_WA(gt, 14018094691))
+	if (XE_WA(tile->primary_gt, 14018094691))
 		xe_force_wake_put(gt_to_fw(tile->primary_gt), XE_FORCEWAKE_ALL);
 
 	if (ret)
-- 
2.43.0



