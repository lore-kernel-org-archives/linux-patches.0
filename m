Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055096;
	b=xCXeSFRVjRMQO2KDnzhNMO2rRWt7VZWhb/SIVOC0XQjjHx3BcAM6qkRXfDQHOO3e1Nj7
	 4mtRIVrKrEGT95L24DaavSCTTjAgYPyGdTuZeld0TCo3qrCl25BLAQ5tY00047gZYfAvS
	 zuQvw8xAwkkVhHwsin5HEaIr9y/6jUVpCP62SU2u4g7Aymi9p8bjWS7eweeaU9oaEzG83
	 Ph9Os13Lz5ATOY/MLWb+XdhBCAF5er3x25LuY8i9hskjM6WAZ+njULZZPjJ8JVmZhjhpJ
	 /icgns8eOi8oxtjAQpp2/xSbUYqXyZ9RvMf4D5BztXeIxvls7CEm1wsQpRYHAkfDivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rtNRmK/i47TfD6HwmT+E+6te9VDqvvKGh7Q3Av0x4W0=;
	b=UNb1shLSXFOdh7RgbexxuIwXomTwPln8hjisEVjDrIMVV28r78j2bPXn2tP8UXyQv0Nx
	 z3MLMJST8IxK2N8zPy4t5U76CPi1G1zhre5spo48/Yxj6AZDsceonNMOOBYcZ3eXA9LYi
	 BB8xmQc3s87nKvJKCHIqNrzyIIoLnv6UMrF1y1XJvVKZOvibeHbJxBO9ymL4Tp1t5XmhH
	 YSBRZ6jgEpBn2jRKmLnMdRNaHH1+gLdn22kJKaI2TKUQMMnVHNDQq6xLrcaHUcBhY/RnT
	 Dt0uF/soLNS9t1L56DfFjbpdbzak9/b8uKIvqTNCu1mLQrKjbA7yCuBH1CgOPQ/8mZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm5fs0dQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E00606A325;
	Thu, 19 Nov 2026 02:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm5fs0dQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE78A1F000C4;
	Thu, 19 Nov 2026 02:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055096;
	bh=rtNRmK/i47TfD6HwmT+E+6te9VDqvvKGh7Q3Av0x4W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm5fs0dQEumj7BOFkJO/8eTiV1eceCdWRGu2m5ZITAEJPMs0ZE4rW4DmZICazwjnh
	 STEp4TAF/qjp8FwQSVT2ZG6iSyW1OTkuBzxfQrqOzp4L0fpUHZRTDFsbelu4C5zbn4
	 u4NWARAzJMj1ZxbyVg/CibhG56+9UEFxNZpWdGyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1468/2214] regulator: ab8500: Treat cut 1.0 VAUX3 as fixed
Date: Wed, 18 Nov 2026 15:52:24 +0100
Message-ID: <20261118150109.931524946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit b9fc8a8d31b914b09329240f532ff0e9c00cd727 ]

The early-cut workaround currently gives AB8500 cut 1.0 the 16
programmable VAUX3 settings introduced with cut 1.1. On cut 1.0 the
selector is not programmable and VAUX3 is fixed at 1.2 V.

Register VAUX3 as a fixed-voltage regulator on cut 1.0 and retain the
16-value workaround only for cut 1.1.

Reference: AB8500 User Manual, UM0836 Rev 3, p. 240

Fixes: 2b75151a1041 ("regulators: Added ab8500 v2 support")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-4-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 662434cccd217..110c660e899d7 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1783,9 +1783,14 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	config.driver_data = info;
 	config.of_node = np;
 
-	/* fix for hardware before ab8500v2.0 */
-	if (is_ab8500_1p1_or_earlier(ab8500)) {
-		if (info->desc.id == AB8500_LDO_AUX3) {
+	/* Handle the different VAUX3 implementations in early AB8500 cuts. */
+	if (info->desc.id == AB8500_LDO_AUX3) {
+		if (is_ab8500_1p0_or_earlier(ab8500)) {
+			info->desc.ops = &ab8500_regulator_mode_ops;
+			info->desc.n_voltages = 1;
+			info->desc.volt_table = fixed_1200000_voltage;
+			info->voltage_mask = 0;
+		} else if (is_ab8500_1p1_or_earlier(ab8500)) {
 			info->desc.n_voltages =
 				ARRAY_SIZE(ldo_vauxn_voltages);
 			info->desc.volt_table = ldo_vauxn_voltages;
-- 
2.53.0



