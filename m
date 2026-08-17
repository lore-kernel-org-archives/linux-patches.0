Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4E5303C97;
	Mon, 17 Aug 2026 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975663; cv=none; b=Dg5swZNB8Qe9DhVbWwfshgtD8PxY3KBnBfgyiUKLVDO+8M9712Uq35tY1pfqmHkYOm+YXgSDZvZim3yjliqjbJHYmswkhVjba3X3luim6FGnZW2ej4AOpqgeakau8P7QyHiizswTN/UlA4O8zY+UCpbQE1H8LTW2jfoL2CZ7HFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975663; c=relaxed/simple;
	bh=qfF9kVJ1xIll8U+VIlzPQO3n9Ee7odGTsNm30jfBp98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5OrBbm9CvcaYQFJUry5xu/cWWw8o71qSvYPaOtfbiZbnIQCx7sFGpuECEu3t6ffj8FxVVC0osd33NBSoi6w31BQvsAznIgz8HW3Bdq9QmtKG/C6w+ltL1AnZAgX2PCs4w4sIwYrDwXyvqUz2mirdiYLbHAC22JrgIM3sNhUms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdsWMyXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdsWMyXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9121F000E9;
	Mon, 17 Aug 2026 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975662;
	bh=q8oBLSdn/4iPpRvjIboPotbBG8Hn2/5Wo4COkwmKt8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdsWMyXOJQ1Xbi4hNybuJuR1pR6W7bI67y1Sp36VGXvRWDZtrSl89zqmRzbVgkC5h
	 Ems5bFSVofT0SkIlCn3tSkjq/dyLENpa+pJ7Iskuj3iKnOHwmZAx0hxOYZHPDu4G9k
	 p0Th1mdzuzJwllnmitq7P4cArEayDl93Pue0ezeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 104/389] drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:29:03 +0200
Message-ID: <20260817132543.219276415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -487,7 +487,7 @@ static void sdma_v5_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -498,7 +498,7 @@ static void sdma_v5_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


