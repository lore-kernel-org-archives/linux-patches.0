Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6571D043E;
	Wed,  2 Oct 2024 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877303; cv=none; b=r3lw+3OCtHU8s5l2VD7tMrmPLr1On4eGnU6ho1jsOO9ik0ZkhTW+OR1eTTmV3+kUXUd1IgxXqyrHnIfCW0A9A6eoa78ObyMLNSNjuMcijKVpLvMcUEBo7WvbSxVTx2Yv7NwPzViufNbzQCr5NQ8/bcqkKIq3zNnbzu9Czvs/JL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877303; c=relaxed/simple;
	bh=ukK/eT4mNlFWc1P+mGkOPjzJrk9m0Apdsi+rLcpfSYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQMCryn3kMzFU7aRlJdi+gdgVwZ9kGn6agWlYCrjGeVgPz41wYdbkct/SQkFySJavW5U5trPEarP6Sq0dqqHazYlLF9aZuHN5oVOthlIBIwEf5UJkjrhopaANC0Aj6DnkDMHYgaHpQKN9P9RCGaQIrIe1kTKG2C4/jMRHhlAQqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpJ+DBqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpJ+DBqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4581CC4CEFC;
	Wed,  2 Oct 2024 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877302;
	bh=ukK/eT4mNlFWc1P+mGkOPjzJrk9m0Apdsi+rLcpfSYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpJ+DBqj/qjpqJ/7SQs18G0DxPpCF80RGK8jMENZH7xs+R3BsA+m3daL92OFG8AY/
	 4LC/nI041uOTTLNTzY+xwSCvgbHaWk5ZiOkEqXcjjbpdjHTOsQBPQXckLUWhmLomZa
	 9xfK8A4CHpqsBVwIdO1g3vGAwQLAq05LIm+SPuQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 009/634] ACPI: PMIC: Remove unneeded check in tps68470_pmic_opregion_probe()
Date: Wed,  2 Oct 2024 14:51:49 +0200
Message-ID: <20241002125811.459091058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index ebd03e4729555..0d1a82eeb4b0b 100644
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



