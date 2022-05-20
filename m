Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7033C3
	for <patches@lists.linux.dev>; Fri, 20 May 2022 21:38:55 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id f10so9081893pjs.3
        for <patches@lists.linux.dev>; Fri, 20 May 2022 14:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zulj73dBhoBwy8zgKmXSONhGGAK+6HOxdNu/R5R9Bp8=;
        b=M1YxvgPhWzo82ALxG7oqCka5wlcen3k/fl6tR9PT3/BMAWMn1re5T+qYsLndDcfFtT
         lBPTRohfnXzYpYN84q/9n1TtG1PjhJpsUP694KF89GMD/q9KBJtKQenHDX+p/ilMUBkx
         TWwttEI1QLAF1/qrGtZTn4QKjyEotE01h/O4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zulj73dBhoBwy8zgKmXSONhGGAK+6HOxdNu/R5R9Bp8=;
        b=UDFXRy1ZiXO4upZWILQ0fAjAkZ4UVOKUm9C0RP6/Mp/1AAZyjOg8czP3dn0RWuNF0V
         AbRDlZyheVb6H0aNbbfix6kp9VsBPdFo7p3EtI7J4bHFRnuZcu/+HGKcKRCe5jdEBR/q
         pd3zkUxFMcEEZYQzi67Sp6nr8HReqILx7dS5p1oPX6tgucQ7oD3pabKrQmUPQQxJrh1f
         qwu9MzyJXs9xAvdDpdyV6tLZ/JqQ9ueoxS3hIbof+3JJbfyiUBNx5bjKladvo2mUyUJj
         fmPwcHgzLgTXES0OSfb7d8GlEzt1p9kcOWGmjrEX/Tw8WVZDES+aLO5lSFipUtLYfMO4
         b39Q==
X-Gm-Message-State: AOAM530KD2XE6TIo/20wk5Cri1Xq2Q4kmgrEuQ+21ZgsEP6cuTMusJNA
	fekxiXduY+2wjcIPvQJaqGKcbA==
X-Google-Smtp-Source: ABdhPJwav1RDQ8a5mFUvn6XmzDrkhUb3q94qYu9K4vek0YEW0MyUzHTZlusMjakUEzDp4KEteRFyOw==
X-Received: by 2002:a17:903:11c4:b0:15f:14df:a919 with SMTP id q4-20020a17090311c400b0015f14dfa919mr11668244plh.21.1653082734799;
        Fri, 20 May 2022 14:38:54 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:b090:3896:c312:c4df])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090a450d00b001df955c28f6sm2070864pjg.37.2022.05.20.14.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:38:54 -0700 (PDT)
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
	Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] dt-bindings: arm: qcom: Mention that Chromebooks use a different scheme
Date: Fri, 20 May 2022 14:38:42 -0700
Message-Id: <20220520143502.v4.2.I6418884d8bab6956c7016304f45adc7df808face@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
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

Changes in v4:
- Use docs.kernel.org link.

Changes in v3:
- ("Mention that Chromebooks use a different scheme") split out for v3.

 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 5c06d1bfc046..5ac28e11ea7b 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -90,6 +90,11 @@ description: |
   A dragonboard board v0.1 of subtype 1 with an apq8074 SoC version 2, made in
   foundry 2.
 
+  There are many devices in the list below that run the standard ChromeOS
+  bootloader setup and use the open source depthcharge bootloader to boot the
+  OS. These devices do not use the scheme described above. For details, see:
+  https://docs.kernel.org/arm/google/chromebook-boot-flow.html
+
 properties:
   $nodename:
     const: "/"
-- 
2.36.1.124.g0e6072fb45-goog

