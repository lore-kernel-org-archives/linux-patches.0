Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B23E1D31A0;
	Tue,  8 Oct 2024 12:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392089; cv=none; b=rt6bDYUTsv8cwTax8UaVUjmgDZaucs10C/i/YPJox9HtYTwBJCobqU9z/f8sqI/RRbFI7sJvjki9EEPYcUit8kCeKH0OdHbpqfBsoC0RxrVppykJqFKhFtPUdGmhuytEi9wSzCWfkzYt+VbqX82T5PHzxL1tBTzwK0o3FloBAFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392089; c=relaxed/simple;
	bh=xXK50V3GHGK2738NFrKeCotFL/RNxHrnwUSZ/MXgPdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bF0YM1WHc2JCpyHiLAiAa9Q2QyE2qzhm2XuicmwH1ntxFOEoO+vAZqlAIrmpZZzYcQZGmSLbLj4IEwu9p996LK1w09rKKkSRZubVaSm6iXpkmW/+R0v03ZSoBGWHtVvHIvsFOzIqTN0G0phX1lKPI1eZxxwV07fzEEXSd46jH1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVB8Z6nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVB8Z6nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE01C4CECC;
	Tue,  8 Oct 2024 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392089;
	bh=xXK50V3GHGK2738NFrKeCotFL/RNxHrnwUSZ/MXgPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVB8Z6nf/0DK1Jt0yEat6o3o2e3mTCEpnFb0GvNZqONuQV5CIPb6DL4EkdTU4vdGI
	 xpCeiv/62BHBrBjz/A9mLu6QQTvv55E73LA8eXL0r30mgvGtfmKB2dWK424MTTnjos
	 0b3YYB/6HIZC669qffa22Whg3L1+v/MNuNJu52Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 281/558] drm/amdgpu: fix ptr check warning in gfx9 ip_dump
Date: Tue,  8 Oct 2024 14:05:11 +0200
Message-ID: <20241008115713.384804362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 07f4f9c00ec545dfa6251a44a09d2c48a76e7ee5 ]

Change if (ptr == NULL) to if (!ptr) for a better
format and fix the warning.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 7d517c94c3efb..6f178bfb8f104 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2133,7 +2133,7 @@ static void gfx_v9_0_alloc_ip_dump(struct amdgpu_device *adev)
 	uint32_t inst;
 
 	ptr = kcalloc(reg_count, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for GFX IP Dump\n");
 		adev->gfx.ip_dump_core = NULL;
 	} else {
@@ -2146,7 +2146,7 @@ static void gfx_v9_0_alloc_ip_dump(struct amdgpu_device *adev)
 		adev->gfx.mec.num_queue_per_pipe;
 
 	ptr = kcalloc(reg_count * inst, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for Compute Queues IP Dump\n");
 		adev->gfx.ip_dump_compute_queues = NULL;
 	} else {
-- 
2.43.0



