Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061877;
	b=VAfUR6W5a/SibYiin7+C2zeXjSxb4d3w2CFe+Q2NmmCuixJEO7Yna2FtK+uVoBLTkcOc
	 5ncCb0TYSUMwurgA1lhCMuIgPnFd7njLmat/agC4tOKslINeP/7PjJEJx+BseWps/HEGE
	 dkHBF/LT4nYGg4bQGEjaa4VsoEp2XAf8l5KsJMhVEUoCcfnjkpk6htyd5qoUXiRi3OA9M
	 BIrrOdHHe48lHCERdLKEPJmOp9/XT8P+STDnyCSZid7UBXv7PJBJ5utxrrJwvK6ylRVos
	 bPD3KlJ8GSuNi/egoi/jWf9Sb8l9dj2KpUSr3pbOln25FjoKJL/Enb9K365CBxDRd9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oacZ/60t5J7vhMdTTSWblsUrI14MJ/Pc9R+HXhdBr9o=;
	b=acJpd+irs2Fwg/duLqyUFekqVN4xbuoXKIxMh1jMXuSWGRbRas1QopQPZTNAMqV1TWbC
	 4tH2Ylp9pQZtH+S9AWnfxkddtKVbzrNpctxTIGRn9xQUjhRkmMiPllFc7IAEojX7pNam/
	 Z2zKwV1nYTIyrmsWpmnV/GYQLp2hlgq+OcsN9PLnaqKMKlbE3y48wCf61p8e3e5IuymAC
	 JDyWNRmCkz4oi/mqFnqwkPAzhH1Ch66NAdRXfyQjqgTTrXf0zoOOn3VEvZSVHNnuP19b+
	 LJV4QCGSQGUzlHT+GXcRDxVOaRcfgsyqZUlwKMor8BB/HwTHqvYALBNK7Zp3Z8eAg/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kj/gvJ4S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91057606A326;
	Sat,  7 Nov 2026 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kj/gvJ4S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD111F0089F;
	Sat,  7 Nov 2026 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061877;
	bh=oacZ/60t5J7vhMdTTSWblsUrI14MJ/Pc9R+HXhdBr9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj/gvJ4SNUF7V8FGJ5dR3+O7JtjIbF7QtgkPkLIshU7ij1edMCLiEceG8GqrjTxAu
	 2hWfYAuDOfYJrFH/bsEuud0fQie8S7qmZzw8g1PtwsnRxOvYGbm/856CkU0gpd4Ugk
	 P+qvRTI74xzC/mp00Rw/ltGfvm5J3iq7GJycwpr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0891/1536] drm/amdgpu: recompute the dw estimate after allocating a new VM update job
Date: Sat,  7 Nov 2026 08:48:27 -0500
Message-ID: <20261107135022.650214258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 36805dcfa1598..902d0a538e419 100644
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



