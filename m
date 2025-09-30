Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EA61F3FED;
	Tue, 30 Sep 2025 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245996; cv=none; b=EOIMdXpx7m+A8+imD9FbCMrRl4WUHbk6Do3hlQLrqKOj++kcCE8U3JLRUPUSvNN8pinZGtyZZj8+rNurEBYR3OMdxAWwP0tLgKh7sQdt+wf9i43pWwJ7Cnn0ayHi/J31UtISGoE/sdwx2a06AMNMa+BnNBVJKcHvXzmf7FjlXFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245996; c=relaxed/simple;
	bh=D7RHVwTT3GViuNNwawXYyWl/IFOz/KmdrqWT26fxOHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hDdY4PBBDvf4nmJObtJGeXQgPnpGJ5/vAPY29Op8Z/i4BPOPkf00/SZW/m2zSMkWa6thRJd757NynFegmhOuK6iU+yAA12WRC0NpfxdRB2lQxY/X01U04lLDIlul7KcX30GfjwUxWeIpFOV0lTpqi2llDbglhUj8EoCAAWqZdTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgzVejD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgzVejD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D215DC113D0;
	Tue, 30 Sep 2025 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245996;
	bh=D7RHVwTT3GViuNNwawXYyWl/IFOz/KmdrqWT26fxOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgzVejD0jZJSvWlajXj9Ustxg1GrOrCenWTXcinRgjBF+/VQ035D5h8cOya2BTWp7
	 aveCpPr61VTdLZUT4qg46CKpkHnHLPPpeBeBKsQi+I0osfYKpTq90LpD5olL8PrIat
	 1KfOBTASruytePeS7UQ33UCYgmg+2PycV0h1uabA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/89] mmc: sdhci-cadence: add Mobileye eyeQ support
Date: Tue, 30 Sep 2025 16:47:34 +0200
Message-ID: <20250930143822.727545393@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



