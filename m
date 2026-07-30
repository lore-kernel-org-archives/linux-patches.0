Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0D12D7393;
	Thu, 30 Jul 2026 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423212; cv=none; b=bboXMh2c2XrgMc4tk3O/xr4uLaFCklUkeybbccRdFOAKqb3oK+Uh/4Unfpv0vWIC6mxiKq9IDifRzs3jsYVDjM80CYU4HcHwsMwvBJ/kgplaSvxILyKA6YLu0hWIQTrguzbtbe95raAgQNtIpcBjuki6pqqB2JpPzSjg4vMiaR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423212; c=relaxed/simple;
	bh=3yFTygoByeC1cJbfcWo9ii5Ya+2sduKLZKnaOVBT0nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwrVBCLwtotkRmFCFWA0F9EZbNWUMZKu4N/GB5MaqAuE6biMYRxZNn6qTANhAcT9gldV3ZGkswpZmqVDK6j7Fl1VR1kcOlTkwbQu2OFwQN//A+AVl/+UHcWOBk6ooThOWPQv2sL/2wXWYIUllBFEkkR7KvWRSEDSlHgRUwef2n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9Iv/upL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9Iv/upL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B201F000E9;
	Thu, 30 Jul 2026 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423210;
	bh=J89CNBZGRXtJiLy2Wd27G34QOT7LVe6Zbc9tY9W6rC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9Iv/upLL7on9t+nBdH/6cbUGKdtjSNrdS38FxlOjPzYwWSMbKUEGfQJExTtlaNsa
	 gc37556strfomjd6kroDkAph7tsd2JBMpyIX6Le13W4ycGXFHyFWP+aocycOTApnCC
	 L/Na5cEZO42S5q8ArldMmoA6V9+OrBwOfPkvx/Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 706/744] drm/amdgpu/sdma4.4.2: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:16:19 +0200
Message-ID: <20260730141459.282933386@linuxfoundation.org>
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
@@ -457,7 +457,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -467,7 +467,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 		addr += 4;
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


