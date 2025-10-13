Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEC930C603;
	Mon, 13 Oct 2025 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369107; cv=none; b=ZNz0+mTXfyHpjpBJI2HCPqI9dNzaIGjsoQI3Yoyw8TsFVXRE7EVDLqymJR4nH/REtfAwsmEtB6L5xP3C2XI3KRNlqCGZU1PNNCOd36eotAWd342cA2HiPNdinCZ6HH5u6xUaUxgiNaZ391lci4EXYTqq0Ir0Z/YNX5l7q9rCt5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369107; c=relaxed/simple;
	bh=RCMH+A8uBeM7fl1o0AN1d9+71RwrlZb0JJUqbKIyEto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8YFYYa4JjZ4YV/oA/WpwMiBJ7NVcrg+1g6Kj3XqWNIiodY54KUkm7oNVWvuzjB3Ng0Z13pUW8kw+UYCBrAJUc4jly8E2/yBs9hGv2qH8vbvho/JiVBpc5hjnuR57825AborevDADneH5085qCEB39ye8D62pfkxd7L24iAEXLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPHBUGXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPHBUGXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766CAC4CEE7;
	Mon, 13 Oct 2025 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369106;
	bh=RCMH+A8uBeM7fl1o0AN1d9+71RwrlZb0JJUqbKIyEto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPHBUGXng9fymXzKQEyeEMHxq3jTOrg+L+VDQ9/nTMjEVNBzGSRv9MLKiXjabFKaL
	 McUTx1pLpKrl8uyNmk/2u48M/xe5mAzQbFv6+w9QEu0gqvZWCQEvs428G7u02Ls5Pn
	 BIeIq/RWlvNCHeYQIhxV8k5RPaDWTFJjM3zHCMUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 097/563] ARM: dts: ti: omap: omap3-devkit8000-lcd: Fix ti,keep-vref-on property to use correct boolean syntax in DTS
Date: Mon, 13 Oct 2025 16:39:18 +0200
Message-ID: <20251013144414.809325652@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 5af5b85505bc859adb338fe5d6e4842e72cdf932 ]

The ti,keep-vref-on property, defined as a boolean flag in the Device
Tree schema, was incorrectly assigned a value (<1>) in the DTS file,
causing a validation error: "size (4) error for type flag". Remove
the value to match the schema and ensure compatibility with the driver
using device_property_read_bool(). This fixes the dtbs_check error.

Fixes: ed05637c30e6 ("ARM: dts: omap3-devkit8000: Add ADS7846 Touchscreen support")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250822225052.136919-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi b/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi
index a7f99ae0c1fe9..78c657429f641 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap3-devkit8000-lcd-common.dtsi
@@ -65,7 +65,7 @@ ads7846@0 {
 		ti,debounce-max = /bits/ 16 <10>;
 		ti,debounce-tol = /bits/ 16 <5>;
 		ti,debounce-rep = /bits/ 16 <1>;
-		ti,keep-vref-on = <1>;
+		ti,keep-vref-on;
 		ti,settle-delay-usec = /bits/ 16 <150>;
 
 		wakeup-source;
-- 
2.51.0



