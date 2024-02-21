Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B987669DF6;
	Wed, 21 Feb 2024 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521469; cv=none; b=XBI+gZFu12QQssbpwJ6VFj9vSBR91TbO3UlvJ+WC8YHBvbJwDa5UYHeM1VSzsqlMIl5Gekq8mUjY5rOZgOq7d1Y0B/JqVkS0R11Le/Cd37HtyJFwWpSGGNqtIyoTc4ntvp05aT1tt8Ys1qUU7fJGxiaFA4NEbtLygVJPzsaFHwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521469; c=relaxed/simple;
	bh=Vhy9Q+XiBQynlB00Ftktlzks/UcvmSMwm2n6Uiv3F5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaG1ADafyxK1Z4Y8pe3flE8KqCO/fZzEoXYcAb9XQRH1ueqTLesc7dA+eTv4ipJ5kxjoWeni6QL5D/sXYGJkrMM1hhogkCwi9nEfwXCtUIpnClZmz3NjxinAXSMaZqN4IOULU/NbAgXhFHulVPCeczkpxe/h85oTz4dsaOEh/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjJUdnNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjJUdnNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE19C433F1;
	Wed, 21 Feb 2024 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521469;
	bh=Vhy9Q+XiBQynlB00Ftktlzks/UcvmSMwm2n6Uiv3F5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjJUdnNC/ZE0i9Du+HQRKFVPWSd9m/CaKs12z8Ck93bg9aS3iqNknoJ505o28jeVW
	 e2SpZu7fydCGBDxnFaMclIiX9FFG1Pg12IoRYxFHpJsvd8u0V2KzG0lvMVPjSuKDFW
	 7HqAJPiqnd5DHSWsx0Ssc5C0DG8wela7ZHUwPyEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/202] mfd: ti_am335x_tscadc: Fix TI SoC dependencies
Date: Wed, 21 Feb 2024 14:07:01 +0100
Message-ID: <20240221125935.598833242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 284d16c456e5d4b143f375b8ccc4038ab3f4ee0f ]

The ti_am335x_tscadc is specific to some TI SoCs, update
the dependencies for those SoCs and compile testing.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220155643.445849-1-pbrobinson@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index dd938a5d0409..6b7526669875 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1247,6 +1247,7 @@ config MFD_DAVINCI_VOICECODEC
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
+	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.43.0



