Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017603F39EE;
	Wed, 20 May 2026 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299607; cv=none; b=oayVds5sg7jQOD34qMKGVG9R/9lrGWXsAEcNwRJpefaTedh4f9cbj4yOjf1pfmY+qpWrXfo58or5v1ta+bQ8YySidjgUxMtPGjdBk2V+pQr+IXmsbchPZBOj+kPZ5KktOq7Jm4bbSYyptE+SFK9Nn0w/f0RQi/eXL2LTG0cdiE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299607; c=relaxed/simple;
	bh=KHb3G8i5er4wuGKbw7bn6EvSzCAkIJy7BI/CEEqRKJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYlC7DPJhsnDW5EtQTY/nrC5iAlNMkvmga2WpIinu6BXLc1G4Jea7fuMVFcO40kHpF1P3XeaPUHdw/HqvOFOC/3YHUder8z8JqfqhnBxcWfTYgPjAluKqG6ZfZ18xOVzxblYvNJbkpNL15/5uvKjAyliN50f2/6xPTPCtVPmgnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxYi3Y6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxYi3Y6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6011E1F00893;
	Wed, 20 May 2026 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299605;
	bh=ls/5aHAA07Lo3cbmqZnXq+yPZPjS1cuFco35fF4JEe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxYi3Y6Frs94edX7LKd3jkItraPK6StoT5WGV/tdrUGr36cW3kWHqYTMnFhGqS9WZ
	 ngK7M371AjDo6PfNEfo19kxwMwcQSvmpk5t3t7L/lg59B404S8IJH/NBh9CuuXD+IJ
	 D/16n8s3CtNQaX11/xXszYWHGbBrtXm8s426q1Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 799/957] drm/amdgpu/vcn: set no_user_fence for VCN v2.5 enc/dec rings
Date: Wed, 20 May 2026 18:21:22 +0200
Message-ID: <20260520162151.892252877@linuxfoundation.org>
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

[ Upstream commit 4f317863a3ab212a027d8c8c3cc3af4e3fb95704 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 28c17d72072b ("drm/amdgpu: add VCN2.5 basic supports")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit efc9dd5590894109bce9a0bfe1fa5592dd6b20b1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index 006a154511971..8b8184fe6764b 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -1778,6 +1778,7 @@ static void vcn_v2_5_dec_ring_set_wptr(struct amdgpu_ring *ring)
 static const struct amdgpu_ring_funcs vcn_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v2_5_dec_ring_get_rptr,
 	.get_wptr = vcn_v2_5_dec_ring_get_wptr,
@@ -1879,6 +1880,7 @@ static const struct amdgpu_ring_funcs vcn_v2_5_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v2_5_enc_ring_get_rptr,
 	.get_wptr = vcn_v2_5_enc_ring_get_wptr,
 	.set_wptr = vcn_v2_5_enc_ring_set_wptr,
-- 
2.53.0



