Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340F13D82
	for <patches@lists.linux.dev>; Tue, 12 Apr 2022 22:00:37 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so4343818pjn.3
        for <patches@lists.linux.dev>; Tue, 12 Apr 2022 15:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCDAOLehwCcYWONpYO55pEeYX9bgO2K2M5jLJHp+bpI=;
        b=f3wqgGp7zhfxxmUYx2wFIqyhK/dVBaSlOkIhRroiZYAKd56bRrIV6waKSNZ/2tsGv0
         Nw3QwGhQIWVYMCrfS8K7BlNJlyiFETnfKvQJlD7NcKbbpBxSuinhvljRQg1gG7HPZSLK
         Ili7D5D8shmf7l6YI7ifS+mCwSe1cVfvLtAZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCDAOLehwCcYWONpYO55pEeYX9bgO2K2M5jLJHp+bpI=;
        b=eB1VyOpKf5yxlozvq/r5PCCCN/STFPkGR7/Js1SPGZ0gOPiTTL+1S6wO7QZUA53KbE
         mGu/Y9EbN9euRGUn31IUoW4IzBXS5BVOw96zqZ1lNL0Y05owMuHvpbiM37cuqgSa+Ufm
         LSkP24PgcqmQHCOYfaqm8YabFYRfVhKSQM0HAFmiQ1Ugcwcq6tcsbXhFrIWELLF/ZDzw
         6awhYGrBMr3TcsiGzcNYeWGC2A1VF/9bFNN9QF1GPQT3ztPqVM06fdM6AtZRDfLmM4D8
         RKR7VBj+d/ElrN4AZIcdACYyYVO80QZePtL9yI4UFHjgsXR6q2HVpOa2RpIXf6SHOB6a
         X4aA==
X-Gm-Message-State: AOAM532WrIizQ71VnMyUIou8jUZ2aWtD8LxExrrvGoc5bylQfizlm4v/
	MzGFCGc4uHSOU3u6Er2/Kw1FVg==
X-Google-Smtp-Source: ABdhPJzNEbYMytxD9EJ57XxGpAfifgM7NYJofzitQ2bTxFGc+O+FdsXfJu8X/2J7qcNA1BQorC6MMQ==
X-Received: by 2002:a17:902:e0c9:b0:158:9b65:aab with SMTP id e9-20020a170902e0c900b001589b650aabmr1738597pla.18.1649800836581;
        Tue, 12 Apr 2022 15:00:36 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:e880:a5db:8eff:6b6a])
        by smtp.gmail.com with ESMTPSA id p13-20020a056a000b4d00b004faecee6e89sm40565288pfo.208.2022.04.12.15.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:00:35 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Georgi Djakov <djakov@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Alex Elder <elder@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 0/2] interconnect: qcom: Remove IP0 resource
Date: Tue, 12 Apr 2022 15:00:31 -0700
Message-Id: <20220412220033.1273607-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two patches remove the IP0 interconnect used for IPA because
they're also present in the clk-rpmh driver. I see there are some more
IP0 usages in the interconnect drivers, but I don't see a corresponding
IPA clk in clk-rpmh, so I left these out. We can remove all of them if
desired, but the sc7180 patch is most important to me as it fixes
boot on my trogdor lazor device.
 
Stephen Boyd (2):
  interconnect: qcom: sc7180: Drop IP0 interconnects
  interconnect: qcom: sdx55: Drop IP0 interconnects

 drivers/interconnect/qcom/sc7180.c | 21 ---------------------
 drivers/interconnect/qcom/sdx55.c  | 21 ---------------------
 2 files changed, 42 deletions(-)

Cc: Alex Elder <elder@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Mike Tipton <quic_mdtipton@quicinc.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
https://chromeos.dev

