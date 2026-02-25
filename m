Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38AF2D77FA;
	Wed, 25 Feb 2026 06:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002643; cv=none; b=rB3cqD73QJhqTL1IQYtanEF9kyJ9azl2yJYG0hEJ/Skj3v7GwM2NQar5Q3uZm0Kr1qM46vAM6PhKbi5Ap36hpUfomEkoii6oacXzly4lQWt03JuMzwBCt6h1FRZF3N7f1o2VJEJZAYtioGrhFtwJednXd8aCwun/0SKXS3aSWbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002643; c=relaxed/simple;
	bh=z/nMbvQkmTrEv2RJ0VipMncCp2L8lxLA93n6hFlPaiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVVvTsr0+EjjbNZ/KavO9q1chlW9yV8d4AQEB6MXjeTOCNujSpCk+J5YrIhSmzkECxqAw0HyFIA3oHdU3AnlelqTX0vlbsmpsnqXxvjWN2pR51BB/fcnzVIef7reePIo2S9+/3xf3fVxA303mHzXeU1eJXHhx9f1OT7g6Szmzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOn9I31A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOn9I31A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980BCC116D0;
	Wed, 25 Feb 2026 06:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002642;
	bh=z/nMbvQkmTrEv2RJ0VipMncCp2L8lxLA93n6hFlPaiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOn9I31A628gSZIOde8R28HqZ+kJhfIT4Jdz4I9NzwYcJv4yQAmnMj+7Azy85Nymm
	 kKMdiTBg4x7KOshquGUV13ajqXD4rjrQKj24EoM+ZngkXsFYJL1GPLzZm5bYBfnFvy
	 PAn+MoxMfFTzBGGkAWqWZXcufiZVigIqqP3AfoOQ=
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
Subject: [PATCH 6.18 410/641] clk: qcom: gcc-sm8750: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:16 -0800
Message-ID: <20260225012358.498042045@linuxfoundation.org>
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

[ Upstream commit a7231d4aa084e485394f9214ec9bcb2d1f65dde9 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 3267c774f3ff ("clk: qcom: Add support for GCC on SM8750")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-2-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8750.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8750.c b/drivers/clk/qcom/gcc-sm8750.c
index def86b71a3da5..db81569dd4b17 100644
--- a/drivers/clk/qcom/gcc-sm8750.c
+++ b/drivers/clk/qcom/gcc-sm8750.c
@@ -1030,7 +1030,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1052,7 +1052,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



