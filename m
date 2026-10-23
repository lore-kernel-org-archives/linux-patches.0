Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774476;
	b=cV3MdjoQN+F9zm7WI6niYqxPbFIGpIaJYMohPV0IglQNVHVXOHs/+k8gLW3k0/N4hci+
	 4AETOvQvmCjwAeGFItDe+l6134MrruAiNFTYQtjt/bJCUQPyPSu6vIulj7c0xi7sDq8Ce
	 rhencL8XIj/jjac50fDLx/dLZOw1qtcWEGRazNsSvwV0I2/XH7FMXh9s0OPrtMvaIgCPt
	 sRn6BQ7MglAPfzcDDOkAvAwSvyi1aZr5ps5ZAlyeN7jSdtzDlXfBUTTwSkFwLitS5qHjV
	 q6jjhs9ROrnt7JBnDJZ/LXlenui6sH92mYjyTvgxxufPfAE6vDy/2s9cDXoPB57JBPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9gWmsjdTGu1k6rfyVtcYEeZr8be00ngRAZNMF1Bpd0=;
	b=13+HrQ25+IoRDaMkj9LA4RxtqBIgyr8UuCAPULqF9vXbWQjMToJ71U3w94Kzdpo0vcaO
	 fBVZmWnzqFg6s/pb00dMm14YpWtQtZfKyp7LatZV/jXl1OElzyGlyOLBM6D7H8caRkfzX
	 b5ruqU58BxjLorj9gjmF1gJor+jVhQOHdvE4Q6J+lbwhkg6PUb36R3V56HtljUgjx8ZkZ
	 J7ym1GkRYaOpKhuJskvuIDEoRyMT/wSupxe4hclC2agoSTkTwrkfY9Llk4W2dzxh0xCKR
	 DfvA4nuXukBzkHXB2+LLhxEWdlMv1KiyWv69O9uJRBpSZ/2xZedCK6XxPd2Amn0ocqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjKqzdFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AC4606A31F;
	Fri, 23 Oct 2026 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjKqzdFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398E91F01825;
	Fri, 23 Oct 2026 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774475;
	bh=y9gWmsjdTGu1k6rfyVtcYEeZr8be00ngRAZNMF1Bpd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjKqzdFgPbRLVPkIlzOESaS7YZeWaxvlNcJKVUVB3gfJpiQF6my/aUAPwrumFJW9z
	 r50XWjqrMpA3Wc4ZVmjhmbFxlmLZXrBD/uqfQuD9hFhKju15VwIaHswYJJAP4Gv8E2
	 hNJafThNFFWVJzqdF6pOVg1+ccXfsAR+UHryDYJQ=
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
Subject: [PATCH 7.2 046/242] drm/xe/oa: Zero OA buffer at allocation
Date: Fri, 23 Oct 2026 18:38:08 +0200
Message-ID: <20261023163714.867585129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e5b0f3e2f3894..a25336480d302 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -914,6 +914,13 @@ static int xe_oa_alloc_oa_buffer(struct xe_oa_stream *stream, size_t size)
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
 
 	stream->oa_buffer.bounce = kmalloc(stream->oa_buffer.format->size, GFP_KERNEL);
-- 
2.53.0



