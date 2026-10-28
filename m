Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215173;
	b=ygaVocrxy0qc9JzSn5LG4u6I3A0AcMmnXpqVldJmJW4Hie/QB79n0fl6kvMPV7cHDIoY
	 Kbo6vmwDUsFrNEviIcJFgpQei3WTUKyY6iIKXbavDIfYuD9tE9F3lUN+8uiLV8EpBcmY3
	 FYvpT6IjgPnGj6Ng3Kytd2qqNF6/SpRSWpF/jinxm9gy6bfJsx7VoCqnG+TEh5P/nPXfW
	 yAgExnWqt4I9smbicyi9oB/ElY3B6wqoDF8gi7piPnHnL7+z471OYkQhvW1UZmGoll263
	 ZhiJCxyyebQVEPl6Sw5c+po/DxXJQfBcBdMZEzslYi4/zyUjSm4Uqd6bNsWDj2mxwnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SeY2r4hZ8WRNhnv0TdcKllXd1NrIFp2rus8NARkOcC0=;
	b=sBxCWzi5CuFENXSMVX/rxUVjJnjTKUanPFvzXMTE8/rOiZ9LTP8cV92ENuNE9FN3Btr8
	 2AiLpXsN+p95x2QO/phKTTe/hJoeWX2Fdl82z/QWK6jcpeHKw7cTTCS+4VF8KNnZYE7+J
	 vdT07wRIBOqR4LJSwgNSaAWzZfkuF5Q7FZkKvg+JfRbOO2NpGKa3OuPk7X7GgAckqhyzT
	 L3WXDmHKmRqzlVsO4gdWFfrQfh+sPdGxmV5pkR3a+tUntCD3Hvs6FtBXPq/R7slUEKAR4
	 8xfoq1REbqH5yusb411rWT55ksDvec51jeW6nWxDw270gcGYQeY8wRAUEVNUDGNVlnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KFCzOvz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D811606A31A;
	Wed, 28 Oct 2026 19:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFCzOvz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D30D1F01828;
	Wed, 28 Oct 2026 19:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215173;
	bh=SeY2r4hZ8WRNhnv0TdcKllXd1NrIFp2rus8NARkOcC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFCzOvz/6xLz0acOq8eYq4Ls0ns31zHJadM/OLdRPK8vcfzaYbxz9BKBa4M8YhO+v
	 j7nPEgI/YvBAgVd9g+r2pqKfuGb37Cf3BS1XzyRiqlcLUmYtEoDYfJDbZJl/7749My
	 aQ1u0dacOauxIsLG8GHTj504w+hYQbkJxkpiAM0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1117/1887] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring
Date: Wed, 28 Oct 2026 17:53:33 +0100
Message-ID: <20261028170524.820912198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 63b0d0b810ec8..ae9e390c8bf6b 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -557,6 +557,7 @@ static const struct amdgpu_ring_funcs jpeg_v4_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
 	.vmhub = AMDGPU_MMHUB_0,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_dec_ring_set_wptr,
-- 
2.53.0



