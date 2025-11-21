Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D4A347BC9;
	Fri, 21 Nov 2025 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732207; cv=none; b=E2I2D7uO/4LbRKY/T2XM84Rlgjlcq47C6uu7fgVhcebT4vYrb/uLAeItIo9VSac1VaKjjFVIbRz/6N/zCVyu7icrNSv5RpQ5/YjIXFzLcZnTfw0lnDjplllgARs8GlURne65gmcfDnqa9cPwPFjx99TsbbUEzVeFSMlS8vfyTrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732207; c=relaxed/simple;
	bh=hB5cGRb101JP9w/5/eUj6VxzTcmLYNIldjyqf/OM0Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7It49HaRJCKDmv4MFzuFfnJYomxcgSW1CpaxLDCtOdHpk4cWc0opuZxIYruvz+LY2+oj5wi4CBDcahoqc/5yuWR9SWjruFVPvTfeleH2UbUWaWKk+GEF2f96SqnQ/byTphGveLh8EctGAvnP6/4JIhqwprEWcEbZ7BZa/uUkhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5vSvDKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5vSvDKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1D2C4CEF1;
	Fri, 21 Nov 2025 13:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732207;
	bh=hB5cGRb101JP9w/5/eUj6VxzTcmLYNIldjyqf/OM0Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5vSvDKYGf6CyGpxYrNmn/qGeYu9bfulKyND6o8U99K6TdmPMrzETbc4kdrxGgMgs
	 VjnjqbA7dH9S7KlHOWfJ2ailw96+o8GCPo4zeBVCsuSWn1N62TB9pFCJUrt6p2s+Fb
	 r+3/1cIt1G6FD+0EFBaas916CkoDamVFbkCjfCIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/529] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland
Date: Fri, 21 Nov 2025 14:05:40 +0100
Message-ID: <20251121130232.463107583@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97d9802fe6731..43458f1b0077d 100644
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



