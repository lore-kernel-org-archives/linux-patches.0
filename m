Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C0915ECC9;
	Tue,  9 Jul 2024 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523991; cv=none; b=akWHH2hcaQ0jJQggZB4U69FunxAa6F9l9ZOs7jJLf18qf62c8ZbP+Zp9+Jf1ddZtuGonl6bYrnX2HNBSwkMTpoUGXggK2P8PbzxAW6A1tuE3TBHL8xctwFIrpMpvr55eQOBsMaU/zM0JulbSuLD/q1gGg/ldm50jzTADKcwPNX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523991; c=relaxed/simple;
	bh=x7gXa9FVap7qEydt5ndMHB46o6lTeuE5tH3mrFrlKSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBBSUKiNchi9znMDpPYKks3VF5BCKDaaMoUPm6agAVhgQQqawyf5daEkH49SSOa7KfXHkhyfpdYzvCfEeQCd+N2M/f0CUPtgZcQs0pFh5GuJXYp5lwiEIawy/eW4VEBszIagL19mOdmAHE2Gk2PVlbaQKNo/hdvo9sG/kmP1abI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDnG7xsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDnG7xsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB03C4AF15;
	Tue,  9 Jul 2024 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523991;
	bh=x7gXa9FVap7qEydt5ndMHB46o6lTeuE5tH3mrFrlKSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDnG7xsQmKFzCd943IUPFm8vwpV4rDJmTa4NuCr4k/9SS2pgIFZnUwCdYrbp/6IQD
	 Hhp4kK/BRWuiee8J7pzq2xqKZRO09H04M0urAyEYu353spdRip0HH5PF2nxloBKebL
	 bUr9LMH9YmR5H9ISpQ3KpewdL1iez+bq2jaqpGU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 037/197] drm/amdgpu: fix uninitialized scalar variable warning
Date: Tue,  9 Jul 2024 13:08:11 +0200
Message-ID: <20240709110710.355287014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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
index 55d5508987ffe..1d955652f3ba6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1206,7 +1206,8 @@ void amdgpu_gfx_cp_init_microcode(struct amdgpu_device *adev,
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



