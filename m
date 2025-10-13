Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB977083C;
	Mon, 13 Oct 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367592; cv=none; b=QPTMGj3jSmTNJcIWLyf1FqgUjBh0sqyJMKInapRdQcZrZkZ4dCgpmBSHeF9o2wQW8dmE87EnaYZSw3EFP5Asj2/WnZoeaRlhoQO+vb1f6VhZ9QnPDZR6u6Q4eVyFfxOqKZXpFF6VR0VUxCr9gJsaSazSh7aut71OVqvg7x1QZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367592; c=relaxed/simple;
	bh=MXjHWmCaBM5WFaWXVtMuwXmsvIKN06X6Kxf67/A2b2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1m4P9WuovFW2XYmHctLJWkwTLokuiE/DWQ7E6YRTwG67PZ3Hnd85XVtuxsvTiTYmTke2zR7Tn+flObCN5LnDOmXypJaRFZEpT2nIqPKJJP9L2YXFo4ONCs/AGrBhuih+K/zmdwc4xW2v0t26z6f2u8AGXPsyhwwYDc195m5Y9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaAD4WGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaAD4WGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE727C4CEE7;
	Mon, 13 Oct 2025 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367592;
	bh=MXjHWmCaBM5WFaWXVtMuwXmsvIKN06X6Kxf67/A2b2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaAD4WGeEdawS9V7heAAcFX+zRikaBWiNMTinT4bNKxotFODLoLkhPYB6hi2MMr+W
	 oSJS+fEhlLkpNOyD4XQNEQRoKmj/AbK74Vz+o/vxqW/Mu0/iFcNq6D2GjqYZTQ9yX5
	 7QxzMEtV8QheTMSHg1vgnM/V/qBRgffofclRUvJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/196] ARM: dts: ti: omap: omap3-devkit8000-lcd: Fix ti,keep-vref-on property to use correct boolean syntax in DTS
Date: Mon, 13 Oct 2025 16:43:43 +0200
Message-ID: <20251013144316.360017612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



