Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215176;
	b=etevW8cr47KsJDRMsXBerS8FkXMNgQ02iqOrCoOZYF/8ob6PPjJiX7rkJVitgXEXLyJE
	 KbM0ghq/wp3OyM9C1Aw2UQEEGpl5tO3xNlnmMbkOeSUcsvOOYXhUvh5RKndlsFQRfEWoI
	 XHYaz1VZ293Cum32SPp31Osiis3LqWjF7L0M4KM4TGKqLjh1P8flN4TqSxtkeHmKDLKHr
	 RozpVTsRE0elQ+MATCfCe2/jPj18e+Q/1gvbA6VA8C/iQcqZBF+8HPQtATGKFJxAGWXPz
	 8+jVFW8leyb5W7sxItM6kF9AutqvpfwTvVd+M1ciTz2HL2oIMiOqFpp5BNYxJmkYCuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zSN68aSUC4fcwkjxkcLzl7Qox0s5rvPmKNp9+rIFThk=;
	b=asNv9jKCkpWe4FKoV5AVdoOyIkUJ9TtC4SBWNaNG+7VjPpffQ8tEnxlDsFbH7DtSjp6N
	 aLj4VLN7F04Pq5EcNLfII7WCOKAMVa6RpevIHa4cCSfFFKRSmurDr9Kxk+bEh9nHqGFEH
	 DR5+q7BPJGrue2rnWthNeVfyAeTqbRPQFsg2XtPUYB+vIarTROWAtCQ5o6pb9EgMZVp6z
	 GFZtZg3Rlcn7XZItIWFxLTyTR9UGv1RGJ2jxqg3dHB7zsDkiw7K14O4t+/f1yOIE293Ho
	 yVe818caytiah917sWXf+IWxWvlOginfyiua0oX8PRNbJUi6NyrDfgDBSOx3V0oQkNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSPOlAbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E61606A31D;
	Wed, 28 Oct 2026 19:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSPOlAbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451B71F01825;
	Wed, 28 Oct 2026 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215175;
	bh=zSN68aSUC4fcwkjxkcLzl7Qox0s5rvPmKNp9+rIFThk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSPOlAbhHROTSN+J9sVaSLnNdlQ9GRMNIWp6fJ78Bv/FZBKERYboNdSjjtqBhBLsC
	 APQpBb8BEbqa37VLrTnH/PIBvMmogSJR6Jpsqz905FL9xDxz0H4ZjZu5rEb9MkJe8Q
	 UqZM9w9O7dG0rydJ/OErpukkwfENUs9rDOeR0+tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1118/1887] drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring
Date: Wed, 28 Oct 2026 17:53:34 +0100
Message-ID: <20261028170524.843894592@linuxfoundation.org>
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

[ Upstream commit a2baf12eec41f246689e6a3f8619af1200031576 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfd57dbf44dd ("drm/amdgpu: add JPEG3.0 support for Sienna_Cichlid")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7d774f100efb5089c86a1fb8c5bf47c63fc9ef)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index 323d68b2124fa..54cbf62a8deac 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -561,6 +561,7 @@ static const struct amdgpu_ring_funcs jpeg_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
 	.vmhub = AMDGPU_MMHUB_0,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v3_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v3_0_dec_ring_set_wptr,
-- 
2.53.0



