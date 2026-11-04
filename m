Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831297;
	b=mSNXyNO+Vnp93hg6bUzVhCwWC3hZYYBENamqML43y5iMj4HRgK4ImSxWXQs71vZUoHma
	 myIn5cc1cMULWVKB2Ss9G9IPNMjwUHDqgg20KNBDW20YXV2bcyYKk3Q1SMuo5jsXIVdZW
	 qHJPP1k3Eh9ykSBt/32dqjW8M/QVZ71ofRjevgtooYGq6j5acPHgKFthzrOG2g00bBYSv
	 QnvF/bOQmItOg+p3St6JcAL9BUD7IZB/u6KISRxY4KZbUI4Liy62H70KjLdzyp7GpU2Lq
	 Dhje7EoYwsOEKnFsjtaaVC/evbxk2PIUY19lYJzQ93J9401J1f4JzVmGo/qSlI4jo/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=53+Sdnooic48F53NQVmgdWFPAisIQ6izfCvr/qtVyDY=;
	b=kZ9spVSg9WRROkov8pp2FLN1o1eWSd5B6/gP8GGO4plP8rp2Gaz5oYmF38k7Rd0kCl1Y
	 Xs8wXOy2OI1LLSnT52tG81EEFGZdy0vl8AlYnPMk0ttnGUkArPgyQE1u5iLl+U2ZGdVq+
	 7bGD6vulSXCzxV7Zys5O/a/FrmvPj284pTsFT3/q8EkIAb8yGId3YVv6DvxCZ4/942Lmz
	 /Im9UKRchc7y+QtxJG3Aft5q4tFXFT6vVuK8L/qovx3Shr+tWYGIuPbdz3JIMz3XBOhol
	 EePhLvQcDjpK2LWDQFaBeLkDu3eAi9GRGU6a5IBZH2UrRSnwNK41y9k0iREnQw75npg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dc4DltJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1909B606AC2E;
	Wed,  4 Nov 2026 22:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dc4DltJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822E51F000C1;
	Wed,  4 Nov 2026 22:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831297;
	bh=53+Sdnooic48F53NQVmgdWFPAisIQ6izfCvr/qtVyDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dc4DltJmWSXiAfThRb1QmkBJNYJRQWlImVnh4kfY4qGjxphLdhhBorqtRUVc5nz8a
	 XkchYhECiQ8FnzqhVhmpscrwFM6P14AYK+XjUyWbny3iDdcbscbBkGmbmoY53bLs0K
	 WxGJRdttQZfKGTICDFtPSTbBEoBoim60eh3QhSNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0591/1005] drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size
Date: Wed,  4 Nov 2026 16:05:24 -0500
Message-ID: <20261104211100.420600559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 8cd2ea7bab77b7aa087b1a6cc26d2df03c2a6ed9 ]

To avoid wraparound if the value is 0.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c0cae35661868af207077a4306bc42c7c972947c)
Cc: stable@vger.kernel.org
Stable-dep-of: c883d0a132d4 ("drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c | 4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c | 4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c | 4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c  | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index 1695dd78ede8e..d8faaa573e017 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -198,8 +198,8 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index bb439f385fc38..fd91e5cfbdbf4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -251,8 +251,8 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
index 565858b9044d4..df03938eb11f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -214,8 +214,8 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index c1fafc5025158..c55a858d523ab 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -209,8 +209,8 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control |= min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1);
+	m->cp_hqd_eop_control |= q->eop_ring_buffer_size ? min(0xA,
+		order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



