Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3793769FD;
	Thu, 30 Jul 2026 15:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426506; cv=none; b=WZDM6+TY2Vy8kQEroCBMLZj3ucu7b0sVdpPHFQ/6mT6qG30CPzw7tADfslAIV3gg2UBrm75twY/Ne6GbthkzgDCpN/heMwAtkoEzyIh4rBXPIwzzjBHyIJFv62sKMaPoOaCB7hYgUZ0mWX2V8h9crikiliuHU9+0gvWMNc+Qy1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426506; c=relaxed/simple;
	bh=wJ2bzE1FlwpIS4u8reG6iTTRGhb6LkGFLLf6wd15f/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3lQTmgvGbNUxh9IxIYs15E08rqGeOT2X3uep+Hv5zel8RMSlNOa3SYoH/CS8ygOZKi3kNXWLUDQ9BJOpFuPPcNqXzzsB5NE2VlFiwbXyj0ubJEuwDVlFDofDjvokzoLjV2w7GEhJxzTMw5XxMXncUPdRVDwc/DVfG7wJ8aM0Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dI1mPl9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dI1mPl9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DB91F000E9;
	Thu, 30 Jul 2026 15:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426504;
	bh=vaizbCCWoUsLw3JYFXbFzyt3eIsZQBxnNjYq7IgdivY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dI1mPl9c7QLoif5azT5z5bvXYK+UwjDgloel8lyLuX450WrTpc8J/0iclqIwBrOJB
	 HBExMrNrRxKLzzfcORfWxevOx9hx9iMemcBzGAOPEBr72aURwoFFC4YDzReBgYG0dU
	 WrqQEHTm8SGOLFeB5NxDu/VHZl0PBG7+LjaYdqV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 443/602] drm/amdgpu/sdma4.4.2: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:13:55 +0200
Message-ID: <20260730141445.272394235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 40cdbe9fa424cc6264a7aed93a04bd7d69109d9e upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fa4f86a148271e325e95287630a3a15a9cd35fdc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -450,7 +450,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -460,7 +460,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 		addr += 4;
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


