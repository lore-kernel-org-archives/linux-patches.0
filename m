Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035697;
	b=yAFwpO+wv0TQQOLfWIWZTSvQg5C5LbAJv0l3HmKG22i49FIa15Y8HEcu6Tbybj8fqJIn
	 VQXSw84vqfN6W2l5DbQNEBMNRmplAUIADr7XczPZa3vm2wh0DW9zRkwxc7YeuapiNnlKy
	 ykHcQT8qL1iHNmUrNsXgqEEAqdYRp9gM9PurumslXFZC0bqvnaO/Cy1lBohEPGDmJIAQv
	 aqbeW1/ChenK1uNRI+itMI8jMo+4RzduYR3B3mgpOPMM0tUpKhhy1itOcHKwXGCborjLM
	 Z6pvV4+pl2D3nrqgEDe1dHwyce0ol165EmfXrdIav+dtirS6GiYqOCyBlBjFOwpZ4lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5A3by3k/RLt04YRIfrYOFnW3LZF0e+9mMelA9CChSn8=;
	b=Q7fzah8isDEVu+F5Q5j1x0/nDWqdVQedQuZ72eHJm1IH7cTJz3X0UAnG6phW6nEKzgVB
	 pZmUlixdpMXjy7lD92twz5BCzce1VrxuEiphKvjJMZ+DSK+hKpsQciyYiiW6taShkwNb1
	 XUp3SYZxbnAIZau/9KSFW0iFz//melMOiqQOPTIsN3rzoCdRqQ7GbJYHqlDqImq4N4D+G
	 HY8BiJkNk5i8AE/nL1Ha4yQcU2QCMuxr4N7tpSiXzAShvQ0ilIZb7iCj9EgW7SR+hT/xa
	 9P2/Z3w1thbVFwHW165z8w/G2CYMteUmBpqAxa98AcJwYcFV3qwL+HeGRGkvAImPh+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmArP5s6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5419D60A2601;
	Wed, 18 Nov 2026 21:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmArP5s6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB941F000C4;
	Wed, 18 Nov 2026 21:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035697;
	bh=5A3by3k/RLt04YRIfrYOFnW3LZF0e+9mMelA9CChSn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmArP5s6lwMz09R570u3f5L+cer+b5aplfvedb2F/QvsFPrPGD0ws0bX+zrG6gDiF
	 bdqOD5edGb3omiNDZE45GWOehe06o6/YBNniYYDtLOgd3Gm7iIHNUvGUIJdGKiQJRq
	 554ho9a9lt2PagHykTK3w7O9xFX8Pu18Dna1vQz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0796/3318] drm/amdgpu: recompute the dw estimate after allocating a new VM update job
Date: Wed, 18 Nov 2026 15:23:38 +0100
Message-ID: <20261118150342.780872342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1cf1498204678..be7d91574ec56 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -265,6 +265,11 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
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



