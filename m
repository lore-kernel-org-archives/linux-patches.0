Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE1C4315A;
	Sun,  7 Sep 2025 20:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277803; cv=none; b=mGzwvq4KVlB/Jg7ZRYTPuCarhNAZRiXsjr09hq6TzQIoZfXVviwqilQyDGYedE0dgsF3svyfka0DHM3TMOye7t4eYY6fWu21FvkyqsZVNxdRgB6bKo8l2Fn3vJCKo/I2sYZi2SuVcjO9smfy1TuhFda43Oq3Zg+WDphM4vXGr40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277803; c=relaxed/simple;
	bh=d3FnGpuZ2Fe2NBC3VQGarTpVYvGciAq+1mFGv26oVMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF3K4qlPMHs7OCvgQkATGw7y2nosKO2r8Ik+VhNOL+E3rs3bGi5RKS4joy6PVr3LSnho13DoQfpindbA6i1X4DHCbN3l+2dVJj3omWdFSfuMtjcadR+0VjyU1OdQMFSvcCbMzNdIIN6moQYGD2BeNB4OP/UEI9cBDE4IsuZc90c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSnN8wKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSnN8wKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CF3C4CEF0;
	Sun,  7 Sep 2025 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277803;
	bh=d3FnGpuZ2Fe2NBC3VQGarTpVYvGciAq+1mFGv26oVMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSnN8wKbqG6a7VoUCdbQt9ScH7l85NWr9NOzYvjNOTbMQgvzrXrudG1hXBHd45p3O
	 PUztklgTCTQSdNBqTB5HwAc5otChw2OzAjHSfJysjvb58QIr4uF30/3LXA2Y+i1iv4
	 KlSuohn9q0YeM5ZpieF5Nhy1BPw1rK0DYElj1eXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 6.16 129/183] drm/amdgpu/sdma: bump firmware version checks for user queue support
Date: Sun,  7 Sep 2025 21:59:16 +0200
Message-ID: <20250907195618.858323301@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

commit 2d41a4bfee6e9941ff19728c691ab00d19cf882a upstream.

Using the previous firmware could lead to problems with
PROTECTED_FENCE_SIGNAL commands, specifically causing register
conflicts between MCU_DBG0 and MCU_DBG1.

The updated firmware versions ensure proper alignment
and unification of the SDMA_SUBOP_PROTECTED_FENCE_SIGNAL value with SDMA 7.x,
resolving these hardware coordination issues

Fixes: e8cca30d8b34 ("drm/amdgpu/sdma6: add ucode version checks for userq support")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit aab8b689aded255425db3d80c0030d1ba02fe2ef)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -1376,15 +1376,15 @@ static int sdma_v6_0_sw_init(struct amdg
 
 	switch (amdgpu_ip_version(adev, SDMA0_HWIP, 0)) {
 	case IP_VERSION(6, 0, 0):
-		if ((adev->sdma.instance[0].fw_version >= 24) && !adev->sdma.disable_uq)
+		if ((adev->sdma.instance[0].fw_version >= 27) && !adev->sdma.disable_uq)
 			adev->userq_funcs[AMDGPU_HW_IP_DMA] = &userq_mes_funcs;
 		break;
 	case IP_VERSION(6, 0, 2):
-		if ((adev->sdma.instance[0].fw_version >= 21) && !adev->sdma.disable_uq)
+		if ((adev->sdma.instance[0].fw_version >= 23) && !adev->sdma.disable_uq)
 			adev->userq_funcs[AMDGPU_HW_IP_DMA] = &userq_mes_funcs;
 		break;
 	case IP_VERSION(6, 0, 3):
-		if ((adev->sdma.instance[0].fw_version >= 25) && !adev->sdma.disable_uq)
+		if ((adev->sdma.instance[0].fw_version >= 27) && !adev->sdma.disable_uq)
 			adev->userq_funcs[AMDGPU_HW_IP_DMA] = &userq_mes_funcs;
 		break;
 	default:


