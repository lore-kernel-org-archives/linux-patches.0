Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0ED2C17A0;
	Wed, 25 Feb 2026 06:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002646; cv=none; b=sYekWZPsAko1QVRN9NfrU+J9gyzl3udQwUTq/hS9GomBRg7wwHYneD1SeS4l5OtALaggD43GJ1Kwwf33tIuIjb8uNBzjoyqpYpE4S0xqyfZEsobDGD5sHfB8JeFB8aAR8WRALwlWP3urc+B7ECqXDjCXVh/qyjoGbRolZ4p0MR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002646; c=relaxed/simple;
	bh=D4auLvlWB6PsVuf3k+5SSqQG5vxyMZ4W6rAm/x8XQ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPF7Em48HFYf+9JscTYhet1o3wzc5jVkoVlK9NsnUH6V0GEC4mslvHaH1MngEngTIVD/EGbz855gWqmh9ZplD6z1LJ5UHk2xkZzvxzUN8VeiWS+ovE79Aftkf4o5rqTTnomMAiszHkIt/yRqoHxexTA1ASuCmj5xexjyNM2x16o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHWnF/Ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHWnF/Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8450CC116D0;
	Wed, 25 Feb 2026 06:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002646;
	bh=D4auLvlWB6PsVuf3k+5SSqQG5vxyMZ4W6rAm/x8XQ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHWnF/AoHpguYXMy4iPbNaFUTXiM4O7aHPjaep8VRLdOCu+VoTOJ+9QjdaFY8T9mj
	 O2tunvEuUcBKYv3bLKELquMzN4AV0YDpubcAEBWkapYcBJGZo1p88pf2x+gTic6xzl
	 cAKxKuI6ZkkXu3khVWiOAKXAaFVJGkMtk3Ss/cys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/641] clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:21 -0800
Message-ID: <20260225012358.614904680@linuxfoundation.org>
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
index dbe9e9437939a..915bb9b4ff813 100644
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



