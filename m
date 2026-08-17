Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BFA3B1B4;
	Mon, 17 Aug 2026 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977164; cv=none; b=XKTaZ5V9JTBmwFF61phAbR7p4UIas8DFqjMZeE8nSw0WfFrMd0ziRmnWi2hjyIGPUb+pcRdvNto5tCytTj60P/TplMoODIRNPdlurgMroB0R0kLAlxKoWoTFBAByqTyqdMuhIkRbIOfJcP8zgVjgY9XK+B+lZ99JZam8DlyTm6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977164; c=relaxed/simple;
	bh=Z+NHKoLZKB4h5DeM3IBK+0al3c0WAxOJO7MvAf05UwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpVzQLHaKA+UGw6PYShwHvspUyYQloBRk8WCVOt7nzq4gJ33DhRuyk2Fn39cBPBM45dqQbWpzxVaaEZTzNnRUEouZcWwGDNTKsLgxWCsc2RpNvZGbI95qJU1lu9puVMTCLHlMEwAcbJkBISUtMrMjCR+SblBOwea9AekmnbfILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYFTOWb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYFTOWb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7341F00A3A;
	Mon, 17 Aug 2026 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977163;
	bh=hsaCOMgUs8wfkdOo6KXUNhYAMni8POx3viPmM0pTDHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYFTOWb6b6M122sp8GEfwxRxj7hRMhYMn/TlaVZDLmKMLsb9coMezdV+BKenbkSbR
	 gnjQVQoD/pGf4lczHbDbYhaAAuIeUqoeWcYOZWkGcrsBuz+ED/FmIjt0v7pHK2Ltc7
	 7+ozyI40aLV1I0YWnK9Mw1bhS9lzt9L8KwozAWOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 227/456] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Mon, 17 Aug 2026 15:30:17 +0200
Message-ID: <20260817132549.016141929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6301,9 +6301,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


