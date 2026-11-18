Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044835;
	b=2iAKKzqR/CA0MAPZoRCKve56j4JC4Qv7wc+GafUH3O+Lp08VKuzV3D0qtcLFJXIyXd1g
	 SgvztMQIzS2JNnUCmFXMPEtqgcbex0+44XMPoQxdAsjgM7bWoehAVXL06bulp4GviwR3B
	 tT7tuxPZxMdlPBVRICvytiIOePennIX1ApvkfyTzw57ynv/ROaEQ0NYgO+8WTWQshqygW
	 yfVKE7wDvuYSpD8OwxIxmPlZOL6ow56vyNRlN+hEYDKup7a4FnJxKCv7SCjiGsX7RR3I0
	 fdNJacs4iA9fS+rgsxLksKpPWr6Q8QzSvQ7wjnOXnRQRF7ckG5+bE4wEfRFtGAJXGkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dBDK1yMb2KFI+r1MJq6bJdGWoxZZXol7l38nWeK6jWM=;
	b=u5E2oai2fVUJtBEVW7l7uHezMBYRiqwDds44/1Zb0EcfVDGeO3yAyFuWo/GAmv7GcMzk
	 tu74ycsF2I/LVh16qEfIWtna9GNyJbIYvJFqbkpvxNnX7NNOtf0Slzm0l3mcdQDw5yMFh
	 Jj8aGCEEDocvDvnUM3LnVC0OnxPSkb6mfqTMP2ZcyrW/8SWM6z0eem6wqD9+8CgrHnBOu
	 Urmt5h/imm5pSPZ2+/qjZImlmL4/NCt8AHf3cqlw0GMi24zOXt7BrpbzeE3rHV+ZYt9sU
	 HsBiol4AqS3UcjRBqbdIWM7YhHXZL5xqFctR5kdNx6XnYR0XUOEMHq/wQbKygNJLJuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnSFS+Qn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B7606A9C0;
	Wed, 18 Nov 2026 23:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnSFS+Qn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C17B1F000C4;
	Wed, 18 Nov 2026 23:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044835;
	bh=dBDK1yMb2KFI+r1MJq6bJdGWoxZZXol7l38nWeK6jWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnSFS+QnNGR+sEJjX0LvjxruFaa9p0HQPpwLuJqRwDhNRwdz/S16QhnP2spi5Y+Vk
	 Fj8VH1M7iLVOUmWKRK6rfygUvOLYzoxq61oiSWP2jLwn+8uzFupJnLvVKmt6y8Ilaw
	 I6hUEjghSbnpVNYPfXegCd9BYT/zFIkTVCO574do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0708/2857] drm/amdgpu: recompute the dw estimate after allocating a new VM update job
Date: Wed, 18 Nov 2026 15:29:02 +0100
Message-ID: <20261118150227.043463517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 126364882d098..7d820ed5c9bf2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -252,6 +252,11 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 			r = amdgpu_vm_sdma_alloc_job(p, count);
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



