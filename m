Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EE33F58CC;
	Wed, 20 May 2026 17:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299535; cv=none; b=VYwu+E2ytkI/1SS00ZBXsGgH0u8N0sK2jtBZXlHLTwZu/Mp54SGRlpkdtvkEVedL6pKkMR1Pli3lPoicPc1KJh7ny8HXGOv+UEM1KfMctF8WNeQI2I63Up8EqVkAB2mPEmyeCqRgGh9/qNMHJYr3/4dzg/9Ak9CNrWuxMzzrw4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299535; c=relaxed/simple;
	bh=KtFVO0XcmQc7hs9qc45B5B3pfzB5KZGm4syVPTtoAj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h3roKkpSizHCXsIQXH+DMUQuFxKXDU19OFGfrLkGVVLeDHHoeKYoNoZHLGPPy6HFfyhlPbKUQenM72OGl0R5KhcuX6TKQuj2Z3/P8v/vD07hWkIQoyyzBub8XeVkM5wsuOfsjn15I22vwqasXGlLRWeKS0MofRFw/2O+ImZjWt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJd1n0aU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJd1n0aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C51D1F000E9;
	Wed, 20 May 2026 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299534;
	bh=pkmuR98FxXvkHxm2sv8jeAel/I5X7hgpglJ3KI05NxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJd1n0aUCD0y0OXYW0QQSRFHJkWSvUyw2T90dDE4yofFfEZ2Bss1fv4s8PksHmERr
	 lQ/kDkI3OhK5g1mOTXpD845vd6lz+27C8fPlBzQZ60WcHrm9KvvEWkCr+/IdnE52A7
	 CXumStIzCz8NqDERKTUXneHYr00q9wx6jVWnwfe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 810/957] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.3 ring
Date: Wed, 20 May 2026 18:21:33 +0200
Message-ID: <20260520162152.132562510@linuxfoundation.org>
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

[ Upstream commit 83e37c0987ca92f9e87789b46dd311dcf5a4a6c8 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: e684e654eba9 ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2f6afc97d259d530f4f86c7743efbc573a8da927)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index 47f2192fc7e7e..99e6dabc36ee8 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1214,6 +1214,7 @@ static const struct amd_ip_funcs jpeg_v4_0_3_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_3_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_3_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_3_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_3_dec_ring_set_wptr,
-- 
2.53.0



