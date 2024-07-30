Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E687156F30;
	Tue, 30 Jul 2024 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358885; cv=none; b=CYpqkSazP3sIs6oD+7qpunvHusKUTUQMis1MAgJ5qejqfQ95z/SN0L/kwXJ03NBeVr00WJDtovPueFALScS68TzwyOmLBifaMCgCgiJROwK0yY7+jDsxpaywZRZsOkaBBgLAppkOi8w/GauMWkdYdBuAKae+8Hq4Cz0x1G0I/Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358885; c=relaxed/simple;
	bh=Sy5BOcnlwo/MBWejMlQIGQgpt7xC4uQYGpfQ3ElS7h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRUqLcbXowRQnVsLHWErUitcVtk2tfbtQCYZZipKdvyJfNGtzmSFkFKAkyTRJoGhbtuHqx4PkEuFMu5Gh2APRkXDOimRxKV4u0jdDQtvwD7Rm7b9GFS6YBM+ulk3GMAgQxZ8ZivbtCPwojOEWcwclVXYmPvbMQFzG7H7bfXlS8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBsPNkX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBsPNkX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CD7C32782;
	Tue, 30 Jul 2024 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358885;
	bh=Sy5BOcnlwo/MBWejMlQIGQgpt7xC4uQYGpfQ3ElS7h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBsPNkX/WKyI9/OKw6jRBf+aqC0JS0kRoDscSdFdO/YmhlUnh1olzPV3TNbnG3pyH
	 j0H4wxVFrL4QtqjyTkfNj5MIDVX6As+iY7Iuqpru/9Brw8uaTsqp+l5kNJAlIt9T83
	 UcbmcjO5VC9L2a4AFXMdj5pBWQ5aopavkI9C+elQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/440] spi: spidev: order compatibles alphabetically
Date: Tue, 30 Jul 2024 17:51:03 +0200
Message-ID: <20240730151632.573203722@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit be5852457b7e85ad13b1bded9c97bed5ee1715a3 ]

Bring some order to reduce possibilities of conflicts.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230120075651.153763-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc28d1c1fe3b ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 2be7138acc38a..5241785266153 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -719,14 +719,14 @@ static int spidev_of_check(struct device *dev)
 }
 
 static const struct of_device_id spidev_dt_ids[] = {
-	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
+	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
+	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
 	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
-	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
-	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
-	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
+	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
 	{},
 };
-- 
2.43.0



