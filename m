Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11B222FE11;
	Tue, 17 Jun 2025 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177064; cv=none; b=claxwi975J4jjzHgJLPV8DcFyb9L57Ffe5cnMmQ6ohI26t8ReNW2fkfrYoU/LCwhCcnwYttFXSnjBvDlY9L2YREeCgcZAmbfJOMEN6v6or6SN/QjLrQ7bL1e4sa8iAyRObuMziGRWb5iJ6tDFeVqb/zWnRjoNgtJhlpJ5CJSghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177064; c=relaxed/simple;
	bh=gUUrsIpSoOb99FZETeURNYflST6/nDu5KKO2jo+RLG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR/q6LSvr91YfiG3161UAhCaCpI4MBSb4Q8GlBxEAe4x9/OPmr1DHFNXdsHpkBIsu24tw6Z4KBUGdTSwmasj76RE7AznWLAJGn8oWXORv9DxeonxHZ08YgNM6ZlYtcVkgCIVd8W0uRLzkr/97B28sKoZKzpMKLl/Fb+jlK6oC5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxL7fwXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxL7fwXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B48CC4CEE3;
	Tue, 17 Jun 2025 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177064;
	bh=gUUrsIpSoOb99FZETeURNYflST6/nDu5KKO2jo+RLG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxL7fwXEArAL4vIGL6J18utKJ8h7M4C4fy8h977G9QvyCbwXaLkqaYChN9UM86Z0u
	 4RMNYPK9UxdcIjSrOSzyGWAW5L2E7u9lJfaz5inArlkSGieRy7vOBKsgwU2eFPFHVp
	 R9w53Bd8Kff8Ma2BE85+XgK6svKw6ORiRzhjewTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/512] mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE
Date: Tue, 17 Jun 2025 17:24:19 +0200
Message-ID: <20250617152431.473430578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



