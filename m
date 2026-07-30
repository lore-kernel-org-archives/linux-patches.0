Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B60270545;
	Thu, 30 Jul 2026 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426090; cv=none; b=hYzJAu/McEGD+GxK3zeAG8tJP1SnUOKnagjNLS5cVzv5A+6oM6VSQp8T1g+2UHT4hpAvc6oGjzCbV13aIhwQAHkq3hoWY2w3cJ7HRNsvI0plV+Sm9hZaeRJ9YqjzxLYVKeMjnJA6iaP7traME/cle+bjG7TcQEdyCOiSHtE3z3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426090; c=relaxed/simple;
	bh=ox8TZ90O6dVbEHBofu7zuSLKaBMd73yvEhDEV2pzSG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBVQaJPrN2Uz7IPpeK0kDdn/dP20Jh43SPMJc9Z9ayYMyS+Mmn6nk1WiEPGEr9nTaeiG87xrrk5ME1BsQ4UGM4HQ4Jfzl91V0FI9OKQ50z7Bgpk7YDNMfLM07lBjBvh6HdMsm+ktFM3KNu2EYRVW5R1w3PUvsvo0R4Nfi7/XU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIGrlMIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIGrlMIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3311F000E9;
	Thu, 30 Jul 2026 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426089;
	bh=OMiSnfp7KvXYUkSnGREqc0++V/f/lV1hFao0fQIAKz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIGrlMIJ8ehg/bwy2lI3Ft25Np1pujAOD2ymh5z7tHMyGZKYWoNnP6mFHcBJczk7B
	 6T0SREaCAiixupOptzPIUT2v2nwaWG+itsT4ZmL0VBkYkw0/LbUU+54TcAXGVWmwuY
	 5/9cRg8jfYye+5GnaSRh7BvZSp+7vqBSfXvoigB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 280/602] drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:12 +0200
Message-ID: <20260730141441.855617276@linuxfoundation.org>
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
@@ -357,7 +357,7 @@ static void sdma_v6_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -368,7 +368,7 @@ static void sdma_v6_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


