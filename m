Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6002D55E40;
	Thu, 28 Mar 2024 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641817; cv=none; b=i+HJnUktc/7m257GipY/UJ9DNHqGcNyw4M/GXGrseNr4GOI8gkrl7i4xhNqvOpOclCIJJR3el0ATsq5OTKEW4syYu4HopWQwTv0IZB2XB+VFapH7uyxcdSFayV6K3HcmVwoUIqsZ8lzn6SM5v3XqdlixEQ41fEvBBjAg5ZM92VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641817; c=relaxed/simple;
	bh=HowEN1J5McZBQqKd59V/2XnrBWjdZT6J3rhINf1YhZA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Ti9Ic4eiuqPxKSP8WEy9NwDGlPcOYhN6s/bl2FrH5S40DBZVcelMo7bSNuzYlBlRJHVYFryfIAht1KtEN/ZJT7MwodBBUJ434fBGBFl0ArebSAz0LzbpWV/2gx45vU4dg91HL7aZn0DOr7ESXQM5W8CMOYfGaR+R2WwbA+y4v7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7+eRdMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7+eRdMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6AEC433C7;
	Thu, 28 Mar 2024 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641816;
	bh=HowEN1J5McZBQqKd59V/2XnrBWjdZT6J3rhINf1YhZA=;
	h=From:Date:Subject:To:Cc:From;
	b=d7+eRdMaC/gJIqZv/7sLa9yMUgcCWWiAnSt2hs1zg6nDy1XypADpu80mFZayKidsD
	 MjORDfcfujmpm3fr4yzefN7wMTDyzYQbr0bVfEeLDXKOLLRj5qUQzBATB0INXwoBsH
	 RmAfu4n3EcWpKlIDDVC86COXXifK40gLWF869RXy+Ukg0yQ6lDVPeHST6d8pHB+G3b
	 mEPt1MVgKUEjcz0KxsqwJjX0KnNXTLzOqtHIueMLdpaThUT0wJ3A8IYjcepNkkri4C
	 pJxVC63ATQRy3gENP714kXQwgPDBUurHfJIwSsnMtGp2a1SyrhS+UFwJdJGEgQMNcv
	 91gb/zKq4hWQw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 28 Mar 2024 09:03:20 -0700
Subject: [PATCH] usb: typec: ptn36502: Only select DRM_AUX_BRIDGE with OF
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-fix-ptn36502-drm_aux_bridge-select-v1-1-85552117e26e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMeUBWYC/x2N0QrCMAxFf2Xk2UBtrRZ/RWR0S7YFtI50jsHYv
 xt8PHDPPTtUVuEK92YH5VWqfIrB+dRAP+UyMgoZg3f+4oJPOMiG81LCNTqPpO82f7e2UyGbVn5
 xv2AKRAOlHMMtgh3Nymb9I4/ncfwADJW3FHQAAAA=
To: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org
Cc: dmitry.baryshkov@linaro.org, luca.weiss@fairphone.com, 
 linux-usb@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1775; i=nathan@kernel.org;
 h=from:subject:message-id; bh=HowEN1J5McZBQqKd59V/2XnrBWjdZT6J3rhINf1YhZA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGmsU27EHX8z59wLf5GLJ5pmnD/N4Pf5imeWvd71h3eX1
 q34Vvv+ZkcpC4MYF4OsmCJL9WPV44aGc84y3jg1CWYOKxPIEAYuTgGYSO8shv95897N9xN3Vdf+
 Jdd1rsPe8fqHM8Ubwx8vFNV4L6rWFNLN8D/wXu48wch97Vq3HJICN60p3zY/nMFWm/dC/J/VgbY
 CRxkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

CONFIG_DRM_AUX_BRIDGE depends on CONFIG_OF but that dependency is not
included when CONFIG_TYPEC_MUX_PTN36502 selects it, resulting in a
Kconfig warning when CONFIG_OF is disabled:

  WARNING: unmet direct dependencies detected for DRM_AUX_BRIDGE
    Depends on [n]: HAS_IOMEM [=y] && DRM_BRIDGE [=y] && OF [=n]
    Selected by [m]:
    - TYPEC_MUX_PTN36502 [=m] && USB_SUPPORT [=y] && TYPEC [=m] && I2C [=y] && (DRM [=y] || DRM [=y]=n) && DRM_BRIDGE [=y]

Only select CONFIG_DRM_AUX_BRIDGE when CONFIG_DRM_BRIDGE and CONFIG_OF
are enabled to clear up the warning. This results in no functional
change because prior to the refactoring that introduces this warning,
ptn36502_register_bridge() returned 0 when CONFIG_OF was disabled, which
continues to occur with drm_aux_bridge_register() when
CONFIG_DRM_AUX_BRIDGE is not enabled.

Fixes: 9dc28ea21eb4 ("usb: typec: ptn36502: switch to DRM_AUX_BRIDGE")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/usb/typec/mux/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/Kconfig b/drivers/usb/typec/mux/Kconfig
index 4827e86fed6d..ce7db6ad3057 100644
--- a/drivers/usb/typec/mux/Kconfig
+++ b/drivers/usb/typec/mux/Kconfig
@@ -60,7 +60,7 @@ config TYPEC_MUX_PTN36502
 	tristate "NXP PTN36502 Type-C redriver driver"
 	depends on I2C
 	depends on DRM || DRM=n
-	select DRM_AUX_BRIDGE if DRM_BRIDGE
+	select DRM_AUX_BRIDGE if DRM_BRIDGE && OF
 	select REGMAP_I2C
 	help
 	  Say Y or M if your system has a NXP PTN36502 Type-C redriver chip

---
base-commit: ef83531c8e4a5f2fc9c602be7e2a300de1575ee4
change-id: 20240328-fix-ptn36502-drm_aux_bridge-select-83ddfd8a5375

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

