Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034915;
	b=Ysd7OKel+y11q2811foVD0qPkGiiYNgMXjh+E69ONSIDUsTXNgTLeYbvDj6i8kI26qRZ
	 Zn33N+fGv0RjfkBUY5lc6gEhbru9I/SAX1exGHuSfS/jnjJ8LpIrZuXO0BZjgBRBME3hF
	 /E4Xv8kPvqTC49b3WBO+6R/ynyxL6R/6qA8QTmoHFg2Nuz/qWP+w/r7uFUNwT8M/+K0Bf
	 lxfH51ic7TwguRK4mh/fIgt07b+gAh5yVmGDC7BvX4zDP8+RyRuS5Vtag4/B/zhcx2mQV
	 y9+3j3ZLiap8K6ipAtuwgiiMXNxAKdn8VYkuC4OXG8DqQM1bIdY7E/megLjuKmYr9hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tyAqKaIQDf0W5isqZOOqjXI7YnbBpBCsGqdYtGDCkG8=;
	b=G1OfMEG3BQkSjJSJNZZINZpeqXKfgfhxDFyxQJf9/IujuM01eIjw7inKoCxeKcnFPFn8
	 37IReLUvItF0lOfrqigo27QpvDhPWL5AToBUiJOamwfIiA1ClfwdXi84J5hmFJhAW+avx
	 UQ78hmb+ZDZHX3sIpain2ITdq/HJ06Vf5m1SH/D+Ynv0udmxAw48hQKIalp3peJB13Q64
	 a0j/TEzKP7CPKBo/UK8WnM+isgsaJ++r1krtO+bQpvaXCCy6J2Au1Jlk7YCuX98EQW4FJ
	 gM7N7Zu3aEfEO1I1QZ0nTLUQz7RM34U8nXXLTzcT3qpjq9uCaWfJ8DiC7tLtk3cOCFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJKswjtn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B3606A31C;
	Wed, 18 Nov 2026 20:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJKswjtn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC7D1F000C4;
	Wed, 18 Nov 2026 20:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034914;
	bh=tyAqKaIQDf0W5isqZOOqjXI7YnbBpBCsGqdYtGDCkG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJKswjtnsWCp0KdGnPAQ6LxGWPsIHVAzHsMiD+H+t34RvCbwxasCwVtVW8gSGNbIb
	 Tcl9JqrGov5Ep0Cn1gysL+e7Qf5HQA9qGzl4qJC35f5PV6d8X7fmxqTpM7AJ6tuZEM
	 U7LTYIXsIgcXwvTtvxhJO5NXIDsrhy+pKgDTouP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0489/3318] drm/amdkfd: Avoid integer underflow in EOP ring size calculation.
Date: Wed, 18 Nov 2026 15:18:31 +0100
Message-ID: <20261118150331.661164392@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9d643c1bd28bb..9fb1d11befb95 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -266,6 +266,10 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 		1 << CP_HQD_IB_CONTROL__IB_EXE_DISABLE__SHIFT;
 
 	/*
+	 * The lowest 6 bits of eop_control store the EOP ring size. If
+	 * their value is X, the ring size is 2^(X + 1) dwords, or
+	 * 2^(X + 3) bytes.
+	 *
 	 * HW does not clamp this field correctly. Maximum EOP queue size
 	 * is constrained by per-SE EOP done signal count, which is 8-bit.
 	 * Limit is 0xFF EOP entries (= 0x7F8 dwords). CP will not submit
@@ -277,7 +281,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 *
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ?
-		min(0xA, order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
+		min(0xA, order_base_2(q->eop_ring_buffer_size / 8)) : 0;
 
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index ad3a47b175413..9e06989239ae4 100644
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



