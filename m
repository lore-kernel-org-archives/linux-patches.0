Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E542D34D4EB;
	Wed,  3 Dec 2025 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778776; cv=none; b=Zdco9VzmXSvKwp9agvSfWJNpUJQVA8FFTa40EmycLWGAegQOghPvUeBvzJuuvz4qhvr7KDNRouawLqSnTUfEhIsCmvZADo255menhxxymIyLDO8IxwSatS1tLItcJoWHZ6g/lKuX6qJi9pW7cvWLGQK8e6fyCVV/f7Zms6sNWD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778776; c=relaxed/simple;
	bh=2IyL4IfzoVGWM1NXKN5vQhIUHhjiTXqbieuGeOICOmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA4WJ/wD2/y0ZvCKoolrVfeyRgF3lUl7Go1rN27q1VCOoL/TPG4suebLOzmE1s+XPoNxEQBFA+yj9HSDJaEYDNyns6mMqSQGDMAaCfjAWQ9oxjscOaOYIrHBLHBbou6gkCRefEZHCS6t9dTrZ5M99aUbF0TGs7PNJCNMi5FLQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kszrGeEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kszrGeEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33437C4CEF5;
	Wed,  3 Dec 2025 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778775;
	bh=2IyL4IfzoVGWM1NXKN5vQhIUHhjiTXqbieuGeOICOmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kszrGeEu061Up4sqI8CnRKtIqFSUiUfFRR3jGHWfNURJk6LMgY3hA5wyS2d8fsj++
	 vOogpKQDN1Gdy7NXD7mmcf7D6xmNvh55F8ZlY95E0W34k8j3WNTuZ6FgnVceo6lmYE
	 eplMf+BERkLCiXB0VzT7YZtNSwGQ2bcPnzXTMg5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/568] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland
Date: Wed,  3 Dec 2025 16:20:57 +0100
Message-ID: <20251203152442.713017900@linuxfoundation.org>
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
index 03df35dee8ba8..6ddf9ce5471e8 100644
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



