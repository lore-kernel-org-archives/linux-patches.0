Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8EC33438F;
	Thu, 30 Jul 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426153; cv=none; b=fVt7eiejnBiiSk3oY29OgxPOIxh/QrFgTjraoc9avy3ktUs6bDgZaKVBkWf4wxlDSsrzMuEDpDwXi2YyAMxVfQPcyRn5HXE++PCzKbnziLgaEh+psY4CX/1wg454oTkZvxHkg/h3nDIAjy34Dzvj7CbwOjDs/L7pAxPnLXSHcyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426153; c=relaxed/simple;
	bh=//tdXQafjrCtsAuaJgogWdzFzpPZA30T1tsU4D07a9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej8AKEJGCf3jsTvjCxvdeubPGI7Mk08/pPVQ7cFZZfjyiwi3kZp5eaLTWOLxp17XqhZn9HQ0E+yQSo05ddC9lL3dJGsyEAfKkhESOaIytXIXzfNF6fq5BU+nip5uOENvcQJQbb8r2gNQ9aVYNtET8QhL90zYNcKqb3p603XDQeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw/oNhG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw/oNhG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2B71F000E9;
	Thu, 30 Jul 2026 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426152;
	bh=x2UkGzU2dfzg7KJPHWnZgXHnAfM2UEEKSN2L+P7NGLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yw/oNhG/tL2c6A+XE9P3M2UWZp+8cGmnVJdeih9QMHMENrVLjFUs1nv6g9/t9lP/k
	 lco/CUhiewfEzNfh6eqqQSnv/hW0wqNh/DuW9EDVBuHdWM3LExKl6t8Mh6cS/z3Fy+
	 8emgYJUv1smLxqurZK6MV6D36ksQuYgIIivPi/qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 282/602] drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:14 +0200
Message-ID: <20260730141441.896624116@linuxfoundation.org>
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
@@ -557,7 +557,7 @@ static void sdma_v5_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -568,7 +568,7 @@ static void sdma_v5_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


