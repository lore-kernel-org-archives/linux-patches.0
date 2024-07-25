Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9321919DF64;
	Thu, 25 Jul 2024 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721925999; cv=none; b=q4hTJxJ/cutpLD+aZggZ7t40TZ52+2g53h+tVc25thVBOwEG8UnX8K1SoBL6FT7h/yfc+93POuVX9ikXcsRYkhi/USJfbIVCUhZsSPgOfzw4JIrrYHBm/5Ec0Pqh8tEm+MSlM21oV+bgy9zdXz1CLgGR2Ws+bW3C0vPePNtAruw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721925999; c=relaxed/simple;
	bh=BB6mD9MVfalBY2Sh8QiPsmLsNCeDOP5OqjX1/QypdnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eulFsQjd73yvAGDSt3xdRURiUfU1ApXiEJ0W/wtQyMhk4IWakdBWDPfiaFguFPRSbZAQVlW1j3Al6Tx3o2RicKiG51VF6njjSJivILixYCrNrPzNGM3/ToyaU6uPn9L02Siubci/roGPqwzEFOjGKZzifHMWo0UnsmSdv4/L4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+d91RQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+d91RQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D1DC4AF0E;
	Thu, 25 Jul 2024 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721925999;
	bh=BB6mD9MVfalBY2Sh8QiPsmLsNCeDOP5OqjX1/QypdnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+d91RQ2OsaoskFRNBR8TuJagp//xrXXJwHZpmg9ujOutiIBRvbkg1dT/Hr0FLDS6
	 JR91ucZ15amlWT4aHeLYvZlPG4cSxFWmwtvsJDqv2BoS2whS5qLtYNwcuLS1LfCEWV
	 cpVbLqoVHAE2hyxF7JT3f7BmEaETBx9KUQ9AyeFoHx2K2EH5ECb4w6GE7ZrsFEeo62
	 tDaqn6XJ7CujZ1E/Pv01m+7iuMn+Lfb+AQQfuvxQRVa/SozCfK0+Tg7QqMBI65i/U8
	 cWa5cLA/wS7AXNlfPB0puTwyxr66I2hFp2h3w5YoeudvputdLsy0wqxuSpbFH2/cq5
	 F0JU21qp5LrCg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Collins <quic_collinsd@quicinc.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 3/3] spmi: pmic-arb: add missing newline in dev_err format strings
Date: Thu, 25 Jul 2024 09:46:33 -0700
Message-ID: <20240725164636.3362690-4-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
In-Reply-To: <20240725164636.3362690-1-sboyd@kernel.org>
References: <20240725164636.3362690-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Collins <quic_collinsd@quicinc.com>

dev_err() format strings should end with '\n'.  Several such
format strings in the spmi-pmic-arb driver are missing it.
Add newlines where needed.

Fixes: 02922ccbb330 ("spmi: pmic-arb: Register controller for bus instead of arbiter")
Signed-off-by: David Collins <quic_collinsd@quicinc.com>
Link: https://lore.kernel.org/r/20240703221248.3640490-1-quic_collinsd@quicinc.com
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index b6880c13163c..9ba9495fcc4b 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -398,7 +398,7 @@ static int pmic_arb_fmt_read_cmd(struct spmi_pmic_arb_bus *bus, u8 opc, u8 sid,
 
 	*offset = rc;
 	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
-		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested",
+		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested\n",
 			PMIC_ARB_MAX_TRANS_BYTES, len);
 		return  -EINVAL;
 	}
@@ -477,7 +477,7 @@ static int pmic_arb_fmt_write_cmd(struct spmi_pmic_arb_bus *bus, u8 opc,
 
 	*offset = rc;
 	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
-		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested",
+		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested\n",
 			PMIC_ARB_MAX_TRANS_BYTES, len);
 		return  -EINVAL;
 	}
@@ -1702,7 +1702,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	index = of_property_match_string(node, "reg-names", "cnfg");
 	if (index < 0) {
-		dev_err(dev, "cnfg reg region missing");
+		dev_err(dev, "cnfg reg region missing\n");
 		return -EINVAL;
 	}
 
@@ -1712,7 +1712,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	index = of_property_match_string(node, "reg-names", "intr");
 	if (index < 0) {
-		dev_err(dev, "intr reg region missing");
+		dev_err(dev, "intr reg region missing\n");
 		return -EINVAL;
 	}
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

