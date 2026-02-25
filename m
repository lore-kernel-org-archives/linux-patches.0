Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02DE1E2834;
	Wed, 25 Feb 2026 01:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983918; cv=none; b=YzTOLXc+0ZHHcldgE0pEpjljP/nmBfMjh0Nuuj2g1NU/K6SZxa1gsSqssvJj7DZTdFm2yeiGO24HWbIbEQ0MTfU/QLQ1omTXPC6hF6O1ec29WrEMzzmf9ClFhECUiQw486QYcgCZenFVf7G3D8PiKJiE3cMJK9x4LCUStvudIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983918; c=relaxed/simple;
	bh=XdbCMe9X5Nz0Aa665gr02r0xuw7zIx3BhaD8FSCI6mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhqpPEbBoQ3oJKbvlYCeI8M2mozXpPG4Wap+M+8t9Qhc6QvfVozMufFfjqyyI8Q3CVo7NOiwrHGFJHTUErcGjJRCCLN4i5AB/GYxmMPg4MnvYcCITezkHL7oKC/vw9TH4LMuzUJRaJ3ShlE56j2h7I1uktbTzBee+5OkI7/+18M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvqAAPFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvqAAPFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2714AC116D0;
	Wed, 25 Feb 2026 01:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983918;
	bh=XdbCMe9X5Nz0Aa665gr02r0xuw7zIx3BhaD8FSCI6mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvqAAPFJT1bKblIKuuui4oyRuB0GdXpjFjUfvAn8XsSCXzzwTq3RLifb0ky9cPe9S
	 UWIzu3aaNU52V6PlPiXl3Ii4Zh2CxRdme8Zy8APabqc9Fk9bhUvcV8Fzm+c2fbYBUW
	 3DPMIj/fSIvS3/DPqI91qu5M310pByYYhY17woIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/641] ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
Date: Tue, 24 Feb 2026 17:17:47 -0800
Message-ID: <20260225012352.539695635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 0b2761eb1287bd9f62367cccf6626eb3107cef6f ]

The P66's device tree includes the reference design dtsi files, which
defines a node and properties for the touchpanel in the common design.
The P66 dts file then overrides all the properties to match its own
design, but as the touchpanel model is different, a different schema
is matched. This other schema uses a different name for the GPIO.

The original submission added the correct GPIO property, but did not
delete the one inherited from the reference design, causing validation
errors.

Explicitly delete the incorrect GPIO property.

Fixes: 2a53aff27236 ("ARM: dts: sun5i: Enable touchscreen on Utoo P66")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251225103616.3203473-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts b/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
index be486d28d04fa..428cab5a0e906 100644
--- a/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
+++ b/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
@@ -102,6 +102,7 @@ &touchscreen {
 	/* The P66 uses a different EINT then the reference design */
 	interrupts = <6 9 IRQ_TYPE_EDGE_FALLING>; /* EINT9 (PG9) */
 	/* The icn8318 binding expects wake-gpios instead of power-gpios */
+	/delete-property/ power-gpios;
 	wake-gpios = <&pio 1 3 GPIO_ACTIVE_HIGH>; /* PB3 */
 	touchscreen-size-x = <800>;
 	touchscreen-size-y = <480>;
-- 
2.51.0



