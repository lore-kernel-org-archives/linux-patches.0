Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E3B34C9AE;
	Wed,  3 Dec 2025 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778772; cv=none; b=icUeONtAbzNHpAeM/YulIj1YYad0wrF601oYuiA4vMzMqLJ/uoZ10XsXZRUazyTNvTdQtCKTy6AZtgS3ggrUsHh+ckcxmk+KKFLVEt+3EAXwlszT1ZahBO0Djf9crijHhMMf2ubHyNbw7akKuGh9Fg6hSj3VALw5USWxGnyZ1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778772; c=relaxed/simple;
	bh=Al2OMCkFhOR2xxsdZgA9neTKKDZB4AIOIWGqj26f7dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+7uGlJ3ZfjmaeDS5skDplVriIxoD4dHLcNZCVXDQ4kvTPz2cMaq46Q5F9Y1ghknP5Q2dmytoOcTY2jmX74i6r3sFiYg/lTC8cHNBYVJED0E1x0vCisR+YNosg5aLabf0GDQzyKCVevp1G378VdK4o5lZfQB9274cBhHaKs5D74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSIE45zG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSIE45zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E3CC4CEF5;
	Wed,  3 Dec 2025 16:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778772;
	bh=Al2OMCkFhOR2xxsdZgA9neTKKDZB4AIOIWGqj26f7dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSIE45zGPP6VChJHeyILdns8nh0KMJ1bJ5Hen4QuGSyd5hnUTgZ6dXOzhtYUmuwra
	 AdDrMBalBDxUKqA+qfhE/CG8fy1F7SKjx6JSrUYVpLWZjVZSNyvOePGw55XnzOKkPb
	 GQ4CTln+4U/CnWwc9wdtgQDZlCuYCrtzqhldH4mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/568] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji
Date: Wed,  3 Dec 2025 16:20:56 +0100
Message-ID: <20251203152442.675965677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 02c094a06605d..50deb4ce767ee 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
@@ -2024,7 +2024,7 @@ static int fiji_init_smc_table(struct pp_hwmgr *hwmgr)
 	table->VoltageResponseTime = 0;
 	table->PhaseResponseTime = 0;
 	table->MemoryThermThrottleEnable = 1;
-	table->PCIeBootLinkLevel = 0;      /* 0:Gen1 1:Gen2 2:Gen3*/
+	table->PCIeBootLinkLevel = (uint8_t) (data->dpm_table.pcie_speed_table.count);
 	table->PCIeGenInterval = 1;
 	table->VRConfig = 0;
 
-- 
2.51.0



