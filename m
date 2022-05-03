Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3789433CA
	for <patches@lists.linux.dev>; Tue,  3 May 2022 19:39:42 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id h12so15835176plf.12
        for <patches@lists.linux.dev>; Tue, 03 May 2022 12:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yb09R8V6T/hLKKorfQqqI/dYQ92aTPVCxYGvivN1WrQ=;
        b=nTnedbqZxvH3D4aoZhb8M4LN7yGE7oQAKVek4oFDpicjTEEuiiy1QnCB4CMj2ITh3r
         E35d1+bmNmbhlwRH6UBciyjGg3S/PzaInsbNHCmaq4LEz3tuoY082AAiyFKfvrkwXBeo
         JfIuom64Lrfu2J6c+jqE1UOZTnEjASjIOGqjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yb09R8V6T/hLKKorfQqqI/dYQ92aTPVCxYGvivN1WrQ=;
        b=5qElrms7zOP4StYxt0xPU/TAhtsGrF91RCBJgPvGlAkmZi8MHKUULm9vOnucKYB3cL
         eZPIvlmLSST1gwMcipfqs4U0iW+sUrl++xjinyJl54UgmDKv6KEEFaOdrcbll0sdOUvs
         aL8pzeHXSjHic+rr+Zb5bNRRdHqkefa6VQoRgc16oYtTyhEa1kJKZHoFdek1suGFyeUT
         45UvfLOPkR3w0MrsWPVxPh6sFgVTmxFtwnfhUI2upGc/VvADFyFP1jxbhh505ITUT7Bg
         HjeX9rkAhIWUEmN1v58SuEoaeHnNdf3oRFpOWeHJ6rR91ZHJaUgmh8jLd4IDuWMoZKVb
         zaDQ==
X-Gm-Message-State: AOAM533PZIQTx/pdKfLbfp59QSvn9WLfzmkG35zdeKLJECeiEb2xPC5l
	blRuvAXf7vKwyAElFYTfXyw5JQ==
X-Google-Smtp-Source: ABdhPJzTCzLG6PohQNnCIuBLy07mZZOZm1WT+JhkbF402wdu6mru5FQFvmPnqMVpAfcfohVdTAjmFQ==
X-Received: by 2002:a17:90b:4c09:b0:1dc:6c30:f230 with SMTP id na9-20020a17090b4c0900b001dc6c30f230mr6442474pjb.110.1651606781671;
        Tue, 03 May 2022 12:39:41 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id e25-20020aa78c59000000b0050dc7628154sm6680804pfd.46.2022.05.03.12.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:39:40 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	linux-iio@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Date: Tue,  3 May 2022 12:39:36 -0700
Message-Id: <20220503193937.3794477-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220503193937.3794477-1-swboyd@chromium.org>
References: <20220503193937.3794477-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to configure the sleep and idle mode of the CS pins for this
device. Add a DT property to do this so pins are in a proper state
during sleep (either hi-z, grounded, or pulled up to vdd).

Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/iio/proximity/semtech,sx9324.yaml           | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
index d265eb5258c8..b3aa2ebf9661 100644
--- a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
+++ b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
@@ -126,6 +126,14 @@ properties:
       UINT_MAX (4294967295) represents infinite. Other values
       represent 1-1/N.
 
+  semtech,cs-idle-sleep:
+    description:
+      State of CS pins during sleep mode and idle time.
+    enum:
+      - hi-z
+      - gnd
+      - vdd
+
   semtech,int-comp-resistor:
     description:
       Internal resistor setting for compensation.
@@ -187,5 +195,6 @@ examples:
         semtech,avg-pos-strength = <64>;
         semtech,int-comp-resistor = "lowest";
         semtech,input-precharge-resistor-ohms = <2000>;
+        semtech,cs-idle-sleep = "gnd";
       };
     };
-- 
https://chromeos.dev

