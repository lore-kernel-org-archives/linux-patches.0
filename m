Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787517CF
	for <patches@lists.linux.dev>; Tue,  3 May 2022 04:22:45 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so1193966pjb.3
        for <patches@lists.linux.dev>; Mon, 02 May 2022 21:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4lUh0yMD8sZjGjtl6Yt4cfDa+0R6nAeSt8H2W7xp7w=;
        b=Py1VeLdd73EaC/N3n2EUF5DQyzaEeRU4qjm+oSAX5LrWLpK5G0FoxrUniGC3udZw+N
         fiTYOoF0VoAZ13/dtzJ5ilWNXkPgwpOUkOYf8VHFH6Aw4m7b2nSBk/c0k/HuvIr5PkuW
         0KscM5R8Eq6nmzyv37b6TOVti2VbxK3HZ4wN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4lUh0yMD8sZjGjtl6Yt4cfDa+0R6nAeSt8H2W7xp7w=;
        b=zAv1XoWclaMBL0az6j7lKnS+MRgk8UCFDSQjS/jHTSrT1X9c4LaaRa8xs4IES7nbgC
         LQmSBabHImc3aZN3U+x0JBDZIvKspsTd87do6Zc4/ZRbiOmSejU/263p/efNlTqx9FrZ
         e727HC2FUtWAewnWai6oR9ITbQV8LbaBE3z1Hh6TDNsNkOsyLOKoQ/exGbM3/hReQolN
         ozIok6fw+iRGyWof/gtlQRJ1c0f4hlP3zZjLAQ7zw7cbsIqYk25u3cIe4fyH2PaAe/2f
         uS4OPehB42WuONZeyetzRyToaBCZ1wyCm4BjUP2CT+PzL+fbfT49z4KkAxW26ITmZ1R2
         uhhg==
X-Gm-Message-State: AOAM531+TcC70cqDtJGZhm5UlLJ0XgKOee+MzYLKFRrLBZRBl3qCJVjw
	MXqVHgSlK3WNVDWcAIN0xjr5HQ==
X-Google-Smtp-Source: ABdhPJxFcEjU1mcmL/2/u9IOmP+AtNAGjAGJjyWxSLlHdtDYjvQy/6Xq+2fsmLuTJIZ9EIwif3WXDQ==
X-Received: by 2002:a17:902:edc5:b0:158:4065:a5ce with SMTP id q5-20020a170902edc500b001584065a5cemr15343814plk.55.1651551764571;
        Mon, 02 May 2022 21:22:44 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e34b00b0015e8d4eb24asm5390223plc.148.2022.05.02.21.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 21:22:43 -0700 (PDT)
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
Subject: [PATCH v3 0/2] Input: cros-ec-keyb: Better matrixless support
Date: Mon,  2 May 2022 21:22:39 -0700
Message-Id: <20220503042242.3597561-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
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

 .../bindings/input/google,cros-ec-keyb.yaml   | 87 +++++++++++++++++--
 drivers/input/keyboard/cros_ec_keyb.c         | 20 +++--
 2 files changed, 92 insertions(+), 15 deletions(-)

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

