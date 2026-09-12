Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D780282F1B;
	Sat, 12 Sep 2026 07:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199020; cv=none; b=XAd0CxGvK0Grh+jabZvJCQmBrzGcjMUVi2XMMYYamvY7oWIlRWb5CcrjgXY0PS1Og3Bqg2j8EwTzSYsw3jYcPagPiLOHwKZZNKac++v8dhDUzJJX0wXSBSPsQSxna7HTRfbUQW1JPGqg4+okbyvyLMap9nyLqJs/eNQHTbkv2nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199020; c=relaxed/simple;
	bh=+El+wrQtYodByNOlaRcO/H/xT7kbxzb96yPLplDmq1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYv+bJGdpsurKt/FQvYizE8rpW8QAHx1jOe1c5V0QNxOKJFirxx9QPWx4UaeN/SnBX0BFpb4eciHC4jQ7b8zj5fxAtggKxBJC/EbVWAa4qrSqRLOumMCtE+9QJ9Qfz0IG3oPsHWy5TfY3hTLKOew34itQI9XypDl4oCIzugELAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDCOKK3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDCOKK3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA58D1F000FF;
	Sat, 12 Sep 2026 07:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199018;
	bh=d4WSJq1cxL9QcNo4V00EN+m09ruZSFLXlMLFJ+w8hAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDCOKK3UO6HEuJAlTesMhIuXm+l06coVFKPCKMG4J76oBEtExnbWd2l8LGRFFjIbW
	 k2fSs3r3yHyXpDh7JOpqGxW7ol3sRiuNv58ktnqz43LZEwidRDy/R/4aGMRcnWzz40
	 4Z6w/VfwU9Un6dG7sgfpa2nNiwi2r89Y7JFmTsho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0497/1815] misc: pch_phub: Complete enum usage for device identification
Date: Sat, 12 Sep 2026 08:37:27 +0200
Message-ID: <20260912065700.559653201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit 077b4d1aa01a1b34c5b768b8c7a77c74b35b190b ]

Recently an enum was introduced to identify the different hardware
variants instead of magic constants. The respective commit however
missed to adapt one code location that still checks the old values.

As the values shifted by one this is a relevant fix.

Fixes: 7b1d4ad96ea4 ("misc: pch_phub: Introduce an enum for device indentification")
Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/8a97d9d5fb0a4abf7032324643e3e2337b1347bd.1779785111.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pch_phub.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 19c4fa017f243..0097611b97af6 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -83,6 +83,14 @@
 
 #define PCH_PHUB_OROM_SIZE 15360
 
+enum pch_phub_type {
+	PCH_EG20T,
+	PCH_ML7213,
+	PCH_ML7223M,
+	PCH_ML7223N,
+	PCH_ML7831,
+};
+
 /**
  * struct pch_phub_reg - PHUB register structure
  * @phub_id_reg:			PHUB_ID register val
@@ -125,7 +133,7 @@ struct pch_phub_reg {
 	void __iomem *pch_phub_extrom_base_address;
 	u32 pch_mac_start_address;
 	u32 pch_opt_rom_start_address;
-	int ioh_type;
+	enum pch_phub_type ioh_type;
 	struct pci_dev *pdev;
 };
 
@@ -344,7 +352,7 @@ static int pch_phub_write_gbe_mac_addr(struct pch_phub_reg *chip, u8 *data)
 	int retval;
 	int i;
 
-	if ((chip->ioh_type == 1) || (chip->ioh_type == 5)) /* EG20T or ML7831*/
+	if (chip->ioh_type == PCH_EG20T || chip->ioh_type == PCH_ML7831)
 		retval = pch_phub_gbe_serial_rom_conf(chip);
 	else	/* ML7223 */
 		retval = pch_phub_gbe_serial_rom_conf_mp(chip);
@@ -537,14 +545,6 @@ static const struct bin_attribute pch_bin_attr = {
 	.write = pch_phub_bin_write,
 };
 
-enum {
-	PCH_EG20T,
-	PCH_ML7213,
-	PCH_ML7223M,
-	PCH_ML7223N,
-	PCH_ML7831,
-};
-
 static int pch_phub_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
-- 
2.53.0



