Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C438144A739;
	Thu, 30 Jul 2026 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427915; cv=none; b=WiZ5FWbZ2b79ySUbdzt2CWcTNvF8M9K4p+Z3xI5Eywc+EuQEdpxkxeyldH3WaFXq58VZ8+skJCqYVfMQJlrLKlpRR/ZAjyahlV37tXz51vUKVuS9sQ9CaRRP6BEYBDcWqWkYYZHRNGQ/cRcxQX3ox0WUmFFMenl6fv66/o1wX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427915; c=relaxed/simple;
	bh=36EmeDi3e5WBnpDorxS+4yp2xuUutI0fTaOveA+zVdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNFHD5IfuMQpWfx3xwYFC5/QazZX4Lnjgub19KJgzT+f1ZCy9pkRk6NYLTdw94et6BusGmidVe//w1QNSBksRl2Z5sCcdffB1DFsG2AXg9ZexGzC/2OjJ3HJiRAan+sUoWwFzovDm/iiiAerQRGx9Vjd05hiADkD1QsAv5y/ykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujIPfVHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujIPfVHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C41E1F000E9;
	Thu, 30 Jul 2026 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427914;
	bh=JDvqQNWQRmEPDAFO1rFnUXjtNJT3b6Ul/LJZJwc3Mts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujIPfVHm8ZN3/iuCO9wenTSmcNq3V2RIx6OQMnjJ5wrLHMbWldPcS1BjVsbvJ+pOS
	 hXiW56+PvPJo+Uu4SAxcBKDM9WQ9vOU4JvFpnr6ME/Ft0t5X72IkRFGSGmKsuyN8TI
	 ynl4aTHWNLfBCIui3KAbZ2mP0CMiWTEkVV5t5+I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 339/484] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Thu, 30 Jul 2026 16:13:56 +0200
Message-ID: <20260730141430.846567182@linuxfoundation.org>
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
@@ -6267,9 +6267,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


