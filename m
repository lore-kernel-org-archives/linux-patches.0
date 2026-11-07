Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063799;
	b=j1QtqUbBeT9Vnw0rtXvXt7XN5yNbgnOQyJg967cAZr/vdHagyA7wrMAaxdpqUC6siqvS
	 pHMJGI8bBpj0zVbY3L//0m9mCKo0+/gPfRS9GonI45StdfMPma55lB4m/LDrlwQPvNWCi
	 LpX6TQoHcj2hBGiGKgTWXq3sWa6RXYd8t/9pCH73/m4VCXRu2qz27HYqN1KAXKcFw20S/
	 a5Ptt3kqdIGPxqhaXgz7Zn4h8R1YgXpNaX3Sb/d+gqFC49D5KtNi3qFCYPBGOV4V11/eX
	 6pftvAvUZYdUuUPHWUx9jNBjhMdzo88axvW9NTjmB9sVdXtrYc1EohrbbCLbpqj8vBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dfxiNV/cp+QQ6oX+QqVfdoM5cDZUF6HXfG8xyysg1dE=;
	b=LwwcRpNPP4wyQxf7BJDAHIBnQsV+EaP6sJF+0srCCB+0sQJ+MetaKTcQSHeMyKIezLtP
	 IRzThIueF9aKBuyk7AAUV7AEw0ybiKXIw+h8cqfABr/hdcmG0lJqDpq/TVu46ut0z4/9T
	 e/HSXHYGp2bKylRjKN5Yk25twWZIvbjz/Qa977tXNeefSXydBBnzeiG4jJyQqiEBV2cOT
	 j4S2NuqwMJjglSagg+2Fkf+++0Oku9QA7n7DkiaZRuLQhKBwS6/Z8CEb6XaX+HJLTB7aJ
	 RP9dEe3oV0lyE3g5s6orisNqjO6ZxhV4WViEe5JUppqWKXdoJCYQRZfxcniRPnTHsxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BopbGysy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9570C606EE87;
	Sat,  7 Nov 2026 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BopbGysy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4384B1F0089F;
	Sat,  7 Nov 2026 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063799;
	bh=dfxiNV/cp+QQ6oX+QqVfdoM5cDZUF6HXfG8xyysg1dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BopbGysyM77WJa7sycS/oOvRrMFzqkp4vSnNzWQ/dWzXDnoO7Y5lpoGlo/KoF0Az9
	 qz7VNJlpu0r/pyZ1Myl96ZvsZ8V9IITLJL/oRoaOIS64O4IbHpRwaBE9QZZNg78W1k
	 tqEQdTk9Rwz9wVkUsb7047vohKUBU2unzSDYlRa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0020/1257] drm/amdgpu: recompute the dw estimate after allocating a new VM update job
Date: Sat,  7 Nov 2026 08:38:36 -0500
Message-ID: <20261107134939.974353707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuBiao Wang <YuBiao.Wang@amd.com>

[ Upstream commit a74c7832b11827907de560169c7d4ac94505fd87 ]

amdgpu_vm_sdma_update() keeps the number of free dwords of the current
job in a local variable. When the job runs out of room it is committed
and a new one is allocated, but that local variable is not refreshed and
still describes the job which was just submitted.

The stale value is then used to decide how many PTEs fit into the new
job. If it happens to be copy_pte_num_dw + 7, or one more than that, the
result is zero. copy_pte() encodes the transfer size as count * 8 - 1,
so a count of zero asks the engine for a 1GB copy starting inside the IB
pool. That runs off the end of the pool, faults on the first unmapped
GART page above it and hangs the ring.

Re-initialize the estimate from the newly allocated job, which is empty
and therefore has its full budget available.

Cc: stable@vger.kernel.org
Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 50cc0779c340e..eb8cf0d9d9c59 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -254,6 +254,11 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 						     AMDGPU_KERNEL_JOB_ID_VM_UPDATE);
 			if (r)
 				return r;
+
+			/* The estimate above describes the job which was just
+			 * submitted, take the budget of the newly allocated one.
+			 */
+			ndw = p->num_dw_left;
 		}
 
 		if (!p->pages_addr) {
-- 
2.53.0



