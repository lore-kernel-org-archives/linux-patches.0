Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215743;
	b=4SpJUiR5VVUuZ5teDJfuquw7SFkSCbY90xs4Uhg8g862Axm269Xdx5y2KFwKIm3hpsY/
	 cB4zPzfJbQOVBjnaWbGddgnb65Tb5WGkK/3Lft3y6dQQKBZG27GSM0/5iw84nNIvPdxwG
	 6ldMOzCdHM/W36A+fJ6IFDuCh0t5KjxZAKJGU0izss/+uM6epR15eIgdxfYNxSriehIWk
	 Nv8u82RMvp/PjBKYxaes+Q1NJ4BQeddV8DTzaYtlGWPhIu69JwLQbS4D3xtaS5f8DOAOk
	 ZIEG1mYf260RTqgWYQea9w3/DcciwtmWYnQ3PENzYNkQJk+KY8lWb76rSrxIoyNjd/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FFcWD07tjqgq6uEJw6Mg7YXrreaBMR/3cLPe3gZ+Aig=;
	b=D3qq2DmfVB3wv8FdyTlezKvmSopMTC4zNP9CfVus6XPYe6XCYDBl8eV4vrU5Ivgrcn0h
	 Aoj3N0N796H8wsEwvO7KPBUuK0wvT+a9iGMlUGjdmX5Hqn78HPUIAAq13k+nl6ZGfDSHj
	 gRDub9kRliCb7JZ5xJUwxwU3cY+VAqgAWdagxry0T8mpWJl6NAUI2+6YXu8xkLo4LYYbc
	 sZ3qnkFkgJoC3Ezzoi9PTL4AVDTLUlrnZ62ZRPFgw1bZWuKuPBAxeIlLkKwRjsx7iufQx
	 TCG5ScRIJPCK28YjYcoyrWZFI4rA/ZQxLJsKEiecgzYu1F8+6J2rwj/VVkaD2QxkEtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRqGqqzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5B0606A320;
	Wed, 28 Oct 2026 19:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRqGqqzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A01F01825;
	Wed, 28 Oct 2026 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215742;
	bh=FFcWD07tjqgq6uEJw6Mg7YXrreaBMR/3cLPe3gZ+Aig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRqGqqzVM+KEsG/9L38MPgnJPad5NgLJ6D/P/qmUodmFmuAzUYSGN2fw+VHibryN4
	 emoW1sQL1XyiF3xSQKCqzP9GaPIFBoM0Tah7+74LEDNwYI2QTJND/5W8/X97PUpQgq
	 E2AQ+tw/OxNXvmEFYt6acdIjI1DLkNNz7vg/cHjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1315/1887] drm/amdgpu: reject oversized IBs with per-ring packet limits
Date: Wed, 28 Oct 2026 17:56:51 +0100
Message-ID: <20261028170529.352324127@linuxfoundation.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit fd37f9dd5b5ab70a46fa7bc76623c0528d602b27 ]

On GFX rings, amdgpu_cs_p2_ib() passed user-supplied ib_bytes through
to ib->length_dw without a limit, while ring_emit_ib() encodes length
into packet fields. Oversized values can corrupt adjacent control bits
and destabilize command submission.

Add a per-ring IB packet size limit helper and reject command
submissions exceeding the corresponding dword limit before IB
allocation. Use the documented 20-bit limit for GFX/compute/SDMA/VPE,
and apply the MM fallback limit for other ring types.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7f48fa2cf62e3fa6c9c3870aa74988f773247e52)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index e63a71506871d..a9e046576f7ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -39,6 +39,25 @@
 #include "amdgpu_gem.h"
 #include "amdgpu_ras.h"
 
+/*
+ * Maximum IB length (dwords) for rings whose emit_ib packet format
+ * documents a 20-bit size field.
+ */
+#define AMDGPU_GFX_SDMA_IB_PACKET_SIZE_MAX_DW	0xFFFFF
+#define AMDGPU_MM_IB_PACKET_SIZE_MAX_DW	0x7FFFF0
+
+static u32 amdgpu_cs_ib_packet_size_max_dw(enum amdgpu_ring_type type)
+{
+	switch (type) {
+	case AMDGPU_RING_TYPE_GFX:
+	case AMDGPU_RING_TYPE_COMPUTE:
+	case AMDGPU_RING_TYPE_SDMA:
+		return AMDGPU_GFX_SDMA_IB_PACKET_SIZE_MAX_DW;
+	default:
+		return AMDGPU_MM_IB_PACKET_SIZE_MAX_DW;
+	}
+}
+
 static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p,
 				 struct amdgpu_device *adev,
 				 struct drm_file *filp,
@@ -343,7 +362,6 @@ static int amdgpu_cs_p2_ib(struct amdgpu_cs_parser *p,
 
 	job = p->jobs[r];
 	ring = amdgpu_job_ring(job);
-	ib = &job->ibs[job->num_ibs++];
 
 	/* MM engine doesn't support user fences */
 	if (p->uf_entry.tv.bo && ring->funcs->no_user_fence)
@@ -362,6 +380,12 @@ static int amdgpu_cs_p2_ib(struct amdgpu_cs_parser *p,
 			return -EINVAL;
 	}
 
+	if (chunk_ib->ib_bytes / 4 >
+	    amdgpu_cs_ib_packet_size_max_dw(ring->funcs->type))
+		return -EINVAL;
+
+	ib = &job->ibs[job->num_ibs++];
+
 	if (chunk_ib->flags & AMDGPU_IB_FLAG_PREAMBLE)
 		job->preamble_status |= AMDGPU_PREAMBLE_IB_PRESENT;
 
-- 
2.53.0



