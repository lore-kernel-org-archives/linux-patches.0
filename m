Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66BD1487F1;
	Wed, 19 Jun 2024 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803269; cv=none; b=iHHxwTPb2B4jlx164n3kngCQNH26IFX0it89Bu0jrxJraUR1h5FNcktOy+mjXWEVJ/ZdfpxPnH6PBm7dbmX8BCReIrHHYoYhYDRXeitc1ylC911qPuU+48kq5LaE4FsNN8VaVcvvFy+t+U7gFV2yZvLl7IBhZ0EXAvnSHM3WZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803269; c=relaxed/simple;
	bh=h1SlYjAqtQF0oS69k/XZdgOHGxqwNPBQ5LmuJ8wbbsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnUKzk0BrnTbKvgOCNOmZ312imDs0kDL2k6DiucX37R41BW1z3mz44Q8LtEFObPFdz0c78Bp4THNLQy8Pum+ZeOnH+xuYKEODKyPKdhDBnaIqnvzOhnqDmoP0rULmlsSqcBeN7vd/4srAnYU+sFaNYcW+xc04GoSeGc+iRFq7GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gn60S4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gn60S4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF53C32786;
	Wed, 19 Jun 2024 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803269;
	bh=h1SlYjAqtQF0oS69k/XZdgOHGxqwNPBQ5LmuJ8wbbsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gn60S4kN9KRVcrEbnC0x//PP4XeLqmyW2GMjakqgT+SunODH/x/AN4q99HXNslFx
	 ZjUPr87tfm6FkltOqgSV9WeB1TA1pBRykWmoo7YQgP7ydMpZODqWjhHTtnGPmev47w
	 YdVDYwzY9u+kwUN8i2iXk7TL0rLIllyXX1Pc+EJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riana Tauro <riana.tauro@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 179/281] drm/xe/xe_gt_idle: use GT forcewake domain assertion
Date: Wed, 19 Jun 2024 14:55:38 +0200
Message-ID: <20240619125616.723758813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riana Tauro <riana.tauro@intel.com>

[ Upstream commit 7c877115da4196fa108dcfefd49f5a9b67b8d8ca ]

The rc6 registers used in disable_c6 function belong
to the GT forcewake domain. Hence change the forcewake
assertion to check GT forcewake domain.

v2: add fixes tag (Himal)

Fixes: 975e4a3795d4 ("drm/xe: Manually setup C6 when skip_guc_pc is set")
Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240606100842.956072-2-riana.tauro@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 21b708554648177a0078962c31629bce31ef5d83)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_idle.c b/drivers/gpu/drm/xe/xe_gt_idle.c
index 9fcae65b64699..1521b3d9933c7 100644
--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -184,7 +184,7 @@ void xe_gt_idle_enable_c6(struct xe_gt *gt)
 void xe_gt_idle_disable_c6(struct xe_gt *gt)
 {
 	xe_device_assert_mem_access(gt_to_xe(gt));
-	xe_force_wake_assert_held(gt_to_fw(gt), XE_FORCEWAKE_ALL);
+	xe_force_wake_assert_held(gt_to_fw(gt), XE_FW_GT);
 
 	xe_mmio_write32(gt, PG_ENABLE, 0);
 	xe_mmio_write32(gt, RC_CONTROL, 0);
-- 
2.43.0



