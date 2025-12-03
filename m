Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AB53446A8;
	Wed,  3 Dec 2025 15:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777511; cv=none; b=PFqPi1/JPUqpBnC5Z82X1rTu0lm4T5NVy+T/Uk3sHcttSDpGKAJfR2PZLrPmFefKLooA2LDhWon28x2eZY6GJyLwT19FBFBk5kn7yD/PxMIvFkZ5eHvoYvgTV9zCcL79pCP2vynWy3EfsIuJJBjPNYpHkK5k6SMFXDX1lfGitaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777511; c=relaxed/simple;
	bh=+2ci2gkjj0xY13dRgzMaUxG76h3xCRif9WqnbCCl2mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/UdnUEJFW2YBqLUHisds90F5Ko2TBaOMGvwHWJc8nWoaFR8dTf+BMmqmDId8oElRbXmoMnaO+mbyMA80ab2RoDYPCdbJQBY1M+j5ugaLkM54+wGklXwsA0hOYq/UKnYHnRBlJGQ9cWwF/ZG2MS7Ifupn0fI7xHdfTIFWR4s1tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqLKGKEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqLKGKEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B27C4CEF5;
	Wed,  3 Dec 2025 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777511;
	bh=+2ci2gkjj0xY13dRgzMaUxG76h3xCRif9WqnbCCl2mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqLKGKEfMLZVQTjyROcD0XsRixB7XGj1hAoDYLo1VaI/DNLq6mLb/bWD7oy/r7Ov2
	 inKZJLlKokmjcd9QqEZCVEzEHMxsraT2ub5ZLinZzY18OiUpX9bI756Q5LHrk2AkyJ
	 VJ/9P/A3j2nspfrvtNq0Mj9tkGH0If87hTKLmpa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/392] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji
Date: Wed,  3 Dec 2025 16:22:58 +0100
Message-ID: <20251203152415.136090472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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



