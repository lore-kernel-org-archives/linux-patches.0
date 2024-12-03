Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6331F7065;
	Tue,  3 Dec 2024 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237663; cv=none; b=DbFzckNi4Bp+EiBQSLPd+fheV4cveeT+FrUqgjhx7BRHduk8guqGUz7xYcGhiar9/2dIuQ1B1s4CMrBVgiUh/dr1yz6h+ggTJP08dnJKVJbXYgp0Oo7qSFqUphUh5wmZ7KCxkrP3mHOKXChE8IMyEzotukhC39r0GioYIMEUqsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237663; c=relaxed/simple;
	bh=cE/AvZSQTdZPK4+CYb7hGOzKyRaPT5j8li/aZjl7VCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhmKnbIF9tL9F/KHrhHqa4jvHGixzev0bansejbaX6SsOU7Db18jusj2oceA5vb23igAYYTT6aUvEO4oJKAG5goUdnwyuWXKLJ6YASw/bPuJXCUGIk477WywtfSviG0ftzpHpBgOHq0bxXwqgDQ0uJvEJDmPYi0E0tlE4qNGAEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mu4KSEBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mu4KSEBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65521C4CECF;
	Tue,  3 Dec 2024 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237662;
	bh=cE/AvZSQTdZPK4+CYb7hGOzKyRaPT5j8li/aZjl7VCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mu4KSEBUPKwWPnD5VXFJwNj/ilCldT+s0RSHSOGtEBu/z6Gwuij0+Kk0gXJRy2r4z
	 +N5xOF1AvJOYhDRl2uBes5wh/paCENiGlasrQOAwsP3QB2JoCOwjTW/OGzX5bRk84r
	 yfZIgSLfUFoJUeEA1mYdwaXpwVwB7V2WsM90WRw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 005/817] spi: stm32: fix missing device mode capability in stm32mp25
Date: Tue,  3 Dec 2024 15:32:57 +0100
Message-ID: <20241203143955.833261521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit b5a468199b995bd8ee3c26f169a416a181210c9e ]

The STM32MP25 SOC has capability to behave in device mode however
missing .has_device_mode within its stm32mp25_spi_cfg structure leads
to not being able to enable the device mode.

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://patch.msgid.link/20241009-spi-mp25-device-fix-v1-1-8e5ca7db7838@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 4c4ff074e3f6f..fc72a89fb3a7b 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2044,6 +2044,7 @@ static const struct stm32_spi_cfg stm32mp25_spi_cfg = {
 	.baud_rate_div_max = STM32H7_SPI_MBR_DIV_MAX,
 	.has_fifo = true,
 	.prevent_dma_burst = true,
+	.has_device_mode = true,
 };
 
 static const struct of_device_id stm32_spi_of_match[] = {
-- 
2.43.0



