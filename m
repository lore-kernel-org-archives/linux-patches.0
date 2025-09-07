Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D96F212B3D;
	Sun,  7 Sep 2025 20:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276401; cv=none; b=dUN2pMu9O8ZRTsWJjqgW6lqOaXRyz1ALBnibGvDZEYCFTVtcePasaPPxHAFIzto0IggJnmDwicWxk2Qw/WXqtMD5wICEw8HFqH0sVtsQi2zTN9J7fOX9Z+l7oWHlj7ZtiWxyVqhhF/GsRf8RqO5BeTmPmsQ8t5yDySyldG04zc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276401; c=relaxed/simple;
	bh=10pRDotPFw8T1cYkabftttGOwjWGq3rbEwnhU6teJkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ato8Yx1XbIukvOy8atloRf+/Nlxo8zHTizRCRtYNtAbw/+CYNjWmGlty6pGHoXubkIcptBnwlZuC5QdE92mQlLF4FScyydYwWtzAdpXAzR73bXHgbWMq9Y5Tf8BjrsrYNwfWHtX0WJrW7UdEvdgn7aenrDQm8h+Pr8/FMPuSrO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BibfR3oD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BibfR3oD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D901C4CEF0;
	Sun,  7 Sep 2025 20:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276400;
	bh=10pRDotPFw8T1cYkabftttGOwjWGq3rbEwnhU6teJkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BibfR3oDCuCKUxv4/wyTB9JbW4qWiyYQ+GUdxHpGuCbRfKziRa622bSXmY7Kh+rEA
	 vrI8KTXARz7fGM/LEKdChHTzQRgqIF/9EG24BEnu90x3Ey3qbtMwXC36DXB5gnDObO
	 jIamtbb6aha6Tdv5kGuIOzovChOTSl0nZAqIQDek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/104] drm/amd: Make flashing messages quieter
Date: Sun,  7 Sep 2025 21:58:49 +0200
Message-ID: <20250907195610.055383815@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1cc506f08b4c4688c729e48d7c665910ed330724 ]

Debug messages related to the kernel process of flashing an updated
IFWI are needlessly noisy and also confusing.

Downgrade them to debug instead and clarify what they are actually
doing.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 467e00b30dfe ("drm/amd/amdgpu: Fix missing error return on kzalloc failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index cbee5c6cdb369..f720aa06fb3d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3552,7 +3552,7 @@ static ssize_t amdgpu_psp_vbflash_write(struct file *filp, struct kobject *kobj,
 	adev->psp.vbflash_image_size += count;
 	mutex_unlock(&adev->psp.mutex);
 
-	dev_info(adev->dev, "VBIOS flash write PSP done");
+	dev_dbg(adev->dev, "IFWI staged for update");
 
 	return count;
 }
@@ -3572,7 +3572,7 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
 	if (adev->psp.vbflash_image_size == 0)
 		return -EINVAL;
 
-	dev_info(adev->dev, "VBIOS flash to PSP started");
+	dev_dbg(adev->dev, "PSP IFWI flash process initiated");
 
 	ret = amdgpu_bo_create_kernel(adev, adev->psp.vbflash_image_size,
 					AMDGPU_GPU_PAGE_SIZE,
@@ -3597,11 +3597,11 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
 	adev->psp.vbflash_image_size = 0;
 
 	if (ret) {
-		dev_err(adev->dev, "Failed to load VBIOS FW, err = %d", ret);
+		dev_err(adev->dev, "Failed to load IFWI, err = %d", ret);
 		return ret;
 	}
 
-	dev_info(adev->dev, "VBIOS flash to PSP done");
+	dev_dbg(adev->dev, "PSP IFWI flash process done");
 	return 0;
 }
 
-- 
2.51.0



