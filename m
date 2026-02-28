Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB2833A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301887; cv=none; b=It1PZLFKQPkSe8fS2X4YXiGbZJcPqgVheetzkak1kPabEGKSXunKkxvz4S9Bcuwk69O3UTF2UmCvJW/4P5KsWq5SBGT+FL1dAKxi0ZXx0QhCq8cNkYuMmGDXoW14xqzOzfS477sEUHZ482OvT15KH6bPxpYWvF16vrWfN4awTaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301887; c=relaxed/simple;
	bh=/NrA88zzL0E7jvsE9+TCt/NxqVh7ExyW3vPvBksUG+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoApGoO8e4zP7/BaGl6CEnFSEi4hPUVd0/onU9k+4a25lkmXs8RFRItV4J94jVQJHiWaNJwyicNvporo6X38AgyjYScxSkbo1IiIF9D3rAREL7RCPI3DvJtrJz7Yp3Fw8JPa/41khcQEgHC0n5Hms3YQ7+nJyEuXR+/ZsajARmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iO3M6/JE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO3M6/JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90408C116D0;
	Sat, 28 Feb 2026 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301887;
	bh=/NrA88zzL0E7jvsE9+TCt/NxqVh7ExyW3vPvBksUG+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO3M6/JE81gM1bCl+YPWqMqzeY7FBRJ9hr7aE+LwnEWOP5NTxgCLaNnvP2Cy9KQUL
	 VR2swZCxqTGfddmkvhVNa4MJDUlhuc2Ib+qFUkKm9WI+fgU4cpS0yEo7eL+PoKasZO
	 BUdPP4eMyQWhEbO3cFrAyVDKMMCK70ngFCDAP1TWd9xhDZWPPUZUxUlOn096UtCY9M
	 ZYF7yK8y9GhmbwmAoDoamZFe0r6WpTH0tEp4BWuk1ZaganlLa/IRR8OMGO8vp+uGw0
	 Zow8yWhz4ljf+UXpu9Qt2CjLCiDKJvJwQrCjncs91vKuigxO+ltZmiHlcngkKBnRsD
	 Apchk/rHDZnjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/385] clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk1_clk_src
Date: Sat, 28 Feb 2026 12:58:55 -0500
Message-ID: <20260228180011.1568201-313-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Heidelberg <david@ixit.cz>

[ Upstream commit fab13d738c9bd645965464b881335f580d38a54e ]

Set CLK_OPS_PARENT_ENABLE to ensure the parent gets prepared and enabled
when switching to it.

Fixes: e3c13e0caa8c ("clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk0_clk_src")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20260117-sm7150-dispcc-fix-v1-1-2f39966bcad2@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm7150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm7150.c b/drivers/clk/qcom/dispcc-sm7150.c
index 1e2a98a63511d..3cd2af842143c 100644
--- a/drivers/clk/qcom/dispcc-sm7150.c
+++ b/drivers/clk/qcom/dispcc-sm7150.c
@@ -371,7 +371,7 @@ static struct clk_rcg2 dispcc_mdss_pclk1_clk_src = {
 		.name = "dispcc_mdss_pclk1_clk_src",
 		.parent_data = dispcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(dispcc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
-- 
2.51.0

