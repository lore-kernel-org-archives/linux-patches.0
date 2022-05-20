Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4541E2FAF
	for <patches@lists.linux.dev>; Fri, 20 May 2022 21:38:54 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id h9so582235pgl.4
        for <patches@lists.linux.dev>; Fri, 20 May 2022 14:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JY2yFL0uwa0h1jwIIpYY9zlYj6tua2HV5MA+NWkzrlM=;
        b=VKf459qgtfIN2nwURKwdzW9/x2MsK2XhWFkIQpwhoxQ8B5sQdZZgm7CeI51WyA1W8i
         bjiZRrIlXQ35qjT+7Fa/pZWRw9ZTLZ6PtWfv9obMY1QnNlnruEZ141wZD3m34+6puxNG
         uvZJ/F6VbPYrW+4mXStLdi94M3px/tar/ZhFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JY2yFL0uwa0h1jwIIpYY9zlYj6tua2HV5MA+NWkzrlM=;
        b=tuwzOhrBtHPLmBtWhEN/PI0qcrm8iVwMWl+DCtFwo7mmc2MXZj6+8FXKb8Wj2zHBOi
         RUJS1jEUE0ggCHhCA2tcpWFpYDLQDO1tR0da3B8Na6hOcaSANaqtHXH0LSRZVkJvG8Pm
         nLM47LIROywdBmHUAoY1V9MUT6CkWQxQzkMsYQIuQjFJt21UPYSezYHLyFb0dNN/II2d
         CyoGgQj3mptTxVFSLtBlhERuhzTv3DVsJWevHXLf65brdNo0P8agua7P2+4o+Bg1znmB
         eL2doN84nJ4UAKsIUg/EG+3FxgGMkyFGVn1/RQKZJ3luOjFuOe+KJwJyZSyEX4jk7T+C
         kE+w==
X-Gm-Message-State: AOAM531dNlxcf0jwKjgT/izA1mzShoB9wbZse0J/ZaUT8k+F3PzniN0E
	8vxlRYkgDEvDA+zd74iws3HKbA==
X-Google-Smtp-Source: ABdhPJyQ7sTZ4EOkBnkyPfFAtpjkbiEhqkikYoQc6iCiuVDywMgjCXw9CxDj9gsimAlD7Cxsu5AJnA==
X-Received: by 2002:a63:2b11:0:b0:3f6:5f7f:9e67 with SMTP id r17-20020a632b11000000b003f65f7f9e67mr6384417pgr.492.1653082733609;
        Fri, 20 May 2022 14:38:53 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:b090:3896:c312:c4df])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090a450d00b001df955c28f6sm2070864pjg.37.2022.05.20.14.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:38:52 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Rob Herring <robh+dt@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Julius Werner <jwerner@chromium.org>,
	Andy Gross <agross@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	"Joseph S . Barrera III" <joebar@chromium.org>,
	devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] dt-bindings: Document how Chromebooks with depthcharge boot
Date: Fri, 20 May 2022 14:38:41 -0700
Message-Id: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This documents how many Chromebooks pick the device tree that will be
passed to the OS and can help understand the revisions / SKUs listed
as the top-level "compatible" in many Chromebooks.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
In my opinion this could land through the Qualcomm dts64 tree, mostly
because I want to land bindings patches in that tree that refer to
it. Since it's a new file it seems like there ought to be few
objections?

Changes in v4:
- Add reference to depthcharge and FIT Image.
- A few rst syntax fixups found by using a different rst preview.
- Updated wording as per Stephen.

Changes in v3:
- Fix up typos as per Matthias.
- Move under Documentation/arm/google/ as per Krzysztof.
- Add missing newline at end of file.

Changes in v2:
- ("Document how Chromebooks with depthcharge boot") new for v2.

 .../arm/google/chromebook-boot-flow.rst       | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/arm/google/chromebook-boot-flow.rst

diff --git a/Documentation/arm/google/chromebook-boot-flow.rst b/Documentation/arm/google/chromebook-boot-flow.rst
new file mode 100644
index 000000000000..36da77684bba
--- /dev/null
+++ b/Documentation/arm/google/chromebook-boot-flow.rst
@@ -0,0 +1,69 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
+Chromebook Boot Flow
+======================================
+
+Most recent Chromebooks that use device tree are using the opensource
+depthcharge_ bootloader. Depthcharge_ expects the OS to be packaged as a `FIT
+Image`_ which contains an OS image as well as a collection of device trees. It
+is up to depthcharge_ to pick the right device tree from the `FIT Image`_ and
+provide it to the OS.
+
+The scheme that depthcharge_ uses to pick the device tree takes into account
+three variables:
+
+- Board name, specified at depthcharge_ compile time. This is $(BOARD) below.
+- Board revision number, determined at runtime (perhaps by reading GPIO
+  strappings, perhaps via some other method). This is $(REV) below.
+- SKU number, read from GPIO strappings at boot time. This is $(SKU) below.
+
+For recent Chromebooks, depthcharge_ creates a match list that looks like this:
+
+- google,$(BOARD)-rev$(REV)-sku$(SKU)
+- google,$(BOARD)-rev$(REV)
+- google,$(BOARD)-sku$(SKU)
+- google,$(BOARD)
+
+Note that some older Chromebooks use a slightly different list that may
+not include SKU matching or may prioritize SKU/rev differently.
+
+Note that for some boards there may be extra board-specific logic to inject
+extra compatibles into the list, but this is uncommon.
+
+Depthcharge_ will look through all device trees in the `FIT Image`_ trying to
+find one that matches the most specific compatible. It will then look
+through all device trees in the `FIT Image`_ trying to find the one that
+matches the *second most* specific compatible, etc.
+
+When searching for a device tree, depthcharge_ doesn't care where the
+compatible string falls within a device tree's root compatible string array.
+As an example, if we're on board "lazor", rev 4, SKU 0 and we have two device
+trees:
+
+- "google,lazor-rev5-sku0", "google,lazor-rev4-sku0", "qcom,sc7180"
+- "google,lazor", "qcom,sc7180"
+
+Then depthcharge_ will pick the first device tree even though
+"google,lazor-rev4-sku0" was the second compatible listed in that device tree.
+This is because it is a more specific compatible than "google,lazor".
+
+It should be noted that depthcharge_ does not have any smarts to try to
+match board or SKU revisions that are "close by". That is to say that
+if depthcharge_ knows it's on "rev4" of a board but there is no "rev4"
+device tree then depthcharge_ *won't* look for a "rev3" device tree.
+
+In general when any significant changes are made to a board the board
+revision number is increased even if none of those changes need to
+be reflected in the device tree. Thus it's fairly common to see device
+trees with multiple revisions.
+
+It should be noted that, taking into account the above system that
+depthcharge_ has, the most flexibility is achieved if the device tree
+supporting the newest revision(s) of a board omits the "-rev{REV}"
+compatible strings. When this is done then if you get a new board
+revision and try to run old software on it then we'll at pick the
+newest device tree we know about.
+
+.. _depthcharge: https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/depthcharge/
+.. _`FIT Image`: https://doc.coreboot.org/lib/payloads/fit.html
-- 
2.36.1.124.g0e6072fb45-goog

