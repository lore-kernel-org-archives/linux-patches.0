Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4373F39C9;
	Wed, 20 May 2026 17:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299538; cv=none; b=VF9rxbu47zgKFM8uCu7nCVHGokhTfiug4SldmoTNMEnVFc4KX1LFA0PLh/Hz2saiQ38bHklRiz8g6onFhujxovVNXUBUfzhpAanXyJnxgd49AZ0bntwKfwEy1EVm4U9ElKdCqCdLCtLC7i0jrF6bk83PyTGU1ziDYC/YTtzi9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299538; c=relaxed/simple;
	bh=2398BNZn+5dj5D5+Nu9cbAiVEXNafX6RwHnriZn4p9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELnA2rNMg4+XYaT2eiLX7S/Pyh52t+RVSCXmq/mzZ8MIr3xoOjihm4LKkqgbNlN3Md0lTV6vZ2fM0ZF+1SStCdBfNB0xXDtdvf58gTfTCuknlnsm98YLG5ij4zv0nFD9MbLtSMuJLlwtbvFqIxTqdpUAaMDJc+rzx6B1fwswir8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKY9axgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKY9axgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22A01F000E9;
	Wed, 20 May 2026 17:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299537;
	bh=70fzr7MfReA1ahZdyDVyENTzGG8gRhD7js03uyhxBMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKY9axgVJzsEwj8zPtddJbQ2Q6koy77xgGg9sR4xtDGuz/XzRvUp8dyy+0hplui/+
	 AWAVqa1slMAMzKr8FRxn/fQS3oHGdL71lH/qGEi9JUKELCT5zVasj1+VKWpJMygKBY
	 1TON5CYjmF6l1KJIrRfsjkqEKBfGyl5hqrMsx6lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 811/957] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.5 ring
Date: Wed, 20 May 2026 18:21:34 +0200
Message-ID: <20260520162152.154841870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit b65b7f3f3c18f797f81a2af7c97e2079900ad6db ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 8f98a715da8e ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f05d0a4f21fc720116d6e238f23308b199891058)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
index 54fd9c800c40a..a43582b9c876c 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
@@ -804,6 +804,7 @@ static const struct amd_ip_funcs jpeg_v4_0_5_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_5_dec_ring_set_wptr,
-- 
2.53.0



