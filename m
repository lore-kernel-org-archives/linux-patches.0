Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A7F2EA723;
	Tue, 17 Jun 2025 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178439; cv=none; b=mcy0nZ22pdbuFpInmDXKruHrr+nmfTwO9WCNhp7Fmih1BOYGqEmQ33kQ2WH6TjkTtyrhG+3C1oByoRQrFOQalX0C7sCJH+omejQ2lOBdkh0L74BjmtRriV9skvOFxZADcJC2sYAQk4jHwoQU9212eRIl5lgoiX2MXQ/iBwjJwc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178439; c=relaxed/simple;
	bh=ImxE09Gz7YQ3A3Ms0y6Yu60VLCNX+jNVjrdr9j2UNvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai2iUyjZwcXuiXaboVP1wq3lAyq5JLWFxL8PmkG6I+F77HV+VqfP7WiWbpCtzuaNXbXpsxMyy6/jKryS+rIZhBEZYRWkOML95yUA5C6zLEZzTYL6+BgzEBtdFZ72XNqH13FDZ5zDAdcDUmpk0JzINW2hGu0E8Me1oMMHAYiUyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cD4FQePB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cD4FQePB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA93C4CEE3;
	Tue, 17 Jun 2025 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178439;
	bh=ImxE09Gz7YQ3A3Ms0y6Yu60VLCNX+jNVjrdr9j2UNvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cD4FQePB8gaVSwXazDi/WaQ3e7Lg5yo/JuA7tXNkzPWfMAvF6jeLkXZe7Fs7VLr5z
	 +lIObk/cN+oAM1AUr2Sqn0kz0Mid7wzTWcwgjzkjIbaAAPnUkryfXgSaj/EQAUwUG5
	 M385nTb9E4+CGhjJRm2exhfYXrO7X9QEMA8JVQ0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 460/780] mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE
Date: Tue, 17 Jun 2025 17:22:48 +0200
Message-ID: <20250617152510.210110481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit 59d60c16ed41475f3b5f7b605e75fbf8e3628720 ]

The name used in the macro does not exist.

drivers/mfd/stmpe-spi.c:132:26: error: use of undeclared identifier 'stmpe_id'
  132 | MODULE_DEVICE_TABLE(spi, stmpe_id);

Fixes: e789995d5c61 ("mfd: Add support for STMPE SPI interface")
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/79d5a847303e45a46098f2d827d3d8a249a32be3.1745591072.git.legion@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 792236f56399a..b9cc85ea2c401 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -129,7 +129,7 @@ static const struct spi_device_id stmpe_spi_id[] = {
 	{ "stmpe2403", STMPE2403 },
 	{ }
 };
-MODULE_DEVICE_TABLE(spi, stmpe_id);
+MODULE_DEVICE_TABLE(spi, stmpe_spi_id);
 
 static struct spi_driver stmpe_spi_driver = {
 	.driver = {
-- 
2.39.5



