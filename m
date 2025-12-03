Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E2135F8A1;
	Wed,  3 Dec 2025 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779249; cv=none; b=ezelMsEgADLlIdoZnGe/tKZ07Tui+js+rRNtkrXURz+N5+QU3uOgK3hQHM5d2IwqyekeXM9Bed87TMxO4KZn0TwKBzdcliuPY+xhLH+bE/z1hDqVXGU9fw5BcXbdChufLtGpWw3ejDDAzxd//1qiQ08tZ8gMkmHrDXBW8q/8Wd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779249; c=relaxed/simple;
	bh=2xJ4ILaSoDH6ETW06QTDNmUcjO7zmvgCT+6SXyFwHzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L12G4K9HStjxNFxlzUmdn/oWssSJhv8wKIJnHPhMiQpEsUV2RiD2O6FKa0MbklqfuN5lD/1znl/N2I0f7EOJjMDHDFz0m23H+2bXodNh/0tcX7FQIA4wjjTPDUgd+YNVEtfivTsdBLsu5W+bGyxvbn74Pvr/kHiNXXQJK7eStMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqVEJK3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqVEJK3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B40CC4CEF5;
	Wed,  3 Dec 2025 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779248;
	bh=2xJ4ILaSoDH6ETW06QTDNmUcjO7zmvgCT+6SXyFwHzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqVEJK3VhshDkTZc9wEala1SLTQFndFSqjsjRCgAIuOSEsPQ8423HbPJDZKUlvMvt
	 Sa9YXDMZ5Ch67f+gr8hGbr3s5NtjssOkWtuTWOsPVPHhPoF3VFlpg/5MDv52COj0+Y
	 B5ItjNLsiFvS/Xu8HjP1V+PxUOcg5nnuxdXLgCRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/568] drm/amdgpu: dont enable SMU on cyan skillfish
Date: Wed,  3 Dec 2025 16:23:22 +0100
Message-ID: <20251203152448.051005532@linuxfoundation.org>
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

[ Upstream commit 94bd7bf2c920998b4c756bc8a54fd3dbdf7e4360 ]

Cyan skillfish uses different SMU firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index d8441e273cb5d..9b1c4d5be61f8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1669,13 +1669,16 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 0, 5):
 	case IP_VERSION(11, 0, 9):
 	case IP_VERSION(11, 0, 7):
-	case IP_VERSION(11, 0, 8):
 	case IP_VERSION(11, 0, 11):
 	case IP_VERSION(11, 0, 12):
 	case IP_VERSION(11, 0, 13):
 	case IP_VERSION(11, 5, 0):
 		amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
 		break;
+	case IP_VERSION(11, 0, 8):
+		if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2)
+			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
+		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		amdgpu_device_ip_block_add(adev, &smu_v12_0_ip_block);
-- 
2.51.0



