Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050899;
	b=FAmaGhHJBxnhgpMBMGLk1L4eRg6DSwlwOG/h16GHH734UD9favKx9ApLlViiw4yA+hdK
	 R+eudDf2D3609SWDmWuZ6MSGhpipjzSDoA3KwA+yOLIust920vb9+ppYz9IPYpfPoHxd5
	 K0HUYsjJIY+eIjmtB3voHr/NqjTZDZnCLO8SLz3lwkM7x4SgukO7bAUqAugWR2/0a/4Ka
	 gWt5Igp3QupM+qxlpSv0EsdkgNCL2zGueMUjJagSLkoWKD851SIrnAlzJVCBGJ0Hyy8zg
	 m0ot8LzqKS7ODNfGijQDkMe1uwdfGsCs6keqvo7a7FBm0n/KNsh9OnzxjeGW+nh7Jsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=O3E9fVmBxrav53N+sMzvrzROQYJBD97Sienn2Ca0RF8=;
	b=EXVtR62McfZRUKmW9cgvfFUz2GWPaEEGjBZ7PGQjFQu+xpKftTN9L//qPx+1ZlA16zx/
	 aM7EQVX68o/tADgzcZ2ZjjgsfSf+ViQ2PvidzorUdNzM8ydPr5FyrRiP0VDUEMslhU+GI
	 sQDMW4OUpcMnY1Kf7XIdWBhp2EipD7HSaHqHDLy2NMQnmHIo0AbBUBoZMj6PSoXYBYlbW
	 4d+9OP2J0lB0NlP1uQif3NCoZeI/VowF3BvvI1BM5FoJ4+ih1H2DQo0pxW/e+tBj85awu
	 Z6hyz45C4j2cdDxI2d9EOqc4whFckuGtb5173nVqAoy4CCjbPct0DZ9b8BhPGW6e1DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0JmBTwCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB44606A325;
	Thu, 19 Nov 2026 01:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0JmBTwCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE581F000C4;
	Thu, 19 Nov 2026 01:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050898;
	bh=O3E9fVmBxrav53N+sMzvrzROQYJBD97Sienn2Ca0RF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JmBTwCpvnW4sFPbYFMDnGN8GnUrlj3RbXUWBX9Zqw71PX6Npk/JSFwGKDxwU59Rc
	 OLxoYCKxLr5tSO9rr6F7guGS+xxdcSVXr9l73Ksymw+290nn4T89cN0R8WBT3RQAeu
	 hD5yOBrgzyza8I2mFnjzwOXOZsxjQpziyGBN8BaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0018/2214] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring
Date: Wed, 18 Nov 2026 15:28:14 +0100
Message-ID: <20261118150010.874079683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

commit 79405e774ede411c6b47ed41c651e40b92de64a2 upstream.

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 14f43e8f88c5 ("drm/amdgpu: move JPEG2.5 out from VCN2.5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3216a7f4e2642bda5fd14f57586e835ae9202587)
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -586,6 +586,7 @@ static const struct amd_ip_funcs jpeg_v2
 static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_1,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
@@ -616,6 +617,7 @@ static const struct amdgpu_ring_funcs jp
 static const struct amdgpu_ring_funcs jpeg_v2_6_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,


