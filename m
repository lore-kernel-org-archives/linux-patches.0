Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773884;
	b=N/ttzI6MXUbYvKR8pFvCNroCX/xG7TQ/uXqUX0V6+g50Svv4UfCU32lxsK2mCxzk1vIs
	 lmMdTk5dJ9monqo9H3th4t5qX2cu/kxoatX/AhAiW4WUs83RHFxI2ImUbi+sqcHmyJT8c
	 kOaZ+KPgUs7m0kLbOowCWS74a9ZqMTSLNK8FyAfjrl1MGLThgRHIFy6qqIioGNixHzS88
	 5XAnnFaJLfFvZOmo6ywP57w/8LNLKRSpijetC6q4th+tGn43SKaFTbtdpsl3xAtGTAWSu
	 ol6TjFLUxFTgqcy5QiSmUgZQqGT56nI1iz3STtPxu4VlByfLm/Ol/FS4yLnsGgNHNMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8PWJgymDzzViirqo573X34eppIWA6sbEcO64Ew1ruXI=;
	b=PZ80cGUa8qCemTBl4tZyfNuF3V4fyCcJUCLl2KhCGvodHFHmORYr0rK5gLxZVNA100lm
	 coh34kI0cllG2wDQdVue2O+pf4VaH504DH3UDz7iaX+YIyG54Q/j4dU7Vh8MQQFAD/8fA
	 vhCZMxgYBXdDyKo75G6GhQpOJ+Aj5pTIe7Ng9J309/HgfW5IyWHSVHGOfHKZnv1hjS/Vd
	 1jWTjgH1ppq2U73CVTsjPgik/VIjWlcvdPQB+tbv8dj2aXBvQ8LoyZqCc/H1gaEBP48oS
	 dndM2pErfLDg4G6RYYb89kDP3ElLMYF6hmo0N3LOgNa2qNy2cClrQOD92y/vcebAxjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r9dlFMAw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4B1606A31D;
	Fri, 23 Oct 2026 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r9dlFMAw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC491F01825;
	Fri, 23 Oct 2026 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773883;
	bh=8PWJgymDzzViirqo573X34eppIWA6sbEcO64Ew1ruXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9dlFMAwa8NGvRB19nrmnfoGumFedSBIgKkMWCTRgp4qQd0im3XGqAvvNukTHCCL4
	 YIGKRzupu4hnjg/ZNY/yb5/LIaCGFo7EhQyaf1IU0dkDM3aImOJShqyEwkn2I1OdhL
	 n+TizkLPfJP2+lN5I8wWiQ3MMC5MGMiPwWib1EL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	"Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>,
	Bommu Krishnaiah <krishnaiah.bommu@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/193] drm/xe/oa: Zero OA buffer at allocation
Date: Fri, 23 Oct 2026 18:35:24 +0200
Message-ID: <20261023163715.322593443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Bommu Krishnaiah <krishnaiah.bommu@intel.com>

[ Upstream commit fd8662823caa114a63f07222d2aa448f6ac5e864 ]

ttm_bo_type_kernel BOs are not guaranteed to be zeroed on allocation and
may contain data from previously freed pages. Since the OA buffer is
mmap'able by userspace, this can expose stale kernel memory contents.

Streams opened with DRM_XE_OA_PROPERTY_OA_DISABLED allocate the OA
buffer without calling xe_oa_init_oa_buffer(). Zero the buffer at
allocation to prevent information disclosure through mmap.

The existing zeroing in xe_oa_init_oa_buffer() remains necessary for
zero report-id/timestamp detection on enable/re-enable.

Fixes: 392bf22238ff ("drm/xe/oa/uapi: OA buffer mmap")
Assisted-by: LLM
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Ghimiray, Himal Prasad <himal.prasad.ghimiray@intel.com>
Signed-off-by: Bommu Krishnaiah <krishnaiah.bommu@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20261006020314.2711762-1-krishnaiah.bommu@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 126c4c5388f9311a390b9b254a835b0cf0f55331)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index a753ac7ecc860..b88d3d39aea66 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -893,6 +893,13 @@ static int xe_oa_alloc_oa_buffer(struct xe_oa_stream *stream, size_t size)
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
+	/*
+	 * ttm_bo_type_kernel BOs are not zeroed on allocation, so the buffer can
+	 * hold stale data from previously freed pages. Since the OA buffer is
+	 * mmap'able by userspace, clear it here to avoid leaking kernel memory.
+	 */
+	xe_map_memset(stream->oa->xe, &bo->vmap, 0, 0, xe_bo_size(bo));
+
 	stream->oa_buffer.bo = bo;
 	/* mmap implementation requires OA buffer to be in system memory */
 	xe_assert(stream->oa->xe, bo->vmap.is_iomem == 0);
-- 
2.53.0



