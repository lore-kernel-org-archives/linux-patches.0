Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214992;
	b=oeyQXf1ug0vBrWC9+QVSj2+HDjpOYKDGKYDMjvZGh622R/SiW14vzkKUJ1r/0pZS/sgf
	 REboXWbPF9E4B4T4GualqTWzGsK4dOpK9InfYWJ/oDga97xyK68hW//m+s/10BvkjBnf9
	 m9EL767u6gQcOAJhS4VxCOf+wddEeR04tT10NckDInkLwizmUqVTBoNh2oy8jR5Z0jEmc
	 Nj0y7xGM4On3RSjlpK8gtj75WS/Ez66WZ/phXzWlVQyEMfw80Z9kjCAHf+2COo/QNlYZd
	 SM/all2jpV0x8L9Cm0m+m1XSHg9+EJP3fgBePzMVcEpJxwmvS55UgbPzCLlOejlKRsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=49yvLgqI0N40M3cVguEhNSCMH6D/dzxQZSEo7IJPSew=;
	b=k/5uh16jQqK20SJEYapKVMt5VqUqRuXL8FvKVV9C1INsfn8Mw4fSRbp/VrnwwSjfz1si
	 cDOJC4Y7zVTY1dIUIsQHU4ctS1RdFgTknakIKnF+hM9E5Mwi52bNPqJDE4rVnBc0bSYme
	 ntuP7c/+5TRVKkiiYXn0rEnC/3jEBoxmQVQ7F2lLtyYISY4ByKlSoE6dWJ8sCs7YboRry
	 b/i/kv46rdisp5gwN5Fvf/9UB6VMmswKdwG/0+SEaJkeJbrkqgFmD4Ve27CNaP1JfPA2s
	 WxGrC3DX/HGjlgKXMsx3rfGoQw7UfVwPYR5FOFwayeBiJZXZX7u/4uH3bCpwKyP+9ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jt/1ZwJD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B18A606A323;
	Wed, 28 Oct 2026 19:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jt/1ZwJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D931F01825;
	Wed, 28 Oct 2026 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214992;
	bh=49yvLgqI0N40M3cVguEhNSCMH6D/dzxQZSEo7IJPSew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jt/1ZwJDZlHuHXce+pV3H9eJPJufdh4OAhGYAc6aIRQLWy5FieoofJ+d3Esqiu1ES
	 NRcpEePuupQHRmqG33gcYCZ3uc5UCtaawJ1116Y/rhCEG1Z+c2KHQWBqQfH9UrlNpf
	 TBa4RNwSUg2MFMFpXD9dSYMS24cMC58aRZ7lNTVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1055/1887] drm/amdgpu/vcn4: Fix IB parsing with multiple engine info packages
Date: Wed, 28 Oct 2026 17:52:31 +0100
Message-ID: <20261028170523.417103695@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

[ Upstream commit 2b10cb58d7a3fd621ec9b2ba765a092e562ef998 ]

There can be multiple engine info packages in one IB and the first one
may be common engine, not decode/encode.
We need to parse the entire IB instead of stopping after finding first
engine info.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dc8f9f0f45166a6b37864e7a031c726981d6e5fc)
Cc: stable@vger.kernel.org
Stable-dep-of: 2444eb0ec828 ("drm/amdgpu/vcn4: Prevent OOB reads when parsing IB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c | 52 +++++++++++----------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index b9f7e061ec8b5..34f4158810376 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1712,22 +1712,16 @@ static int vcn_v4_0_dec_msg(struct amdgpu_cs_parser *p, struct amdgpu_job *job,
 
 #define RADEON_VCN_ENGINE_TYPE_ENCODE			(0x00000002)
 #define RADEON_VCN_ENGINE_TYPE_DECODE			(0x00000003)
-
 #define RADEON_VCN_ENGINE_INFO				(0x30000001)
-#define RADEON_VCN_ENGINE_INFO_MAX_OFFSET		16
-
 #define RENCODE_ENCODE_STANDARD_AV1			2
 #define RENCODE_IB_PARAM_SESSION_INIT			0x00000003
-#define RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET	64
 
-/* return the offset in ib if id is found, -1 otherwise
- * to speed up the searching we only search upto max_offset
- */
-static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int max_offset)
+/* return the offset in ib if id is found, -1 otherwise */
+static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start)
 {
 	int i;
 
-	for (i = 0; i < ib->length_dw && i < max_offset && ib->ptr[i] >= 8; i += ib->ptr[i]/4) {
+	for (i = start; i < ib->length_dw && ib->ptr[i] >= 8; i += ib->ptr[i] / 4) {
 		if (ib->ptr[i + 1] == id)
 			return i;
 	}
@@ -1742,33 +1736,29 @@ static int vcn_v4_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 	struct amdgpu_vcn_decode_buffer *decode_buffer;
 	uint64_t addr;
 	uint32_t val;
-	int idx;
+	int idx = 0, sidx;
 
 	/* The first instance can decode anything */
 	if (!ring->me)
 		return 0;
 
-	/* RADEON_VCN_ENGINE_INFO is at the top of ib block */
-	idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO,
-			RADEON_VCN_ENGINE_INFO_MAX_OFFSET);
-	if (idx < 0) /* engine info is missing */
-		return 0;
-
-	val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
-	if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
-		decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
-
-		if (!(decode_buffer->valid_buf_flag  & 0x1))
-			return 0;
-
-		addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-			decode_buffer->msg_buffer_address_lo;
-		return vcn_v4_0_dec_msg(p, job, addr);
-	} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
-		idx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT,
-			RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET);
-		if (idx >= 0 && ib->ptr[idx + 2] == RENCODE_ENCODE_STANDARD_AV1)
-			return vcn_v4_0_limit_sched(p, job);
+	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx)) >= 0) {
+		val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
+		if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
+			decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
+
+			if (!(decode_buffer->valid_buf_flag & 0x1))
+				return 0;
+
+			addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
+				decode_buffer->msg_buffer_address_lo;
+			return vcn_v4_0_dec_msg(p, job, addr);
+		} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
+			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx);
+			if (sidx >= 0 && ib->ptr[sidx + 2] == RENCODE_ENCODE_STANDARD_AV1)
+				return vcn_v4_0_limit_sched(p, job);
+		}
+		idx += ib->ptr[idx] / 4;
 	}
 	return 0;
 }
-- 
2.53.0



