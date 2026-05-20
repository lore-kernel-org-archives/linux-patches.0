Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB9B3FE35E;
	Wed, 20 May 2026 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301461; cv=none; b=b0PVRoYOc5c1eIW0o3SzrVDY6j7XBh+KQpOhqb/G4kvPzufTf1xoEOmpBEOd/MkD+69awpISbXq1UibXMRZjJxw0aKtIremmA/6rQe5B8R33GC8ol9PU23Fe3AW2gaTYcSDEkLEafh2FtFIrjDWYp6VRdD2VIygkmZ8oLis3DYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301461; c=relaxed/simple;
	bh=EkuZZIcDhag/CPjrK1qvPWV4r5W4funb+OwMtHrL/mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GcBeepJhwcLxtF3xB2jaXykwD9Z7L78aEE+hKM33t4w+vYI+rxNZPIaA2gwuY/O+NuvchqMuDVFswBNJLgI/I2goAMRoSKWS+sC3jzoP/Du5HTF5oeihuHspoI9xwCTZaMzpF6mjRd8lxbFGeRkD1vL+VF7e8Qwz3eIoHl48stE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKF9dIrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKF9dIrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1E41F000E9;
	Wed, 20 May 2026 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301459;
	bh=5aRQwQ4kqLNgsGbArpkRyoFBnAaR5nTETHSLeaW2560=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKF9dIrzxz6Tmt9WS6iLg1ZgLmkd9uqUIbeRcq5PbHOHw1P1jYGceyJuTiGsgd9Xj
	 XoqdKdgNWoQwpqaIEVS/vaSFu2M9TJkWFTu6JQIROMi4Pub12RlIvAYqlpdX3+7zz5
	 WA0NrzYxv/O8mmPX1pnac0aBdlE7LORstJ81kQT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 561/666] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring
Date: Wed, 20 May 2026 18:22:52 +0200
Message-ID: <20260520162123.425943675@linuxfoundation.org>
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
index 341c551dad8b0..5c95cf6167d94 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -766,6 +766,7 @@ static const struct amd_ip_funcs jpeg_v2_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_0_dec_ring_set_wptr,
-- 
2.53.0



