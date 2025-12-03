Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725835E551;
	Wed,  3 Dec 2025 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779252; cv=none; b=Oea6txO6ggNtWERi4vFxbutg1RqAG/a6B0JOR9qgw2iliQrLQ9k97vSb3Sx6DPX0MQZeHhYoEpIQjifJZLkQQBGGR3CuCWN6wnkIMgwbrzFl8U6RtoFXZhkMvjuL1xKUvCpg4veGNtb7kL5EQLIw28eecfv8zAoNOQFwuyY6NMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779252; c=relaxed/simple;
	bh=VaOvl0FX7Q8psqgT7yrc6l/WtzR7YksncLULWD3BPvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMfFe+pQYhus5VbuZ4Qf0CJyYvo/0GfuLFeeycz7SmhjQB4imdj1L/BOXaBuQhR0CIIWsSLWGtErUMYZK389CRDHFKMHs4+uMB13FGgCJKCHWSzSejeDg59Np6jIh+rZz2ihgykxKsh5QzskxYOvzXeGeNudz+IPhuagdDmjpaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UH4z5ybW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UH4z5ybW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD45C4CEF5;
	Wed,  3 Dec 2025 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779252;
	bh=VaOvl0FX7Q8psqgT7yrc6l/WtzR7YksncLULWD3BPvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH4z5ybWFfs1m8s+E/bCYZDNLTmCKMMv0vmq3I6Jfe/P+8A3X8LuR3zbNVdfnjn+G
	 xlAhW8vn7ZEmFNHLmpQShsOyCHJOXtHKY8VZjwKl6zqiFcozY2F3h0ejurBbHJ2ezV
	 MIsMOCEjGVx7LzbZSVhEKXVP0oeDD7Ik+66aMHXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/568] drm/amdgpu: add support for cyan skillfish gpu_info
Date: Wed,  3 Dec 2025 16:23:23 +0100
Message-ID: <20251203152448.087511469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 079cf3292f632..18a0802cb74dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -91,6 +91,7 @@ MODULE_FIRMWARE("amdgpu/picasso_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven2_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/arcturus_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
+MODULE_FIRMWARE("amdgpu/cyan_skillfish_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 #define AMDGPU_MAX_RETRY_LIMIT		2
@@ -2019,6 +2020,9 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
 	case CHIP_NAVI12:
 		chip_name = "navi12";
 		break;
+	case CHIP_CYAN_SKILLFISH:
+		chip_name = "cyan_skillfish";
+		break;
 	}
 
 	snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_gpu_info.bin", chip_name);
-- 
2.51.0



