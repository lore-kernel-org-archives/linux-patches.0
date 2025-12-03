Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2230AAD0;
	Wed,  3 Dec 2025 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775905; cv=none; b=DeiDqNFZUNSdbtBaDQjak1ZpYvSl0fsgGIUNFclwkn0xdEsbhCUBnO6rV+Sn/hF+XxkYXyqeZbA+nN7YuB7RCX8ZnYgvWYoZ2l8v93n6wZAXL7tQ7uBewyEUizvqmHlPsAHakSDhY1wnQhSZ0NbPoF4YPZ4/gQSqMG1QjIpTSeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775905; c=relaxed/simple;
	bh=inGy7tHhAuUjT3tftVeP6Ya4fTbrrhjccmYIRZqp8Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0dk8zwdc2VrtH2p0vnNwBrHGLhcm/hY5f83C/O90H3AwjJc0Qk44XhiynV2crrKRJOsrr2Numa6nPEFAXBhqr3pId9Vp3CNDK8UiXqCbfDAXvFGiZ833nuG3FhlYq7rr+e7BVMLN/4Z9Pwm7nFQbM3BEZIwr3tM1UjpwKSb5mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYlwmc57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYlwmc57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E048BC4CEF5;
	Wed,  3 Dec 2025 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775905;
	bh=inGy7tHhAuUjT3tftVeP6Ya4fTbrrhjccmYIRZqp8Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYlwmc575NMDldOfdy6mWRDcZR9TzElAl4f166UwPoG8yb4DcHy8G7ago8NPP8MBC
	 eOpFeTorEIDB1tL+OCyHLo8BX6QlfAexQYHb+YWbCYwtUGzNn4Ns13zxn+9pD66Sn5
	 GjAFrLAFrmdBY+7iEGeWBVOyXgy04cEO8YNOQ0k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/300] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland
Date: Wed,  3 Dec 2025 16:23:46 +0100
Message-ID: <20251203152401.280693138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Smith <itistotalbotnet@gmail.com>

[ Upstream commit 501672e3c1576aa9a8364144213c77b98a31a42c ]

Previously this was initialized with zero which represented PCIe Gen
1.0 instead of using the
maximum value from the speed table which is the behaviour of all other
smumgr implementations.

Fixes: 18aafc59b106 ("drm/amd/powerplay: implement fw related smu interface for iceland.")
Signed-off-by: John Smith <itistotalbotnet@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 92b0a6ae6672857ddeabf892223943d2f0e06c97)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/iceland_smumgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/iceland_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/iceland_smumgr.c
index 431ad2fd38df1..06d89fafae55b 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/iceland_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/iceland_smumgr.c
@@ -2028,7 +2028,7 @@ static int iceland_init_smc_table(struct pp_hwmgr *hwmgr)
 	table->VoltageResponseTime  = 0;
 	table->PhaseResponseTime  = 0;
 	table->MemoryThermThrottleEnable  = 1;
-	table->PCIeBootLinkLevel = 0;
+	table->PCIeBootLinkLevel = (uint8_t) (data->dpm_table.pcie_speed_table.count);
 	table->PCIeGenInterval = 1;
 
 	result = iceland_populate_smc_svi2_config(hwmgr, table);
-- 
2.51.0



