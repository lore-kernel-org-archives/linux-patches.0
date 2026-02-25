Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E7F1FE45D;
	Wed, 25 Feb 2026 01:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983987; cv=none; b=JBhp+S38ZnV6pEWU4qDQVXgGlJHiEAOggemRGAFeMxFRf6KqvOWnVyUvheMjX9RVgtm3wrcEtZQNSZ9O6ioEAqwfK8Q3I+3sIQE/dI167WVy+0BV3OmAbeFkMHZPmuPCKMV1QX44gYnESQ+7zqujne7drB53TUa39BN4EPwl3vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983987; c=relaxed/simple;
	bh=oNHKH8fRRIea1c24t/hVzSgTXAZcxP5CcKTY66r658A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6QsHhR+xV98/MKmL8D2CwsB1mHBFvaszV5wTBkOv69eiv3peRzGLd+LZLVP2qelME00GxJGSzvpjaxz2YaFrEqqGAWTeSrQOXNHpTVr7QGSCK078gWeddISICG9a5gK86qno1+B7SF/g+KsgFkym3tvrwfGfDVl36I4jma+GqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaqGU+Lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaqGU+Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6439C116D0;
	Wed, 25 Feb 2026 01:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983987;
	bh=oNHKH8fRRIea1c24t/hVzSgTXAZcxP5CcKTY66r658A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaqGU+LmeTEqW73Hbh/mFf+2I0Zo0kK/sIls+c9+Yxl8szsx1+V8/xf107JFQrKLT
	 bGOZe2r8mW26GANyP9eb6BCKI/j9JYPVGdVjbSwjMHfl4eCFbHs/4CB0WNXmiBSltQ
	 Rw8Y0EkAzPIggR2i2J2R112iGZ8gXOHuhf6i1Wic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/641] drm/amd: Drop "amdgpu kernel modesetting enabled" message
Date: Tue, 24 Feb 2026 17:18:34 -0800
Message-ID: <20260225012353.561963192@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 8644084a74a4573278d6f454c6638ccd5965f4e2 ]

The behavior for amdgpu was changed with commit e00e5c223878
("drm/amdgpu: adjust drm_firmware_drivers_only() handling") to
potentially allow loading even if nomodeset was set, so the
message is no longer accurate.

Just drop it to avoid confusion.

Fixes: e00e5c223878 ("drm/amdgpu: adjust drm_firmware_drivers_only() handling")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index ec9516d6ae976..3aa33c1de29b5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -3155,7 +3155,6 @@ static int __init amdgpu_init(void)
 	if (r)
 		goto error_fence;
 
-	DRM_INFO("amdgpu kernel modesetting enabled.\n");
 	amdgpu_register_atpx_handler();
 	amdgpu_acpi_detect();
 
-- 
2.51.0



