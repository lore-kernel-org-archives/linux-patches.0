Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FD71A619E;
	Tue, 30 Jul 2024 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357784; cv=none; b=I6l1m3ogsehVuakFmqwmEQMs/gMDdfd49nuaFyQ6KGcOCouoPcDqyOSZ3E7fFKDxRcx2fnkEnCPLtrp8jpZ5RlLv40ABS1Geo0XSHCd+9S20hmclhDMbxTn2dSPLQX7fFdK/3gRt8sqiXhyIoDmDzf+KX2O/KD4kdBTeBcLwkNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357784; c=relaxed/simple;
	bh=JTCs2ZyDvyG9w0XHGRY/g55fnNWjkLMB2C6jeTl4+/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvajayHANqdFMNHGq/WAHNQfxwYgylchIvjET6HDaXlCR3zIfzuIRA8O6J8z7PsVph///A15pdWi8kxnCY1NSqkG1mRt/MRiM/uPxQ46e+k1WtsWn06e6mQxkmo5OVWhIi51ESTJBsJkEq8crKgimSsbj8B8OjjfWW+WPxAPJSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y987XWa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y987XWa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF68C32782;
	Tue, 30 Jul 2024 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357784;
	bh=JTCs2ZyDvyG9w0XHGRY/g55fnNWjkLMB2C6jeTl4+/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y987XWa0D15hZ4Myz9DcE8LVK18aqdocaQQqFtWkGI52eUFmkSyUE34Hc1gx0RrfJ
	 4FzVKjERWRGfY78Uy6Fb71PVIdcyuvSmzL7MLnNOmtjyThY3Nb92aM/eRQyCgn68r3
	 rTPx+TbwAgOPq4v9soWVyBy18qaaav4fBkYOKxaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/568] clk: qcom: kpss-xcc: Return of_clk_add_hw_provider to transfer the error
Date: Tue, 30 Jul 2024 17:46:38 +0200
Message-ID: <20240730151651.247908083@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 9db4585eca22fcd0422a94ac792f87dcbf74b643 ]

Return of_clk_add_hw_provider() in order to transfer the error if it
fails.

Fixes: 09be1a39e685 ("clk: qcom: kpss-xcc: register it as clk provider")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240704073606.1976936-1-nichen@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/kpss-xcc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/kpss-xcc.c b/drivers/clk/qcom/kpss-xcc.c
index 97358c98c6c98..d8c1f2b41eeb3 100644
--- a/drivers/clk/qcom/kpss-xcc.c
+++ b/drivers/clk/qcom/kpss-xcc.c
@@ -63,9 +63,7 @@ static int kpss_xcc_driver_probe(struct platform_device *pdev)
 	if (IS_ERR(hw))
 		return PTR_ERR(hw);
 
-	of_clk_add_hw_provider(dev->of_node, of_clk_hw_simple_get, hw);
-
-	return 0;
+	return of_clk_add_hw_provider(dev->of_node, of_clk_hw_simple_get, hw);
 }
 
 static struct platform_driver kpss_xcc_driver = {
-- 
2.43.0



