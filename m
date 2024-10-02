Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0A21D175D;
	Wed,  2 Oct 2024 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878170; cv=none; b=UMFK32TmdInx7PQ2aXqwQGFastLJhjLqrz70VzUoI9Lid5NMKbWu/CCasO17evAHNomFsG4YuK5vsPoEL9jXYTRPGcLMgnnT3KBZvEfj99nyxJO8Ui3FpmnncOrydCjbOyibqesuSblJl8yvarXWKT7FPXo3IQY+9RIhcvKavv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878170; c=relaxed/simple;
	bh=0ksJdNrC99S9ygpu9/hOZtoiCq3i5t2u3QAw/z33aNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gpa3JFnOvwM4A849lsc0Z1FXc7fc/a8a9vCS/P9MfKpvapuqaHG0TOjkG4Kg5HaRRDsvEa+/vv8A7xI9YhQbabuCAYhpJl+uHtlh+EtFYow4XfekPbk5pH40tqW9gYmNpOWN5zwunXaUCr9fDX7+JwSIY4fLHOAIuv3M1WgB4D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK4piv7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK4piv7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF7DC4CEC2;
	Wed,  2 Oct 2024 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878169;
	bh=0ksJdNrC99S9ygpu9/hOZtoiCq3i5t2u3QAw/z33aNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK4piv7a74H/cHp/XAOCeslyd0fj13/WkrbGDEtIdmt9+l7HDL/EUJiYFDrn/Fgme
	 Vjsr7bZr6uq5XXWtn9/WmdplSWde8aYhJMJzkhj71LyiE/10fqf2jrvk0aaJE+IO9M
	 GBx/S7Ohc/Xe0Ra28nPEy8G5xXjC4wc9SGA+CJ4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 323/634] clk: qcom: dispcc-sm8650: Update the GDSC flags
Date: Wed,  2 Oct 2024 14:57:03 +0200
Message-ID: <20241002125823.852267966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7de10ddbdb9d03651cff5fbdc8cf01837c698526 ]

Add missing POLL_CFG_GDSCR to the MDSS GDSC flags.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-4-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index 6ac7a0cd7e063..abf03fe5727d3 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -1611,7 +1611,7 @@ static struct gdsc mdss_gdsc = {
 		.name = "mdss_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL | RETAIN_FF_ENABLE,
+	.flags = POLL_CFG_GDSCR | HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc mdss_int2_gdsc = {
@@ -1620,7 +1620,7 @@ static struct gdsc mdss_int2_gdsc = {
 		.name = "mdss_int2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL | RETAIN_FF_ENABLE,
+	.flags = POLL_CFG_GDSCR | HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct clk_regmap *disp_cc_sm8550_clocks[] = {
-- 
2.43.0



