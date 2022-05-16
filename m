Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0A1376
	for <patches@lists.linux.dev>; Mon, 16 May 2022 18:34:54 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 202so14856689pgc.9
        for <patches@lists.linux.dev>; Mon, 16 May 2022 11:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ND8PT1JbEK9sNH8l0vjUc9ivWP9q6grqcaLrqiHd17w=;
        b=aTih4suD01GOEGOHwQsrDkW85JkMwe1FJcwfcvDvngb4WWWw+0R+L8L5R8u2MXSqgz
         wCmXeepWtdzQyrBAzJrQx+umSW7wgVVtad9nT4mFpm+yzsT2lPkuCUEsOWIvqlGlDc/u
         +M3cYdBEygDR4d+8o1Q/08O2j986Jxmg9pgM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ND8PT1JbEK9sNH8l0vjUc9ivWP9q6grqcaLrqiHd17w=;
        b=fn889iCtCEXbRDJd/hZ8dmxvY+AorUDbQslR+nNrtA0yEqlZkFmW8g0VGySMdChTUI
         vnIuRlXI60J20VUAwf2YmLCMIynpkHxqYwMugL40AfI+h8igkFSmKY6z/vyapHA8wBpB
         VdA60DuMV+gdHOA+KoR3SZLzlsMY73AToObdvNP0Ix4AsRUgJvCCqt0Oko6gYhZ5bzR9
         Q7Lo73WtcwMeK9Oev0pqnhXWJobO7E/pZZDO0QM7yVaki6TWIeYXrsrirLbnxpsZFxOi
         e2B60C/jnzUI+ceAMmO8sDYyFT6zUfxzi+wXG71BSedONESwPaFk9zE843X7YZ/j7I48
         9qmA==
X-Gm-Message-State: AOAM531jRKP01KR/KDldDhg6kttzeoAtfYIXfXYT5AUpbEKo1AdFlUo/
	p90KNrWAzOxKKuaO3GQpeAyGzg==
X-Google-Smtp-Source: ABdhPJz6CmiuPrfYudzJKS4y8hS8jwFnUVEBC5Zu6nO9STUk+y6bjDsVybZ5mlT/a0AGoMiNT+8EbQ==
X-Received: by 2002:a63:2048:0:b0:3db:7de7:34b4 with SMTP id r8-20020a632048000000b003db7de734b4mr16508794pgm.105.1652726094158;
        Mon, 16 May 2022 11:34:54 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:7d0d:b8ac:a3e3:757a])
        by smtp.gmail.com with ESMTPSA id w16-20020a1709026f1000b0015e8d4eb24fsm7331090plk.153.2022.05.16.11.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 11:34:53 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH v5 0/2] Input: cros-ec-keyb: Better matrixless support
Date: Mon, 16 May 2022 11:34:50 -0700
Message-Id: <20220516183452.942008-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a followup to my previous patch[1] that skips keyboard registration
when the matrix properties aren't present. This adds a compatible string
for this scenario so we can ease existing DTBs over to the new design.

Changes from v4 (https://lore.kernel.org/r/20220503204212.3907925-1-swboyd@chromium.org):
 * Make switches compatible fail probe if no switches present
 * Add description to compatible list

Changes from v3 (https://lore.kernel.org/r/20220503042242.3597561-1-swboyd@chromium.org):
 * s/register_keyboard/has_keyboard/
 * Pick up review tags
 * Indicate properties are required in example #2 in yaml file

Changes from v2 (https://lore.kernel.org/r/20220429233112.2851665-1-swboyd@chromium.org):
 * Drop rows/cols check now that compatible schema handles it
 * Make binding require rows,cols,keymap for cros-ec-keyb compatible

Changes from v1 (https://lore.kernel.org/r/20220427203026.828183-1-swboyd@chromium.org):
 * Better enforcement of properties in DT binding
 * Skip registration by means of adding compatible to device id list

Stephen Boyd (2):
  dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
  Input: cros-ec-keyb - skip keyboard registration w/o cros-ec-keyb
    compatible

 .../bindings/input/google,cros-ec-keyb.yaml   | 91 +++++++++++++++++--
 drivers/input/keyboard/cros_ec_keyb.c         | 26 ++++--
 2 files changed, 101 insertions(+), 16 deletions(-)

Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>

[1] https://lore.kernel.org/all/20220425210726.3813477-1-swboyd@chromium.org/

base-commit: 4352e23a7ff2f8a4ff229dd1283ed2f2b708ec51
-- 
https://chromeos.dev

