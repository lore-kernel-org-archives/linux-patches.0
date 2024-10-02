Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327CC16F84F;
	Wed,  2 Oct 2024 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875188; cv=none; b=k7YQZ3n/JAGUYx5Nt7JmM2fWNNV/5PFg5lpZpH4bGHA44jr0B1BbV5PgtMyOtim/tNqgfavx5KuXPqk9BvIi00G4/CJMknp6Iw3AJG47QNTOi3Z+g1E5RKxyMS0BQVxbcsnF2kwLIS10DsHg3GUd0AUEioSboIaOFvsqTgjJ3Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875188; c=relaxed/simple;
	bh=z9PCtrPTuYW0ttC4Q/PY40J3juCW6cdhgoG/l2580fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMcXb3qRw218a/gyx7YPn6PB6UlqDQaa4tc6SfRpI/oMaVkOLccutueFq0b0h3zmnQZG1N+LfR49VANiJshZADTFjtZyi6eZ3Tqk0UXruRzZD2Dr/h5TZgqZu7kCDCGv44SgJRJz2114Pu2TVXR7HLnj8fgLtwOkeQ67C+903q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMFVYjbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMFVYjbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66977C4CEC5;
	Wed,  2 Oct 2024 13:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875187;
	bh=z9PCtrPTuYW0ttC4Q/PY40J3juCW6cdhgoG/l2580fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMFVYjbXxpW335Etobb8BZdbZg6Tc6KcaBn17xhSFZuBpCRKJ03wNAAQcWq18QJTY
	 1y0tltjCE3J1hizCY3i/IgDtF1heSrAvXirmFRqLbwmQlc/0fVOOwp20jf5yysY4Lr
	 1DqI9QMSxJfZ8haKCU0Kuz7KK/NoJvsOA41V3VMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 009/695] ACPI: PMIC: Remove unneeded check in tps68470_pmic_opregion_probe()
Date: Wed,  2 Oct 2024 14:50:07 +0200
Message-ID: <20241002125822.859190342@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



