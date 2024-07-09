Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383AD155389;
	Tue,  9 Jul 2024 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523532; cv=none; b=niPPDh9mtA97rRIlkkxw+E367Kv62ulHdPmSoFSWVoB6HHZpjcUy6dAFYj2tDCRBwB/XMGkS+EW8tkHN9Vp3iitxnyf1279XoPKslYc88gdLDwLaCrbHIllyAaTAZIetbvrugMMgJSig40ZS8DC/yW0qY2nb/JPE1dHCvd8rfE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523532; c=relaxed/simple;
	bh=YTSQAcZNL0vlRgvFO1VFNmfN6RG7q512WPncganV/B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V92rgUUle8YZJqbV5LYWe6lzMuuLHRjZWq+do3PwWEBGsXE7eak7UKjlmL/U9XbBSdMyY3XSc+X0MFWPPml8/gPFmMsYk34ZNIVbAxhGOSPOVXSf7EEsN1SoCvHQmJdbuf0g7c5It+thhNzsQbUdo1tDBlAuOmAWc5IR0WMYHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCY6O03T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCY6O03T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4CBC3277B;
	Tue,  9 Jul 2024 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523531;
	bh=YTSQAcZNL0vlRgvFO1VFNmfN6RG7q512WPncganV/B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCY6O03T4fuFecMlCii7R20ZTAmAtcns36klJNQXE6hiufcosJplTI7XTODa/lXjZ
	 ZBfEJeLL3VwP/zk/Z4RYzUbED42e76GW/Ja34f9Wxjma3Yf1AtXxKcD0xEOoV5SLMd
	 7XHTX0PAQ7NBWqY0uhBEPHxT/ugaOfeUHvQbTyQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/139] drm/amdgpu: fix uninitialized scalar variable warning
Date: Tue,  9 Jul 2024 13:08:44 +0200
Message-ID: <20240709110659.099263724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 9a5f15d2a29d06ce5bd50919da7221cda92afb69 ]

Clear warning that uses uninitialized value fw_size.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 053983e9f4aef..0ca51df46cc0d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1184,7 +1184,8 @@ void amdgpu_gfx_cp_init_microcode(struct amdgpu_device *adev,
 		fw_size = le32_to_cpu(cp_hdr_v2_0->data_size_bytes);
 		break;
 	default:
-		break;
+		dev_err(adev->dev, "Invalid ucode id %u\n", ucode_id);
+		return;
 	}
 
 	if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) {
-- 
2.43.0



