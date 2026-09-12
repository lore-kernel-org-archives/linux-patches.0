Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4779F37E5F3;
	Sat, 12 Sep 2026 08:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202826; cv=none; b=b+KpSkn00JPtsRVbBogfjoJSvp5b/PtdtqcxmjBRx90rZCKBIdMgeKJUy84Q0RCrno7S2j0MFBsBHv6Mp1EVYlRyfc8wWN4fmGord0KMBpC9QFI4ujCr0TgBHnJUmXJnb1noqQob+0VYoxsON5HhWyxGfFbzW7WgwGXFl8ESuDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202826; c=relaxed/simple;
	bh=iPUlacgXAiRrc426zT3D8Hdo9GGlfyAQLPCcr80bqvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZJBH8JwgVGo6i7KecV8iY/xMYm8M/dl4lhpn2+CGA7I9jf0Uo6DZoVmeMP6HB9I5gD4jyXV+VbDox8PNIVicQvM24foc1CejFCPRCchXY/fao2l588ZGbALya5AgbpDOEylbLj6z/rBbeLfeo8ssgXJIlH5+AvhNXFeLd1fldA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPHEk/xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPHEk/xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9931F00893;
	Sat, 12 Sep 2026 08:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202820;
	bh=lD1H+LFPUiANasgJDz4XZO9q/aiWmluozRla+lvyl7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPHEk/xgodukixcCUSIiVYR1uExL29CllFMsnTSDlSMhqrUq+ZY34Yl8IawbJn8lb
	 phnZryaboQr/m7Rdinj1Hp3ddePLQznjockzw8y+t/9hrkaEfMWrrE7IMriVaIXJG1
	 AOg7gq8I5x3RKNd82BaWYjyqGpYJooGn8TyhUq2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1239/1815] pinctrl: airoha: an7583: fix I2C0_SDA_PD register bit order
Date: Sat, 12 Sep 2026 08:49:49 +0200
Message-ID: <20260912065718.099863395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit d560e28bdca824781898023496658404df01be9f ]

I2C1_SCL_PD and RG_I2C1_SDA_PD bits are swapped, fix it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/airoha/pinctrl-airoha.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/airoha/pinctrl-airoha.c b/drivers/pinctrl/airoha/pinctrl-airoha.c
index 817d51141fed1..ffbc7b3c61812 100644
--- a/drivers/pinctrl/airoha/pinctrl-airoha.c
+++ b/drivers/pinctrl/airoha/pinctrl-airoha.c
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



