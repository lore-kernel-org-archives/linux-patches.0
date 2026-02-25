Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC8F2D77FA;
	Wed, 25 Feb 2026 06:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002644; cv=none; b=TAsG1sZMCGL+yIz02YApR7hAXLn05McJruiSsnJrNf5pTF5tuJtEhTlBnj+eNfUasR1AtcE9fv2zCkAKyXvnYii0dHgEMPLx3AtB6WaoS0KF5JdVhmqYGcPpL+kTL97XAHFMyG9pFQhMxASntlZMU1dpg36Hqsq1PikKap3Rl9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002644; c=relaxed/simple;
	bh=qFa638VKM5XxJy9GBbpX400mZrBVHos/hvE+scArLB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql+UOI12xShTqIP2+VKJueE3RR9Bbw6mAlEmWDC5VxYjf8a7KvNAos4bcPEj5W1CwDmQYCWpkOl1lvWOsXfvS0gu42fwNBzeqCujw5COT8H4OWRPyimKXkV0toAznEBy+ONa838dAoyLpPNXPCWkOANecOvB/obXQwJRBLvtJD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMbicfck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMbicfck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E216CC116D0;
	Wed, 25 Feb 2026 06:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002644;
	bh=qFa638VKM5XxJy9GBbpX400mZrBVHos/hvE+scArLB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMbicfckIVSpfCqDx7PyF7RGr6vZQdP7pm+GvLyhuBU1e/iFWrS1xi2Mlvrtl3tJM
	 dbL4cYT9Aw6dF7hoKO0uuD7a6c0GcN+cYJLVzipmrYt1CycBby0yHfnBWCJY8fTfaa
	 n0noT9lezr//XSMy9dsIkeAZwkGgBWFw/Ax9wNH4=
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
Subject: [PATCH 6.18 412/641] clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:18 -0800
Message-ID: <20260225012358.544894194@linuxfoundation.org>
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

[ Upstream commit 4b057462bb61a6571608ba393e6e018c9da9c9c3 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 108cdc09b2de ("clk: qcom: Add GCC driver support for SDX75")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-4-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdx75.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sdx75.c b/drivers/clk/qcom/gcc-sdx75.c
index 453a6bf8e8786..1f3cd58483a2d 100644
--- a/drivers/clk/qcom/gcc-sdx75.c
+++ b/drivers/clk/qcom/gcc-sdx75.c
@@ -1033,7 +1033,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_17,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_17),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1057,7 +1057,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_18,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_18),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



