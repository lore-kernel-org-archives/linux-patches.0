Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061413;
	b=msd/JDG1nhP3HlwvcSJgm94fzbV+ocL0V0lbhSA/JZNLDxSeKEeeffS8/ucBNSl+/02b
	 t8mZ6QMV5xyi04l17QpSehT55sDcqDTWdLRT6QpLC3P4H3malCalC3b0+T1ZQ8/iOyL9d
	 ck3a3UwvkLhpdbDWyJtRllUCLVResvN4v23TAgYj/6QW4kSNuJLb7DWaT8hlqIg7qn5er
	 +OEcI8+2jbvYk0BK007Vz/TGsKXAjNaOZt6YOeYIylSXgpjj9dTyIKzclpkb2H3a8svEL
	 pfL1opEiVfPkRVxgJN5vtkFe+Mnou+pxVPF6S7fDgMTT8f/Z2+OOM0doGvuqwokqAcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=set2zqwEdNyRWujJIuDBiiPgNttbuArfaZkNDcOdy2U=;
	b=UgeKFeLWQX8A0AKA+CJGZFCIGzhwC0y16wVda6UvHm2NQPYqH0/TGxodAKMuHDRHNxCY
	 XxlqwawmgsgTpBfZipOVjmTwE2A4q2n5KKT3zH4UrP+P8wxriaEqBqJCiEyYXeAJu14gB
	 kBpq5VIGx59oQQx9BnrIJR8rZzCypJfHeBCBtUhd8oAp/r2Yv9o8m98lr+G27VLnaV64H
	 zJeynNZ+HEIOCIe08+I90qYur7gYnwSd99PxBDRCMA5LeI48YjFwGESddmy0U3kOddSyZ
	 ufFRBiAA+XWHETYlvymTt5LitZFBFrRlgOefS/IE9ucc72110LEHxQDnrxju839U1iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBAz0tgn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ED6606A32F;
	Sat,  7 Nov 2026 14:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBAz0tgn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821281F0089F;
	Sat,  7 Nov 2026 14:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061412;
	bh=set2zqwEdNyRWujJIuDBiiPgNttbuArfaZkNDcOdy2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBAz0tgnWue8xUGNHZ1CasrEi6PikUO2xrMdw1XL4xv+00q6X/dqZf2T6/Bhty6i6
	 jRwkfn8ibcxoTbLqFiZWOVJ8KruXsRnpyH7S6KlfFfOb3rUWvxzFMwQTTgzIKUBQUf
	 /b/IXzb+IPE+TGw5u/rPlMWAfegDe297fI7zE2QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0526/1536] drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc
Date: Sat,  7 Nov 2026 08:42:22 -0500
Message-ID: <20261107135012.196737029@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

[ Upstream commit c883d0a132d430ef7ebb23fd94323be94d0fbdb8 ]

The low 6 bits of cp_hqd_eop_control store the base-2 logarithm
of the EOP ring size. This was calculated as

ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1

But ffs can in theory return 1 or 0, so this could underflow
(although in practice the ring buffer size cannot be less than 4096).

Change this to

ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)

using properties of logarithms.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4f18c56630383c14bfc6b2d65f88f2f895d2121a)
Cc: stable@vger.kernel.org
[ sashal: Dropped the hunk for the GFX 12.1 MQD manager file, which doesn't exist in this tree; the other three files take the upstream change unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index d8faaa573e017..4a621791da230 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -199,7 +199,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index fd91e5cfbdbf4..ca90454b01acc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -252,7 +252,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
index df03938eb11f8..1f6825a91db86 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -215,7 +215,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



