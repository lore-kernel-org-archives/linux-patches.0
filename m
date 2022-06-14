Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF161FCE
	for <patches@lists.linux.dev>; Tue, 14 Jun 2022 19:51:46 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 31so7784527pgv.11
        for <patches@lists.linux.dev>; Tue, 14 Jun 2022 12:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2w3cw6QyV5W4ckRn4xpfe5uPFSmcbBCuI4xeqnurwz4=;
        b=G4JiB1ndRniiJ+4Y32AhhgixsTU9L+tauaWfipSoo2+jJTyRjnlU+83RyDNQAjp9Wk
         WaLFgyDse9jNN3bPgOPJag4MQMg9xEL5tcAOuXQggX+nGSFVC/x919Ybrc8MFoHrSyeq
         yQhTYgHkDTAmVYKW2I7Q2FvGTc+an10Hw4f3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2w3cw6QyV5W4ckRn4xpfe5uPFSmcbBCuI4xeqnurwz4=;
        b=XsqrVrxDardlmbRkpUtGfY5iGvvffXVhGUVAfVMDHl4QV8d+7LNI3FpZD5hANYGJJl
         mPp7N6xA4M2wlnn8t95HCFoJy4Wh7Gp3DIYXCCTRKRVw0tIYVUwpnAZnXePyYT7U6EG3
         HD13J5vN5UnR2ynFQyrnkJ1vVZDMpX/zLa3JpGWwy99HEYHuhwlR5q8oFgxvj7rxU+m9
         6YXz4jXuOjTNxIZb6YrzI2F/9W+YnNA3T2//zhfTHgUK6yl+wNaA+SvpRlQVhGCruh7U
         pIkMYXxz4dUTvvJZNJyrYFlPk6GIIgPQAiQKlT3Z69GD0Tv2L+u2UBMSttjurlTj3RXa
         CIjQ==
X-Gm-Message-State: AOAM532u9U6fUTj0Jpb9PLz/QZmszG3MlNgbXHEsCgSpEP2V+6TDpwH2
	lPC13OgvlGqISDnxWPm9TJoAbg==
X-Google-Smtp-Source: ABdhPJwgIhMeRmRqmykxCqA3+kGYsQRsHDqhsNpzowYN0ya0k2yp8EHb0e6cPWYLt1THYYKy56LpZQ==
X-Received: by 2002:a63:d57:0:b0:3fd:ac2b:75aa with SMTP id 23-20020a630d57000000b003fdac2b75aamr5750872pgn.533.1655236306228;
        Tue, 14 Jun 2022 12:51:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:82ae:1136:b202:95da])
        by smtp.gmail.com with ESMTPSA id s21-20020a170902b19500b0015e8d4eb29csm7625484plr.230.2022.06.14.12.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 12:51:45 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	devicetree@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Craig Hesling <hesling@chromium.org>,
	Tom Hughes <tomhughes@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 0/2] dt-bindings: cros-ec: Update for fingerprint devices
Date: Tue, 14 Jun 2022 12:51:42 -0700
Message-Id: <20220614195144.2794796-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series introduces a DT binding for chromeos fingerprint
devices. The first patches tightens up the existing cros-ec binding and
the second patch introduces the fingerprint binding. As there aren't any
driver patches this can probably go directly through the chrome platform
tree if Lee can ack the mfd partfs.

Changes from v5 (https://lore.kernel.org/r/20220512013921.164637-1-swboyd@chromium.org):
 * Split out to different binding file again, while using 'select'
 * Fixed examples to have required interrupts property for cros-ec-spi

Changes from v4 (https://lore.kernel.org/r/20220321191100.1993-1-swboyd@chromium.org):
 * Drop last patch that implemented driver logic
 * Drop second to last patch because it's not really needed until
   compatible is used.
 * Rolled cros-ec-spi into cros-ec-fp compatible to get all the pieces

Changes from v3 (https://lore.kernel.org/r/20220318015451.2869388-1-swboyd@chromium.org):
 * Drop spi_device_id because it isn't used
 * Dropped struct members for gpios
 * Picked up tags

Changes from v2 (https://lore.kernel.org/r/20220317005814.2496302-1-swboyd@chromium.org):
 * Dropped cros-ec spi dt properties that aren't of use right now
 * Picked up tags

Changes from v1 (https://lore.kernel.org/r/20220314232214.4183078-1-swboyd@chromium.org):
 * Properly do the boot sequence
 * Add a message that we're booting and delaying a while
 * Fix typo in commit text
 * Change binding to not spell out reset-gpios and indicate that boot0
   is about asserting boot mode
 * Split device id to different patch as it's a different topic from
   booting

Stephen Boyd (2):
  dt-bindings: cros-ec: Reorganize property availability
  dt-bindings: cros-ec: Add ChromeOS fingerprint binding

 .../bindings/chrome/google,cros-ec-fp.yaml    | 97 +++++++++++++++++++
 .../bindings/chrome/google,cros-ec-typec.yaml |  1 +
 .../bindings/extcon/extcon-usbc-cros-ec.yaml  |  1 +
 .../i2c/google,cros-ec-i2c-tunnel.yaml        |  1 +
 .../bindings/mfd/google,cros-ec.yaml          | 38 ++++++--
 .../bindings/pwm/google,cros-ec-pwm.yaml      |  1 +
 .../regulator/google,cros-ec-regulator.yaml   |  1 +
 .../bindings/sound/google,cros-ec-codec.yaml  |  1 +
 8 files changed, 132 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/chrome/google,cros-ec-fp.yaml

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Craig Hesling <hesling@chromium.org>
Cc: Tom Hughes <tomhughes@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
https://chromeos.dev

