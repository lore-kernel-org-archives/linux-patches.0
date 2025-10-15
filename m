Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C9A32A3C8
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704510; cv=none; b=hlvpIKNO2NeYNqQ4sCfHNXhxybyU+uJWOXERmg8w02MVzdp5TNGDmKEQw5ZY4gqgpJ4e5v7TOJvFcua1BpiUmZJkbkON3hvqSolcO9icBx4Mvw+Md+NKMJGne63dxPnR6fk4g4gguTg9y+HDgxDB0Q1gjIeE0rFoeAPO3X2h+U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704510; c=relaxed/simple;
	bh=ML2Ti7tRJ2KQiK381fMrUP2Ry1b88VZpb0yvl3PCZsM=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Subject; b=gIIh0I3VNDxEXeMceo5ZBZKFuVm6IbLhYLGs74OcX/56TGcc4J3ZWsWxW2KI+/gJHJqpfy8kVsU/r1n4WkSCJpdlfhp4oCitFhrVSfm8DOlJj/RrDnV2K/QYGc1lL23Zwkm7zK4lXPYOsy/5x2EwYGrdWHqlf8uWirrDONkAro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=We2aEycd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="We2aEycd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59F7C113D0
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 12:35:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="We2aEycd"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 17 Oct 2025 13:35:06 +0100
Resent-Message-ID: <aPI3-vbGC3uJROhi@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 15 Oct 2025 11:35:22 +0100
Received: from tor.source.kernel.org ([172.105.4.254])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=XNYv=4Y=realtek.com=oder_chiou@kernel.org>)
	id 1v8yql-002SAz-U4
	for broonie@sirena.co.uk; Wed, 15 Oct 2025 11:35:22 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18DCA62587
	for <broonie@sirena.co.uk>; Wed, 15 Oct 2025 10:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D77C5C116B1; Wed, 15 Oct 2025 10:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76A3EC4CEF8
	for <broonie@kernel.org>; Wed, 15 Oct 2025 10:35:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 76A3EC4CEF8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=realtek.com
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 59FAYmkT6782519, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1760524488; bh=LRe5HHaJZ+PKbIf6PPoCgzmS5UQrHCwFuVDQ+Vg2ai8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=We2aEycd7/xhGYTvOlZHl/AgcFm2Mlqkz0OlRtcqhV2THGT+4I/qefx38wmr0MyAe
	 OvtTBH6BJz3EM4tt78rwD+7W7HqgcI4vmOVOf/UA+t3IbwUIXgLlvqkVLNJgRWpUKD
	 kbg9USJ/7anfbSobxHy+LhgRY9n7acWCxhc2D98DSHU/caFCjGr9enu8VgiOmeuq2b
	 +2wjUiENYh5XSuREmpCIO49mWUF8xFtCHB0PRLDlZm8/EnMfOLn71gXzx2xrMb272l
	 4zlKGNlLjcZ9KzN97Wh3Dd1amV3Gz/7XnlOdMsHgBmpZy+zdHKI63ryOgSf7vDc7jx
	 Kgn7nLJyMZOQg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.13/5.93) with ESMTPS id 59FAYmkT6782519
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 18:34:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.27; Wed, 15 Oct 2025 18:34:49 +0800
Received: from sw-server.localdomain (172.24.54.4) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.27; Wed, 15 Oct 2025 18:34:49 +0800
From: Oder Chiou <oder_chiou@realtek.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <flove@realtek.com>, <shumingf@realtek.com>,
        <jack.yu@realtek.com>, <derek.fang@realtek.com>,
        "Oder Chiou" <oder_chiou@realtek.com>
Date: Wed, 15 Oct 2025 18:34:04 +0800
Message-ID: <20251015103404.3075684-2-oder_chiou@realtek.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251015103404.3075684-1-oder_chiou@realtek.com>
References: <20251015103404.3075684-1-oder_chiou@realtek.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTKEXHMBS06.realtek.com.tw (10.21.1.56)
X-SA-Exim-Connect-IP: 172.105.4.254
X-SA-Exim-Mail-From: SRS0=XNYv=4Y=realtek.com=oder_chiou@kernel.org
Subject: [PATCH v5 2/2] ASoC: dt-bindings: realtek,rt5575: add bindings for ALC5575
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: jy/ejGtWCnpD

Realtek ALC5575 codec has a built-in DSP.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
---
 .../bindings/sound/realtek,rt5575.yaml        | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/realtek,rt5575.yaml

diff --git a/Documentation/devicetree/bindings/sound/realtek,rt5575.yaml b/Documentation/devicetree/bindings/sound/realtek,rt5575.yaml
new file mode 100644
index 000000000000..8fbcb64ae1d3
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/realtek,rt5575.yaml
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/sound/realtek,rt5575.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ALC5575 audio CODEC
+
+maintainers:
+  - Oder Chiou <oder_chiou@realtek.com>
+
+description: |
+  This device supports both I2C and SPI.
+
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+  - $ref: dai-common.yaml#
+
+properties:
+  compatible:
+    const: realtek,rt5575
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        codec@57 {
+            compatible = "realtek,rt5575";
+            reg = <0x57>;
+        };
+    };
-- 
2.34.1

