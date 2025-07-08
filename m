Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E402DCF48;
	Tue,  8 Jul 2025 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994145; cv=none; b=KBr65bbv+TuzW+voKHp/XrKsN1Cn6ViupGEWGfKYsEl1aFlYP0akDG6jpaRcH7FNKKUA40CQ/HeZFoIvPJDGTc+iHD2V0eqDFlhYNz2nHLvCkMn4pYIjsDDuboLY92k/2QIjiPWzdMo7wzXyHEEBRczXe9puB7z2gPxtO6IAXXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994145; c=relaxed/simple;
	bh=3Etulblx/WvbCXQVQeAWmtNHCWzPibtbo6MQ4E+3VQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgBShoxgEAFI3iS+oF4cuxxXIsegkJaEFpA0mIWPOJXnwMUlzoXNdmpaKi6knGSc+u7qRTCjrbqNPnowZXouEEUB+wRM+2t6/BubdP5D3wcgyHQ583mbQHN2cXqBoeBvYWH+DtM8zIRrFdDe7pEvQU+XCjXOVbtBW1zAxOOO6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6owBOVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6owBOVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBA8C4CEED;
	Tue,  8 Jul 2025 17:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994145;
	bh=3Etulblx/WvbCXQVQeAWmtNHCWzPibtbo6MQ4E+3VQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6owBOVuNpQtrnNi4sPzkLqB56MNpiA/HKrK1Sb/OxaRwhKG7DO+mgLVn4PWcfhTg
	 8eU5eyK5aGz+/8ZaZ27GzUJvFIvpAHeK+IS4ULztZaVMXX8MBSpOagS3z3pMqNRFnM
	 bP8cslqWd2P4or7wOfBv8JL7caBoKnYvA0mnIuTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jonathan Liu <net147@gmail.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 100/160] Revert "mmc: sdhci: Disable SD card clock before changing parameters"
Date: Tue,  8 Jul 2025 18:22:17 +0200
Message-ID: <20250708162234.266847584@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit dcc3bcfc5b50c625b475dcc25d167b6b947a6637 upstream.

It has turned out the trying to strictly conform to the SDHCI specification
is causing problems. Let's revert and start over.

This reverts commit fb3bbc46c94f261b6156ee863c1b06c84cf157dc.

Cc: Erick Shepherd <erick.shepherd@ni.com>
Cc: stable@vger.kernel.org
Fixes: fb3bbc46c94f ("mmc: sdhci: Disable SD card clock before changing parameters")
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Reported-by: Jonathan Liu <net147@gmail.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Closes: https://bugs.debian.org/1108065
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250624110932.176925-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2009,15 +2009,10 @@ void sdhci_set_clock(struct sdhci_host *
 
 	host->mmc->actual_clock = 0;
 
-	clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
-	if (clk & SDHCI_CLOCK_CARD_EN)
-		sdhci_writew(host, clk & ~SDHCI_CLOCK_CARD_EN,
-			SDHCI_CLOCK_CONTROL);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
-	if (clock == 0) {
-		sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+	if (clock == 0)
 		return;
-	}
 
 	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
 	sdhci_enable_clk(host, clk);


