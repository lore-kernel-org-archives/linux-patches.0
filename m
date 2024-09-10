Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50F214D280;
	Tue, 10 Sep 2024 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964662; cv=none; b=qm1I+R3Fq+3Lbqi9+djydxpR4wjOpF9Ivfomm38t7gbwId2zkjKBsKg5TzDqo686AFm1Mec7j5bfjT7IkApewVotLX97U5t7zgZLokLoLlCrjibMJ1jkENbEKpWQda2IAZbuKPXwr2tHBdN3yyM6bUR27R0nZGDI7pVNVmHhr6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964662; c=relaxed/simple;
	bh=LmmOjUWHGiKC0MzOMkfGA8tF+6M8e3BAF9gpnpdOr50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdCXXHk6Q70c0DBI5n/Y6G/+qpSeoV3MPic6o2a6dSsPOVJIhLmrC+oFkPIjAWBbhTFMLPHnmi6S2tLKpNuRENnRdCiaBtGEU9xZnAOT2xovhlok/szuxUis+zqR8+M5qIT8jrTVAbvsSZMzfhOEbQXs9WXsUozT1ez5OJ1VRgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cX+HuAYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cX+HuAYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEED4C4CEC3;
	Tue, 10 Sep 2024 10:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964662;
	bh=LmmOjUWHGiKC0MzOMkfGA8tF+6M8e3BAF9gpnpdOr50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cX+HuAYP30PBtty66jr/YUMEu0dyeqrLAXaiv9vI7zxLKvJ3C0YCexbEvC1aF8NWz
	 sfJFfGcjKISmX8HfqmeQUxEjWcPD6/7gw8nbjAhPlZPqBPoK+BM916MZoEo4Ed8JSv
	 CenSjnrJx8FPXwWQauqjO2hc4nF67P4TxhhyQLSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/269] gpio: modepin: Enable module autoloading
Date: Tue, 10 Sep 2024 11:34:05 +0200
Message-ID: <20240910092616.972278095@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit a5135526426df5319d5f4bcd15ae57c45a97714b ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Fixes: 7687a5b0ee93 ("gpio: modepin: Add driver support for modepin GPIO controller")
Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20240902115848.904227-1-liaochen4@huawei.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynqmp-modepin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-zynqmp-modepin.c b/drivers/gpio/gpio-zynqmp-modepin.c
index a0d69387c153..2f3c9ebfa78d 100644
--- a/drivers/gpio/gpio-zynqmp-modepin.c
+++ b/drivers/gpio/gpio-zynqmp-modepin.c
@@ -146,6 +146,7 @@ static const struct of_device_id modepin_platform_id[] = {
 	{ .compatible = "xlnx,zynqmp-gpio-modepin", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, modepin_platform_id);
 
 static struct platform_driver modepin_platform_driver = {
 	.driver = {
-- 
2.43.0



