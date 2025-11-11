Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC44C97;
	Tue, 11 Nov 2025 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822479; cv=none; b=XzMziecvG4Wxjo5vP9Rwj3+sCceW1DQ146Emx6ndryQLFgdCyVHRq/8gAUV1rAjMltPTMRuecT/lCkBIFSfxN9pV+zbmO22muQjJokm3xCZ5+rar8c5k3Bzk4bPvLQ8mRP92Kzz9jT4egA1wiKtonmVsCzYiqKUfImPjcyk7d4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822479; c=relaxed/simple;
	bh=dgUTkJfgBR+cBv9Q9jrFwL/YsuBWpbDM7sS7vI4f020=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP7qvZ8/DtfD2EXqa58rTjpmSlf6cfJlY8o/oSodVEnoFgeABU4zcrNkh77HGBGINPvF37nATh+kAdtzk+TxtH+lcmQDPp5HmA3Uq+ajjfNtyCWI90gl1WVgPeE1tQib8xaH9vsNtFD1rr9i6Q1w46589fIu2ZxNyR29AkTk6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCGdoVWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCGdoVWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0839AC4CEFB;
	Tue, 11 Nov 2025 00:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822479;
	bh=dgUTkJfgBR+cBv9Q9jrFwL/YsuBWpbDM7sS7vI4f020=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCGdoVWOV8JmHLJRrakHqcNR6ByHex8L3jwYA9dYzuisJh1+nOV44UW8sVy8C/WjO
	 9lEZOOTfyHFU4P87Gkn+Mvvl/tts1WEZ92ydqsATvahlPMebJvzKnJ+1gZ2F2VzWbM
	 squ6XD+XRv3ZKyfo8+jrru+tK7vKUqjOKfrGy6Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/565] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland
Date: Tue, 11 Nov 2025 09:38:34 +0900
Message-ID: <20251111004528.226963112@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17d2f5bff4a7e..49c32183878de 100644
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



