Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F518B0A;
	Wed, 25 Feb 2026 01:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983401; cv=none; b=c4s8w/SJx/g+znjM3K4xjep3LoiLENqWh8UwTwNStak7uG4bNbQIDB5cPtGXUh4W5kzz615hJ63xKKqk3IPrENHIzBSYnEzgaz2pRCzr+Z12JF5gqGcjZpme97RZpxcWpZg2Rzw+m3oG23JGc4aKIp+4fQCUtBouDcNCppN9yhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983401; c=relaxed/simple;
	bh=HeDFZPMeLbt3MOTK4VbXUrZxKa4cyb5Enqf0mZFtceA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+gH200UP2NXKbnBmqjoINbm0RezOXhlgzOl7tob6sJ1BeYeH0kJVP/dZJsXUDL71qdamekwngyMBKmzdT9xBLVEOWStoWEQEf3QTjXVQoANYjmtEAaLQloiBUgJXzhUpiy/m92yCQ+rBuoMpgFFEHzsnM822o3X7N7vVB/SnTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulK8SWIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulK8SWIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2DAC116D0;
	Wed, 25 Feb 2026 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983401;
	bh=HeDFZPMeLbt3MOTK4VbXUrZxKa4cyb5Enqf0mZFtceA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulK8SWIEhcaK7wF+51mdIhL/ZVsX6ux8x0sb+4+MjK6Kl4omij/S8vDZXf7T/w/t/
	 bnUSAq8qy4uMJE6X6Qbbv118lnErw7Ng1jRmTFMNnN3TluZSuDu1bQcx+KAnvrTby4
	 iTJFsqoCgbIxicZ0OVBnuLu3hZUd5Wlu+ELSsQ5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 522/781] clk: qcom: gcc-milos: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:20:31 -0800
Message-ID: <20260225012412.604135145@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 08da8d7dabb161cea14c6d3ad9b5037aaf6d4b7e ]

Use shared_floor_ops for the SDCC RCGs to avoid any overclocking
issues in SDCC usecases.

Fixes: 88174d5d9422 ("clk: qcom: Add Global Clock controller (GCC) driver for Milos")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-5-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-milos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-milos.c b/drivers/clk/qcom/gcc-milos.c
index c9d61b05bafa1..81fa09ec55d7f 100644
--- a/drivers/clk/qcom/gcc-milos.c
+++ b/drivers/clk/qcom/gcc-milos.c
@@ -917,7 +917,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -938,7 +938,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parent_data_10,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_10),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -962,7 +962,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_11,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_11),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



