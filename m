Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E2434752E;
	Sat, 12 Sep 2026 10:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210503; cv=none; b=cd+7y/EmA2NzuE5gx7AMFvClCc4daPTnxWaPu8n5z4UVboRD/rUKbPQOB6UX8o/cwF9IPtsY6iT0U7JsRGDtGgrbmDbvOkkbRE/549NQdtkwCsiGC971mN14/Cv7y9sCXvO96oWOdg6KmDIPoI0PjuMHDQ2m8Y6cmOVF0L8Rnr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210503; c=relaxed/simple;
	bh=awukT3iJjsqEcXDqVIyG3ptJ5I725U3j/0tB0UAybSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrOScwBjQB9DH8Ymf2PGPWAGa9K4O61sSx1pbztK10z95Ob7CY9kZjhV9KTfFOPQVKTziZlnIOgZGzlBY44fF1pkyNywgdcVLPXkySYd+q3mMZXSwH04X+BmwgOSJ5MoJgy3R9xdJ4RG7JFIvMM699Z6O0wYXfiqNHmQbeYp5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vh8dWU3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vh8dWU3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEC81F000FF;
	Sat, 12 Sep 2026 10:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210501;
	bh=yx5fy3xZgVlOd7C2PVJ9TUKXFDlwUm+bFI3l/Y6qgZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vh8dWU3Abg7KCPIemuhO/zc2ZoUwdj8QhqA+iEphldZ3h9K6H17wbpZN2S85K2Fkp
	 6rfPKrNDTQXl10MiHnboLOt1QCFhbQxGHf64wq/wmfm11RAJMsaooU0NfZh7+DXk4f
	 b6vcWynLcVC1mOftrxgculjoFb4pUCYbmvoApbEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1012/1518] pinctrl: airoha: an7583: fix I2C0_SDA_PD register bit order
Date: Sat, 12 Sep 2026 08:53:01 +0200
Message-ID: <20260912065646.345800796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit d560e28bdca824781898023496658404df01be9f ]

I2C1_SCL_PD and RG_I2C1_SDA_PD bits are swapped, fix it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 57352ebfaadd5..3729da8f7df5e 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -185,8 +185,8 @@
 #define I2C_SDA_PU_MASK				BIT(0)
 
 #define REG_I2C_SDA_PD				0x0048
-#define AN7583_I2C1_SDA_PD_MASK			BIT(16)
-#define AN7583_I2C1_SCL_PD_MASK			BIT(15)
+#define AN7583_I2C1_SCL_PD_MASK			BIT(16)
+#define AN7583_I2C1_SDA_PD_MASK			BIT(15)
 #define SPI_MISO_PD_MASK			BIT(14)
 #define SPI_MOSI_PD_MASK			BIT(13)
 #define SPI_CLK_PD_MASK				BIT(12)
-- 
2.53.0



