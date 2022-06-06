Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEC54C63
	for <patches@lists.linux.dev>; Mon,  6 Jun 2022 23:51:57 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so19219790pjl.4
        for <patches@lists.linux.dev>; Mon, 06 Jun 2022 16:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1RFyXYoYG1d/O/MId2w1B4qXmXmbYcy40FEdfUxvDQ0=;
        b=Cn3xLCJxxjoTsVuwqp4QaegknKudM2FH3/d/+nJkjzf4H1AvVDp/IgClVKDfHZJ2A2
         jACgpuyFCU00hBNTwxrs1EueGiz3NjE//n6nfUgIMPTiqfYvnQeyna7MqsO6S5qHtI+V
         tF8lvzR57RWx+SLLgvn+Qqgw7S+zESJVXQYn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1RFyXYoYG1d/O/MId2w1B4qXmXmbYcy40FEdfUxvDQ0=;
        b=sgiHw7VsdtU3v+11WGu07OMxnenphYRsIFqZnSZn6rk6b3Xas0j32aLXpxTdffWCm/
         YmswYCUgzlYBh4MZObHYIAOlD44/+wb3veaUldBgqqba4yckPvh+URSaQvgXmonjRtfs
         WeXj/mKymxDmjJjd0WhohTPLkN2lpYPOl+S8t7GQ1j1sikU+mj8AT1mcXd8JoN9INb98
         KC83wHvEyEUfVOyB15Hz4v5ulISCtlWu6MbXRlhfvU2OHfCIy3HVpDNHT5XNkXTvUZDE
         KBfMu7wTB6ZwAiDa/LT+B57ZuB81ZYkBa9aIjtw0lQ6IYb1gSy7tHUIOGN6TJZTUTK0P
         ICDg==
X-Gm-Message-State: AOAM531XKLflsMu8bJ/cwgUUchRkI2fEAXwEoTQq0mJphIUsMogS24OZ
	XNbzatmA3KNlzrxMc/fgNti7sQ==
X-Google-Smtp-Source: ABdhPJzmrGgJHv3Bva+srWmCfwk6Cq0f7P99pevSkJYxd09EjqAPoGwRWZ7+0eiFwXeNjYxkmOiYlw==
X-Received: by 2002:a17:902:d4ca:b0:164:1971:1504 with SMTP id o10-20020a170902d4ca00b0016419711504mr26181185plg.138.1654559517315;
        Mon, 06 Jun 2022 16:51:57 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:7100:486c:d20:242a])
        by smtp.gmail.com with ESMTPSA id 66-20020a621445000000b0050dc762816dsm11005789pfu.71.2022.06.06.16.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:51:57 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.15 0/2] Fix suspend on qcom sc7180 SoCs
Date: Mon,  6 Jun 2022 16:51:53 -0700
Message-Id: <20220606235155.2437168-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two patches fix suspend on sc7180 boards, i.e. Trogdor, on 5.15
stable kernels. Without these two patches the IP0 interconnect is kept
on forever, and suspend fails because XO shutdown can't be achieved.

Mike Tipton (1):
  interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate

Stephen Boyd (1):
  interconnect: qcom: sc7180: Drop IP0 interconnects

 drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
 drivers/interconnect/qcom/sc7180.c   | 21 ---------------------
 drivers/interconnect/qcom/sm8150.c   |  1 -
 drivers/interconnect/qcom/sm8250.c   |  1 -
 drivers/interconnect/qcom/sm8350.c   |  1 -
 5 files changed, 5 insertions(+), 29 deletions(-)

-- 
https://chromeos.dev

