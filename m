Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4FB12C534;
	Tue, 30 Apr 2024 10:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474497; cv=none; b=d8Ot4+Lzaip5kzpetTNq1q+e7Xj3P+SX9N/EmoCzlbsh53GrKjT7up7NWIYVCf/afSdrB1sIwMH8SKHVdr7C4XTWZZIT/6kTAANl3mZIbTmu2Ca+MrnZMVC+mLptpZGmK1ZuW8F2ceuJB/B78GjAiM4+saU/kI9zxLw5enG9n6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474497; c=relaxed/simple;
	bh=uTJifPHfV058eN2oAFaprSp7y4DQM7N8tkUZW0C1AEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2DAiQK+Hw7dR5ib1Ks8y2/s97jvsUlGfNqGKDjbIvSu6l1H0mY8FES7Wz2XEyeZ8CzgQCCAP9id8TTI/GOfKbDZMawsR2LLQ0UxWPELUk97ebenTl4SKzevc5I2D9dZMJYsPVOiQO7FKF+IkfV5B4Arxx+H29J/HdgAr+VwL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erINjGZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erINjGZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BC8C2BBFC;
	Tue, 30 Apr 2024 10:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474497;
	bh=uTJifPHfV058eN2oAFaprSp7y4DQM7N8tkUZW0C1AEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erINjGZJioL2+KZ9JWG5OhFGkB3+vtokUOmlMvYI9PLiEEN43/pbQJK3Dk4YzUs9f
	 cgSqq6HCP8kpIQ+cq8GZZdjKqDB7Wo0v0bJyMTUITOJiIJqNtCjJxEI5pGwBMcObB4
	 kBkB/X1Tr4dT/5BW9XIB/lNJ+yxaNtKjHx3GIlaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 174/228] drm/amdgpu: Assign correct bits for SDMA HDP flush
Date: Tue, 30 Apr 2024 12:39:12 +0200
Message-ID: <20240430103108.823622771@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit aebd3eb9d3ae017e6260043f6bcace2f5ef60694 upstream.

HDP Flush request bit can be kept unique per AID, and doesn't need to be
unique SOC-wide. Assign only bits 10-13 for SDMA v4.4.2.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -366,7 +366,8 @@ static void sdma_v4_4_2_ring_emit_hdp_fl
 	u32 ref_and_mask = 0;
 	const struct nbio_hdp_flush_reg *nbio_hf_reg = adev->nbio.hdp_flush_reg;
 
-	ref_and_mask = nbio_hf_reg->ref_and_mask_sdma0 << ring->me;
+	ref_and_mask = nbio_hf_reg->ref_and_mask_sdma0
+		       << (ring->me % adev->sdma.num_inst_per_aid);
 
 	sdma_v4_4_2_wait_reg_mem(ring, 0, 1,
 			       adev->nbio.funcs->get_hdp_flush_done_offset(adev),


