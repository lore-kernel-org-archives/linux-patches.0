Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D30386562;
	Sat, 12 Sep 2026 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232375; cv=none; b=WbQ46ZuMcPv8WRGeuM5fXp9qHj0ucTa3ZjN9TE7dt1evVtEaO/4HV4ezHqAWbEjY4Ub5pWWskposKQjylP5mNMzRtdCYjreAESxjvEvO50QpkFSlRXUKfS5BzYSMhx3dhT+2s8iqvFP+jDvHBRnr+AwMLS5yhAvOqVelSQLaaF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232375; c=relaxed/simple;
	bh=gaNJA628uAIJGFBCC3RUQ972qpYOwKg0ikxC0moiDX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsuO+Kddcaf7m3Dl0DQxnl254WitMZcQPgimikphGePydmhB63esKrFHtnS/BB168E9Kcw7h0oRen1NJbRY60+rQPey1250N3EVUFaibp6bNoHh9ZO0/gwo8ML0ghCxMme/t588oRTvL+fXnrStMwKHk8KqRcMUXCktjCoWDhf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chk6Imbv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chk6Imbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEF41F000FF;
	Sat, 12 Sep 2026 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232373;
	bh=5qeVTaXnPa7yfbU4/D2yG54z+qn3K0MDmquZoDp0PWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chk6ImbvA7irLoJz0Fjv5NfG2fapyQre13EfLwmHfLDpYhND/TRGaldteJ+dSKvD9
	 02tS+73BOYuzrp2z05nolboDCu7ANAmM/TKu9uaZUTV4OIbH2SFnIAKGWoC5dpcijU
	 ltBeI/NLG12K5UZMgoRhxxjs/aZuybDbusoXMNDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1152/1191] clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs
Date: Sat, 12 Sep 2026 09:04:40 +0200
Message-ID: <20260912065614.020870494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 1c06e3956054fb5a0930f07b02726b1774b6c700 ]

In line with commit a27ac3806b0a ("clk: qcom: gcc-sm8450: Use floor ops
for SDCC RCGs") done to fix issues with overclocked SD cards on SM8450
powered boards set floor clock operations for SDCC RCGs on SM8550.

This change fixes initialization of some SD cards, where the problem
is manifested by the SDHC driver:

    mmc0: Card appears overclocked; req 50000000 Hz, actual 100000000 Hz
    mmc0: error -110 whilst initialising SD card

Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251124212012.3660189-2-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index 0f8fa570dc854..c27782c2f80f6 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -1024,7 +1024,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1047,7 +1047,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.53.0



