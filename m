Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748F39440
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 12:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D140C4339E
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 12:21:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="p+1hV7sW"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 21 Mar 2023 12:21:36 +0000
Resent-Message-ID: <ZBmhUIES+/NlwTxV@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 15 Mar 2023 15:47:56 +0000
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Q5NZ=7H=opensource.cirrus.com=prvs=843822f42b=vkarpovi@kernel.org>)
	id 1pcTM1-007KPO-Lm
	for broonie@sirena.co.uk; Wed, 15 Mar 2023 15:47:56 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id EBD7F61DA9
	for <broonie@sirena.co.uk>; Wed, 15 Mar 2023 15:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7134CC4339B; Wed, 15 Mar 2023 15:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 473BEC4339C;
	Wed, 15 Mar 2023 15:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 473BEC4339C
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FFMHZ9015868;
	Wed, 15 Mar 2023 10:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PODMain02222019;
 bh=dPToRk/+soaeY948VOsT5VDpfTszKykVdxRQIdaJ4k8=;
 b=p+1hV7sWSHo5hIReEy59RVHQpa0rBH5blKa3a9arfdl8kMhyBQ4MD8iUMxERVaUz/1HY
 2j5s4nEWgsuDGI9Ia5/LGDs29RDCeJ3+0K74pkSpqQawBuA1dK8hDzf8xOH8FDhnyQAU
 s4luAqXnrEjs6FL/EhzLQLTUZGMg3YGXUIHHcwnqdZqGv/6ML5/BRYLbSAm2/0hTjLX3
 w+tpj3UBA6I9csIk5iAGTRnB6nXE0VZi7TcmXFYBnzuR+wzTfjrIxhqSvCgg7wVeMqJX
 ICOJVdSrXQO2PcbE9nAF5Lm/fctVYBki6ME1AVqg3+Mmz68WgnjEKUiU7Pp0oJzkCVxD OQ== 
Received: from ediex01.ad.cirrus.com ([84.19.233.68])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3pb2cr8rmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Mar 2023 10:47:44 -0500
Received: from ediex01.ad.cirrus.com (198.61.84.80) by ediex01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.25; Wed, 15 Mar
 2023 10:47:42 -0500
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by ediex01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.2.1118.25 via Frontend
 Transport; Wed, 15 Mar 2023 10:47:42 -0500
Received: from vkarpovich-ThinkStation-P620.crystal.cirrus.com (vkarpovich-ThinkStation-P620.ad.cirrus.com [141.131.206.93])
	by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 30CC345;
	Wed, 15 Mar 2023 15:47:40 +0000 (UTC)
From: Vlad Karpovich <vkarpovi@opensource.cirrus.com>
To: James Schulman <james.schulman@cirrus.com>,
        David Rhodes
	<david.rhodes@cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Rob Herring
	<robh+dt@kernel.org>
CC: <alsa-devel@alsa-project.org>, <patches@opensource.cirrus.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Vlad.Karpovich
	<vkarpovi@opensource.cirrus.com>
Date: Wed, 15 Mar 2023 10:47:19 -0500
Message-ID: <20230315154722.3911463-2-vkarpovi@opensource.cirrus.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315154722.3911463-1-vkarpovi@opensource.cirrus.com>
References: <20230315154722.3911463-1-vkarpovi@opensource.cirrus.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Nc3rwwIbfbxLDRRkvWpQKOFxmLJBfL_z
X-Proofpoint-GUID: Nc3rwwIbfbxLDRRkvWpQKOFxmLJBfL_z
X-Proofpoint-Spam-Reason: safe
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=Q5NZ=7H=opensource.cirrus.com=prvs=843822f42b=vkarpovi@kernel.org
Subject: [PATCH v3 2/5] ASoC: dt-bindings: cs35l45: GPIOs configuration
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: B6URvSkdNua4

From: "Vlad.Karpovich" <vkarpovi@opensource.cirrus.com>

This adds description of CS35L45 GPIOs configuration.

Signed-off-by: Vlad Karpovich <vkarpovi@opensource.cirrus.com>
---
 .../bindings/sound/cirrus,cs35l45.yaml        | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/cirrus,cs35l45.yaml b/Documentation/devicetree/bindings/sound/cirrus,cs35l45.yaml
index 184a1344ea76..34c2867e2fd9 100644
--- a/Documentation/devicetree/bindings/sound/cirrus,cs35l45.yaml
+++ b/Documentation/devicetree/bindings/sound/cirrus,cs35l45.yaml
@@ -47,6 +47,74 @@ properties:
     maximum: 3
     default: 2
 
+patternProperties:
+  "^cirrus,gpio-ctrl[1-3]$":
+    description:
+      GPIO pins configuration.
+    type: object
+    additionalProperties: false
+    properties:
+      gpio-dir:
+        description:
+          GPIO pin direction. Valid only when 'gpio-ctrl' is 1
+            0 = Output
+            1 = Input
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+        minimum: 0
+        maximum: 1
+        default: 1
+      gpio-lvl:
+        description:
+          GPIO level. Valid only when 'gpio-ctrl' is 1 and 'gpio-dir' is 0
+            0 = Low
+            1 = High
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+        minimum: 0
+        maximum: 1
+        default: 0
+      gpio-op-cfg:
+        description:
+          GPIO level. Valid only when 'gpio-ctrl' is 1 and 'gpio-dir' is 0
+            0 = CMOS
+            1 = Open Drain
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+        minimum: 0
+        maximum: 1
+        default: 0
+      gpio-pol:
+        description:
+          GPIO output polarity select. Valid only when 'gpio-ctrl' is 1
+          and 'gpio-dir' is 0
+            0 = Non-inverted, Active High
+            1 = Inverted, Active Low
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+        minimum: 0
+        maximum: 1
+        default: 0
+      gpio-ctrl:
+        description:
+          Defines the function of the GPIO pin.
+          GPIO1
+            0 = High impedance input
+            1 = Pin acts as a GPIO, direction controlled by 'gpio-dir'
+            2 = Pin acts as MDSYNC, direction controlled by MDSYNC
+            3-7 = Reserved
+          GPIO2
+            0 = High impedance input
+            1 = Pin acts as a GPIO, direction controlled by 'gpio-dir'
+            2 = Pin acts as open drain INT
+            3 = Reserved
+            4 = Pin acts as push-pull output INT. Active low.
+            5 = Pin acts as push-pull output INT. Active high.
+            6,7 = Reserved
+          GPIO3
+            0 = High impedance input
+            1 = Pin acts as a GPIO, direction controlled by 'gpio-dir'
+            2-7 = Reserved
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+        minimum: 0
+        maximum: 7
+        default: 0
 required:
   - compatible
   - reg
@@ -71,5 +139,15 @@ examples:
           reset-gpios = <&gpio 110 0>;
           cirrus,asp-sdout-hiz-ctrl = <(CS35L45_ASP_TX_HIZ_UNUSED |
                                         CS35L45_ASP_TX_HIZ_DISABLED)>;
+          cirrus,gpio-ctrl1 {
+             gpio-ctrl = <0x2>;
+          };
+          cirrus,gpio-ctrl2 {
+             gpio-ctrl = <0x2>;
+          };
+          cirrus,gpio-ctrl3 {
+             gpio-ctrl = <0x1>;
+             gpio-dir = <0x1>;
+          };
         };
     };
-- 
2.25.1

