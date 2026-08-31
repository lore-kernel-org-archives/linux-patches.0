Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF014A1E02;
	Mon, 31 Aug 2026 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183714; cv=none; b=RCmME6gTUeW/OEgxcaWkkJTU6nGvOH0MfhkJA+ZC6WLEdsc0HvC1uDchoncd2W4DoVGQtHNIqja+8iQJ/ys8Fk1MvS+mbdcFKGVwdfL4eOGErXbaFEg2AdUVnlEH7ioFF4K2FVIRIqFwxSjiFPHVnk5qgN2AWtYSYm4ys6hBu2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183714; c=relaxed/simple;
	bh=8QRNQGrPn3mKZUUf9FPk3LPYqaUmCLugOPk+PSUhL2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VfRfKrKNVbecdvExlX8Ar4/6AcvzF5JIaPJCtJqwiJjIh3whJyoSl1avM6baEiP4PF6WKh1nYnWOgSOCoOl6l1G8ry1gvOmsbd979QZx9LLAYjRQ7TMO4MGKn+o8IKbcnE9S+r9OYkoi2MzzMukjZPvDajHzzipvARMbRIoSReQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEl7rQbk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEl7rQbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD031F00A3E;
	Mon, 31 Aug 2026 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183712;
	bh=YqvMqISvbPGw6o1VNEIJCKDFu6iDAFc1lP0qvaruqM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEl7rQbkUmkb4QoPU9khKxrVuQku89iRwnflxMNJNUy5/uY6TcNDQqRhI7RO90sJz
	 dqfEHquyzT/82HB97p5Bw2g25YzIDh6QfWlN/g+A6j3Zzubp/J9uJxDND4R9TLHYL6
	 wBzKN1/P8LG8N4o4bvpQGbcmTaJ3qBLLXxHZG7E55OPZynarCymuhzvyjrTWf4JZLI
	 wzg7eCnC0OU5pFDuSs5YP8H7x95eCL5qSKo4OgLl4xok3IGTyybgCeu91hrT7vH0KG
	 DK6otHuzUg1XRwjeXD6x3DOJ/btdAek6RXPuCyfbE24J4i20+w9KF1CNY+MNd/7zAR
	 WKTCWqbCAMdHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Bystrin <dev.mbstr@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] mfd: rsmu: Add 8a34002 support
Date: Mon, 31 Aug 2026 09:24:48 -0400
Message-ID: <20260831133314.4125787-260-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Bystrin <dev.mbstr@gmail.com>

[ Upstream commit d18fd55c780c2bae3d353024cab7f8746d3d9e91 ]

Add compatible string, i2c_devcie_id and spi_devcie_id to support
8a34002.

Signed-off-by: Matthew Bystrin <dev.mbstr@gmail.com>
Link: https://patch.msgid.link/20260429072047.1111427-3-dev.mbstr@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git log --grep` searches finished with no matches — this
tree (6.18.44) doesn't have the `8a34002` commit yet, which matches the
earlier finding that only the DT binding lists it while the driver ID
tables do not.

That supports the **YES** backport recommendation: it's a small device-
ID addition to the existing `rsmu` driver, and the patch should apply
cleanly here.

 drivers/mfd/rsmu_i2c.c | 2 ++
 drivers/mfd/rsmu_spi.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu_i2c.c
index 9e5fc8259eec2..c57795ed20f4e 100644
--- a/drivers/mfd/rsmu_i2c.c
+++ b/drivers/mfd/rsmu_i2c.c
@@ -330,6 +330,7 @@ static void rsmu_i2c_remove(struct i2c_client *client)
 static const struct i2c_device_id rsmu_i2c_id[] = {
 	{ "8a34000",  RSMU_CM },
 	{ "8a34001",  RSMU_CM },
+	{ "8a34002",  RSMU_CM },
 	{ "82p33810", RSMU_SABRE },
 	{ "82p33811", RSMU_SABRE },
 	{ "8v19n850", RSMU_SL },
@@ -341,6 +342,7 @@ MODULE_DEVICE_TABLE(i2c, rsmu_i2c_id);
 static const struct of_device_id rsmu_i2c_of_match[] = {
 	{ .compatible = "idt,8a34000",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,8a34001",  .data = (void *)RSMU_CM },
+	{ .compatible = "idt,8a34002",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,82p33810", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,82p33811", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,8v19n850", .data = (void *)RSMU_SL },
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
index c931d8cea0a1a..e07f21482439e 100644
--- a/drivers/mfd/rsmu_spi.c
+++ b/drivers/mfd/rsmu_spi.c
@@ -241,6 +241,7 @@ static void rsmu_spi_remove(struct spi_device *client)
 static const struct spi_device_id rsmu_spi_id[] = {
 	{ "8a34000",  RSMU_CM },
 	{ "8a34001",  RSMU_CM },
+	{ "8a34002",  RSMU_CM },
 	{ "82p33810", RSMU_SABRE },
 	{ "82p33811", RSMU_SABRE },
 	{}
@@ -250,6 +251,7 @@ MODULE_DEVICE_TABLE(spi, rsmu_spi_id);
 static const struct of_device_id rsmu_spi_of_match[] = {
 	{ .compatible = "idt,8a34000",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,8a34001",  .data = (void *)RSMU_CM },
+	{ .compatible = "idt,8a34002",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,82p33810", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,82p33811", .data = (void *)RSMU_SABRE },
 	{}
-- 
2.53.0

