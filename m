Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3913FB05A;
	Wed, 20 May 2026 18:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301484; cv=none; b=JZSO6Hlk+zIciUWz0V9oeBPT9Use1yjbLszdwr1WQpRLV67nTgWrUNKDjIH/dNEQU/7AJbdmxIhdrNbdhP15E218aMpyvKJKOz9s/KI8y6T3r5NFcimVJcLu0wAEWhvPxudQsHWUSQ3JNzlOaisroQ7raPl8d+9lbvscATy/CkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301484; c=relaxed/simple;
	bh=ikXV4+oKAwRz1hfmtzV8KyBoXCXU3+mXrqGlyITQwRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=anm1pPZvF6Vv0BD12jEBw6luJyU5FCVAy3gzPWh+u4xQ9DAvFNsmXC7JVbvDqCq56wiC2FyGTE38P/aaEX+QsK/YFtIrtdKgsDnHzxfFyohZVsDPtz5BoTCYbwf5NtssXOe6HeIFox6Cr1RcrV6LMMgy+OLEr59uIfGEr1BvuAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kyrpt6z0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kyrpt6z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9691F000E9;
	Wed, 20 May 2026 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301483;
	bh=Q+HEZqZYvZDZ/PLYu20+LC2jX55Aj9ANho42YMJlsug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kyrpt6z00+/R2hQwExnVoQDkahrEXl9N1AfylHvFBnffLFWGDCi5kv4Nt7GOUVxh8
	 IUkCjQgVxlQIsdz46bNAWzPt3hbTxEf/42qh1lyAEqNQgIceqmqBwjNAesjaomQSgM
	 zSzUV8wg/lQuNjWIYGxnOcD7jIHBvWJ3BFwC4gDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 565/666] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.3 ring
Date: Wed, 20 May 2026 18:22:56 +0200
Message-ID: <20260520162123.514013794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fd0ba04a66045..c4f812939a85f 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1122,6 +1122,7 @@ static const struct amd_ip_funcs jpeg_v4_0_3_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_3_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_3_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_3_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_3_dec_ring_set_wptr,
-- 
2.53.0



