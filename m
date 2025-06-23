Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5BE70838;
	Mon, 23 Jun 2025 21:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712963; cv=none; b=uK30DZWZd1N7Jntg6oFba40NqD48+oqiepg0/0jWBVFBMD61ipRseraF40saouzDNahFeZWQ2GUMoUfahEh58+gM2fahIKpApEBQUOD/074ULc02jLtz2FahIbjeySYw8bkM3JbAIqvO0WNtJ72kHS+I7SNduo7aLc36tcWBwoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712963; c=relaxed/simple;
	bh=fGPN0XvXb09IWfdf55R31hOHllI9r1e+ovH3QCPL0Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgMvR1omgZBc2icDjELskNANsVcXYAP0VUrVSy4k37VyF6vmHuNhssuM2Urx/CafDKYDJyIRgzlGo9ilZhdmk4FSw0IFFb6v5M0tKITpdG3oxnhLxz4mRyfox8082T5PXII1C9fjXHEXtpl6VTkFLW8VBM92Inbh1Ny+OliGtIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFIiYen+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFIiYen+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A932C4CEEA;
	Mon, 23 Jun 2025 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712962;
	bh=fGPN0XvXb09IWfdf55R31hOHllI9r1e+ovH3QCPL0Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFIiYen+KFxRzl5/Sse+cCREhJc/SWv0ap7J354PS/mCPvRLF5O55wL0XRXGPQVEi
	 EsUbuX22LxHwKYMgON5Uk+A9MGOa4MdvyZXXR/ldj6zHv89PGEt3fy2B8EEy38VC64
	 l98x5giXHLu3xtG5ljzzYr236IDSL3ZJYvDfK8IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/411] mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE
Date: Mon, 23 Jun 2025 15:04:02 +0200
Message-ID: <20250623130635.953491523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



