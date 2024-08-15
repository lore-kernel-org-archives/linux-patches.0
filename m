Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6285A18D630;
	Thu, 15 Aug 2024 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730041; cv=none; b=R0ffCNJb8WX7RWKc1CSmxcyYotmUNEV3I9jgCl6OQypauwPx+sIDp0C2/1wdDC+xYZSGTByMf8COWHp5MIUF9bUTvs/vzwtLsHteq/0EL09Ja9tEVIPCI8p8vWKUzPxQs1Q+MS1OCT2uZ0dbKw9lmrTbUAZtqmba0gPm00QaNLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730041; c=relaxed/simple;
	bh=HnyltDQseZGrIWEC4Q5YL5ahDtCVEV9mT0KZed47hrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofKTwQtvZG4Ewa7UlAMiAFLYAS8enLsuCTSc29yXiK6D8BrH+mcKk6QT7JcMeb4IKTLahxI54Yck3oAcYHk2K7o7Pt8MWqUN8ImX3JlCS9BM2eUxHD826hEHEmBfCkpbUHFO+lK+P9VY6jwEKcIXMoeGrZ59UUMxDRjJ/qDLqtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpFL1yI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpFL1yI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA214C4AF0D;
	Thu, 15 Aug 2024 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730041;
	bh=HnyltDQseZGrIWEC4Q5YL5ahDtCVEV9mT0KZed47hrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpFL1yI2BYN1sPwgXqKI0+y5cahhvOg/P2EnGVzBLb2wKk4czWQX73raNFHuXYVJo
	 67hVk8FEmeoQ7AcObjAECo1p4j8wx3UDHx98Tg7OgZjOOMpQLhUb3k+5YA0wZXilCB
	 pT5UfCSUevu4bpuFcjLOO6ctO3nfxsBDWzjg/QgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Tremblay <vincent@vtremblay.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/484] spidev: Add Silicon Labs EM3581 device compatible
Date: Thu, 15 Aug 2024 15:22:23 +0200
Message-ID: <20240815131952.415856156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Tremblay <vincent@vtremblay.dev>

[ Upstream commit c67d90e058550403a3e6f9b05bfcdcfa12b1815c ]

Add compatible string for Silicon Labs EM3581 device.

Signed-off-by: Vincent Tremblay <vincent@vtremblay.dev>
Link: https://lore.kernel.org/r/20221227023550.569547-2-vincent@vtremblay.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc28d1c1fe3b ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 4a19c2142e474..c083d511f63dd 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -690,6 +690,7 @@ static const struct spi_device_id spidev_spi_ids[] = {
 	{ .name = "m53cpld" },
 	{ .name = "spi-petra" },
 	{ .name = "spi-authenta" },
+	{ .name = "em3581" },
 	{},
 };
 MODULE_DEVICE_TABLE(spi, spidev_spi_ids);
@@ -716,6 +717,7 @@ static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
 	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
 	{},
 };
 MODULE_DEVICE_TABLE(of, spidev_dt_ids);
-- 
2.43.0



