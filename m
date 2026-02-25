Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A7030CD94;
	Wed, 25 Feb 2026 06:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002653; cv=none; b=cahv018Gc/+auNSZeSjn3hmTTfhwjI2X8leTjhKX0VWw32+PQOj5IIIblKlSbOlQOlv4ILLdS2T9V8UejjX7fo8bSAPWoMDgesC67b9VybohCudVShxuZEqHUjTWlhCiOVIDGOdiBIcPEOPPtchYQNlF6w3NgCKKd8ZwDsr1CoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002653; c=relaxed/simple;
	bh=zkZH3qTAiOXHBE5bbuuQdle9QBtHX3rTDNXyBCLzOis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkSW9Tnh72rT89FO7AEzrdToBzA3HVaYPVR+eJpkWRnH+RNH4pECKiEPKBsflf48t8u5TuaUUa+X0/E6/pLAjh5o0kKqxUeZaJUePEf7FuHSrrwYdR7xb2purUydV+hqNU/QeZrewL+VAitjl7XImItW6j7JNo+jnSs/B8YC1+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mw6NCZXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mw6NCZXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE56C116D0;
	Wed, 25 Feb 2026 06:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002653;
	bh=zkZH3qTAiOXHBE5bbuuQdle9QBtHX3rTDNXyBCLzOis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mw6NCZXmC05tUDfLaXL/uFoMwb5+QzVaeo9lHw72chimQh0YP3T+Ojmw2DXBdxlPJ
	 Gfp07aTDShX0ZCPQz6ENIFMc1MeeObGJl6eXuLSXP3bvVQ/7ZOtH3dw0aB7FTAf8LF
	 /Iwza6OE5kaaz7jI4HjkCILv08/VH3ObE6r2+jtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/641] clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk1_clk_src
Date: Tue, 24 Feb 2026 17:22:34 -0800
Message-ID: <20260225012358.917329655@linuxfoundation.org>
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
index ddc7230b8aea7..923f0f38e804c 100644
--- a/drivers/clk/qcom/dispcc-sm7150.c
+++ b/drivers/clk/qcom/dispcc-sm7150.c
@@ -370,7 +370,7 @@ static struct clk_rcg2 dispcc_mdss_pclk1_clk_src = {
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



