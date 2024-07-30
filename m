Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AEA83A17;
	Tue, 30 Jul 2024 17:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358872; cv=none; b=RokDACwF1yMQdHs+N+JDxwJPKXwCZ7uKn3ObRoDXsa2hKxbcFgZNeqICwA+pLzCLu8Ads1q8bNUQiIWvfLPpwQ02KSfD8NGMs10wZCr2YoBlGmVHTInFZWHtpqa4QU/RqX1IhTvifbQCXq26I8aDpiDhHriPmuy0bi9X/jlsMyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358872; c=relaxed/simple;
	bh=8BEEc+NnXBZsKH4VgEyfddxmj2SAxBf7MsIJDIfpknQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCCqny8iKZUmBnq3F8szh+WV5Nu3yKGrtYjlm8v66pX79Uz5J0iOW13Pn34JXz0jMVKAfiri0RmYN1WsBch2a2CKelQmyfvh0/ROhUXXf0KeKXucnws8tKeFHfzhGY5I1c2/0YRLdS+al9193ledCC+M56OSoyT2EanDED2cG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGtdQxG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGtdQxG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FE7C4AF0A;
	Tue, 30 Jul 2024 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358871;
	bh=8BEEc+NnXBZsKH4VgEyfddxmj2SAxBf7MsIJDIfpknQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGtdQxG8CAh9itR6wzn7S9F/wrLS6kuP8cOxcbqofe/mPJ+PgzRMiBsnugsXsy5pO
	 U1mmSB5gGxCZ5Y/QLy8355+6/N/acf0zSyhtf9YUIHTOGAKb8f5mrsP9uRtzo+ledd
	 VcCeGaXDFmRoD71mfbYFbwLJNiCxR+aYn8sCBKeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Tremblay <vincent@vtremblay.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 429/440] spidev: Add Silicon Labs EM3581 device compatible
Date: Tue, 30 Jul 2024 17:51:02 +0200
Message-ID: <20240730151632.534983164@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 71c3db60e9687..2be7138acc38a 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -700,6 +700,7 @@ static const struct spi_device_id spidev_spi_ids[] = {
 	{ .name = "m53cpld" },
 	{ .name = "spi-petra" },
 	{ .name = "spi-authenta" },
+	{ .name = "em3581" },
 	{},
 };
 MODULE_DEVICE_TABLE(spi, spidev_spi_ids);
@@ -726,6 +727,7 @@ static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
 	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
 	{},
 };
 MODULE_DEVICE_TABLE(of, spidev_dt_ids);
-- 
2.43.0



