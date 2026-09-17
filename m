Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45287547078;
	Thu, 17 Sep 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668261; cv=none; b=urzHefC+x8XJK3ZSRQpl51U6ovwh5V/2TR4SSvSFVCoFtgF7oQ5N1Up44vUA3olJaXtUlQNAqOAEwqwfvf3O5jBSABX0zcHMtGFipvuSI5jfVWEmEJEnbbMpAsjNQuqCr3bmeRuY8die/bm/rdPGBnsjISDH0NjE2YscQWj5IHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668261; c=relaxed/simple;
	bh=iC6iqjD3T37ezGIkZIjMLbc9kKU8VqtCLwa7GbV9QRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roAFQgJv6V0uFMkGykJ5KZpL5CMxv2QZGyGY8mlArnnLnS4Gn68hl5uXUJX1IIG9D/25uq6cH1oC5hzmvJ8OGgcKwXgtVERo9GGm0X+Jak08BP2ph0PcVGk+77E+fAurrmlBdh8x2cKF4QkDVXmIN8LN8aTZt1sVf4RbcmS+QNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZW9l/WS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZW9l/WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421821F000FF;
	Thu, 17 Sep 2026 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668259;
	bh=KppIBjtOuaoZf3ISy5JtkrYmcsBJ8mPFmfHEwsQk2ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZW9l/WSybGqmbgXJeoSO9GCc69OH7dsKdU7vYh4yj0DotjKmOROzbuGw98gw9wbh
	 4SX5mVHerIlCTngThO23RLsFkcXW/t3mV0bTo2ikVidBX8njWJzoTW1v8c/IRV1HBH
	 vi4oe0mQLZI2NpcQsSRwxbU2CqJe6EHy4/nUxf5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bystrin <dev.mbstr@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0328/1102] mfd: rsmu: Add 8a34002 support
Date: Thu, 17 Sep 2026 16:04:31 +0100
Message-ID: <20260917151547.866283600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



