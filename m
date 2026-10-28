Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215190;
	b=kGkxDt+uDSJMqC3VEUa2NfE4V8nY0b+Ypu1jmXz46fMRgRe/LyI/nvAGyxheXISs1oHN
	 4N1Mv45/zsUJjDeEScIoLMsscSTBtPONIeSdAxqA2EE7KwuKEABcNwSYo2EfzWjk/BQ8g
	 bBlcUeG+DUIGTkR1WX1b4roz6hzhIn9h+ZMzAoYLz3MR9qJGZmwYqAqQ4zUB0q+IXb3Eb
	 02CbMNG+6EV8bMhONPLFKsBvxWhC/sQbCzaiC7vf7dpJCpzfmkpeW9qBR/TZNURzRC+Sx
	 zMrP3Q8eeSK2Kmx6YIBvrzeijA8lQaazDGzOs6G8osEzMSqv/Q0+lwT80kttrQpSPTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JwujvMA2HiARvmgBEM/PI+VKjCWeWzv2OB7xVxzWSaI=;
	b=sKjkN+WnxK/d9ylBH79Z6To1C65QfisZsR1ve4SxAM5JIGxdmqwwWeuFxnX9OL7lVKNL
	 /akEtHh28A7QxJw3wCVnTLMh10O1Btt7jMnRv8pJNH6IgA7/snULVGREnaVck/qf6aWIx
	 ZCwJV7eUOT5CqZhv8lLeqD4Bt1TVV72XjIOOBtivrXdrGrc2t9I0scxwzs6zVRx33/B3n
	 yR3xbY++XVQqMczLDpCpc4y3BqSP0So7fZvFiP4aBDQQdQekIwTRheDQoD/g0QuGXajqm
	 ly7AHbhtVSOxXWkbHkftvLKf1VJtqVKlJJGDOmdYZdMvcNEtXo+OOs1R5cS5z1TV7nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxMv2tTA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304C606A31A;
	Wed, 28 Oct 2026 19:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxMv2tTA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535A11F01825;
	Wed, 28 Oct 2026 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215189;
	bh=JwujvMA2HiARvmgBEM/PI+VKjCWeWzv2OB7xVxzWSaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxMv2tTA1Z9tTe2fQKgKK+ss1LDpkkPrtLY6QXd1KleYS6o6TIGzuEWrLtO2PGzvA
	 BNjfBj94vEkgUl6cS4PuXdGZsNFrElfHpNQ/SgteYoEpn8twOGIxZ9ED2AYzH0Hds5
	 l4pWG0fgJ2yzA2pyfDODCJFZ6ffTME0ltKuUSAW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1123/1887] drm/amdgpu/vcn: set no_user_fence for VCN v2.5 enc/dec rings
Date: Wed, 28 Oct 2026 17:53:39 +0100
Message-ID: <20261028170524.955327957@linuxfoundation.org>
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
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index 8a7006d62a87a..f2a07794a2868 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -1527,6 +1527,7 @@ static void vcn_v2_5_dec_ring_set_wptr(struct amdgpu_ring *ring)
 static const struct amdgpu_ring_funcs vcn_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.vmhub = AMDGPU_MMHUB_1,
 	.get_rptr = vcn_v2_5_dec_ring_get_rptr,
@@ -1558,6 +1559,7 @@ static const struct amdgpu_ring_funcs vcn_v2_5_dec_ring_vm_funcs = {
 static const struct amdgpu_ring_funcs vcn_v2_6_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = vcn_v2_5_dec_ring_get_rptr,
@@ -1659,6 +1661,7 @@ static const struct amdgpu_ring_funcs vcn_v2_5_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_1,
 	.get_rptr = vcn_v2_5_enc_ring_get_rptr,
 	.get_wptr = vcn_v2_5_enc_ring_get_wptr,
@@ -1689,6 +1692,7 @@ static const struct amdgpu_ring_funcs vcn_v2_6_enc_ring_vm_funcs = {
         .type = AMDGPU_RING_TYPE_VCN_ENC,
         .align_mask = 0x3f,
         .nop = VCN_ENC_CMD_NO_OP,
+        .no_user_fence = true,
         .vmhub = AMDGPU_MMHUB_0,
         .get_rptr = vcn_v2_5_enc_ring_get_rptr,
         .get_wptr = vcn_v2_5_enc_ring_get_wptr,
-- 
2.53.0



