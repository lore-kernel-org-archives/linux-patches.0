Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B69730567C;
	Thu, 30 Jul 2026 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424955; cv=none; b=R7Bm39F/CeG4aAlbk4AGB8JaYlXT2BwYjt2AwBI0Z0YCnyoB8zlm5/HHFw52t1xHWkWCMFb0cwYrUAuDA9SKuLKSHl7SUVcyoLfOC50OW/FSEPx++OK+QVUk1cDRdmNvV3GAkOfRyo98DyQ1AzzIK6g8CAHkwR3CF1QM3AV8OvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424955; c=relaxed/simple;
	bh=P5vDeMjcAkzqYkyj1DNpSO8pkwXY5qQTwU+vqPMmXAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGUL9tcPjYV6nOAQGLiA2ch25/OIu5Rnt5p6zPaDnq3WDReMCFXYje+j+PwfpY+jb8HojRyP/ziKzSQs1l6+Vh11JhNSBQjYExlxdRGy+wYkzwDKisBczFAfUSwq56NshXlZwF5RPL4d2012c7KGFk9H5wBygDdE4uAeetRcTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgEoKsui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgEoKsui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F601F000E9;
	Thu, 30 Jul 2026 15:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424954;
	bh=54jqT1yrLRWLzSaOKxbwkDHX+QY6k1pNIXZ+YREPa88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgEoKsuiuhglc5KOPLWSeKnKnDqXVlu6UY9ovP7jGDzu+nJfTsZD7KUS2hka0+UPO
	 QViF2iYSt9GvAz70Sgb7kUOhoMCC67HGiZ/OJ0fI7hHbNUYyflFC5Br00UarVETB1I
	 X0KYdEI3VvIimXNaPcu2iN+yx6zCkc9gf0oz+eWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 575/675] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Thu, 30 Jul 2026 16:15:05 +0200
Message-ID: <20260730141457.350126204@linuxfoundation.org>
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

commit 84a1a8a952ab4b8c23c5dd1f2eea4049cb4914f5 upstream.

There's no need to crash the kernel for this case.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7c25208ca612b754f3bf39e9f16e725b828891)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -6226,9 +6226,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


