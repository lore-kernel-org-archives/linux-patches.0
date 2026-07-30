Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FC7431488;
	Thu, 30 Jul 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422413; cv=none; b=Wq1jjWtrmobCpl2vogW9MTXvSKfkypxaH6RVYdvZZbnTDYY1uL4q9889LYr49Lic3ztPwBDXVsH4C7r3TVAVKNvIHWNGXbxlOh92CY6iMsIjHvuB/sGoklAuzGt47ONogaPzwVEhBkXD8HgLoql7nxmlpl31R6XLAMtOebB4+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422413; c=relaxed/simple;
	bh=KUEWw9UK/4hF9Ql5LH8EqkHBs9sHyKKDTa7feVnIc0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DATqTSeaLcW5+cyzxV5BxX7EfBqk1EPuh+5jxmHH9QmtfWG8NKHkgEmZdhlU+UngsECKwy/m/oXnnusFF8VbKVg9M1FfCNWOV8mxvguisH2hu3/zd4EBQ4DzW8maYpXWU5C4GDbIg5tdTdjnQ5sHXAoLHugNFP5fQB3p1N1jTOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWSSovps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWSSovps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351EA1F000E9;
	Thu, 30 Jul 2026 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422411;
	bh=/cG+YNgaBuaL8G29N+77r65qpP5vla0t5+btmd+gHp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWSSovpsbRmuYkIeARB7bFHTmQEj6VmqGvoxz7KiWdJBez4S9UyDCl3pbDZDzAJ3z
	 2uqRdE1nF5WDFV4mC3cg3CbqbiwnQrO+PhUlvGyYokGfVSlO84ALbk2/mHmAqXkbsi
	 4A1+Kx9xqPSurk/Fw79CclF6BYKvzHh64z9u664o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 429/744] drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:42 +0200
Message-ID: <20260730141453.415886535@linuxfoundation.org>
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
@@ -360,7 +360,7 @@ static void sdma_v6_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -371,7 +371,7 @@ static void sdma_v6_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


