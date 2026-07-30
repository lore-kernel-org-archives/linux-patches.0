Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB606453A50;
	Thu, 30 Jul 2026 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427591; cv=none; b=r2AN+5+S+8QXX4Cpx67qm2ZzMU6oyBw6S6d2qXj5cQoELz31M1GfcNSldfn6+ipQuT63UZcKCYRxQq3GpQBe3P3DftqcDLDpTrfkELgb+EzqJcJkjeOt2+c/ocZ8VQHf4J3J/GEOkgG/qGSuRobEop5jDluDV/3Hb4HyE/MqzKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427591; c=relaxed/simple;
	bh=PlIPPsi7WRkqsXYXaLUhlndSM5KzPwKfMkzE8XautEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5YSQRCXsMpwkMlepg7jTtEK+fbBbdcNH5Y7rWo3uEr6T0cFNvFoPr+NMshS4xKZp2OQdVMpFxMkc48yrnuYBvC+mgg5JE6fBMEq7W+pUTJNnfgowGUysnDXEfvuF2VJnwEUhbsDaEa/2djEEjQz7CCtMA+v8JlOQGt2smW4F4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcN3LFoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcN3LFoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126FC1F000E9;
	Thu, 30 Jul 2026 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427590;
	bh=4GdfvH1AgC0twmza7q2QHdPIYcS43Goon2aicVS/RLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcN3LFoEqsvq3KNeREfhfk5mWfMWKehdL7ZcUbcfxT3618kucFYPfpREn+ywrltMV
	 vy2PuXfq/JwK7o57wuVEe5mRyQ9AQiIY2QgIfkUTy1QWjLybSLDUc3LpsS74g8D/a+
	 42H9OTrpkXaX5+l7b4jBkXC8j4BnIF+AkGPvKKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 222/484] drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:59 +0200
Message-ID: <20260730141428.294804573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ec42c96c322e5cc48099ab5e67b5cbe236cb1949 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c17a508a7d652da3728f8bbc481bfffe96d65a87)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -343,7 +343,7 @@ static void sdma_v6_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -354,7 +354,7 @@ static void sdma_v6_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


