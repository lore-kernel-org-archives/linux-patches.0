Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061411;
	b=Wo45D6gkaT4prDI9DCznqH9soe7IqMCvFyKD5Cp0o3YYrnUGbjld2lqIlgmflXsiEi+D
	 tCeyH429lE3jNVeuEaND6hZfx3g9JU5AI3QQmQtAKZAefzj7UzjfljH1s+isfRD1+wgov
	 7FOnBZxkkaOUjWQ1V2ZRKLQservnCEhR2zUY+A45xoitNcefr3bXOTA8ibiAdMpqpwpNi
	 tY8lKXlrW/evtgGVpM5jw5mgNlk9L6+ZjOcthlnu0ATnigSSaM2UR6ZrMgSFUhmuaWs2o
	 7vFonUvIAC2k5JQMxdADBh53AKQY2yQcW9/1R3p43k+D/UGgBTuWsdoxPqtYrVQMnjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RNMrNjazfrMVZIZsnkKuVMLEWuenVM0l8xkk77gNME=;
	b=xZoODBJpa+Z/r8jtPcTXWV0bGIySGAmJ1XzzQUR1MlkIfyw874BCCP9FLqXX//WV5g3P
	 rD+CDfpej6YynbpvDe4nLZ2u8dGEanoEPyfIt7BNrJBhVy/CG5+WPnarWraRa96dZvnqa
	 eWhiFo4rIGKhVRqOVNi9hpDr3ClWmV/pgb5+wcT3KZLxNtfHeUtBoodSaZmH7lrte2glY
	 SpwdqgJpmuQ2U39QVbWBzbLoOFZUtzLq8YCTFepuw9IPTdl5yMGGa+7xawjzNAK1X+zDq
	 AGwL4uWWSQw2sNniCoJZoyPBpmHyagMiZ1nkrscaIh0Yvvf0tnuvKMFgI4v+h1GNxfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=naBNRX4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3137F606A32F;
	Sat,  7 Nov 2026 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=naBNRX4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1451F0089F;
	Sat,  7 Nov 2026 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061411;
	bh=7RNMrNjazfrMVZIZsnkKuVMLEWuenVM0l8xkk77gNME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naBNRX4sdUrkg8i1dijdzKH/t2mwulg2cUXYMNmcHvEddZTjVW0Ds4uYVf2g+aon2
	 nOUPU+bgmnIFeEr14GkRMvgPoRdSu3NZ3/G5wmpL5N+xH0757nbZt3GRCw05y2N5Bu
	 3mgL5O5PprW9HOLoBpi6k+A2p78DjAzGutpEd2Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0525/1536] drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size
Date: Sat,  7 Nov 2026 08:42:21 -0500
Message-ID: <20261107135012.170448689@linuxfoundation.org>
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



