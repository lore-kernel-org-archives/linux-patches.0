Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35979748E
	for <patches@lists.linux.dev>; Tue, 25 Oct 2022 18:07:06 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so1732072pjh.1
        for <patches@lists.linux.dev>; Tue, 25 Oct 2022 11:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UaHvsuBeqGUDHNJwrHZu7I7KXYW+zqfgTqUGn6DC/xo=;
        b=BrZrLWVB5VSJpkzOeZqV2YWZUWJDEwqbeQ1Nve9BZ4AAyOSYp43pwQEn1bBPMP1PUV
         xFiQdrcQEowdrnFBqYSxGvy8VpMmBzyE2atFCIS/8/rs65U/DPt7ezxoUwSB7kqZU/LH
         rZ4F/tlv0HbrYah5/V8rNIThPb6tiWOQcfTEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UaHvsuBeqGUDHNJwrHZu7I7KXYW+zqfgTqUGn6DC/xo=;
        b=V5o8TQkbMcLS0XbqDcXa585XIa0WhmkHrATH/TaijE6DLtu0RaKNX8FMBecPh7hb7A
         KPEicafjLureYzbqkis6sPkdf/x7KmvanCkk4RFGhqN13Loq5LvQs4l5ms5iSqKr7+nb
         CdoMPiGn/YgOUInX+qqPt1jnD35Bu5Bl7YYoc4VsrubFMnU935g/uLf72xXF3QKJfIS7
         /ktisrn5l5c5S5+Xe6QAWX9++rpZUJ1IfDRlPQsxqbPDIqs7s4iPS4zCB24GvaB7NmLF
         jdlsJ6E8wutwC7XHqs7ehzBh3NX5FM2CsueszefcdrhG/fgLqiECDz/5DtGyzPOtu3YG
         z/Vg==
X-Gm-Message-State: ACrzQf2ujY4q6P9vlWqTFW+I1PaKPbbS2chEU+ylzZCR54eVlDuFBdzQ
	SyaPErwJArxNSBzLM3X7lTZ8BQ==
X-Google-Smtp-Source: AMsMyM6KD70FiLQ2NY7/KT4ZdCgreGIg8amZ286q1tYd4ft48X6ah9dtxyQ5N7DjKGkH08gBYBnE6w==
X-Received: by 2002:a17:902:d483:b0:182:cb98:26e8 with SMTP id c3-20020a170902d48300b00182cb9826e8mr39797221plg.73.1666721225601;
        Tue, 25 Oct 2022 11:07:05 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:97a:f22a:beab:58])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902654800b001788ccecbf5sm1493786pln.31.2022.10.25.11.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 11:07:05 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH] arm64: dts: qcom: Remove fingerprint node from herobrine-r1
Date: Tue, 25 Oct 2022 11:07:03 -0700
Message-Id: <20221025180703.1806234-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It turns out that only a few people have the fingerprint sensor hooked
up on their board. Leaving this enabled is slowing down boot for
everyone else because the driver slowly fails to probe while trying to
communicate with a sensor that isn't there. Remove the node to speed up
boot, developers with the board can manually enable it themselves.

Reported-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dts b/arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dts
index c1a671968725..8d07401d852d 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dts
@@ -47,10 +47,6 @@ &pp1200_wf_cam {
 
 /* ADDITIONS TO NODES DEFINED IN PARENT DEVICE TREE FILES */
 
-&ap_spi_fp {
-	status = "okay";
-};
-
 /*
  * Although the trackpad is really part of the herobrine baseboard, we'll
  * put the actual definition in the board device tree since different boards

base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
https://chromeos.dev

