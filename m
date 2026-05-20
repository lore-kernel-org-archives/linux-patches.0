Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FEF3F5BDA;
	Wed, 20 May 2026 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296900; cv=none; b=XKKlB4DeFiu5o4CWm7FSb9jW3PLHJb0rtNnW7QM7viguExEA3u5QmrEWiikZiA2BMJpk2A0pJd2G3kKlHznovKocI13K8hZ/LkcRbM9tdz9K5Vd7F3/jvj36NdZYR2d9+TPCAi/2pl/R23ATgdP9lBvNa4hG7c6X3kUmJ4fVj5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296900; c=relaxed/simple;
	bh=tCwlZbf8idYJbixT29/YhQhC9s0hGeRkXskhhxk8r3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EruFUVUpkn0sjGonY7HHDNEUC6Wc8gqxp3hDJCrcp1BmJPtZ6fv9Tg8PqRgUr7f1w7Y2/xrn0YGUZ+rAxbXHxUeN41J0Fkn+Rzo5FkLMrVjcYDJlLeKjV/ThaKTqfQnM5cGkHLaGHwXCgPL3du47CyaZJXSmqgu6Bo4BMPS+jh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEvVqJAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEvVqJAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6E91F00893;
	Wed, 20 May 2026 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296898;
	bh=/aQTp2iaXhTwzWRlb0Y0eDOwVhPg8u3UcDYHD1ykWMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEvVqJAWIEzeKz3ugfd3n0Ek8pHkYhBLoAD5RKJkjnY5ELkjxSabQHJn3AEJ9uSP/
	 /fAL7a/ILv97/Y6d6c13qbbj339M3ciEKFScBAiSokZ1NrlSzycnKQ07jRaki3qNw7
	 sG3JI7ab9lW0DoH8GzONWs0svPHBSk5Adg+h5Olw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0974/1146] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring
Date: Wed, 20 May 2026 18:20:24 +0200
Message-ID: <20260520162210.274860535@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit e7e90b5839aeb8805ec83bb4da610b8dab8e184d ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: b13111de32a9 ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_0")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8d0cac9478a3f046279c657d6a2545de49ae675a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
index 0bd83820dd20c..6fd4238a8471a 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -759,6 +759,7 @@ static const struct amd_ip_funcs jpeg_v4_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_dec_ring_set_wptr,
-- 
2.53.0



