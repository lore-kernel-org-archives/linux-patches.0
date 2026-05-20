Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A682701C4;
	Wed, 20 May 2026 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297976; cv=none; b=N9d7tVf4tWfFDcF47eySVL1kMR7EEye1NHg4KZSjGRvaeihBG6ZK24uYlrGf/8tx+JjUMBUBA6kyW6OJOAFk9Sc+vd3p/5cPyeik6HDp0ThBjGk1QyPXZjSQVBDQ7xStnedf0poBfhMKX54dTssNgbB4ApqzTKH5R4OnY2tBtAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297976; c=relaxed/simple;
	bh=oPoXA0yr6BMBy1k4U5PZyijCn77cA49NbCOTTDwtQkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iszvk88IPGnHUWW6sbXcvXOf3Vqgl3BI3gK1zVw0+G0YikSxUMbU4Jd1qIJjE09Ifoe8fbLUIF91fO6RKOypZj5MWWmKRakk8sHV/hPd+A4yoZfv3cc1SnUm4Hw2uGmzIKmLnrGFLsfoJVuAab+4ZruNK3iyAF10xMS0h3nRc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9BPzblE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9BPzblE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9B61F000E9;
	Wed, 20 May 2026 17:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297975;
	bh=gZgobUeXYZnm+5TkKrCF8/gQaPMTpJIAUMljYDS334E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9BPzblE2DlEVcdZ2/mgOLOJe6csFeD+mOPdHEmJlxAOcPtaxi61ShBgu361GVOiP
	 MyH+W2QJMcttLih2bbFAFhUjNFIzsf09NUjRPEs3YIJBvHl1maJrUj5p6HfEdbi9iR
	 FEIBa69rXgpBc/Pbna+hpK0isYTPl8faN66SMSms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/957] drm/amdgpu/gfx10: look at the right prop for gfx queue priority
Date: Wed, 20 May 2026 18:11:58 +0200
Message-ID: <20260520162139.635745059@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 355d96cdec5c61fd83f7eb54f1a28e38809645d6 ]

Look at hqd_queue_priority rather than hqd_pipe_priority.
In practice, it didn't matter as both were always set for
kernel queues, but that will change in the future.

Fixes: b07d1d73b09e ("drm/amd/amdgpu: Enable high priority gfx queue")
Reviewed-by：Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 003bcece715eb..234753a10361f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6751,7 +6751,7 @@ static void gfx_v10_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_GFX_HQD_QUEUE_PRIORITY);
-- 
2.53.0



