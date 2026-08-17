Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5E3CCFC3;
	Mon, 17 Aug 2026 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979301; cv=none; b=uuemwDAR+4+KXzNUuVbWpOKwiIFcWWbCUjXBKcSGJN4Do+CrMb9m3uixOT0782uddEXIVRNc12ti2WZVF8uelxBvWRxqhlNSwZlNsWq6F5Gr4S97tu1mob0JZDdBrvhagplMgsET6K17JPjZjCU0b6rVgihi4hjiOUQeZMzI4K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979301; c=relaxed/simple;
	bh=n66Q9bOkEGo1WpHGQZJjfrmkLwFCCheHFySMK2Rqhck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcpCG1nrPhSUzmC3F9SRPj6lXhT+8UF/wBj/PyxME3+KX3OwZ4CuYO0jTZ8c0wcA3A9G/KFJT7sH7A4PF7CZ+vHiSRMoFgldLe7atitJVnnb9oop/KQ1y+9t9iujFjV93pmXxr3YrPHv+A1LHMHr4HL9ZwiYv2gSusEOpxi8PRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHu/35BJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHu/35BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6461F00A3D;
	Mon, 17 Aug 2026 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979300;
	bh=vN6VoH+gQpjG9DZwGTbWJr4gF6QaNg4/CgRJ2TyNYvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHu/35BJHXVgU6EsJZMTP6OJFS7O+ixzjso06PvecCHRFKhf02dP++zv+wqmMaFlV
	 azAhfz3mQuxljHjps8fWgmbYaaYJo52DQe2rma7vBBgGsQg0vV1To0X9aKeP3ngN4D
	 cVCDYFCxjEhdADkljqGYssl3mjlVmXq7UxKnWBsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 178/609] drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:27:54 +0200
Message-ID: <20260817132550.028672947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -363,7 +363,7 @@ static void sdma_v6_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -374,7 +374,7 @@ static void sdma_v6_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


