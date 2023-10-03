Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D629365
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 00:34:31 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5859b1c92a0so193831a12.2
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 17:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696293271; x=1696898071; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CLzLe9FrFcSRLQYLz3TN9yC6YJWYh7HG+BIh8jZ2l60=;
        b=VPUPILnlmMvpVL6miDDumchQ0AaEsDxlDTK6Gh+lRySuWNIAtPDP9jnx8dI3ECGEug
         Pn1u+FEc7gb8E7iR8pdykFtvi4ysn1ja+tZUA1SqpgwA+l/4ToHMKFqUB5fcDRqn6iz6
         8I9U8P9eNG8LYOtQ+Mvx3ixhRv/cA56Nki+2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696293271; x=1696898071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CLzLe9FrFcSRLQYLz3TN9yC6YJWYh7HG+BIh8jZ2l60=;
        b=Z6qoZUOneaIU06jAlcBOuKZQBqPVJKlEp1nw7gzV4BUuTb1XKruGiTVFk0hO8GbVzx
         jbwbSMNaAN+6qlFbcSm6rWl2+a8E9d3r6FivO5RBH2mHWoVplqUmfbRx8KGbqFtkX+W4
         jSB6ry8rRSwmuVnSA2vGjKLRfhrTewbcIQv1js+fegxF90Y3+9djP6Nu27eye4fiFLMZ
         /+QwdTe0oTsGXupspfhOHa2EUtN7uqI934/bPZ5bzrsxm+zFgPJXU5QCjri5T76ll4Y5
         p1guEmHJ8HXF1HEifS0m/OfMJfcVr03ieOuBXfYb81QAndMnP6HlN53OZhjGdusvRc00
         pC2w==
X-Gm-Message-State: AOJu0Yy7sg0HE1sIvJKrFOr23ee+tgdhztaijhwKEUJYnkg9wuotHUc1
	dy+dKeyR6tRG+v17oO6XK3IvGQ==
X-Google-Smtp-Source: AGHT+IH9X2WMxnOuNE9ItsTdLVOGQrsDzZs7Y+RgdoCxMjPQ14Zoimq0BAGrTodLKwpbqhDegXssXQ==
X-Received: by 2002:a05:6a21:1f20:b0:15d:6ea0:82da with SMTP id ry32-20020a056a211f2000b0015d6ea082damr11124826pzb.33.1696293271241;
        Mon, 02 Oct 2023 17:34:31 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:f676:8db:8677:aefe])
        by smtp.gmail.com with ESMTPSA id bm2-20020a056a00320200b0068a13b0b300sm101368pfb.11.2023.10.02.17.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 17:34:30 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev
Subject: [PATCH 0/4] platform/chrome: Random driver cleanups
Date: Mon,  2 Oct 2023 17:34:24 -0700
Message-ID: <20231003003429.1378109-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's some random chromeos driver cleanups that have been sitting in my
tree. I've noticed them while browsing the code for something I'm
working on.

Stephen Boyd (4):
  platform/chrome: cros_ec_typec: Use semi-colons instead of commas
  platform/chrome: cros_ec_typec: Use dev_err_probe() more
  platform/chrome: cros_typec_vdm: Mark port_amode_ops const
  platform/chrome: cros_ec_proto: Mark outdata as const

 drivers/platform/chrome/cros_ec_proto.c     |  2 +-
 drivers/platform/chrome/cros_ec_typec.c     | 18 +++++++++---------
 drivers/platform/chrome/cros_typec_vdm.c    |  2 +-
 drivers/platform/chrome/cros_typec_vdm.h    |  2 +-
 include/linux/platform_data/cros_ec_proto.h |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)


base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
https://chromeos.dev

