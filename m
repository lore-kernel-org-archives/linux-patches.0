Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7287613B2A2;
	Tue, 27 Feb 2024 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042895; cv=none; b=p2JH0uFXpIe/0CD3bXacISm8cbO2WRTl3037U0pi93R2ii4uCXOwxOxHwhEARoG96O54LVvGEjlCnREtvVKFqGt7sY6pNBMaEYBGi2dp3XqleQto/Jc8h9FRoZL3jgnLGxhdwteRAF+oNlSt4Rg8iRKWaas4Dm6JcBfWoN0+Mds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042895; c=relaxed/simple;
	bh=BCqo6yHSJ9WQg1xe0pdNntPEUGvzumcOg0Gz+oD//Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxRfS69Te+96DkJDpOxctm1aZfmcSUnAqMlcy06lecVxiLGz+7lSa7cH15z3tamuzyO1+lqlERB1Dt0ARdLJNWZFNgMqQvbYTgFKGds9TSa5BfkwKP6rxUMPk0ZOYWYc/WY9YZ879jD48MF+4MEaulylJct5qVQwBJ45wFG7F8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rpGfDFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rpGfDFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1512C433F1;
	Tue, 27 Feb 2024 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042895;
	bh=BCqo6yHSJ9WQg1xe0pdNntPEUGvzumcOg0Gz+oD//Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rpGfDFPR2mI8WjTX5aH+OU8dUqaQj84yLblOjoOiRh7EfVJ5gAfhhSbnnDOGdVyV
	 /HDOIo33dALKSwBT+aYkGe2k0nRYIYIR73CImaSeC339Qpe0R6vVVeQcygLAzLSHCG
	 6RaOjyFk6lUY55+E2OM6UjNq9hfcxmN2LJKZpClk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jeff LaBundy <jeff@labundy.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/245] Input: iqs269a - switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()
Date: Tue, 27 Feb 2024 14:25:48 +0100
Message-ID: <20240227131620.410284603@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 29eac950768a48651e2389f7d3f2ad597f6e58d1 ]

SIMPLE_DEV_PM_OPS() is deprecated as it requires explicit protection
against unused function warnings.  The new combination of pm_sleep_ptr()
and DEFINE_SIMPLE_DEV_PM_OPS() allows the compiler to see the functions,
thus suppressing the warning, but still allowing the unused code to be
removed. Thus also drop the __maybe_unused markings.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230102181842.718010-9-jic23@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 18ab69c8ca56 ("Input: iqs269a - do not poll during suspend or resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index 1530efd301c24..07eda05d783ef 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -1687,7 +1687,7 @@ static int iqs269_probe(struct i2c_client *client)
 	return error;
 }
 
-static int __maybe_unused iqs269_suspend(struct device *dev)
+static int iqs269_suspend(struct device *dev)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 	struct i2c_client *client = iqs269->client;
@@ -1746,7 +1746,7 @@ static int __maybe_unused iqs269_suspend(struct device *dev)
 	return error;
 }
 
-static int __maybe_unused iqs269_resume(struct device *dev)
+static int iqs269_resume(struct device *dev)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 	struct i2c_client *client = iqs269->client;
@@ -1793,7 +1793,7 @@ static int __maybe_unused iqs269_resume(struct device *dev)
 	return error;
 }
 
-static SIMPLE_DEV_PM_OPS(iqs269_pm, iqs269_suspend, iqs269_resume);
+static DEFINE_SIMPLE_DEV_PM_OPS(iqs269_pm, iqs269_suspend, iqs269_resume);
 
 static const struct of_device_id iqs269_of_match[] = {
 	{ .compatible = "azoteq,iqs269a" },
@@ -1805,7 +1805,7 @@ static struct i2c_driver iqs269_i2c_driver = {
 	.driver = {
 		.name = "iqs269a",
 		.of_match_table = iqs269_of_match,
-		.pm = &iqs269_pm,
+		.pm = pm_sleep_ptr(&iqs269_pm),
 	},
 	.probe_new = iqs269_probe,
 };
-- 
2.43.0



