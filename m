Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3CC1F76B6;
	Tue,  3 Dec 2024 15:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238785; cv=none; b=Yw8mASbCLmPaTwbRbPJAlhReHfsRROZiPwiMZXDAAt74kC2q7QBwLtpeHYNP9mFgZMZQNgy4su6PLtgMZV+1SMPlufcB0Pj80vZt99bzhN5rL0WJUrAetnXfHxMyF14fICTl9NlQwMUDg32zVs3rEozq1/+RWJoBJ8GqNrtAqs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238785; c=relaxed/simple;
	bh=5caMOOc+Nfv411rBBOXUaNNWINyaHNReTKf4rQVXpGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mosXNKv+cykCryhO4nIFXLNsc1Eww3PRiPuA3HQz2IBrAZ73+VTYxGKp7bK9zTo8ObkMFJiV7AUqCVB35HDcJaCAJy+T7IOJkqUjY5CCyGbo3AtjRaWArUXd8moQlGVblY3nCTPDQlG2zWnV2H/sXey+YOZfqech5GhTe3B2n7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVue7kU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVue7kU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8854EC4CECF;
	Tue,  3 Dec 2024 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238784;
	bh=5caMOOc+Nfv411rBBOXUaNNWINyaHNReTKf4rQVXpGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVue7kU/02ar6BX5RsTxIAwbi8D3BS7dTR+XU7rPv2aJ0IdPbdjVI3klg0Jau71eE
	 umeUK942vYrr2SYPi2MK6I78T+vNilwq7HOhaniOrtL/DgdzjTEqiq2S0F+595xXBm
	 DKXMMOWkzgLJ61QCUZQQ13xegRxOyFMw1wUB9+oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 395/817] mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication
Date: Tue,  3 Dec 2024 15:39:27 +0100
Message-ID: <20241203144011.292903178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3727c0b4ff6ba0e61203544b4c831f7f8899753b ]

For all of the devices regmap IRQ may try to created the folder
with the same name which is impossible and fails with:

  debugfs: File '\_SB.IPC1.PMIC' in directory 'domains' already present!

Add domain_suffix to all of the IRQ chips driver registers to solve
the issue.

Fixes: 39d047c0b1c8 ("mfd: add Intel Broxton Whiskey Cove PMIC driver")
Fixes: 957ae5098185 ("platform/x86: Add Whiskey Cove PMIC TMU support")
Fixes: 57129044f504 ("mfd: intel_soc_pmic_bxtwc: Use chained IRQs for second level IRQ chips")
Depends-on: dde286ee5770 ("regmap: Allow setting IRQ domain name suffix")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241005193029.1929139-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index f588e0f1fd0ad..b65f604a1eec3 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -149,6 +149,7 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip = {
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_pwrbtn = {
 	.name = "bxtwc_irq_chip_pwrbtn",
+	.domain_suffix = "PWRBTN",
 	.status_base = BXTWC_PWRBTNIRQ,
 	.mask_base = BXTWC_MPWRBTNIRQ,
 	.irqs = bxtwc_regmap_irqs_pwrbtn,
@@ -158,6 +159,7 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip_pwrbtn = {
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_tmu = {
 	.name = "bxtwc_irq_chip_tmu",
+	.domain_suffix = "TMU",
 	.status_base = BXTWC_TMUIRQ,
 	.mask_base = BXTWC_MTMUIRQ,
 	.irqs = bxtwc_regmap_irqs_tmu,
@@ -167,6 +169,7 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip_tmu = {
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_bcu = {
 	.name = "bxtwc_irq_chip_bcu",
+	.domain_suffix = "BCU",
 	.status_base = BXTWC_BCUIRQ,
 	.mask_base = BXTWC_MBCUIRQ,
 	.irqs = bxtwc_regmap_irqs_bcu,
@@ -176,6 +179,7 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip_bcu = {
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_adc = {
 	.name = "bxtwc_irq_chip_adc",
+	.domain_suffix = "ADC",
 	.status_base = BXTWC_ADCIRQ,
 	.mask_base = BXTWC_MADCIRQ,
 	.irqs = bxtwc_regmap_irqs_adc,
@@ -185,6 +189,7 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip_adc = {
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_chgr = {
 	.name = "bxtwc_irq_chip_chgr",
+	.domain_suffix = "CHGR",
 	.status_base = BXTWC_CHGR0IRQ,
 	.mask_base = BXTWC_MCHGR0IRQ,
 	.irqs = bxtwc_regmap_irqs_chgr,
@@ -194,6 +199,7 @@ static struct regmap_irq_chip bxtwc_regmap_irq_chip_chgr = {
 
 static struct regmap_irq_chip bxtwc_regmap_irq_chip_crit = {
 	.name = "bxtwc_irq_chip_crit",
+	.domain_suffix = "CRIT",
 	.status_base = BXTWC_CRITIRQ,
 	.mask_base = BXTWC_MCRITIRQ,
 	.irqs = bxtwc_regmap_irqs_crit,
-- 
2.43.0



