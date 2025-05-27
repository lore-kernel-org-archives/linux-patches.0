Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4527F728;
	Tue, 27 May 2025 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367219; cv=none; b=X7j32WZsQYBZlMYeokEHUKJsLgd4Opp/TNmWFThW0JxvtBnJ3Ngoj30ZssknRVs+ybl1/ZXgyiZN5wFGs4BKh20kj1ERcCzrR8SZkv/3BFA5Z0NaQiB1aS5zFBPbcT6MrYFDzRcDPVQZtAcq/EyiB6fRQ3FLnVgYTRqp9joNGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367219; c=relaxed/simple;
	bh=mxahw2dzGY/NMWFzAJOrYfwZNb+15CNZl8QiJukMstk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os6ENcbCmfoBLWdgFB0d9T8nJXlUnPbDhFAGZRp3QhcSH9b3aLj7XvZ6Jee4G5pQyJT9qHkQErBjcRh9SoSMq8KGu5e5ATeT7auKvCItCWjCspoQokLdPTsd5diqO46cEylkPm443To7i+bQ6HhdPSOMrBMJ/4vSsjRtWMLXAoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7UfhxaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7UfhxaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EBFC4CEE9;
	Tue, 27 May 2025 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367219;
	bh=mxahw2dzGY/NMWFzAJOrYfwZNb+15CNZl8QiJukMstk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7UfhxaAA2a/630OirSppgDF8EfYTgMhYMJPFRCsh4RxMNOafxFmN+jQCXL63V31q
	 Fvb09Zvw0FzdmxfJ5rUGMcsWOiEomGvhOclH2Y5YD0S+VsslPjm0EJkJJjaFKyjEvz
	 N0cRrZrOaBaWjz5D8SuGvApmM2g6YzSZpANhzGx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 286/783] drm/amdgpu: Avoid HDP flush on JPEG v5.0.1
Date: Tue, 27 May 2025 18:21:23 +0200
Message-ID: <20250527162524.733878551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit a734a717dcfe1ce618301775034e598cb456665b ]

Similar to JPEG v4.0.3, HDP flush shouldn't be performed by JPEG engine.
Keep it empty.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h | 1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index 88f9771c16869..b2904ee494e04 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -637,7 +637,7 @@ static uint64_t jpeg_v4_0_3_dec_ring_get_wptr(struct amdgpu_ring *ring)
 			ring->pipe ? (0x40 * ring->pipe - 0xc80) : 0);
 }
 
-static void jpeg_v4_0_3_ring_emit_hdp_flush(struct amdgpu_ring *ring)
+void jpeg_v4_0_3_ring_emit_hdp_flush(struct amdgpu_ring *ring)
 {
 	/* JPEG engine access for HDP flush doesn't work when RRMT is enabled.
 	 * This is a workaround to avoid any HDP flush through JPEG ring.
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
index 747a3e5f68564..a90bf370a0025 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h
@@ -56,6 +56,7 @@ void jpeg_v4_0_3_dec_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 seq
 				unsigned int flags);
 void jpeg_v4_0_3_dec_ring_emit_vm_flush(struct amdgpu_ring *ring,
 					unsigned int vmid, uint64_t pd_addr);
+void jpeg_v4_0_3_ring_emit_hdp_flush(struct amdgpu_ring *ring);
 void jpeg_v4_0_3_dec_ring_nop(struct amdgpu_ring *ring, uint32_t count);
 void jpeg_v4_0_3_dec_ring_insert_start(struct amdgpu_ring *ring);
 void jpeg_v4_0_3_dec_ring_insert_end(struct amdgpu_ring *ring);
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 40d4c32a8c2a6..f2cc11b3fd68b 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -655,6 +655,7 @@ static const struct amdgpu_ring_funcs jpeg_v5_0_1_dec_ring_vm_funcs = {
 	.emit_ib = jpeg_v4_0_3_dec_ring_emit_ib,
 	.emit_fence = jpeg_v4_0_3_dec_ring_emit_fence,
 	.emit_vm_flush = jpeg_v4_0_3_dec_ring_emit_vm_flush,
+	.emit_hdp_flush = jpeg_v4_0_3_ring_emit_hdp_flush,
 	.test_ring = amdgpu_jpeg_dec_ring_test_ring,
 	.test_ib = amdgpu_jpeg_dec_ring_test_ib,
 	.insert_nop = jpeg_v4_0_3_dec_ring_nop,
-- 
2.39.5



