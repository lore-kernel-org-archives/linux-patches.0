Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB78933CA
	for <patches@lists.linux.dev>; Tue,  3 May 2022 19:39:40 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id x23so10256760pff.9
        for <patches@lists.linux.dev>; Tue, 03 May 2022 12:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ppinaPJbJgnZ4lYEqEvTzKJ3KVzhWfLCUNKpobV/uMY=;
        b=GZDeuBBjdMiuh/0GD4S5Z7CgdVlfhqyeR9pyDRdIelbo2EyhbeprTZG0UPddoltyRe
         YWfDjfPBAwwodFAHt/hTo5mCvpD+K0h+ojF2FG2IP3+iWe0lLVFg4Zly+NPfk+Ohz7YA
         lpuB0QfbsIb6ogjiopQIq82iN7cahaV/R2oEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ppinaPJbJgnZ4lYEqEvTzKJ3KVzhWfLCUNKpobV/uMY=;
        b=LgZCdA/PoW93wNwhcllYn5pgCIQN8kS+9+LmS/WvNaanxs9BwPJ6XeqGFUgdQSkkKL
         Z+nzlIU+PHin2DWhKOckqCXkKzB9Fm/9b9jfitxFRp0XZtgreZMU12UYbMUs49njZuji
         UNEOIsyP/fCF+F6mazvr+BU5e53eOZUWqnqjqaknh9+0bCBhp4wMt4jBZzwanVtye5Jm
         fxQ+52J/sdu6CNu+y5eUXckx3Qhz7rwcTGIKG1iaeZ7ZocB7t5nojQzbUkyDr8+APnlZ
         SXMBb+B1ZLkWx8hn02RufMdBQ1ijpJxUh3fok7c4pzCvLkDAi2Riak3PsdQFifXmkSAj
         5qtg==
X-Gm-Message-State: AOAM530YEEHhjc0BLEWSv8VnuA7RN4C0FS4sRGvFbZDdajZk1SxiKuuY
	Fwik2a6oWey9DHBG90RGYJYjkw==
X-Google-Smtp-Source: ABdhPJyZI+fpaSs+G3ah33WViC0DquG+m5KKFzchEtRgKTakKTw0bcLyUz7uyKzt4loAHdyoWdKh9A==
X-Received: by 2002:a63:2a0d:0:b0:3ab:392c:f45c with SMTP id q13-20020a632a0d000000b003ab392cf45cmr15076384pgq.575.1651606780120;
        Tue, 03 May 2022 12:39:40 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id e25-20020aa78c59000000b0050dc7628154sm6680804pfd.46.2022.05.03.12.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:39:38 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	linux-iio@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: [PATCH v2 0/2] iio: sx9324: Support CS idle mode
Date: Tue,  3 May 2022 12:39:35 -0700
Message-Id: <20220503193937.3794477-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I need one more property to set another regsiter field for 
how to configure the CS pins during idle and sleep modes. This is based
on the latest patch series from Gwendal[1]

Changes from v1 (https://lore.kernel.org/r/20220503004156.3559940-1-swboyd@chromium.org):
 * Change 'hz' to 'hi-z'
 * Add property to example

Stephen Boyd (2):
  dt-bindings: iio: sx9324: Add CS idle/sleep mode
  iio: sx9324: Add setting for CS idle mode

 .../bindings/iio/proximity/semtech,sx9324.yaml   |  9 +++++++++
 drivers/iio/proximity/sx9324.c                   | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

[1] https://lore.kernel.org/all/20220429220144.1476049-1-gwendal@chromium.org/


base-commit: d79478a79cfa393cde46bccb05d52fc7d875d2e2
prerequisite-patch-id: 05986765e921df4c9725d10a3f51e68b0b5cc211
prerequisite-patch-id: 5e47b28af046dce1eb7d7ca492c466df0f30e07c
prerequisite-patch-id: adb59d1a14b74ddfe02c442da8bcca04765e7d15
prerequisite-patch-id: ec6069ee00463db27826962537ff880e69522f70
prerequisite-patch-id: e40f2a3048da2ff28bb426b85e41d277f29f18ef
prerequisite-patch-id: 82077662b97c09014c5b291fe5a42938a29ddbcd
prerequisite-patch-id: d02f0ec3be1fa9cdbf02a22c700982008d0550bd
prerequisite-patch-id: a02a8faefc5b7b68b99c0cc326973948c9356b60
prerequisite-patch-id: 522c808e4b8bf99b8404c01d495526a685e5b97a
-- 
https://chromeos.dev

