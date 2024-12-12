Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609A223C7A;
	Thu, 12 Dec 2024 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018508; cv=none; b=XKxAWgQp5Yfe7rdwECtC6P9b5CKG6P7A+7AA+ZCv0BAQtdhC5dsnBJLVBglfl/osPBweq3H/Uu/FdrKZbLV9bTtzRZC99LqzTPKt0FEjRFDb+TRQIfqqFlrwZfOl4D50LVavyTD8J93eRS4gdNfsZ9ATOhGoXObQZ//G/Q9YL8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018508; c=relaxed/simple;
	bh=lKrwKn0e16Tmr3fZw1SPJaq6J9f5aCX0vximwEJ4uxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qiXaoQ7NVTnJPgRpBEdDDRTpPjcbd0CJin1KSYdF7aKg8xHoqhf0uiMunq1cgjisqF8GiyAO8mEH/MWcrLUYVq/zLF7AmBnXUgylDD8VQ7weTOKk0yc3mPDOjN9s14iDcm/auazv+v+x0gdqNx8x+T3sOqDdLumu4+LVajz7Kr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvNXQrk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvNXQrk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A3BC4CECE;
	Thu, 12 Dec 2024 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018507;
	bh=lKrwKn0e16Tmr3fZw1SPJaq6J9f5aCX0vximwEJ4uxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvNXQrk59z1Hu7LsYfiacYjW/EQLwLYgtxEGPJB1gH2YbZnVmHHLmo+xOB3asCKyH
	 Y+tLNHWu0GGkQbFAe+4gV4tsSLFk+dimB3JB95osIXEdPKHmsTGpUmjhntVOyLrmph
	 CNSZ7IADjsiLxwmBgstCTlQRhzTSYu/ApHb/qi4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Inochi Amaoto <inochiama@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/356] serial: 8250_dw: Add Sophgo SG2044 quirk
Date: Thu, 12 Dec 2024 16:00:31 +0100
Message-ID: <20241212144256.884388895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit cad4dda82c7eedcfc22597267e710ccbcf39d572 ]

SG2044 relys on an internal divisor when calculating bitrate, which
means a wrong clock for the most common bitrates. So add a quirk for
this uart device to skip the set rate call and only relys on the
internal UART divisor.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Link: https://lore.kernel.org/r/20241024062105.782330-4-inochiama@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 8aed33be2ebf4..eaf4a907380aa 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -785,7 +785,7 @@ static const struct dw8250_platform_data dw8250_renesas_rzn1_data = {
 	.quirks = DW_UART_QUIRK_CPR_VALUE | DW_UART_QUIRK_IS_DMA_FC,
 };
 
-static const struct dw8250_platform_data dw8250_starfive_jh7100_data = {
+static const struct dw8250_platform_data dw8250_skip_set_rate_data = {
 	.usr_reg = DW_UART_USR,
 	.quirks = DW_UART_QUIRK_SKIP_SET_RATE,
 };
@@ -795,7 +795,8 @@ static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "cavium,octeon-3860-uart", .data = &dw8250_octeon_3860_data },
 	{ .compatible = "marvell,armada-38x-uart", .data = &dw8250_armada_38x_data },
 	{ .compatible = "renesas,rzn1-uart", .data = &dw8250_renesas_rzn1_data },
-	{ .compatible = "starfive,jh7100-uart", .data = &dw8250_starfive_jh7100_data },
+	{ .compatible = "sophgo,sg2044-uart", .data = &dw8250_skip_set_rate_data },
+	{ .compatible = "starfive,jh7100-uart", .data = &dw8250_skip_set_rate_data },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
-- 
2.43.0



