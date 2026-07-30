Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BD43DA3C;
	Thu, 30 Jul 2026 14:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422407; cv=none; b=edkHpJKOka2YXx7kU+S1IUvjWF9Yqr1OA3lZnONquw0e/pV++4N/xFLHm8Chq67cM2RHKIG4gJSeChtO7OcscFihpk1uI9/vfzzMwkMiWte7KB8loq/YZo+E4iar/2s1xGdJw80TTNww+HP6WCS0gjkiqWlZL4YvTyQda3uG3EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422407; c=relaxed/simple;
	bh=P3xLY72mozS0YJzSOeQLwcNLJ5XgnsJC9bFuoOr+l40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC1RFyJmqfhbj0fRCJeClDsXP0b4g8NAlnFBhAgQrJJ/QAJ7ChfhK+0MXjNmmatMwo/sdUccHKejoT7CJM7Ml5XGLDskj1Pi2WHNbAdJgCEEU/EiXkafQS1mmLTArUlsVumYsQvVtv4TSzoREXdB+szeubkK9qbYQ+1YOcK75W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwAM5H2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwAM5H2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF8A1F000E9;
	Thu, 30 Jul 2026 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422406;
	bh=/9/6MLXEr2Hk0rXcqF0cUFaXLpxlRmexyxCyBp6gEac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwAM5H2sOPTVg8PDpDXxv14lB0TlXHYMndj01OHQTa/cGwUzWDebaDUHpeppq9+Cq
	 UgzFtPgt+g9yqP3oKUrDNgbdNNiEcNYH3dkLP2D1JJGAMd+XddjY1ldctq1C5VkBxz
	 KwUuDV6X1vYY75Ksen8YZzBxsg1rmzSGzoEpHves=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 428/744] drm/amdgpu/sdma7.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:41 +0200
Message-ID: <20260730141453.394712044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -363,7 +363,7 @@ static void sdma_v7_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -374,7 +374,7 @@ static void sdma_v7_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


