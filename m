Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238121D2784;
	Wed,  6 Nov 2024 12:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894870; cv=none; b=rimtFUXiopomfLjDxRpX4/NYof17aPOy9Vv7n2Ltj+h46rk/9Ev7ioUfZS/7AY5kSARQ6Pt18h+8Shr09mYbtEKK/qMcyyW9dJJn07DQq5Jdpt8nSOIJ7m/lPA1LGgkgX8yCMvNliMHeQTMML1rW9KgnAIcO1CZEoJMAcH+4AWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894870; c=relaxed/simple;
	bh=Dvo2g6aD4zrcZM+5psL/pFFYwYkiiRyFb1kO7/ZvOnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8eJQhgmOygABOYIkTvGuCLYr49u5BTqBeYOp1LoQ5QmmocyLlvLTapEhP8BxLxhNPGG+yfzK70x3hrKu3kFlLjrS3MBWcRi47ezdYTJr59Flso1/g2rs0X0x1vln8G9slmVJ97gPiCHGP/iDNgia+ZXvVOZOeHu5YxmAtU8wQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExRVlmb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExRVlmb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3962EC4CECD;
	Wed,  6 Nov 2024 12:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894869;
	bh=Dvo2g6aD4zrcZM+5psL/pFFYwYkiiRyFb1kO7/ZvOnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExRVlmb0p7PXx3SO0CdyHY8YZnGT1Ue2LUUyYVHB8xHuQXlkVNAmP6euuayFTSpno
	 KY/Kn94j/vSMhP4VrPDo9jH6OET6Xo2mdcW0qC/Bl41fPwlGQAyfRhY4JoGjmnu3tL
	 K5Blnj4+gmBZ9pbSYLZDE3nYng7GRsEdx8aMUh4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/350] ACPI: PMIC: Remove unneeded check in tps68470_pmic_opregion_probe()
Date: Wed,  6 Nov 2024 12:59:16 +0100
Message-ID: <20241106120321.571598928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 07442c46abad1d50ac82af5e0f9c5de2732c4592 ]

In tps68470_pmic_opregion_probe() pointer 'dev' is compared to NULL which
is useless.

Fix this issue by removing unneeded check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e13452ac3790 ("ACPI / PMIC: Add TI PMIC TPS68470 operation region driver")
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://patch.msgid.link/20240730225339.13165-1-amishin@t-argos.ru
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pmic/tps68470_pmic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pmic/tps68470_pmic.c b/drivers/acpi/pmic/tps68470_pmic.c
index a083de507009e..fde8a1271c9b6 100644
--- a/drivers/acpi/pmic/tps68470_pmic.c
+++ b/drivers/acpi/pmic/tps68470_pmic.c
@@ -376,10 +376,8 @@ static int tps68470_pmic_opregion_probe(struct platform_device *pdev)
 	struct tps68470_pmic_opregion *opregion;
 	acpi_status status;
 
-	if (!dev || !tps68470_regmap) {
-		dev_warn(dev, "dev or regmap is NULL\n");
-		return -EINVAL;
-	}
+	if (!tps68470_regmap)
+		return dev_err_probe(dev, -EINVAL, "regmap is missing\n");
 
 	if (!handle) {
 		dev_warn(dev, "acpi handle is NULL\n");
-- 
2.43.0



