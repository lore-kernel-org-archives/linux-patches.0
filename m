Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484B384;
	Thu, 13 Jun 2024 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282030; cv=none; b=WkmWzo7EBcXzz0MRCdXODFgQzMQHS+KmT4qr2AWyOn6bH4XU9lJ4u6xowR18o3APhlVFTuHGy7TzUlMgj3oncyaZDGibqfEYah0zemvpnMMw+mlX748AVYUGkfLyP0aZMv5Olii9nTDfpnQ1SOu/82iH+s3pzXkK4NJ6MXupE4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282030; c=relaxed/simple;
	bh=0GE9WSamdGCHsfBpNMEeXEbDOPGYkyUcgnmtfr/tbbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ6zyjfFZ/HymREQ80oMjJRdmOouxEkNbf1RIF1fuFxXSvgApOx/uWPUyx2bA7ZbtqkvMpKSzO2Iz3c7WsTTUbK1q1tOuguLv1UDtosPJyfHrMgLRvTsaqUUdXwo4JGNnXsKydguyNTXPlii/7ue/mX+A2HbO98gF0oZk6QHUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yl/EIN80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yl/EIN80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FBAC2BBFC;
	Thu, 13 Jun 2024 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282029;
	bh=0GE9WSamdGCHsfBpNMEeXEbDOPGYkyUcgnmtfr/tbbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yl/EIN80CK8Vpg1z/n1SkaC0yLeOgvInlZeYvmItTAnHrYA6wq/ObZHyjcNsW9MTJ
	 vZ2WcJW0kV40QHJ+iQxeqLiz+Z+buyykkt0DJ1ZOJCmC4oEim9TSGPgSCvPTqXl8z4
	 wWk1LEQo4PHN7SYBzTrYTLtou3xcd/jwBU7SkITs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Rob Herring <robh@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/402] media: dt-bindings: ovti,ov2680: Fix the power supply names
Date: Thu, 13 Jun 2024 13:31:35 +0200
Message-ID: <20240613113307.520369860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



