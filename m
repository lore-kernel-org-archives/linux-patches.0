Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F53230C62A;
	Wed,  3 Dec 2025 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775902; cv=none; b=rBQmq3Lk/fPPAns6D0gGbt/mW7/XFnGjfmMOHKPlipJAH9Hcju/AXPmfM307XjjuLWwDoOUiYAracAT4k9my/V8LOlF8tLkRnT73q6o8+mvs8S4CU+ykj+w0ONwvwmAvaQP54CJnRTYERug8rlGPDjSHG42atAbo7AB40PvSXKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775902; c=relaxed/simple;
	bh=r+NS4PrrQaV6s7gIxlfE5bw+MgY+TifmY9mfeOweTBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkMCCEIA5Nzf39Yni4vzNBk2bq61Ma0MTf3b8VlJpvl3Mg/hHSf8o3samuHOkckjGhKwwDbkHWz3xK7hVfuE61YqUdgPbglGZOVdXFKXLTIFe1yTaPr6FSL0PUijc6QMl5fCcPlM11P8tcxRvukW/bQ9aisN4O7lbC37VdNGvrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki3PgWWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki3PgWWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B930EC4CEF5;
	Wed,  3 Dec 2025 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775902;
	bh=r+NS4PrrQaV6s7gIxlfE5bw+MgY+TifmY9mfeOweTBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki3PgWWsnehiE8PcY3+o62MjDtsPtXEw7NbvMVgF+gPRQi+B0CG/xCkJUCBBVODBp
	 T92UsGIFbzgsSNn1JDgY4l+qky9IsVJkTb9sl4O6YHX/1j3HTK5mPNllfK/MU01b9o
	 CLdxc6M/GACC10o9n58yVDs0RVYMs+WEuq7c2L6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/300] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji
Date: Wed,  3 Dec 2025 16:23:45 +0100
Message-ID: <20251203152401.243109460@linuxfoundation.org>
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

[ Upstream commit 07a13f913c291d6ec72ee4fc848d13ecfdc0e705 ]

Previously this was initialized with zero which represented PCIe Gen
1.0 instead of using the
maximum value from the speed table which is the behaviour of all other
smumgr implementations.

Fixes: 18edef19ea44 ("drm/amd/powerplay: implement fw image related smu interface for Fiji.")
Signed-off-by: John Smith <itistotalbotnet@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c52238c9fb414555c68340cd80e487d982c1921c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
index ecb9ee46d6b35..6049edcaf6ce9 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
@@ -2026,7 +2026,7 @@ static int fiji_init_smc_table(struct pp_hwmgr *hwmgr)
 	table->VoltageResponseTime = 0;
 	table->PhaseResponseTime = 0;
 	table->MemoryThermThrottleEnable = 1;
-	table->PCIeBootLinkLevel = 0;      /* 0:Gen1 1:Gen2 2:Gen3*/
+	table->PCIeBootLinkLevel = (uint8_t) (data->dpm_table.pcie_speed_table.count);
 	table->PCIeGenInterval = 1;
 	table->VRConfig = 0;
 
-- 
2.51.0



