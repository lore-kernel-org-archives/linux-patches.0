Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3177352FA3;
	Fri, 21 Nov 2025 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732661; cv=none; b=UVoDSMpA5FfhA1o7muc0r5wAx5O+iKycnvHpCBDOkSgkdFm8Wjf45UALRlrBFvxFtgHoZk09pbo8m50O7qyG0pLGrVjVenVWiGZhI5CYzwECMZU5UAipxfSLpXaZYcteuKTYhZH6ptPWp4JaS3qMuGOQ6UaNbQCf814I3CiIS9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732661; c=relaxed/simple;
	bh=eqadG0TNa2I5vt8hH9zyHEJip1ZNp1M44Y7gowd2jBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAH1yksgCMM914Ph+GmG2D0Jf+uX6TKbb0LMbY1NMSmR1pU0S9i8mLNf8vKBKLAkyOAflXHGOEZQKUTh1Sonc/4gpvMi8HUU+yPz1UkWrhMFs/T3qSs8ZqOFQFp+eucBFGRjumkzCOsQqWC1JZqn1FCw3ckLvtpZ6YykXGUjMC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7ocPAIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7ocPAIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC94C4CEFB;
	Fri, 21 Nov 2025 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732661;
	bh=eqadG0TNa2I5vt8hH9zyHEJip1ZNp1M44Y7gowd2jBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7ocPAIv+Z6+MzHJSijOz/0D4SDWUZykHj/h1NeLhC9rBsif7nhLKB/fCzPMXO7/h
	 bwEoBtHIIrUasB956rJubdtpM0yzi5vyfViB1yz5CEwwjfXUpFK+7/5hfpDZwFIjfM
	 h2+lIVJ1injMVmWO5a+9V88tnUAS0E8/ZpkF+rGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/529] drm/amdgpu: add support for cyan skillfish gpu_info
Date: Fri, 21 Nov 2025 14:08:17 +0100
Message-ID: <20251121130238.061593151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 200b59318759d..475d93d4a40bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -93,6 +93,7 @@ MODULE_FIRMWARE("amdgpu/picasso_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven2_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/arcturus_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
+MODULE_FIRMWARE("amdgpu/cyan_skillfish_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 #define AMDGPU_MAX_RETRY_LIMIT		2
@@ -1939,6 +1940,9 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
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



