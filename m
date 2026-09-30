Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369C51C050;
	Wed, 30 Sep 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791039; cv=none; b=dYYhPb/wrHS3FOAdtqRn1EzBiE8+qo8bfB68wAsae/VIMU+Li68YzprekGRJw9/U1+l9gH7d65t7PdJ1KTme9Giv8i6SfWVeBM0bAd0Mu570aHlg95Ua+lrQQGrXtjaiZP3C8DNHHh3xDre6lDZ+gAdt0zrjqctH2knmV0YDQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791039; c=relaxed/simple;
	bh=uxRjZIXKWiujdzy6UXnmYhPlvzojeg85EuUsoOaN74A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUBy94L/YRVkHoAnWy0HAa/0hXYGK/VeEFiS43vgLml3Zl4SOOnkWFb1Sr4Ou8Rzrcazv/h8k7Ti0MvJJ2rbP08o3FYTEnA6oorR3XUDMPrDpLerqYXUz8NaU2X19ErpOkvXCUsJfhtR3RQWFZ6a/PPL3ZNgt5ZxzbOcqolHBwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLdmy8WU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLdmy8WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0C51F000FF;
	Wed, 30 Sep 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791037;
	bh=RIBHPYJiCgz6PO4puZwbvZ2s3IeuHk4ksN4Tf0bGnxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLdmy8WUceclPCFa9eHPZDiGVvaaBLpLCEuGSzAhJjXPWaaTye0IC9k2DBWICGoBo
	 lnP8ZwyU7kvdhW4bkYp0OwPtHVtYM7J2qAOUohLjy8hq9DKQpkmv68WyenWuivUQlC
	 FCskeiQXZmsVC6vgSoEKaFjOkTKKF8fz5KU6Uizs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bystrin <dev.mbstr@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/752] mfd: rsmu: Add 8a34002 support
Date: Wed, 30 Sep 2026 17:20:31 +0200
Message-ID: <20260930152401.677942638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Matthew Bystrin <dev.mbstr@gmail.com>

[ Upstream commit d18fd55c780c2bae3d353024cab7f8746d3d9e91 ]

Add compatible string, i2c_devcie_id and spi_devcie_id to support
8a34002.

Signed-off-by: Matthew Bystrin <dev.mbstr@gmail.com>
Link: https://patch.msgid.link/20260429072047.1111427-3-dev.mbstr@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rsmu_i2c.c | 2 ++
 drivers/mfd/rsmu_spi.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu_i2c.c
index dc001c9791c16..8c25a15db9807 100644
--- a/drivers/mfd/rsmu_i2c.c
+++ b/drivers/mfd/rsmu_i2c.c
@@ -158,6 +158,7 @@ static int rsmu_i2c_remove(struct i2c_client *client)
 static const struct i2c_device_id rsmu_i2c_id[] = {
 	{ "8a34000",  RSMU_CM },
 	{ "8a34001",  RSMU_CM },
+	{ "8a34002",  RSMU_CM },
 	{ "82p33810", RSMU_SABRE },
 	{ "82p33811", RSMU_SABRE },
 	{ "8v19n850", RSMU_SL },
@@ -169,6 +170,7 @@ MODULE_DEVICE_TABLE(i2c, rsmu_i2c_id);
 static const struct of_device_id rsmu_i2c_of_match[] = {
 	{ .compatible = "idt,8a34000",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,8a34001",  .data = (void *)RSMU_CM },
+	{ .compatible = "idt,8a34002",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,82p33810", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,82p33811", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,8v19n850", .data = (void *)RSMU_SL },
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
index fec2b4ec477c5..d4891344bba7d 100644
--- a/drivers/mfd/rsmu_spi.c
+++ b/drivers/mfd/rsmu_spi.c
@@ -232,6 +232,7 @@ static int rsmu_spi_remove(struct spi_device *client)
 static const struct spi_device_id rsmu_spi_id[] = {
 	{ "8a34000",  RSMU_CM },
 	{ "8a34001",  RSMU_CM },
+	{ "8a34002",  RSMU_CM },
 	{ "82p33810", RSMU_SABRE },
 	{ "82p33811", RSMU_SABRE },
 	{}
@@ -241,6 +242,7 @@ MODULE_DEVICE_TABLE(spi, rsmu_spi_id);
 static const struct of_device_id rsmu_spi_of_match[] = {
 	{ .compatible = "idt,8a34000",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,8a34001",  .data = (void *)RSMU_CM },
+	{ .compatible = "idt,8a34002",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,82p33810", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,82p33811", .data = (void *)RSMU_SABRE },
 	{}
-- 
2.53.0



