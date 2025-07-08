Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E2F8F5B;
	Tue,  8 Jul 2025 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993270; cv=none; b=nLSz2PkqDKa1hzYaRqiSJgGV/ICsBzMTUtYE3bLFajexTiUz02UGf36bOpAxs1nhB/th0e/gMrvcAY7Y7Nl46PtrL7OxrF0pI0GHCuHQodpWqMH43rgGD7g6IS0OreEexYTfkRhs5DnoW/L3rkOkVS0ikGFLZQniKT5n70rjCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993270; c=relaxed/simple;
	bh=HoKJMRI72N8N9EWNCaB6mH6YxBhXEPpAEHkbkHU8rP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuQ6JfOLcZEaY0PS+E+47f607fiXbgON8U6nu2NDMxm68X5/HYtz8aEfFExbxPhUP9VZGMJsOC2+DEmb0APIstHl4fqPIwMvgEhvDkOB1dASeq92FI4Yjz+N9/4Vw3mheCLKQMGSMd0cZ+egwFRE5ItFzH64Ur2IR6H5SvpecSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiNnY50u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiNnY50u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC467C4CEED;
	Tue,  8 Jul 2025 16:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993270;
	bh=HoKJMRI72N8N9EWNCaB6mH6YxBhXEPpAEHkbkHU8rP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiNnY50ua9EnzIf4aRzhUJSTQwGwMU7RUZ8YxilD7MMSHwfJP2khR3xlLbtOiZMW7
	 8Vp9UAJy3Avg0sgMEkLdV+wF3mlTOaKV/YujgNGyNgIp9QnkdWPyNLMsePTd0yZNGA
	 rcpjfqw0UlZTQUWT9TpYCcMpUXuQY7N1EKtBFzRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 017/178] mmc: sdhci-uhs2: Adjust some error messages and register dump for SD UHS-II card
Date: Tue,  8 Jul 2025 18:20:54 +0200
Message-ID: <20250708162236.997897664@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit 49b14db035135341f6cf4de7af6ac2cbc8ad29b6 upstream.

Adjust some error messages to debug mode and register dump to dynamic
debug mode to avoid causing misunderstanding it is an error.

Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250606110121.96314-4-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-uhs2.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/mmc/host/sdhci-uhs2.c
+++ b/drivers/mmc/host/sdhci-uhs2.c
@@ -99,8 +99,8 @@ void sdhci_uhs2_reset(struct sdhci_host
 	/* hw clears the bit when it's done */
 	if (read_poll_timeout_atomic(sdhci_readw, val, !(val & mask), 10,
 				     UHS2_RESET_TIMEOUT_100MS, true, host, SDHCI_UHS2_SW_RESET)) {
-		pr_warn("%s: %s: Reset 0x%x never completed. %s: clean reset bit.\n", __func__,
-			mmc_hostname(host->mmc), (int)mask, mmc_hostname(host->mmc));
+		pr_debug("%s: %s: Reset 0x%x never completed. %s: clean reset bit.\n", __func__,
+			 mmc_hostname(host->mmc), (int)mask, mmc_hostname(host->mmc));
 		sdhci_writeb(host, 0, SDHCI_UHS2_SW_RESET);
 		return;
 	}
@@ -335,8 +335,8 @@ static int sdhci_uhs2_interface_detect(s
 	if (read_poll_timeout(sdhci_readl, val, (val & SDHCI_UHS2_IF_DETECT),
 			      100, UHS2_INTERFACE_DETECT_TIMEOUT_100MS, true,
 			      host, SDHCI_PRESENT_STATE)) {
-		pr_warn("%s: not detect UHS2 interface in 100ms.\n", mmc_hostname(host->mmc));
-		sdhci_dumpregs(host);
+		pr_debug("%s: not detect UHS2 interface in 100ms.\n", mmc_hostname(host->mmc));
+		sdhci_dbg_dumpregs(host, "UHS2 interface detect timeout in 100ms");
 		return -EIO;
 	}
 
@@ -345,8 +345,8 @@ static int sdhci_uhs2_interface_detect(s
 
 	if (read_poll_timeout(sdhci_readl, val, (val & SDHCI_UHS2_LANE_SYNC),
 			      100, UHS2_LANE_SYNC_TIMEOUT_150MS, true, host, SDHCI_PRESENT_STATE)) {
-		pr_warn("%s: UHS2 Lane sync fail in 150ms.\n", mmc_hostname(host->mmc));
-		sdhci_dumpregs(host);
+		pr_debug("%s: UHS2 Lane sync fail in 150ms.\n", mmc_hostname(host->mmc));
+		sdhci_dbg_dumpregs(host, "UHS2 Lane sync fail in 150ms");
 		return -EIO;
 	}
 
@@ -417,12 +417,12 @@ static int sdhci_uhs2_do_detect_init(str
 		host->ops->uhs2_pre_detect_init(host);
 
 	if (sdhci_uhs2_interface_detect(host)) {
-		pr_warn("%s: cannot detect UHS2 interface.\n", mmc_hostname(host->mmc));
+		pr_debug("%s: cannot detect UHS2 interface.\n", mmc_hostname(host->mmc));
 		return -EIO;
 	}
 
 	if (sdhci_uhs2_init(host)) {
-		pr_warn("%s: UHS2 init fail.\n", mmc_hostname(host->mmc));
+		pr_debug("%s: UHS2 init fail.\n", mmc_hostname(host->mmc));
 		return -EIO;
 	}
 
@@ -504,8 +504,8 @@ static int sdhci_uhs2_check_dormant(stru
 	if (read_poll_timeout(sdhci_readl, val, (val & SDHCI_UHS2_IN_DORMANT_STATE),
 			      100, UHS2_CHECK_DORMANT_TIMEOUT_100MS, true, host,
 			      SDHCI_PRESENT_STATE)) {
-		pr_warn("%s: UHS2 IN_DORMANT fail in 100ms.\n", mmc_hostname(host->mmc));
-		sdhci_dumpregs(host);
+		pr_debug("%s: UHS2 IN_DORMANT fail in 100ms.\n", mmc_hostname(host->mmc));
+		sdhci_dbg_dumpregs(host, "UHS2 IN_DORMANT fail in 100ms");
 		return -EIO;
 	}
 	return 0;


