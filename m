Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214995;
	b=zjeCBslrQAOUpiGA+rtPUuPs0p8Ol74uDeRpG6+Wcu8QPS9xblaTtYAzoaHHGWocZVqT
	 P1tQrgCCf4XE+tVvMnLdBPHKN5Ap/YekPFhYIpX4aw/EikUQeUeSpKy8X5seQTBjd98zJ
	 9UWuTiBcyaPXsC5cXqK6SovVs3WTnekIy9pT8xz42th4Z7nZ6yRcNaWiDkz0JLlSJkOD5
	 s/vC/FShpljpE4gdHyWv5q21HIy8n1tFBs44vbRlMulLMsfcwbLs2ZOHl7psPyxWr5IQm
	 2XiWn3bFJbTNB+KB7vEnjze84sYpvZss0CKm8ZPbj+aDlUK5aCLaqv1gyLLhKaS70lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=10q5EkCUBG/fxadfmsYSdl3aFLzm4IWDDGoR0Z2fPso=;
	b=25KaZ62tUNWM5YpCh7B1RK1pHSjLL1a6ZFL8dyYGdeBGdtL3fl2wHZjZZSLvR9Q5rU1b
	 xQLCOKvXSYRxvgqh6XEbuYGmdBmbg3ZOiosZWk7ssyMxDv30g7sXm6yuld5NnjTICbhiQ
	 Dlk296DYPKeXyWQ74X660Dywh0JMW/IMD3LpZms2OBYhEKwCLEYmBASHTf/QI4b57KjtA
	 Lbj7l6u7VPDGkDaqFfP3Al2sW0ppw2sGIXfI9U0wIcvEJ6ByVlKdhGU57f2OzThgTibgG
	 WAglze/IuSniGAR0WFwnG3E0yuwzD8LKSaYw0r15UnoFXQF+ITJL1zcWRmjhPyiIjLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0QXz2Q4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F19606A323;
	Wed, 28 Oct 2026 19:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0QXz2Q4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ED11F01825;
	Wed, 28 Oct 2026 19:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214994;
	bh=10q5EkCUBG/fxadfmsYSdl3aFLzm4IWDDGoR0Z2fPso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0QXz2Q4FVI+Wa0XS5ldAmieRmAJ4Wkets0qNol4Y15EUEkZ97iSlvsNp4IV87mRs
	 /s7RXMVoG5tWnsKlZSquO9ddxQIbUmBv5szbeD7RvP1pQe/jog4GcvP+O5IKsTfVXq
	 SKAios1ElvW3bvUUX5ezGM4BPwWyAlgaDbO3yH3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1056/1887] drm/amdgpu/vcn4: Prevent OOB reads when parsing IB
Date: Wed, 28 Oct 2026 17:52:32 +0100
Message-ID: <20261028170523.438781002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Benjamin Cheng <benjamin.cheng@amd.com>

[ Upstream commit 2444eb0ec8283f4a3845eb7febad378476e1ba3c ]

Rewrite the IB parsing to use amdgpu_ib_get_value() which handles the
bounds checks.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 34f4158810376..2e9ba94894746 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1720,9 +1720,10 @@ static int vcn_v4_0_dec_msg(struct amdgpu_cs_parser *p, struct amdgpu_job *job,
 static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start)
 {
 	int i;
+	uint32_t len;
 
-	for (i = start; i < ib->length_dw && ib->ptr[i] >= 8; i += ib->ptr[i] / 4) {
-		if (ib->ptr[i + 1] == id)
+	for (i = start; (len = amdgpu_ib_get_value(ib, i)) >= 8; i += len / 4) {
+		if (amdgpu_ib_get_value(ib, i + 1) == id)
 			return i;
 	}
 	return -1;
@@ -1733,8 +1734,6 @@ static int vcn_v4_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 					   struct amdgpu_ib *ib)
 {
 	struct amdgpu_ring *ring = amdgpu_job_ring(job);
-	struct amdgpu_vcn_decode_buffer *decode_buffer;
-	uint64_t addr;
 	uint32_t val;
 	int idx = 0, sidx;
 
@@ -1745,20 +1744,22 @@ static int vcn_v4_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx)) >= 0) {
 		val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
 		if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
-			decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
+			uint32_t valid_buf_flag = amdgpu_ib_get_value(ib, idx + 6);
+			uint64_t msg_buffer_addr;
 
-			if (!(decode_buffer->valid_buf_flag & 0x1))
+			if (!(valid_buf_flag & 0x1))
 				return 0;
 
-			addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-				decode_buffer->msg_buffer_address_lo;
-			return vcn_v4_0_dec_msg(p, job, addr);
+			msg_buffer_addr = ((u64)amdgpu_ib_get_value(ib, idx + 7)) << 32 |
+				amdgpu_ib_get_value(ib, idx + 8);
+			return vcn_v4_0_dec_msg(p, job, msg_buffer_addr);
 		} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
 			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx);
-			if (sidx >= 0 && ib->ptr[sidx + 2] == RENCODE_ENCODE_STANDARD_AV1)
+			if (sidx >= 0 &&
+			    amdgpu_ib_get_value(ib, sidx + 2) == RENCODE_ENCODE_STANDARD_AV1)
 				return vcn_v4_0_limit_sched(p, job);
 		}
-		idx += ib->ptr[idx] / 4;
+		idx += amdgpu_ib_get_value(ib, idx) / 4;
 	}
 	return 0;
 }
-- 
2.53.0



