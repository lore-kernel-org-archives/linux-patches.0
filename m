Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749CF36C9D1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302212; cv=none; b=sMIqktYS9BKt+3MYwsfnI6rgFRmO8XSs4TOOtrrv0F/aKLcDhnp5yYF2p6SWxw2+EwGbhXeWlf0wpYUgvY2NRn4q6UYyV95LfVS4LusorwJCKD2iuBUcDVUlnqT2h9BOMhQ/53Tdi7+by1mYMWR3MCiu+Vc/EJpUhZxDsvuZBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302212; c=relaxed/simple;
	bh=8AQGJCsxEmDBEvrYf2NJxeTkTA+vH4NOrAOS6Rqy16E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOBl6YrewEPFQS6XJNDQt1OhAJnvDTljRmHIvFEOfXr73qI8JyrFFOaA19Xikquq4BBBX1Dzrrrz+Gpb+VFCURSoVgkEBGJpgomg9AomOFijFQ0lPDsSmmRFEH6PhSU+bW7MHVTpl+fbq8wSHi/BQwOlwgR5Qe4pWVu/LaO1vvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhGmjhqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhGmjhqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9759AC19423;
	Sat, 28 Feb 2026 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302212;
	bh=8AQGJCsxEmDBEvrYf2NJxeTkTA+vH4NOrAOS6Rqy16E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhGmjhqKOEWcUXyEbX3rTf0kXr8U59Xzr81d7W93m+dAtYZ93z+JllyTdazc2kOjK
	 Q9OmMeLwIjbV7jI4c0DDWFQyFzfyMY0Y7zjkPYa2tusvibCmz5y+X1wN6GQX60ej2+
	 jXmltMuavM2Cn6In/4+hcdT2ffCyoHKcrbQXB2nijLUS3gwCRW1qW08GZTMW7P/G6G
	 IwgNlas0liV34w0XkabDhgb7iUvHfXHvm/2csazflT1QziCSemc10cN/RhUyPsMMPi
	 N9nCTUWFJzfhl3h0hDMWp+e3pl8FHmcFh3Yac1ObQtgYrnfdZxoZD0VDRdH4GMR/r5
	 bfPBs5JZK7P3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/283] clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 13:06:00 -0500
Message-ID: <20260228180709.1583486-218-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 947c4b326c1f4dc64aed42170b39c2cf551ba8ca ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: baa316580013 ("clk: qcom: gcc-qdu1000: Update the SDCC clock RCG ops")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-7-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qdu1000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qdu1000.c b/drivers/clk/qcom/gcc-qdu1000.c
index 9f42d2601464e..84643f9ffb02d 100644
--- a/drivers/clk/qcom/gcc-qdu1000.c
+++ b/drivers/clk/qcom/gcc-qdu1000.c
@@ -904,7 +904,7 @@ static struct clk_rcg2 gcc_sdcc5_apps_clk_src = {
 		.name = "gcc_sdcc5_apps_clk_src",
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -923,7 +923,7 @@ static struct clk_rcg2 gcc_sdcc5_ice_core_clk_src = {
 		.name = "gcc_sdcc5_ice_core_clk_src",
 		.parent_data = gcc_parent_data_2,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

