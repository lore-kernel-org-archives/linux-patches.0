Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563A436C9D1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302210; cv=none; b=OcGzF85TQjPTolg6gxoqbs4fXXx+DlfhPGbXCl36XjbcwSt0cnfBxEkqD8+mpxU414q7yDVZ7WREZLImecTvvn2E/pNkGBJAh+1yq2Vn2vUgMJwYNwfiTKkvkHSaJejwt6uiNWPgtDaOYL/XNKKg7ds95cq8iChGKhwv5uyN2A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302210; c=relaxed/simple;
	bh=nfVjGFJ5nwmZqmWZHoXo2vzcOpXuQruLhpkeY2dmjZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paGAzjmTq6FwxrwDas7OOJt9WZxi7HNn6S/FWn2wz4dykmwATz7JAJMbAcwFWPf0meR17O/Q9dkEE24CzkbUUcc0qFxcPZ81OMyO+pRyUsWATFqxHzOVeEFSxNIyvWIZXC8pJ6YxQOWIA0EQ4zcklfC5XovypO6Wl8znmYijKls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ik7E4GTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ik7E4GTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66158C19423;
	Sat, 28 Feb 2026 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302210;
	bh=nfVjGFJ5nwmZqmWZHoXo2vzcOpXuQruLhpkeY2dmjZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ik7E4GTvDKA215WM76GnIzSkzNn/hlAZEXqrzgP9fbmGKuJIFrvAfbC+IaiA72HZz
	 Dq6WIYgKInYYnA5Vmovl1peBGCf0MpeY4OTC05KsYqRrR7tnQo9SPDE0MRrFxEbPcW
	 cFSxlikomKvWKVzrworMSPK5Ej5KJqnN/oR9g1PyNSge3enjUIu5evHbMITsN5DrIK
	 L3ynoUvqZqvSzupK0R3ZM+AZDf9vqbsjtoACTy9QtxzvPn5xN9q5j1V8ayUuyXtq7T
	 PTirw/Hq7nZLorMeLpsmNXyNfDS5wy0dVnDAQV15xqqCEW3934cS2vAM6uRcbHweV4
	 /TKFmSKPuJEqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/283] clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 13:05:58 -0500
Message-ID: <20260228180709.1583486-216-sashal@kernel.org>
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
index 4c55df89ddca7..ef02d1003cb4a 100644
--- a/drivers/clk/qcom/gcc-sm8450.c
+++ b/drivers/clk/qcom/gcc-sm8450.c
@@ -936,7 +936,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_7,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_7),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -959,7 +959,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

