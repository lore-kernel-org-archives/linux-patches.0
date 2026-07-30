Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3055C35DA67;
	Thu, 30 Jul 2026 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426059; cv=none; b=AmbgJLvWUf7EF/jy8PkVOX7N9Gz2cK9tgvy4vHIFWjcud9RNNuw+qkq5DzipbT5UZrUw12a61OW8mwPu00BDGRIoNRnmoCkXaDNk8g0+rDne4u/hY93D1ttmsF7Xr/f5Ue8ZD4xs6xJxKaqrv5PVRRmCWD5gSZoNyIeHI0ycilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426059; c=relaxed/simple;
	bh=41AGFP427wLyqX7DR9PWZwVOBbCsNO3DhzwsTMwQK18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDw9zipj5uvk+5qcBhUHC6vTczbI8Hul4MceSGdkDIefbIVI2eWdosKkNYaO7ekFFk9xsW31jVlZk24tiY0i5b9FdoMaiTYie4oylV2IAxOhKI81u7fV3B7N57p6LHYUx0+pMBqDEaX9KBEkJnmW8CmXsk6DTyvdN0sJ2YwtiXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YldekyPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YldekyPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E521F000E9;
	Thu, 30 Jul 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426058;
	bh=YkFLUZ4K/izAK8ll3lapTcAXZw9UigrtypycoRePfhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YldekyPL6Xi80SEhMSib/CiyauhRik8UPKS69SU+YCbhgZkPCIGpFlRiR6Ojtz0Nn
	 M8naXKfmZgh9lFS6ICBUmlX2/s8Nia3RNcr7OZpEIIZKUnqe2AhdFkQptk1hN2cslZ
	 tDoICUjMKR3lyfey65Ie6rWTZeurP1IUj8xShlbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 279/602] drm/amdgpu/sdma7.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:11 +0200
Message-ID: <20260730141441.835200492@linuxfoundation.org>
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

commit e80e28f398f5d9f6e361ffb56382d2e74fc87556 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9723a8bed3aa251a26bee4583bac9d8fb064dd44)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -389,7 +389,7 @@ static void sdma_v7_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -400,7 +400,7 @@ static void sdma_v7_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


