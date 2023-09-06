Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638910953
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:12:29 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68a3f1d8be2so106113b3a.3
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023949; x=1694628749; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rzB/a+Y/lgN6TI3eOxXMKAuw0gNhLZ5Kr4Exadxywqo=;
        b=Oh/vFJwfH0eO8ksTIxgBp6HHfO768Wa2X2+saIkqRfDDP/w4d4j8aoM5HxbNF4q6o6
         ygvQo3PivwKk+mb4DZWWH+L9KKe0Kc+pyfC0WvYeQE6vf4KdL4Wzwr6lp0jPPtaC9uaO
         6b/kb8xHTgNserXyPm8ZpAzn+wWVg4T2+8sn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023949; x=1694628749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rzB/a+Y/lgN6TI3eOxXMKAuw0gNhLZ5Kr4Exadxywqo=;
        b=gBY7svvuRmeRRunzwciBhtONILETYSmso1daezwYNbfwSCjXpLdmQugzDY2qEkST9L
         F9oXj30wjtVlrIZlzUcGzCavt/KI+gEJwtee96di4OfBFe4Z+12rV40aGQ5h5SgWO20z
         mpDEIgGT6LviGbidjZ9neSVZ3e6mibUA+oBnxyH5JaV+3m+QKAfyo8pmAk0SpmZgOuxy
         LDFF81ZjN6/ziOWFRsRhK26dOwz1GgcDL8sxS4kpohL/DX2bP2AIM135dzdbmdMNZsGI
         koyeIshgmIu4qZf/0mk2/K9v0EPhlkv+rdaQPyak6GbXGh2wOOGqX5M+ly+5KNnYZaIY
         Wrmg==
X-Gm-Message-State: AOJu0YwxalG7dg0ZOASE1iuRytE8rtzqajNuoWrlJZwpxGTzLMeQ5nD1
	zwsOBLOyYQtXMkw2uh3izMSA5UEhWu537YJiqp4=
X-Google-Smtp-Source: AGHT+IFw80g3ey9sUj6HYD/2kE56XDAkqaOhhVXfaGukTfoWlgxr29tf8KH2PEk4eYpkhtgk61cguQ==
X-Received: by 2002:a05:6a21:3e0b:b0:14c:5dc3:f1d5 with SMTP id bk11-20020a056a213e0b00b0014c5dc3f1d5mr15722364pzc.32.1694023949115;
        Wed, 06 Sep 2023 11:12:29 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id c10-20020a62e80a000000b0064fde7ae1ffsm11080552pfi.38.2023.09.06.11.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:12:28 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org
Subject: [PATCH 0/2] drm/msm/dp: More DPCD cleanups
Date: Wed,  6 Sep 2023 11:12:24 -0700
Message-ID: <20230906181226.2198441-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a follow-on to this series[1]. I can resend the whole pile if
desired.

[1] https://lore.kernel.org/r/20230829184735.2841739-1-swboyd@chromium.org

Stephen Boyd (2):
  drm/msm/dp: Inline dp_display_is_sink_count_zero()
  drm/msm/dp: Remove error message when downstream port not connected

 drivers/gpu/drm/msm/dp/dp_display.c | 10 +---------
 drivers/gpu/drm/msm/dp/dp_panel.c   |  1 -
 2 files changed, 1 insertion(+), 10 deletions(-)


base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
prerequisite-patch-id: c637903336fb0fd5593f0016f0c863305c43a6b9
prerequisite-patch-id: 8610693078de9cd5041266c70c4d044d15a5f701
prerequisite-patch-id: e10675f41cc68dcefa566f7f288b2df72afdb116
prerequisite-patch-id: 63280d764b830e3d25455ae642840cff5f90e118
prerequisite-patch-id: 567e00d48c5a296b454079a51483f2acce357347
prerequisite-patch-id: 1c18472728edc1ca8800dd6ed6ff12cb98084ea8
prerequisite-patch-id: c6f74b922b3a4f2255bcdab11fe3a2ecf7891262
-- 
https://chromeos.dev

