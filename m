Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214989;
	b=z8gawfvZdP6AJk56N82ROp/PQvL42HAEx9KHFDlmQaGQLQt/T/YAqvhrbBVO2gPXOH05
	 vLDdVEClbcOv+jKscuOZkJhkmrW+4xhz3O3OgHrlsgYVvQ4ZR/b4drcdiUGpYr3LZvD/o
	 Ct1DhcvmjYRNh9lrwixOev9Edqhv7H2YwH4vPpf+2i28OF/EVItZSlb2c0dqUO6FsjDTv
	 GhX0TofKINNbnTW4ozh7a/0ESZ+H/vQ0PzwmXG7sRDDABKjD9kyr5BRxXNwXtWMGgFJim
	 c8vtlAeWXIUJWIYFp04xHwNX+03xNbeZEV+lLaruN583qcaDoCX821w3J1LbgBfk3rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUvQ3lIisQWxvSWxZWdwh1aj1kqDI3/0SmDT7PekX9U=;
	b=eSr/VU9GB0G974RzoLkOMfwbJhmMnXlNlWgBUdOncOncHXCUB+Q+ssFU5XiXg+2/EdCH
	 fg3tHjMFlLLLDGSSU0U+ZvYZfMwaS5uzeb/JPCkT6lVZgKSaKPXLvX+b/A48Y+mr9i94U
	 c8fkWwszGEIFxiQtkH70YldTtV5MnlrECC1Bzo0Lh6WgVu7UqL5Ti62daQALvGR1/QhRP
	 TBfk59hnbShWB+9aIaaXdJl6Gfz5of7EqDwXW549Ffp2OiVr/VaZq4EGBOswsbcs1TERN
	 YK/6hx1Tq1S+CM6kQltkfLMOdarwRFaSIHkrJfxPbqtLZbl4WtJ4rSfJXCC3uToMv/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iaKGku0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591DE606A32E;
	Wed, 28 Oct 2026 19:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iaKGku0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DE81F01825;
	Wed, 28 Oct 2026 19:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214989;
	bh=VUvQ3lIisQWxvSWxZWdwh1aj1kqDI3/0SmDT7PekX9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaKGku0d18L3HjHA7aY0KClxAQ1Uyst2HadaCy6dtKI3DafeEd35VPTYhpXd/ddh1
	 U3uIyC2KkJS4BcYcd+oEY2pbWlMOYL8ojHA3fSH1Ci6+0Zo9Kc9qxct7sRRTw9goiX
	 cysWCrxoaGrHSl50ykc6X3yqdpT5x+GFGYKgUJ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1054/1887] drm/amdgpu: limit AV1 to the first instance on VCN4 encode
Date: Wed, 28 Oct 2026 17:52:30 +0100
Message-ID: <20261028170523.394711676@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit f823323b4abdc171b510190280a01565e21bd392 ]

AV1 is only supported on the first instance.
Added vcn_v4_0_enc_find_ib_param() to help search for an IB param.

Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 2444eb0ec828 ("drm/amdgpu/vcn4: Prevent OOB reads when parsing IB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c | 62 ++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 2ae426f5e1339..b9f7e061ec8b5 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1696,7 +1696,7 @@ static int vcn_v4_0_dec_msg(struct amdgpu_cs_parser *p, struct amdgpu_job *job,
 
 		create = ptr + addr + offset - start;
 
-		/* H246, HEVC and VP9 can run on any instance */
+		/* H264, HEVC and VP9 can run on any instance */
 		if (create[0] == 0x7 || create[0] == 0x10 || create[0] == 0x11)
 			continue;
 
@@ -1710,7 +1710,29 @@ static int vcn_v4_0_dec_msg(struct amdgpu_cs_parser *p, struct amdgpu_job *job,
 	return r;
 }
 
-#define RADEON_VCN_ENGINE_TYPE_DECODE                                 (0x00000003)
+#define RADEON_VCN_ENGINE_TYPE_ENCODE			(0x00000002)
+#define RADEON_VCN_ENGINE_TYPE_DECODE			(0x00000003)
+
+#define RADEON_VCN_ENGINE_INFO				(0x30000001)
+#define RADEON_VCN_ENGINE_INFO_MAX_OFFSET		16
+
+#define RENCODE_ENCODE_STANDARD_AV1			2
+#define RENCODE_IB_PARAM_SESSION_INIT			0x00000003
+#define RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET	64
+
+/* return the offset in ib if id is found, -1 otherwise
+ * to speed up the searching we only search upto max_offset
+ */
+static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int max_offset)
+{
+	int i;
+
+	for (i = 0; i < ib->length_dw && i < max_offset && ib->ptr[i] >= 8; i += ib->ptr[i]/4) {
+		if (ib->ptr[i + 1] == id)
+			return i;
+	}
+	return -1;
+}
 
 static int vcn_v4_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 					   struct amdgpu_job *job,
@@ -1720,27 +1742,35 @@ static int vcn_v4_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 	struct amdgpu_vcn_decode_buffer *decode_buffer;
 	uint64_t addr;
 	uint32_t val;
+	int idx;
 
 	/* The first instance can decode anything */
 	if (!ring->me)
 		return 0;
 
-	/* unified queue ib header has 8 double words. */
-	if (ib->length_dw < 8)
-		return 0;
-
-	val = amdgpu_ib_get_value(ib, 6); //RADEON_VCN_ENGINE_TYPE
-	if (val != RADEON_VCN_ENGINE_TYPE_DECODE)
-		return 0;
-
-	decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[10];
-
-	if (!(decode_buffer->valid_buf_flag  & 0x1))
+	/* RADEON_VCN_ENGINE_INFO is at the top of ib block */
+	idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO,
+			RADEON_VCN_ENGINE_INFO_MAX_OFFSET);
+	if (idx < 0) /* engine info is missing */
 		return 0;
 
-	addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-		decode_buffer->msg_buffer_address_lo;
-	return vcn_v4_0_dec_msg(p, job, addr);
+	val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
+	if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
+		decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
+
+		if (!(decode_buffer->valid_buf_flag  & 0x1))
+			return 0;
+
+		addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
+			decode_buffer->msg_buffer_address_lo;
+		return vcn_v4_0_dec_msg(p, job, addr);
+	} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
+		idx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT,
+			RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET);
+		if (idx >= 0 && ib->ptr[idx + 2] == RENCODE_ENCODE_STANDARD_AV1)
+			return vcn_v4_0_limit_sched(p, job);
+	}
+	return 0;
 }
 
 static const struct amdgpu_ring_funcs vcn_v4_0_unified_ring_vm_funcs = {
-- 
2.53.0



