Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289511F09B3;
	Tue, 11 Nov 2025 01:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823726; cv=none; b=pXFgKNL+MehHmwCmKwj2+xFmSB3v3aezFy2vZnCzG1s9+qDc2PyZ0G85gQlXoQ5/JzmKO0G+Ze2FUG/mIattU8xmj8jwGl/MdhfWTAkq1sOEmS/WUKHPEHbmu3jzJ6R9LO79A549Z18UL4lYMK70KMLej5ER3HsGD7JyPhW3+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823726; c=relaxed/simple;
	bh=tobJo+FmRj8l2xkBpmiCeGRm44p2612Qfxd7eS8eSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7tv4PGqFap8OvY5SmoHvrRBnx3gow7pwENY9X5sfk91qhSuU036ZDPJHOv24gZVsX3/gmMFm7FKOp7AnrCOqPSGtyOgSCNwsQIJdaH99K5uE4mP+cnv3vSFNydvrdTD342whwB3Oo8vMpJc3EeE13IjNQBauK7Vi1LxJIEaCv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBQZvtMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBQZvtMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B900FC4CEF5;
	Tue, 11 Nov 2025 01:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823726;
	bh=tobJo+FmRj8l2xkBpmiCeGRm44p2612Qfxd7eS8eSBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBQZvtMRw7GgOSr//zxlwQwqR8PU23mxNCqEMs27xoT3FU4UucLjxZVV+JlJV4edP
	 hM6D9TYFNJx+e2ICyp82Duyyxc+HGfT9x00My4M3STRJBElvqy1/BBwFyKsvnr5LbK
	 KKZGHKWAx86sw/sFRZO+6fVBWVtYJpegektALSZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/565] drm/amdgpu: add support for cyan skillfish gpu_info
Date: Tue, 11 Nov 2025 09:42:44 +0900
Message-ID: <20251111004533.814631806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fa819e3a7c1ee994ce014cc5a991c7fd91bc00f1 ]

Some SOCs which are part of the cyan skillfish family
rely on an explicit firmware for IP discovery.  Add support
for the gpu_info firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 373c626247a1a..7ff81bd1ec200 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -93,6 +93,7 @@ MODULE_FIRMWARE("amdgpu/picasso_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven2_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/arcturus_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
+MODULE_FIRMWARE("amdgpu/cyan_skillfish_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 #define AMDGPU_MAX_RETRY_LIMIT		2
@@ -2412,6 +2413,9 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
 			return 0;
 		chip_name = "navi12";
 		break;
+	case CHIP_CYAN_SKILLFISH:
+		chip_name = "cyan_skillfish";
+		break;
 	}
 
 	err = amdgpu_ucode_request(adev, &adev->firmware.gpu_info_fw,
-- 
2.51.0



