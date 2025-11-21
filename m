Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61D131158A;
	Fri, 21 Nov 2025 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730914; cv=none; b=hu/msPTPsFPI96n2HzAlovR0RpJKU/gwbXEamwlwfbM7CkNEgSM/XuWpUXioHoq2BP/XMZz15m13DQejH7Ta9N9C78R+GaQGbJ88LubOltedG5do4yqoSq7gvdo0REKYavmWbv88+dmk3fkKs3wN67yqHZV/WXgrGXN/TQ2KY3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730914; c=relaxed/simple;
	bh=4APoSwc0nvA3QTCqza9bwK666n2gKRXN562+v4t3iYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+eQIkUto+KvSalSF9mfrATnq3JFXzRVdk3MGEV3K71HlX+SbAdXa9Ej0yaxNfdhJcD38gLc6cYFzTvWlzcMRpZ+xnv9p5IWDue0OLo8rfFl+WDdbPC2i08k8ELd6Ip0n/ApdtaCSNMOFI2CbRAw+25q7BnrdI694A916iBa57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNixHlmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNixHlmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385E6C4CEF1;
	Fri, 21 Nov 2025 13:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730913;
	bh=4APoSwc0nvA3QTCqza9bwK666n2gKRXN562+v4t3iYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNixHlmQY6cw1ZVjZV2At+RO8IJ11ZLgnzr4CFLg5RJajDw6ImWRUbs+utHHEPCya
	 hhRNsvFY8YLyQwRPVmdwN00HCPVU7JAFR/Bi8Tno/2qZhIPfIeGVINBNXBelH+G42P
	 Oi6uzudF9+YDVSOzWb4riziQWegDnXM0Q1s5lSYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 026/247] drm/amdgpu: remove two invalid BUG_ON()s
Date: Fri, 21 Nov 2025 14:09:33 +0100
Message-ID: <20251121130155.543145417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 5d55ed19d4190d2c210ac05ac7a53f800a8c6fe5 ]

Those can be triggered trivially by userspace.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 --
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c37527704d433..25a5f7fa5077d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5864,8 +5864,6 @@ static void gfx_v11_0_ring_emit_ib_gfx(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);
-
 	header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
 
 	control |= ib->length_dw | (vmid << 24);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index fd44d5503e282..329632388b43e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -4421,8 +4421,6 @@ static void gfx_v12_0_ring_emit_ib_gfx(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);
-
 	header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
 
 	control |= ib->length_dw | (vmid << 24);
-- 
2.51.0



