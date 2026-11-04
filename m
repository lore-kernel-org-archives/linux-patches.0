Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831319;
	b=us8NfnwRdAxVhbM4t4wQuaJi9cr2glAXqQ1aG3PQxwC+xi7OM5dhNR3x1HJcb9HP5rhY
	 rpiv3cHUXVpFtA+Zrnbztd7XcyITDDTfa4TqqUyW7x2LH4bs80YuI5XLjfVAtGL2AfI17
	 uMd6MOzRT0fdZK8WieSFd9XiUhGBMyRajhpl+RGsRHUvbQ3YVDj3EVXap2Au2hXDkE650
	 jBaTY4NEjbYYb3+E9m4nytn6Ig69G9orHECvH6vHmfZbchs4wBunlivDWaWmTLMxDsryH
	 FeWXQlf7YOrb8sNf7s8J5GudS1jL7B/DeNxSW/rYeXUpaeYUi14jbmHejVZgQYH4QDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iB6YPvjYt6CX2YWfIKr+zrCryCDuDO5N2o+BvyxOYN0=;
	b=oDkof77JYpcIcfWaTdJyF/qooksMDv5L9i36KuLw/dwgI0dtrY8gBDNlTfi5G30JQOho
	 ey09VFbQBrRL3YbbluKJDJXhtOkjl1mzVtPQIMUrEWuFpCnbq64dn+CawYZ2r5WhE0eLV
	 ed/d8K7jckg5MWfP3RtJhVq/9q2BdRwdHus+AFQCxSgctRFWSnDMq/vSPwVWhr9UrFqaF
	 +msbWtU/FD8AfrYeQW0lsM1gcnD6eEffYtMLDBaK1iMJBzhs3orakY6exBjea0MRc/OTj
	 ZuwkiZQ4oOlCw0lndQxI/lSkPZ2yOrAX4kimF7J+pNsyO5z0uXlpJf98ndw6o/NHwXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yHcTUdIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92780606D810;
	Wed,  4 Nov 2026 22:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yHcTUdIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3076A1F00919;
	Wed,  4 Nov 2026 22:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831319;
	bh=iB6YPvjYt6CX2YWfIKr+zrCryCDuDO5N2o+BvyxOYN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHcTUdIhsi2QTT5ULHJnB1t+g1PaOSd4tYmoUf1bJcGFuD8+bA6onHBMRJWnLZhXj
	 zkxT4SNLmEqCeALqWI/fO7MjwrZkaXP1NKJza19TZfrqD1scIbgsyy1/9lvmQr/W8W
	 9YW5hpWXR+bPrl0e9EUVxxPJR88H1pqmwiHP9b8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0593/1005] drm/amdkfd: Avoid integer underflow in EOP ring size calculation.
Date: Wed,  4 Nov 2026 16:05:26 -0500
Message-ID: <20261104211100.473838770@linuxfoundation.org>
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

[ Upstream commit 8ee521b8b189799e361d4233c5180ba56656d4d4 ]

The low 6 bits of cp_hqd_eop_control store the base-2 logarithm
of the EOP ring size. This was calculated as

order_base_2(q->eop_ring_buffer_size / 4) - 1

But order_base_2 can in theory return 0, so this could underflow
(although in practice the ring buffer size cannot be less than 4096).

Change this to

order_base_2(q->eop_ring_buffer_size / 8)

using properties of logarithms.

Also add to the above comment to make the mathematics more clear.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f0f43fcf8b2b3a924cad9444340921c96ed5f634)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 6 +++++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index e3a33a92b1799..f0e7a7244a33f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -271,6 +271,10 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 		1 << CP_HQD_IB_CONTROL__IB_EXE_DISABLE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
+	 *
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -282,7 +286,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 *
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ?
-		min(0xA, order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		min(0xA, order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index c55a858d523ab..f0de0893bc597 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -203,6 +203,9 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 			mtype << CP_HQD_IB_CONTROL__MTYPE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -210,7 +213,7 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control |= q->eop_ring_buffer_size ? min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



