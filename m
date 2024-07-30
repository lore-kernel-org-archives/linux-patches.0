Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15401898F2;
	Tue, 30 Jul 2024 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359194; cv=none; b=NNlH6CCHNWXCLkMwx9m5JQK8VFuyw4wvJ0y+IztNlxy2cexsdHk0B9oVZAFPkCsTERhAilRodLaIBGTk/YyVExhRVYZs0zF5q6fLPY3mPFxZD2/7DNV6RUYSOdYv0g9ajud8VPxReJxiw/KWBXFt6b/wNyxPKsGoDTaoSrgTuko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359194; c=relaxed/simple;
	bh=VG1CU6eqWMgdnN1G9jtzV/1hT7cD5Q+6woic/yAZh1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rmpad/7kbiR9UHzUBn0kCvYco8WlVd5+/bz/mjCFj8P6Xxl9D7qLggCskwmgBb5D4MY/tZcyPQDuN+OnpdbQhfJ7XYsky2PL47HLT0NB6yEN0H4kwED9KiMArF2xsPiWibzyEsrbCAaOXhOimqP/o7lMUk5ZNkXNd3gnuQWVpC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTlV4+RE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTlV4+RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45B3C4AF12;
	Tue, 30 Jul 2024 17:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359194;
	bh=VG1CU6eqWMgdnN1G9jtzV/1hT7cD5Q+6woic/yAZh1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTlV4+RE7BtpB3Ynf3lJyqBIq15Q2ixvRdAHDSNGWuITflEO52fQa2Uz4Gw3WxwPz
	 W2biayVo/7HkT5aJjPsBS+/F5/YtkjM0dbrVrj6YxBPz6NWChhDAahU+zWQDqPUZbw
	 qSWa7GLIAJDsSPpnN7p3MEQgqVHyRjq5FXpl8Wqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 449/809] clk: qcom: kpss-xcc: Return of_clk_add_hw_provider to transfer the error
Date: Tue, 30 Jul 2024 17:45:25 +0200
Message-ID: <20240730151742.442189282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 23b0b11f00077..e7cfa8d22044e 100644
--- a/drivers/clk/qcom/kpss-xcc.c
+++ b/drivers/clk/qcom/kpss-xcc.c
@@ -58,9 +58,7 @@ static int kpss_xcc_driver_probe(struct platform_device *pdev)
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



