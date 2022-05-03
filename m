Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D4D190
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:41:59 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id g3so12885316pgg.3
        for <patches@lists.linux.dev>; Mon, 02 May 2022 17:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wYFtzIrfueBMYkfnReff/T+IPaO8wkd6Eu3COpG1jyw=;
        b=ID3tXj1Uzg9g8JCj0ITrp9Wpw+TuEF/qu/STWO0fQaoemE/EQYBL/dFn0sJ2fonLXL
         A/rvUHwOoFGebEOKpPiP5frTx2F65JPrfGjRrl/tqgg9aqsv0us8Hp3FlU/ZNIdJgCn8
         ud7TkuEK3uOTyQFg070R4spw/3mMZd/jVI0AQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wYFtzIrfueBMYkfnReff/T+IPaO8wkd6Eu3COpG1jyw=;
        b=5tPuJi4AZIcKphur2/7Dkfgh8CyxIBIBYTUKuZkJK6ba9p3iwfgITCpJ6CPtdaTKC5
         VpF9wShFka0e9qX0xtPiclvMlK+1L0vFR/5F57KT8cK0vOgwRkXnxrCPHLh9bUCUkT3a
         KK/dZDim2eY0qHWlYr+9diR1e17Tw8C+ULWDN/G/JlOyqbzW11VJyGBphimFaGSR/I95
         TvRS4UzPnyVObstnXSrOqlnjrqQFdMN9GYH6R3b2RXwMmzlFjT69sMQmFi6fTuecz9hS
         FXdoUjkCra7xgzY9fGfwqI6fCpMRSwyMs+Os0pZZhk02WmhMzYT0FuBR7Xx/VmZQYZ2T
         UP6w==
X-Gm-Message-State: AOAM5333PEMo+S6CQuAorIMNPxvZfzbTIzZ6DGrkzfx8s8YADoITWJyo
	7XkIYLfMTTwKyWaandBXCJjBog==
X-Google-Smtp-Source: ABdhPJzKVlYRARLnwIRKFb/PA/der9oV6KC/mTyJjBcp3p2GzSbu2BXrgotfzjLD+hU4yZnnbAMsJg==
X-Received: by 2002:a63:2c4a:0:b0:3c1:df82:cf0e with SMTP id s71-20020a632c4a000000b003c1df82cf0emr9971548pgs.474.1651538519296;
        Mon, 02 May 2022 17:41:59 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id i10-20020aa78b4a000000b0050dc7628177sm5258794pfd.81.2022.05.02.17.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 17:41:58 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	linux-iio@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: [PATCH 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Date: Mon,  2 May 2022 17:41:55 -0700
Message-Id: <20220503004156.3559940-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220503004156.3559940-1-swboyd@chromium.org>
References: <20220503004156.3559940-1-swboyd@chromium.org>
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

Cc: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../devicetree/bindings/iio/proximity/semtech,sx9324.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
index d265eb5258c8..6cec3481c8b2 100644
--- a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
+++ b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
@@ -126,6 +126,14 @@ properties:
       UINT_MAX (4294967295) represents infinite. Other values
       represent 1-1/N.
 
+  semtech,cs-idle-sleep:
+    description:
+      State of CS pins during sleep mode and idle time.
+    enum:
+      - hz
+      - gnd
+      - vdd
+
   semtech,int-comp-resistor:
     description:
       Internal resistor setting for compensation.
-- 
https://chromeos.dev

