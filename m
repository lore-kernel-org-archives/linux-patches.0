Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E77355024;
	Tue,  6 Jan 2026 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720236; cv=none; b=f4j++HGXCh+uhdXIVJM05Iu508GdgirrigUpszGO1bhzaWdaX4cIjgsgf4qxGazsv2JrBECviVlwHd2vazmjENoQuDR2AKkdRbqy4y0wNqTJHGOvAYPYmHoVx73huUjUGDwDoi9dzYnhZVT8IsoLJgyu22OJrKEZfjUKdyE54Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720236; c=relaxed/simple;
	bh=dMc+csNqhNT1InH4uCJhDT5N3hurNNCnCdUOac5UxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMrXKRUnxZwylbDtvUWJgRsUs/nS6DI/WELJctDuSn/vaGYHr9nuLURz+hKe/aKMWTQXCKhuD8J4Ys6YjrRCB37akZXuXNy3VC3RZzhhcDAq9vEbCyR6uNKGmJhct1Be1Vqbz3FR7oYVPYQi9IY3eHf54GzdEKT0AEUFRpA6EfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eURTl0UR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eURTl0UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E2C16AAE;
	Tue,  6 Jan 2026 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720235;
	bh=dMc+csNqhNT1InH4uCJhDT5N3hurNNCnCdUOac5UxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eURTl0URplawOTryQ05oUi2cOF9o+86b/hQuPq1UzhQAIapI/nqmKNJUZcQQ77dRJ
	 P8j6iN9vTK0c1yuiHLqBQl5jMReEGPR6BP3J69GjtdzqoR8rMEPXzAP8bGDqtDx8XI
	 PSTMKHi16uu07Spo83ey5/MfFC8nPVyuKQLnxlJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/567] clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk0_clk_src
Date: Tue,  6 Jan 2026 17:58:45 +0100
Message-ID: <20260106170456.615242247@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jens Reidel <adrian@mainlining.org>

[ Upstream commit e3c13e0caa8ceb7dec1a7c4fcfd9dbef56a69fbe ]

Set CLK_OPS_PARENT_ENABLE to ensure the parent gets prepared and enabled
when switching to it, fixing an "rcg didn't update its configuration"
warning.

Signed-off-by: Jens Reidel <adrian@mainlining.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250919-sm7150-dispcc-fixes-v1-3-308ad47c5fce@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm7150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm7150.c b/drivers/clk/qcom/dispcc-sm7150.c
index d32bd7df1433..1e2a98a63511 100644
--- a/drivers/clk/qcom/dispcc-sm7150.c
+++ b/drivers/clk/qcom/dispcc-sm7150.c
@@ -357,7 +357,7 @@ static struct clk_rcg2 dispcc_mdss_pclk0_clk_src = {
 		.name = "dispcc_mdss_pclk0_clk_src",
 		.parent_data = dispcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(dispcc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
-- 
2.51.0



