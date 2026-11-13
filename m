Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590134;
	b=ftX9EdRM/PE44Cp5kUpduo+7u2wgnZEMoOUQRRe2sRgpndoffFu3Y7Y0wYNVOA2UypPs
	 5pdyxq0Xjza9lR7hcy1Q0cWjKdgZwzJHtTvzzxg7S4KBJojH0pyvVPhjtRJh5RXd66qHb
	 P91v3mAlTfR8F7xBfY5wsYJEWBQZLpnTef6Yxbx3O7S1HOqVd9303wYvjKhhJy8e9g1yI
	 byP7GJku1FN8rDUMWeqyzUTGdgTLnv5taNdjJI9C2mmEYm2jzdm9UMftVfhp8/QGNUGSZ
	 fcc8IqyRarG6rtSvf59LeycXlRRfOOwFqeVIHdCF4CE0hdZfRE95YooeNnAuhHQFmPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4VI6vdiVE6K4SsnZS5llBBcs47jEtu5rUvTfXSN0i6Q=;
	b=pQbCgtraZpGdCPQmfd2xBqoc1tqiiBYEe89NxrkRMZFEoTMmofcCMwdrHukBjEnlKS/I
	 m/v1zQyS2gWtADCkYdF0H55DNvJ6LC7QR8CYp6gU+xRujEKOQTQd9eVHkf00bqQgsUSr3
	 7vbUNumsCC3byt/ft1OV83/GSDj+0vGtcQN9/swP82c77kGGQLiU90pyO78HxLAHA3U0Z
	 WnZqxxq/+1ABvBpKIn7nWizF4ce44KoHNWsgLLVIvFoOcWLCa9odrRT/3UVCuYJhw4ygI
	 q48ZvdNjfuEZPSKZOfRqY6BXcV6KSyVF5b4vPFzaoFlqb/0xv+8bO2aKo7lPPrbvWcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D75nkYog;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7AD60A5BDC;
	Fri, 13 Nov 2026 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D75nkYog
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB4D1F000C9;
	Fri, 13 Nov 2026 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590134;
	bh=4VI6vdiVE6K4SsnZS5llBBcs47jEtu5rUvTfXSN0i6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D75nkYog/SE2voLXomVElxVcnbjuKtMys0e0djZEV/5jrIR8jhC1DOPVj3GaytQUq
	 4gdyts66XQHEwFGFIiHBHbEWYtRIFQd1beJAfFm31S0FnZZixWXnsha0tUxBkkSbh3
	 jYJrwv5TT6KskFiTI/EYY3o8caN/d6FGTy3SKi1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/686] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Fri, 13 Nov 2026 10:44:46 -0500
Message-ID: <20261113153825.980510372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rupesh Majhi <zoone.rupert@gmail.com>

[ Upstream commit 4334dc4092c271e6cd010c2ee70b7f4415c4c199 ]

Driver defines them as BIT(4), BIT(5) and BIT(6). Per datasheet P_SHIFT
is bit 2, FIFO_EN is bit 1 and SPI_MODE is bit 0.

Only P_SHIFT has a user. dps310_set_pres_precision() sets it at
oversampling 16 or above, so with wrong bit the result register is never
shifted and stops matching the scale factor compensation divides by.
in_pressure_input returns -ERANGE at oversampling 16, 32 and 64.

FIFO_EN needed by FIFO support later in this series.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Fixes: d711a3c7dc82 ("iio: dps310: Add pressure sensing capability")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/dps310.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index 41b2d0b014e18..a617f26eeb300 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -50,9 +50,9 @@
 #define DPS310_CFG_REG		0x09
 #define  DPS310_INT_HL		BIT(7)
 #define  DPS310_TMP_SHIFT_EN	BIT(3)
-#define  DPS310_PRS_SHIFT_EN	BIT(4)
-#define  DPS310_FIFO_EN		BIT(5)
-#define  DPS310_SPI_EN		BIT(6)
+#define  DPS310_PRS_SHIFT_EN	BIT(2)
+#define  DPS310_FIFO_EN		BIT(1)
+#define  DPS310_SPI_EN		BIT(0)
 #define DPS310_RESET		0x0c
 #define  DPS310_RESET_MAGIC	0x09
 #define DPS310_COEF_BASE	0x10
-- 
2.53.0



