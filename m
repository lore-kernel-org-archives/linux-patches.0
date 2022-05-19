Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA28933F8
	for <patches@lists.linux.dev>; Thu, 19 May 2022 23:51:28 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id w17-20020a17090a529100b001db302efed6so6522077pjh.4
        for <patches@lists.linux.dev>; Thu, 19 May 2022 16:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q35UEoXZMSOCcWFw42emLPYiONOKqm2lz40BTN9A+tM=;
        b=DqXWeTE0OEyINrjPcpc9yri/jFkIZtNX9Jtkf89JF7Ixsn2tRbTntduA/QiAb4FOuc
         PDvVmT2zyplpwW6ARV04IhNM28Ecb25ZSry69jftIUQd9WwWmVoE7JvgFw6DUa/XmQJV
         sTQCP6ztMskUe/UDVTqet2hxP5IvoMk3Vtp5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q35UEoXZMSOCcWFw42emLPYiONOKqm2lz40BTN9A+tM=;
        b=B6c55cNJu5uPaqp6BLn9eJf/sDi/xMMBsMGacBgMq8fcKl6nuMm38FR386vzHxGQyZ
         fhCTgF7vYnHWNJR4qEvqQGOkhtKBWuWTimJr2BX6Q8r8IAeR6/6088yBC13MQW99YOIz
         jeF4MQLSishG85gKoDZmhmZV8R/do7ql8RD6qDUP8wboXe+Zu33S/0e2B8+JTAmyJmeG
         jTJfKyc3k2SvmOLbRs/cdaMUGYI40cT9dhjHsZ6wyaqO7RRhKvfht17BlWJgWauZH17c
         wkD0XMpV3D5gmDxANPKZ3r9eKmTeXUAbWHel0xurvjbzlSNalXjdXoHnK9o6OLvAN99z
         MuLQ==
X-Gm-Message-State: AOAM532+N711sgKPn27wTjoeym8t37KrtQ1tO3hVoWD8x0C0K6SODhWc
	61G095DaP7XHbQnFJECT+viTbA==
X-Google-Smtp-Source: ABdhPJzMGN37UVZtjWP6BKx/lse700pzDoGhoFR29+V9COGUUz+/fqUNPpKhMjPOpqTK8XweCe+SCg==
X-Received: by 2002:a17:902:8501:b0:15f:173:40e1 with SMTP id bj1-20020a170902850100b0015f017340e1mr7086601plb.74.1653004288460;
        Thu, 19 May 2022 16:51:28 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:e45f:1f3c:299b:4d86])
        by smtp.gmail.com with ESMTPSA id m2-20020a6545c2000000b003c18ab7389asm4128992pgr.36.2022.05.19.16.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:51:28 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Rob Herring <robh+dt@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>,
	linux-arm-msm@vger.kernel.org,
	Matthias Kaehlcke <mka@chromium.org>,
	Andy Gross <agross@kernel.org>,
	Alexandru M Stan <amstan@chromium.org>,
	"Joseph S . Barrera III" <joebar@chromium.org>,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Julius Werner <jwerner@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] dt-bindings: arm: qcom: Mention that Chromebooks use a different scheme
Date: Thu, 19 May 2022 16:51:06 -0700
Message-Id: <20220519164914.v3.2.I6418884d8bab6956c7016304f45adc7df808face@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
References: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The qcom.yaml bindings file has a whole description of what the
top-level compatible should look like for Qualcomm devices. It doesn't
match what Chromebooks do, so add a link to the Chromebook docs.

Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
---
The link added here will (obviously) not function until the
documentation patch makes it to mainline. Presumably folks who want to
read it in the meantime can find it pretty easily. If there's a better
way to link this then please let me know.

Changes in v3:
- ("Mention that Chromebooks use a different scheme") split out for v3.

 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 5c06d1bfc046..df5230792b37 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -90,6 +90,11 @@ description: |
   A dragonboard board v0.1 of subtype 1 with an apq8074 SoC version 2, made in
   foundry 2.
 
+  There are many devices in the list below that run the standard ChromeOS
+  bootloader setup and use the open source depthcharge bootloader to boot the
+  OS. These devices do not use the scheme described above. For details, see:
+  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/arm/google/chromebook-boot-flow.rst
+
 properties:
   $nodename:
     const: "/"
-- 
2.36.1.124.g0e6072fb45-goog

