Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E63173;
	Tue, 30 Sep 2025 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245673; cv=none; b=CCXhxSJo1nHfYJLDcvlH+bc3S/qSApBn1hMJmouj1ZiIa4hUTjdHzUl6v+ZhWjGhx+l5uYfmEFt0Bk61Sd9UI7ShcPg8AT4RZX5WKC9Z19zDvzeYHvDxEqJoJQmbyfB8wAO2cKMRMW2oqQilUriY+h5GBP1IEbcxL0nJNAv9jBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245673; c=relaxed/simple;
	bh=gMGEr+nUf9VdWVsrTxqTuwSGnflNGlkl1o9fJYyK5Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I+kgRH/uulnze7yqbyG8WDVjb50HJLANxMOL2N6yjUXWjHGQwC4E2G9IwOLycuC8IbRUgGWuBNW+TGfjL2Z6MCw3ZGlXqRvG/KHOWViA1wQazxy5S0eypYPsktEMJ8Dca9U9NT8UCfn61e3CklnSr/onypOtkQQlvi5cnI7QhGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/udR+1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/udR+1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AF6C4CEF0;
	Tue, 30 Sep 2025 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245673;
	bh=gMGEr+nUf9VdWVsrTxqTuwSGnflNGlkl1o9fJYyK5Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/udR+1oRsja7aMD24/kDdtBcQe8zljR0xF8iBz6V/ipjDnB3lTxFLsu1G5gwFMHW
	 mGtzTCa8Sjby+bKGwGapuf6LnruXQP3POZ6g5gRPJSBsniodeWmDZ72ZL4Q9jiGmQZ
	 BTnZpCkuBNHs5lUbhkx7oMWf9CSEH+yUkRxIltQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/91] mmc: sdhci-cadence: add Mobileye eyeQ support
Date: Tue, 30 Sep 2025 16:47:15 +0200
Message-ID: <20250930143821.805060967@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@bootlin.com>

[ Upstream commit 120ffe250dd95b5089d032f582c5be9e3a04b94b ]

The MMC/SDHCI controller implemented by Mobileye needs the preset value
quirks to configure the clock properly at speed slower than HS200.
It otherwise works as a standard sd4hc controller.

Signed-off-by: Benoît Monin <benoit.monin@bootlin.com>
Link: https://lore.kernel.org/r/e97f409650495791e07484589e1666ead570fa12.1750156323.git.benoit.monin@bootlin.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-cadence.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-cadence.c
index be1505e8c536e..7759531ccca70 100644
--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -433,6 +433,13 @@ static const struct sdhci_cdns_drv_data sdhci_elba_drv_data = {
 	},
 };
 
+static const struct sdhci_cdns_drv_data sdhci_eyeq_drv_data = {
+	.pltfm_data = {
+		.ops = &sdhci_cdns_ops,
+		.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	},
+};
+
 static const struct sdhci_cdns_drv_data sdhci_cdns_drv_data = {
 	.pltfm_data = {
 		.ops = &sdhci_cdns_ops,
@@ -595,6 +602,10 @@ static const struct of_device_id sdhci_cdns_match[] = {
 		.compatible = "amd,pensando-elba-sd4hc",
 		.data = &sdhci_elba_drv_data,
 	},
+	{
+		.compatible = "mobileye,eyeq-sd4hc",
+		.data = &sdhci_eyeq_drv_data,
+	},
 	{ .compatible = "cdns,sd4hc" },
 	{ /* sentinel */ }
 };
-- 
2.51.0



