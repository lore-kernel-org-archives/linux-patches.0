Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35232D4805;
	Wed, 25 Feb 2026 06:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002682; cv=none; b=obHilJNZX3Vssy689T6pe+GHVGlnY6SOGjZFCBq+3xAmq5iscrauywenzi6U8bppqmAbjmYP2SOtkgHZrmNdXcN9ApH2JzywMlg7sCwHj4vex/mliswGyMNuoo8xeNMyinRG1xxIEYZvh5eGIdaBlVKJT3gogXjEGaGQl0CZW3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002682; c=relaxed/simple;
	bh=rcYXMfC11fvvIHI1l0OxwE4O/iFWHrRJz9hdbu3mtaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asGEMBRrO/Ftcx6F3xo0zqAeaWO6nbndhhfjV1gMEos3VCQFqnXgOXMg8Rlb8oXIlDKyfZ6DSR+TJHM1D0i6kgZGxgBj5wVt2uycwA6d+EdFRCcly1hRU5yWxJz24NfbsdeSu9sY9iXt6OvlGAEdRM51zibr3eR5++amusrY5tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUfqnb20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUfqnb20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB82BC116D0;
	Wed, 25 Feb 2026 06:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002681;
	bh=rcYXMfC11fvvIHI1l0OxwE4O/iFWHrRJz9hdbu3mtaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUfqnb20enNGwNqoNnyZO4Ms5Nob0qbL5a7L0TxocbRtOYhDHo8rieS6R7pETvb/V
	 PtC1jpOKEA53HF+sYNGsbrkLwHjB88K3umwV9yaYAGStcIPv9HoCkyr6LPnusVuEvg
	 7cuvC8I7G91SI8qlnFPGz5EJQXYf+AwZm67Kv05A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Hodina <petr.hodina@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/641] clk: qcom: dispcc-sdm845: Enable parents for pixel clocks
Date: Tue, 24 Feb 2026 17:22:33 -0800
Message-ID: <20260225012358.893209602@linuxfoundation.org>
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

From: Petr Hodina <petr.hodina@protonmail.com>

[ Upstream commit a1d63493634e98360140027fef49d82b1ff0a267 ]

Add CLK_OPS_PARENT_ENABLE to MDSS pixel clock sources to ensure parent
clocks are enabled during clock operations, preventing potential
stability issues during display configuration.

Fixes: 81351776c9fb ("clk: qcom: Add display clock controller driver for SDM845")
Signed-off-by: Petr Hodina <petr.hodina@protonmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20260107-stability-discussion-v2-1-ef7717b435ff@protonmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sdm845.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sdm845.c b/drivers/clk/qcom/dispcc-sdm845.c
index 2f9e9665d7e93..78e43f6d75026 100644
--- a/drivers/clk/qcom/dispcc-sdm845.c
+++ b/drivers/clk/qcom/dispcc-sdm845.c
@@ -280,7 +280,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 		.name = "disp_cc_mdss_pclk0_clk_src",
 		.parent_data = disp_cc_parent_data_4,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -295,7 +295,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk1_clk_src = {
 		.name = "disp_cc_mdss_pclk1_clk_src",
 		.parent_data = disp_cc_parent_data_4,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
-- 
2.51.0



