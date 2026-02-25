Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C73E2D77FA;
	Wed, 25 Feb 2026 06:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002642; cv=none; b=A0LtjlBiRT1YYtCNmk1FCuDkInJ8x9RqE0g9Jyxp3RyjzBJuGhdbWfQbwh1INwOcDQN4dxwn/QoUPKB0dswhz5/T62I7ehU2Q4+jiJlCWcivLU5zMAKba83OniIrfjDLBKDwp4LXO1Yy/JFZISJYV8JENPuladLR4pnH/ww+8MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002642; c=relaxed/simple;
	bh=gNNYgjdU6DGMnc1AGKsSq7veHbJlcnlLP8WHKXW2o/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIgXepAAJFLBwoxyjmkVAjg6X8VrEO5eCAKackJ7qZEoE+SNNWDZDGLi3hoeA0AXL3jlw2IqMTGcjuCtVxjExMQ5LHo9ZpCjXTrmZl95445HjKDMHRi4mpnFxng2d/wwO862DYFr3elMloajBTAFh/6YeO9pLjMkpeIPcltnd/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ic3VSaWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ic3VSaWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E973DC116D0;
	Wed, 25 Feb 2026 06:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002642;
	bh=gNNYgjdU6DGMnc1AGKsSq7veHbJlcnlLP8WHKXW2o/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ic3VSaWWP/4CAcMDonAUfKB63tbE/xceFRkxIO/PNj+dLu2aNQ2N0tikVDFC0iE2T
	 7aze00zIuy0+wxbzQ+YlucTnVrNIf0QXNf31aRaX3LqHOgEtByRQcC0NEvBVEOQHi0
	 zvS/jFuBnpDZw3ZPgf1Z7QDm6av9TuLyZ3Os3OE0=
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
Subject: [PATCH 6.18 409/641] clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:15 -0800
Message-ID: <20260225012358.473850755@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 89428516f99572a9c37ebbb7859595881e7025a0 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: a27ac3806b0a ("clk: qcom: gcc-sm8450: Use floor ops for SDCC RCGs")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-1-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8450.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8450.c b/drivers/clk/qcom/gcc-sm8450.c
index 65d7d52bce034..b18bb34889ab2 100644
--- a/drivers/clk/qcom/gcc-sm8450.c
+++ b/drivers/clk/qcom/gcc-sm8450.c
@@ -1034,7 +1034,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_7,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_7),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1057,7 +1057,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



