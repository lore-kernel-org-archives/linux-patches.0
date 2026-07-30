Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37573E95A8;
	Thu, 30 Jul 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424482; cv=none; b=NbEHRnbsjs1XkTYXK2jn4hweMdzQ3R1FDiCMmEIkkUgwOx3Rpb9Ljjc90aPMnBFmxjFDXQ5vVwUTkJZjnpxt31ZyShjK00erzYEpqgHiyG77L69q0rhf6VfoKA0cEf65efPRRBntoMfhDpbl6V5I8nAk0Nr+hc7e2v1I5cxB5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424482; c=relaxed/simple;
	bh=7l/vzY0/dcyvKvTzEFhZdvET77bix4F09oLcI2HrgeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIIGDPMND4z56qfAN5sA55UNT204A1ZQOgjmOEyI25GyIp5LyDUkDKfRd6USe8tmLpMtN8Hyhra1WAxE1ttqSFQ1WOlEfUoTRTkjMLBMrlLpb/1II5OGCzlxOWL0j4tbu0qb0TFl1Y7c63SFb06dY2doAB3as9IF0d+9CS+C2u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ3HU6HM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ3HU6HM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423E91F000E9;
	Thu, 30 Jul 2026 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424480;
	bh=SEruJZpzQ13SKNh4LG7szBhwKlF2F2e2Arr9vHD61Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZ3HU6HMx28RPPGHZGy9zlGDp/M738XCg7R/fhsOE5bnxdZdjoN9zyoXVYCHgYHMJ
	 xdhxw4Z3jy2FJSwalCfCOWl5IOH97MdZaEr8+4h42hxaMyEe6QVPk9cigrhCGT0LLf
	 XEWSN5MGGiVyjak7xrdg6GnUMDkk6sHwF6MPUmy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 364/675] drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:34 +0200
Message-ID: <20260730141452.865548202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9e98ed3113943257ad6e5c1e6beddbdb482a70ad upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8d144a0eb09537055841af48c9e7c2d4cd48e84d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -528,7 +528,7 @@ static void sdma_v5_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -539,7 +539,7 @@ static void sdma_v5_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


