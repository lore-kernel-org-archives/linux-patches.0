Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8290530567C;
	Thu, 30 Jul 2026 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424958; cv=none; b=MbEigbLcaI2nRC674y5APUZmdYcUi9tuYAwDA4oqUsCaablETYTurhDjibrOnKTFtBmVMUzBJW6nqqfkP0nODCagOXTMGdnptCm8XUC1DnL6VBJMDSF1l6vHIudOrTo7xSCpbZUpXASrsHGIh+f7oGtMJBzrUmC6uIp+/FjFY8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424958; c=relaxed/simple;
	bh=NnNJEkoGBbfRfSmnnnWkjSxflJBnKhkxZNqvTw75GYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjzqZUiLVQm19YW3jGF1Hz6Z7pggadzUykmUlrO5tWmU81x05BTpkKOzHARddoZNhQ6t0JeztLBu/+whKsNBpnRQwv4/2SJje9OXTPZ2dB/aL9bufSD3+n6Ceci1fGQv/oSBIWmMUFea9G0uBc9uN5VoxqsVlQfF7PHiVnoS2WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HH00Zb7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HH00Zb7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B61F000E9;
	Thu, 30 Jul 2026 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424957;
	bh=5+k3iqwSrW3MQGm1W534PXmb6TFzVBgkU1DryhYgP44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HH00Zb7nCyIqk8LnDckzBUTfyqfTQQsUDlflLlABZMxrZn1l947Pbmo2uz2Ha4DMZ
	 vYDcoWpO2v9YrV2U8D2ZQ56CiINGpUMy+JDVFNtLmLdBuZ9Q/99cp/u8neycOAcqPf
	 gEKaZv+pD4jCf/4qY3G5hBcpXaaaIV2yj5peDDCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 576/675] drm/amdgpu/gfx9.4.3: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:15:06 +0200
Message-ID: <20260730141457.371434857@linuxfoundation.org>
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

commit 00f4050f7c367d7bdce347ca279ce467c434cf15 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5676593d08998d7a6d9e2d51d6b54b3820e3755c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -405,7 +405,7 @@ static void gfx_v9_4_3_wait_reg_mem(stru
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -2871,7 +2871,7 @@ static void gfx_v9_4_3_ring_emit_ib_comp
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -2905,9 +2905,9 @@ static void gfx_v9_4_3_ring_emit_fence(s
 	 * aligned if only send 32bit data low (discard data high)
 	 */
 	if (write64bit)
-		BUG_ON(addr & 0x7);
+		WARN_ON(addr & 0x7);
 	else
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -2967,9 +2967,6 @@ static void gfx_v9_4_3_ring_emit_fence_k
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


