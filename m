Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A87A16419;
	Mon, 23 Jun 2025 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685923; cv=none; b=pFPggENTDFqPGalpWiMk2CW0hu+sUH01R9zbsb7xmxjXJ+QE+/pIXGjonOTV7EBK8VIe4JGW4WA/kcDI8OofFwnFf99hvwHYogJfE+/cYqSKG3BxZpMPcH233YlMSj8fhwJLFGYbctYWaHSA4CUss5WNXrObyWwyqmGAF27HaOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685923; c=relaxed/simple;
	bh=1Fh+Pfmu82ZOI2IF8WaPLhLUC+chv+EddooA5cd6Np8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQXSosJvofHFyRyQTWFDp3D98s01F2GaiZz2qYRTIxXChkA9doHwIvUkSJ4FycN2jBAyYbFcK2zKljEv10j3My1cO1y92EY3anKxoHnhCmIPr2TDu5nRGf7yWS5Cz4lihw1O+ENs25me39aHhP1IjkpQ8cIa8+Da41COt/3sRKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/8mVxuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/8mVxuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C280C4CEEA;
	Mon, 23 Jun 2025 13:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685923;
	bh=1Fh+Pfmu82ZOI2IF8WaPLhLUC+chv+EddooA5cd6Np8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/8mVxuPcGuPJ6dilwpYkqSxa4KL1sNuveTuagKClZf3lBUCPuSJNBn2De4mhdpCz
	 6p8CXcLm/pnFt0cC5gVXN5POMCj8i8OslsmJwDsCz0WTJ2MlR3knD95gKPBxqaWgnt
	 87UJMrluCdToG+kIVIYm0anr896pwBCSvQLUO7Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/355] mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE
Date: Mon, 23 Jun 2025 15:04:41 +0200
Message-ID: <20250623130629.221826086@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7351734f75938..07fa56e5337d1 100644
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



