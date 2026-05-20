Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC153FE372;
	Wed, 20 May 2026 18:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302795; cv=none; b=kPps3iSSJqG5e+SnK6qpSip0Yp9Nq0JBNM6fLO2BOCJCWX0OrNhoP7X3s30su/Dw/yvonGTeI21JUKPrJouCVYAvttCtDqAmO9Q1w0ntbO6ZkcyXHBen7KgHcgvjDLI+wVc+ZRgJZxDlelDnDMMhNEExqSzQdF+lAau/Kn0plnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302795; c=relaxed/simple;
	bh=qAYphluHPe2r9+R06ydVLejqS7AO/jE+mS87sJQvcAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rav1tf0zHy1mqVOUEy6TahVo7SSUxkm8JiUKpSmghhvIb4n03HLDIBj/aTxcbDC2SiGwnPZnRMsCFR6jMmZOBR7PgW5ZPcz/G+lCfSbgkxw4YkTTfJavmJs8EsKT450v/9/a/T5uaPGa6OJ2t8dCn7PS6CMGeDtuPPtpO+1vYrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJdld+SP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJdld+SP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D0A1F00896;
	Wed, 20 May 2026 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302793;
	bh=02xh1ZEojvsKwi+vBraIsLYwBKkZTDYtIKqzdjhBu30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJdld+SP3/9dI1/nw0uA95Hdx5caiZf2EQSXrxPkfaaysP+3+y9HaIxEZX59/7ffp
	 Fxk5BlYfRyfQW44Oo7n7A6SKBxmC7DSnBUqGBfyBvwHHMow3ZOKmP2VcXUzUs2iZq6
	 TXnCKlvSNQjcpskfzr5u4V09JG/DHOylw83qnwtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 403/508] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring
Date: Wed, 20 May 2026 18:23:46 +0200
Message-ID: <20260520162107.343908329@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit e5f612dc91650561fe2b5b76dd6d2898ec9ad480 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 6ac27241106b ("drm/amdgpu: add JPEG v2.0 function supports")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 96179da0c6b059eb31706a0abe8dd6381c533143)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index fbe57499495ec..c2b9829c12fd9 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -764,6 +764,7 @@ static const struct amd_ip_funcs jpeg_v2_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_0_dec_ring_set_wptr,
-- 
2.53.0



