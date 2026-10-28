Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210114;
	b=r7cA68I2T/gZIfRUK6riRYhJLNKJXfYd7JvYZzrqe4ecyQ3UqXaHeZfNAMHbzu5NMPxu
	 SCJYeoDJViBdDk80zLVHq/BzxJSa/W65+CsYH6Q3kvGlO2K0YPxUnB04F9aK2go+aczsx
	 OryAe91PktiONZrMhMHE5FziEF6f1O4fs0gfr5alJcwres0MBoDEe5pdjGCUeIg3TVLLq
	 Ctv6uMNYeiuyAputRS8AqJSNDqk90pnPtLYFeAqHBBmIbUKuqPFN3LC8wdNBrKpzwvK2h
	 GPEUMZtKQMjP26P/o4nwYcGvbbT6G7pIXWRC4d1+/3vmkgYWZgW6R/jkLZx9WKtGVgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M8L8/4FcN6i/zJYr+MIB8jRk70M8y1A4FeOL/q69ETY=;
	b=J23ZwpNvTv1D2kAtvRT8dDKz586IU2Ez/JwtgDky6pbDB6bYJu0JZEjKmkyRDrvhkG7s
	 QAAg2SMVzXZUmA6dRS5FXXwFuc9SARNDk3ocAFJFE4zaIeWMxKyTOutIzNti8oQf0UnS8
	 HYdqJxU/SqMOQ3PrtmjXIfZ0v7oWTxxRrEUnhE3JRRUyT/juFluMQC6XZawOoQ/dIhZek
	 2dOP2PoxANCx7p/1LnwYeWg8iWc5c1spYg4pE8T71V8iucqAzIwLOUJ/7i1sXK69kxDQ2
	 BdTgAgKwvhIwA1wTsR30hgJAfCCu4YiTXUCL+vebeKyJ+J8Obov2i+XDyL+rI3HtPNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BfwjZr5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0295606A31C;
	Wed, 28 Oct 2026 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BfwjZr5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C75E1F01825;
	Wed, 28 Oct 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210113;
	bh=M8L8/4FcN6i/zJYr+MIB8jRk70M8y1A4FeOL/q69ETY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BfwjZr5MzRe9Loh2EfBOniTN5i33xK4BTTtglnei4cM0vZJOGfUn5rY2UDqfOl7b
	 pxID1kKkg4VMwt+t+w0fzIqSwzNaz5clJWYjfBwomd+SbDZWhLn1B5esy8+sbR84kM
	 Qxrkp0qdpk9ESeQV1+HmxhRa0uxe9QWnPJgblfi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/168] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Wed, 28 Oct 2026 18:00:16 +0100
Message-ID: <20261028165944.978832472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

[ Upstream commit 2ee9836545e690c9e66ec203445d7705959fd7a8 ]

The largest frame is 20 dwords, so 0xf mask is too small.
This was always wrong, but we were lucky with the VCE_CMD_END
commands inserted after fence and vm_flush.

Fixes: 8897ea8c761b ("drm/amdgpu: Implement insert_end for VCE 3")
Cc: stable@vger.kernel.org
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
index 1b5afa08f52b9..18df0735ef777 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -959,7 +959,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



