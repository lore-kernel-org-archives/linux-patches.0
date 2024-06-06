Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F55198858;
	Thu,  6 Jun 2024 14:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683336; cv=none; b=W0guOeTmeczazQVfVNdNQ/emKJPCyZmg7AyOf5U8nBT+wPT78o4YRSHL+cT/gOmjuL1on+wOo1FrujsgWIYNYD/VQMxmJDi4w7S0UqLsUoN3d7lYmaQVvJlijC5Jps/HkHKMlfgCBTVtRzQft4csHFZxOkT26w3tBcvIJ/FjWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683336; c=relaxed/simple;
	bh=14K4oPHM1rAelKuELWz+wzBH61YtnNd1OaYqpFHfvJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku9dfEoerAPrspkgZ0Rm+PiHbbP46ozF0yznWgiSob+zyYLMQKm2Yvl7l+dXt2SbEqpHxXbpn8mZursZT70zrj0oSLiRAuUcVBsxY42CElrxC2hRTGIZd4/OAuF/qytJvWJgdA2rZ9ZJfeTvyMGLrlJxNGhdcFm2qDu2mWax4nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QL15cgsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QL15cgsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3387C2BD10;
	Thu,  6 Jun 2024 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683336;
	bh=14K4oPHM1rAelKuELWz+wzBH61YtnNd1OaYqpFHfvJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL15cgsp5/d96VjRm8PPcnuwZ7BovVEWFR0cPXDB5kO9gMaO1gLAFcxPuFUWnjo0B
	 bMRnDxXsoHgweyUD1Zcw8S9lp4QXvMbIRAZT23IyZIMhkMrCqxmeEbtkC9v7o6zo3M
	 rmY1zMi5rICjrtANGNmn4SjJsuy3f7Jx/g7VM8TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Rob Herring <robh@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/473] media: dt-bindings: ovti,ov2680: Fix the power supply names
Date: Thu,  6 Jun 2024 16:02:27 +0200
Message-ID: <20240606131707.109914355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit e2f6ea61b6f3e4ebbb7dff857eea6220c18cd17b ]

The original .txt bindings had the OV2680 power supply names correct,
but the transition from .txt to yaml spelled them incorrectly.

Fix the OV2680 power supply names as the original .txt bindings
as these are the names used by the OV2680 driver and in devicetree.

Fixes: 57226cd8c8bf ("media: dt-bindings: ov2680: convert bindings to yaml")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/media/i2c/ovti,ov2680.yaml        | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ovti,ov2680.yaml b/Documentation/devicetree/bindings/media/i2c/ovti,ov2680.yaml
index cf456f8d9ddcb..c87677f5e2a25 100644
--- a/Documentation/devicetree/bindings/media/i2c/ovti,ov2680.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ovti,ov2680.yaml
@@ -37,15 +37,15 @@ properties:
       active low.
     maxItems: 1
 
-  dovdd-supply:
+  DOVDD-supply:
     description:
       Definition of the regulator used as interface power supply.
 
-  avdd-supply:
+  AVDD-supply:
     description:
       Definition of the regulator used as analog power supply.
 
-  dvdd-supply:
+  DVDD-supply:
     description:
       Definition of the regulator used as digital power supply.
 
@@ -59,9 +59,9 @@ required:
   - reg
   - clocks
   - clock-names
-  - dovdd-supply
-  - avdd-supply
-  - dvdd-supply
+  - DOVDD-supply
+  - AVDD-supply
+  - DVDD-supply
   - reset-gpios
   - port
 
@@ -82,9 +82,9 @@ examples:
                 clock-names = "xvclk";
                 reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
-                dovdd-supply = <&sw2_reg>;
-                dvdd-supply = <&sw2_reg>;
-                avdd-supply = <&reg_peri_3p15v>;
+                DOVDD-supply = <&sw2_reg>;
+                DVDD-supply = <&sw2_reg>;
+                AVDD-supply = <&reg_peri_3p15v>;
 
                 port {
                         ov2680_to_mipi: endpoint {
-- 
2.43.0



