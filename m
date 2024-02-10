Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8593C46C
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549012; cv=none; b=dEHpvsQV1qDYQ7rGe0X+otUvkBWhnq+2V9XQZXNHBaOVwd2BefX32ZPIk2xoFU42fbxggYCJ391mPk6nxYBmqz4tBHG2YIOXfX7q+2CkNjefDt2pMKsHNj9hGnU/lAhL574HsGC5BzQZs6ezpvlaJ5jehXxY56Sx1IU/MvxotGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549012; c=relaxed/simple;
	bh=QWiqq/EJWFUQcAozvbWJFLlKJLTTtEoiwf9S8hzbqeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUFcxOfZv6VZKlwHzMrPhc6ROtWblv0ImkzKHczjBE+B+QyV9zFUSKkrgJ8Exu1sxvI6YD1o1kycJDWy0DlTQhwhnUewcSxwY42GEZcEDVeNrE9K1qljE40fUKAaxp4oqhHMG6V5gT5bOiRRL6SoXHL7V3dbxebwuWJHCLcGv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=UgKDRhay; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UgKDRhay"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bed8faf6ebso81579039f.2
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549010; x=1708153810; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDZTkmgJLWBgtbMLYvgKp9lpTe2pMS2z/gX4STfhWdw=;
        b=UgKDRhayi1TGRqmcafUCJispz9Ne28t4S5d8EJpkH0rj2c5+B7mgvjAGQx6rCg8PDN
         w7eg6dsRZ88Rdj+vbmEz5LzXBwhpPq6Lw54l3cgCAE8IjNwd9g9r4b3P/VV38AmWJrd9
         SrtnxT1C/Tu6D6Wle+9+mkMSnayXvxYXbse0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549010; x=1708153810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDZTkmgJLWBgtbMLYvgKp9lpTe2pMS2z/gX4STfhWdw=;
        b=ZdQdrNvR2odLZj3pscYlTe70t3fpQcsayuFo85+rBAD3LIFtzfORjYv1iyiv+yK8u+
         XfO1igvM//87fkHqkhK20A/1RfEtnOmWPtev1DtnrRnNwV5TZl6uWNAJ3KTDxXVdaqqF
         cac71p+BB3aOdW6HFGb48l/KbaUkU50DNHB5CGQ+lOLIs7wxmasIf3I36zUWrT0coSGS
         Q+30YunuPJq+pfYetT9Bb2mDZLMl9qB37H/p34BgiRCelc/L3681UZ7FozgEKz4f9Fx9
         QbVimEzA2JZFXpBOtiR686044cPNbmcHc+OY2Fg4a7bWaepGsfCbeZfi+swUPeVwaO8L
         B6Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWen0z9Lh1PCjLwbSknl9A5eOo5O7CjfzKCyLaTwn73zz8GT5LDQi8zpUgkNFrZxQNTTOj0G0IsaFCRWOVPUs5t7d446Vc4OQ==
X-Gm-Message-State: AOJu0YzBdGWVlQyQAFjD4nQM5leji6nHWVymnVV4lCqsw8HIb15DQU56
	Htx51MJgSXyRUNTK1ZOlulFC2iAZDBy1//pi1+0oE+pjNWR1550t2VRXivQkxQ==
X-Google-Smtp-Source: AGHT+IHs/c8PKyjVEScyFRbE6bgu7Z0/4J8m591pv2LP5Byv5N2xK8dgo6/QivpRemKJGxe0uIu3Cw==
X-Received: by 2002:a92:d68d:0:b0:363:8440:94af with SMTP id p13-20020a92d68d000000b00363844094afmr1850383iln.4.1707549009907;
        Fri, 09 Feb 2024 23:10:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXcbuzrwhJYBRxjSeZiLO7NiAXZkROYgoL66zUbURb+mKWdFNkE6YZWqeF+fYWzC1OoLZJ7vIaJmnoX3ubJWT7jqdvCY3rb09nwzZNcZhyC6krhPIcpvVvuVMMZNAnyKp9wnSSTH4t5cCAFUNIT7kJ+WfzMIPezrdAnaANZwomwtlICT/Zr6r6RH5dlWO4ezhFtYRQ6Q6Oh3zoSRI5OqGmM7ak06KvSvc3623YX+w3HE1EN3Csld1jrH73e0N3sxhR0B0J3jsxOise0EElL18ApOgIkSprzCthwYIBL1QtBa+JJtH2NCkcO9g0jOyB9NNaWXW17EVaMe/lRlek3BOYXPVYdRj87lUF0pBXGkR6DRfMEjWr7zzTZSsxS1JPLsk6LX/BNGwzXn6f6u6mmbipoH8xhmPQ3KatEpPcQwL4MwelEQEs/zshZ39hj53M=
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id bx34-20020a056a02052200b005d8b69f882esm2566257pgb.38.2024.02.09.23.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:10:09 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>
Subject: [PATCH 18/22] dt-bindings: chrome: Add binding for ChromeOS Pogo pin connector
Date: Fri,  9 Feb 2024 23:09:29 -0800
Message-ID: <20240210070934.2549994-19-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
In-Reply-To: <20240210070934.2549994-1-swboyd@chromium.org>
References: <20240210070934.2549994-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe the set of pins used to connect the detachable keyboard on
detachable ChromeOS devices. The set of pins is called the "pogo pins".
It's basically USB 2.0 with an extra pin for base detection. We expect
to find a keyboard on the other side of this connector with a specific
vid/pid, so describe that as a child device at the port of the usb
device connected upstream.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../chrome/google,pogo-pin-connector.yaml     | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml

diff --git a/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml b/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml
new file mode 100644
index 000000000000..5ba68fd95fcd
--- /dev/null
+++ b/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/chrome/google,pogo-pin-connector.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Google Pogo Pin Connector
+
+maintainers:
+  - Stephen Boyd <swboyd@chromium.org>
+
+properties:
+  compatible:
+    const: google,pogo-pin-connector
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  port:
+    $ref: /schemas/graph.yaml#/properties/port
+    description: Connection to USB2 port providing USB signals
+    required:
+      - endpoint
+
+patternProperties:
+  "^keyboard@[0-9a-f]{1,2}$":
+    description: The detachable keyboard
+    type: object
+    $ref: /schemas/usb/usb-device.yaml
+
+required:
+  - compatible
+  - '#address-cells'
+  - '#size-cells'
+  - port
+
+additionalProperties: false
+
+examples:
+  - |
+    connector {
+        compatible = "google,pogo-pin-connector";
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        keyboard@2 {
+          compatible = "usb18d1,504c";
+          reg = <2>;
+        };
+
+        port {
+            pogo_connector_in: endpoint {
+                remote-endpoint = <&usb_hub_dsp3_hs>;
+            };
+        };
+    };
+
+...
-- 
https://chromeos.dev

