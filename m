Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0F2D77FA;
	Wed, 25 Feb 2026 06:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002643; cv=none; b=XSU0aE9lSl2Ynksx/65x2lnJcw/6yvaNg49elNjm9oL6v2BsFGZJhjotoa2U2cEnbyqFjbMp9Kpi6u8N4DFkiWtmWiERxPWikJCHr5Sh+KHtvqK7NjjP8bsYPHc8vKxTOfZfNc/Pj76SKcR55tsu/4rbPvSubIen0a/Dwt8gGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002643; c=relaxed/simple;
	bh=8EWqtnr7YZg7hRMsPgszGc9Q9dbxbANdnwc9vsB6ztI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4Anl8taGcNnSFuIQCL+uky2Bdi8mVPd++INGXpHhJJKu1rz1UGSe+hw1b+YUFCagj0E7H41vVaeM9B5RYFtYfTjgqh8hYLijJKtvpURN10vDkkVJqPhTJ/99UgMIWPe6bZ5xDY1M6I5DsFV2zojaeu3uH+7sP+MXshs7wRUnus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGpXsaRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGpXsaRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E10C116D0;
	Wed, 25 Feb 2026 06:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002643;
	bh=8EWqtnr7YZg7hRMsPgszGc9Q9dbxbANdnwc9vsB6ztI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGpXsaRcVX1NU2Z12+1A+pEsp9JfAecCsHnymlhwefnK3AQhq01oqVaWVp8tgZcQU
	 G1fNcsIfHliLgMTZLjkQ5L7oU8k5Sh9QGY/uoOAorqT5fL6RaLvWdHle6J9QMMS23K
	 al2rcFpxuil7pirSOLlzCpnPCvGc0QXul5bz9Xqw=
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
Subject: [PATCH 6.18 411/641] clk: qcom: gcc-sm4450: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:17 -0800
Message-ID: <20260225012358.521883082@linuxfoundation.org>
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

[ Upstream commit 458e8a082186335380a9ab83003a385aec9bb254 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: c32c4ef98bac ("clk: qcom: Add GCC driver support for SM4450")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-3-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm4450.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm4450.c b/drivers/clk/qcom/gcc-sm4450.c
index e2d9e4691c5b7..023d840e9f4ef 100644
--- a/drivers/clk/qcom/gcc-sm4450.c
+++ b/drivers/clk/qcom/gcc-sm4450.c
@@ -769,7 +769,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.parent_data = gcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -791,7 +791,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.parent_data = gcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -815,7 +815,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_6,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_6),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



