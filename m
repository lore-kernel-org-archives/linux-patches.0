Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707F1256C8B;
	Wed, 25 Feb 2026 01:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983416; cv=none; b=o7L3BPcSu29/3i792OZxGa8j6v6nE3QjqHVKC4oShXCufowSWyjDT0wxiSWmNiE221IUfrWt3+ZOgFm54b5Y9MYsxrr2IrGJYblCs9sVphWJCuSnzIxxIIZEil8YAJCME/IvMyHLNeVqs9w4zWuusHksxccfbSgWjAJYQjIqpaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983416; c=relaxed/simple;
	bh=6KxPFP+Ec9Hrbr6MOc6ezdp/V+DhILhaIf9kOdgYXco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq22Q49JUXpo4PBCDwFhFsm2eok8pDki8nzZr1Go9tvF8bOWIySthGP5UXTmRm5QEyEuV47kw0PZfpwSNVuumBqZHx76NqxLnILN4Bmd6Ohx/2PnUeZ7uBTk/ofdD8Y1VWQXkc9YTlb7papuoDX+yuEVlZxYQ3rzbuTXuqD6MPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXnflfhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXnflfhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4368DC116D0;
	Wed, 25 Feb 2026 01:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983416;
	bh=6KxPFP+Ec9Hrbr6MOc6ezdp/V+DhILhaIf9kOdgYXco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXnflfhI2LSEU+Wl1YHd4F0kFxUI2+CjcS5a9piQbCWghjXqK9/c+51hikR+rSql0
	 WxyKC3TFhW3zbRBuL4DuFgXj4DytT3W3IqhZIvN09bZ4ZisO7ngFIfhUfdpmVAVtQY
	 oJkSgwFugEPiHGe4WAUnWFEbMweM55NvhvJIBhZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 537/781] clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk1_clk_src
Date: Tue, 24 Feb 2026 17:20:46 -0800
Message-ID: <20260225012412.970363388@linuxfoundation.org>
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
index 811d380a8e9f9..ed8e34ffd69b0 100644
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



