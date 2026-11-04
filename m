Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831315;
	b=m0IigRFh734IvL/mFQ6alKDmgo7ZCBdIEPFo0x71rDmZqmd9bp53gQZcwCfOiqc19GHQ
	 FvE8tgYn1Pl768u1pnjEbicRfMramTbpnd34OxgodDBNl1DAygjOQSfkakyXbLXtM5mtU
	 Phl5OtO9MM3EkYyZa4zQd10BY9s3Mr63hAntfckAm4VvjxilimyOwhY6EIWCTYbQPLowl
	 z4yi2UCRJOb3IzvM2cjswxBBxDVs6R9m87XwImQAxipQNa5wxJR7i9NNQlhW5R3WfXVnu
	 DBsZcyM4V1w9R4TsWTtaE5rotlwHjMBqfERnOqZGKUpUWGTt4/CgW/17QcIW2ro+Htg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uOe0xAGOaUkDsLxPy0c3B/wnKjvzeMlJuynunv9E+1c=;
	b=BVEMbApbwAo4vj/3dSWaRzJgIlUjVnXwN5NrfA9K5wJ46ih71f99lc5p+ZrvQ95beY+/
	 l/L1o75Z4QPdlFigFQrdivr+AOpnD97s7Rvph6bYK4JNnJqymLzLBUbul5xN+y++ZbGJo
	 woE5kOfeqFEg2dZe/xspUlClpYJ7XRoLIoX5A1QnUUXixKx9LFRNdyjOy0UmK3wdJZFry
	 vomf+6q5SsNCmlGehbdtoVi3cpZDVvD3TrbfUXA/m4qPdZGlwpcYEkfW5jzMxTVHlsDMF
	 0iWmjexrqkal5CCUQ56cjiXRFK67fd96EoHzl7V83Rj7m4SvRC5dAFgEnXzZ0ewuRbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOOk1kKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD84606EE96;
	Wed,  4 Nov 2026 22:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOOk1kKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01051F000C1;
	Wed,  4 Nov 2026 22:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831314;
	bh=uOe0xAGOaUkDsLxPy0c3B/wnKjvzeMlJuynunv9E+1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOOk1kKNTBTzDLPLzZZ+HD0vzwe/28dybRaQ4ToDntCQR6N5v8PPYQjkNevtXIPnj
	 i0pjx2bAOvUqb4c3x+hF89+h3cbjj8RbsQHCHSzhEF+exfPe8Cx+mUJGWNzYyQb9Nf
	 vEl6tLhb1zLAFXp0FT7r3okOBwJjkfTHNw7e0kp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0592/1005] drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc
Date: Wed,  4 Nov 2026 16:05:25 -0500
Message-ID: <20261104211100.448172275@linuxfoundation.org>
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
[ sashal: Dropped the hunk for the GFX 12.1 MQD manager file since it doesn't exist in this tree, so only the v10, v11 and v12 changes are applied. ]
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



