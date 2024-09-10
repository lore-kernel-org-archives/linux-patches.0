Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB614D431;
	Tue, 10 Sep 2024 09:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962278; cv=none; b=qSjxamsV6B3Jo6vnBq30tUKnjG9V83WEG5S53B8QIt3z3pivzEH/bI9XRmmOFEoMOxzR4YK4DGPebdORVbZAgm8+3ZA2LIx19qjR8I1vRKoN+9kx5rOnQyg2T5i55to5wdj0n6pdzA/ImEPu98lNVB2io2ApXngh1JJ8MWOoF4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962278; c=relaxed/simple;
	bh=xrGtrQmyn8nd1trN6H81GLggUIBFAJQc3QOHo9ikeIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jurdNp704Ef0RjSbn7cGHNeUrIldOAZP1s5cS7dTjE0TeRU5YwNKwoWRG5Vjsxn8EZ+5YyEq4aoYeC+piryzuQ1QnXx2Na6NL1eK/Xzi5ipZDfclEOcbs6/+j88gYSKLg5oiJjojU+jeZ8cANpg+hE6QF/7t1+xGqJBSiZ/VZ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLD2j1ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLD2j1ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC11C4CEC3;
	Tue, 10 Sep 2024 09:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962278;
	bh=xrGtrQmyn8nd1trN6H81GLggUIBFAJQc3QOHo9ikeIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLD2j1uea24j3T/ZuSms3XXsIlVgt/dfptqndLs0KvM3CN/Hmvl36h1G2EOKTVTqR
	 v9j4JSQFx9KxPiGiaLkABupaeru5gJyDzI3XAOGB8yaIDmy8gqtEV6SUdtjjy82e6e
	 hD008cBB5I7mU9Vk4WC+EJ6S3J+vXKnEGMzorPrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 356/375] gpio: modepin: Enable module autoloading
Date: Tue, 10 Sep 2024 11:32:33 +0200
Message-ID: <20240910092634.558224694@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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



