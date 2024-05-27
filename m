Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9EA17E90E;
	Mon, 27 May 2024 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837240; cv=none; b=GP80KsXcQmA6Y/8ahauPXdbUKiV4BZ1XP2QZJ+PH5v54GriZ0A9x76edcplnUPjXRsPHBctRWaHa8u28BicvqJ7jJZ/Imi1vd7ZqmbZBMEYd/j74WwOWItyzVJVgGDFHCvqhWkLEuVL0fx0MyPQIH4IlJFrYFUA7PRormTxbdc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837240; c=relaxed/simple;
	bh=Xr21Fc+LEPYLo0GMBzU9u1y8bnJL1XA4+Xt9GIcGqn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCH5f1KwjB1J+xcXLKxEIqByIwW6ljd4sXm2iP4+H143WShce7/fnt1aMa25SUdzxq1f6g1mFsYU7nVwBM48i/X4sO5uhjJzKC47i5dDHfi6truNBeAciW/JMU5WCfeKIkHSzEPTFNpPgD+VcGeUcT7r+ZT8SfSaujN5dzo1W7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCkm9daL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCkm9daL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7810C2BBFC;
	Mon, 27 May 2024 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837240;
	bh=Xr21Fc+LEPYLo0GMBzU9u1y8bnJL1XA4+Xt9GIcGqn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCkm9daLSz5HFPq5xqkvDOruVXfqWPbPKr3BVkfJ+SOWh3ifQBZ96QJtpsSn3sBP1
	 Pdhm+QwfWXANItR6RVSpTLz7WXQ667AiVUIq2xkN8vA3XO0sSAgFjcInGvJjaplGfV
	 Jj2Lg1I44BsRixhFkE94mREoHBj3rMdJsiqhVyr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Rob Herring <robh@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 322/427] media: dt-bindings: ovti,ov2680: Fix the power supply names
Date: Mon, 27 May 2024 20:56:09 +0200
Message-ID: <20240527185631.680296890@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



