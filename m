Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C88392C27;
	Thu, 30 Jul 2026 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427597; cv=none; b=NBCkuuL/PGYIABUiNNyoz3M03h7N0uZpAexjbpNc+D+pLcQhe3hSfX3875bFZvABfcdfsKPkqYOLayeI2UVgj198jZocSYoDApiPw2UThpRdPc2AoxKXNXfJOIUAFSxXaYMFBUfOJTOAJETWdc4wRnyBJ7b4rk5UlfgPmnYYegU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427597; c=relaxed/simple;
	bh=Qn7e41pncrzzHDsKqw6/ZnuJFW02636XX3qNZxtDmRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCNK3eN6CpY9cDfP5VqBg0WVVbwecd2wid897NitbWGBqCUgmN9AesCmldoqgdRjZ1VsduqyhfKdVMMokqkBvSYSFe40TVEZkCVnAJ+BTVf0UWN3n4mUR7hByLnr7QVuiQ6GTpeLZSYwlRCoeMjfioxAZXhz4k9jqiqCD7QPynk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3RQXa9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3RQXa9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CC71F000E9;
	Thu, 30 Jul 2026 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427596;
	bh=AWI+tjK+J+UBJkufBSJI3aIyxNkFi8Qg4JU0rO3FvlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3RQXa9WMOupAKtJmgfMEMYDW+zqjiSmSi/zLK/iIZDeZhgxdw3TYKZ5s1czlICUF
	 gdmRDzjpJ7GbxKhzlN++80Ar8kZ3tQIxexNlQ4Ar3DIatDbWqpwB4Kbe5jM00iwR2Q
	 xIbByzcKpP5ekHZPhVuMfwLNrGEJOk9luYndi94w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 224/484] drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:12:01 +0200
Message-ID: <20260730141428.338771753@linuxfoundation.org>
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
@@ -520,7 +520,7 @@ static void sdma_v5_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -531,7 +531,7 @@ static void sdma_v5_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


