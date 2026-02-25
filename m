Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAECC1D5141;
	Wed, 25 Feb 2026 01:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983406; cv=none; b=dMaRzCiFKewag+JCE67a3YZ6T/2FYmygeNicVlWUNTGJOilSmB4W1uVtCz0YPmtl5jQcVXQRtXIQ1jEKFw5NvVoHYDXv4vaLhyshDFu3HJjO9XVRpov+m3y5QRT/T74PqvxNJ3hhmJAlEC9gEsUU+prtSwLR8BoKgzi4IW7D7pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983406; c=relaxed/simple;
	bh=ZP0fwtWH9yDsSlzCjZvLxezSNeA6nDuaYgDWEC3ooRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaGUctDxeWnyZlfgsv91Dy5KVioyG54DUJ7dzp9Zgh88sBnIO9SOqjhPOkfPv5n00kMIwNmYPvCqE8tq6tD4ArI2qNAAVrph8WJHWAqtVLoeHuExQPSRXAl34CrkxQ+ykRqEKaQZym13oIP+ldHdUT5UNnqvAKEG8C4ouC5x4Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zr0lHcek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zr0lHcek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1C4C116D0;
	Wed, 25 Feb 2026 01:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983406;
	bh=ZP0fwtWH9yDsSlzCjZvLxezSNeA6nDuaYgDWEC3ooRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zr0lHcekFpEFsFc/9HzbVZsCMa0ep9LxQ4IKUJhsWEIR+Ha+MlVg+3w8cZjA1PMKO
	 qsWn+X/yZ1ERRBioAaxaERZsTCvdzNHksyCHq4cnwSeW7LJxXlV4Y6IWwkQidJKdtA
	 zCp/qNuL48oturrirP/ErkMrq9wOwMXjP/yoDdcE=
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
Subject: [PATCH 6.19 525/781] clk: qcom: gcc-glymur: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:20:34 -0800
Message-ID: <20260225012412.675306813@linuxfoundation.org>
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

[ Upstream commit d5639a6d72810023d257c935cb763aea1ada1abc ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: efe504300a17 ("clk: qcom: gcc: Add support for Global Clock Controller")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-8-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-glymur.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-glymur.c b/drivers/clk/qcom/gcc-glymur.c
index deab819576d0e..238e205735ed5 100644
--- a/drivers/clk/qcom/gcc-glymur.c
+++ b/drivers/clk/qcom/gcc-glymur.c
@@ -2317,7 +2317,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_17,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_17),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -2339,7 +2339,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_3,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_3),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



