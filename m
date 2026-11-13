Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590444;
	b=uiCSyhNnvM+/9a1W+aUlZFOZcj5C5cs5G2GwWMBnrEdMvt5xDZ586EqI8hbEZ8IxnUDc
	 zTX7k+Dgzn5u3i0YwDWpOSHWII3bNrPpRR9pRbCdOzZBkKTjXuk7DduTF45Q4X5RnCR64
	 Pp7/84kqlSRAzear7/u5ECF+C8VIwIpVIYDf3AfoUYoPC/0UGMRyg27G54cvqhxw0iEwv
	 /oR7H7Kvje82pCWaOmnFcdqfWOKSEiKX6p05qck09ouKuansLabrl61AA/rG7I4LvcSWd
	 1YyWSino7T5VABxyyM6TTeXOTpM0CQPIPZL3a8hSiF7mrQAIaKdRPFp92JkxCd0NkSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Br6sZmJpyaviRSGyS30qFD70q+te0FlRR4oQYUUkr8=;
	b=BmaNnw3VembxCbArBbw8dS4u4CwygzLX4CAkxtPll/nzfVu7BZl2sT2ztPr/hZgGZoUe
	 2PzBi8TMSpIohIsGi3IVGR/ubFaLeJUNMm9J7onG/fsX4kDe56vOhDv6LwdfQl/Mdlii7
	 /6D93mSUhOj9RfFqTQt6tkxvHeNOFLjtVaJo40YoatUu1zd/NrYQLRk8xUPG0MnLijg2J
	 HRwo3j75B3aflkfWqHrsJNous+/NkoONq4WPItLFuwFO3fVKgGpf09wRyzsc1r5Ch51VG
	 6dFN2nj0V874pon49HZt/5vDv+A0jDl+fQR6Uu+rHO6rNm8cr09Wqj89wq7nGhMgsew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqXaPJxq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14790606E675;
	Fri, 13 Nov 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqXaPJxq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CE61F000C6;
	Fri, 13 Nov 2026 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590443;
	bh=0Br6sZmJpyaviRSGyS30qFD70q+te0FlRR4oQYUUkr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqXaPJxqzosyXLPgekPqgtio37gSPZjJ9WHS8q0yyDhCnIspYDOGtibx8iBoMfWRO
	 rqhyowuv2G9APejRIMnxFkdEMm92m9p/EWNVKVr74fhajT/MlWpr+vXMzg2PTw0ZcU
	 Oxi8r+3Hx3m7Lj/FfwEpfsHCFWZgV5jxJ/JxtVeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Dariusz Marcinkiewicz <darekm@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/686] drm/amdgpu: check amdgpu_vm_ready() in dma-buf move notify
Date: Fri, 13 Nov 2026 10:48:55 -0500
Message-ID: <20261113153834.611228619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dariusz Marcinkiewicz <darekm@google.com>

[ Upstream commit 920ca822f527e45ce084b36f3c420b625eb7c62a ]

amdgpu_dma_buf_move_notify() touches the page tables without first
calling amdgpu_vm_ready(). When a process is SIGKILLed, its VM entities
are stopped. Teardown of an imported dma-buf then tries to clear PTEs by
submitting to one of those stopped entities. That eventually hangs the
task.

Commit aa5fc4362fac ("drm/amdgpu: fix task hang from failed job
submission during process kill") added the stopped entity check in
amdgpu_vm_ready() and used it in amdgpu_cs_vm_handling(). That did not
cover a call in amdgpu_dma_buf_move_notify(), what was already mentioned
in:
https://lists.freedesktop.org/archives/amd-gfx/2025-October/133076.html

Tested by SIGKILLing a GPU workload holding imported dma-bufs. Without
the patch "Trying to push to a killed entity" errors are logged, then a
task hangs. With the patch there are no hung tasks. This was tested on a
6.18 kernel.

Fixes: aa5fc4362fac ("drm/amdgpu: fix task hang from failed job submission during process kill")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dariusz Marcinkiewicz <darekm@google.com>
Assisted-by: LLM
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bee5c9d7a34cb1b510ad3b4c18c30f9d38b0ab7d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index efa6214eee315..640f627342916 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -533,6 +533,11 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 				continue;
 		}
 
+		if (!amdgpu_vm_ready(vm)) {
+			dma_resv_unlock(resv);
+			continue;
+		}
+
 		/* Reserve fences for two SDMA page table updates */
 		r = dma_resv_reserve_fences(resv, 2);
 		if (!r)
-- 
2.53.0



