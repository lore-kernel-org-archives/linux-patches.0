Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535FD1360
	for <patches@lists.linux.dev>; Thu, 23 Jun 2022 00:25:43 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id h192so17589109pgc.4
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 17:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zzh8+fZjM5hPtSMBwoYZp8q7cJJBA1KjGLsk1UEGJzY=;
        b=JeZKCxa6bNzpsmRCpGpgy7EB/22moTTKpfrVHcl/9qlhp/I1SufTP5QykncHgNW9hR
         avenedCjqEyWeq8lKo6Zowji08L4Ek+9niZjCH0F9P3OflsKYnqFT/WrWjb5FjZOb25C
         pH9FQlDVUs5EHyxnSEgE/sKUz80Sk+7gtVR90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zzh8+fZjM5hPtSMBwoYZp8q7cJJBA1KjGLsk1UEGJzY=;
        b=xO2OSQ/HLSuUDHlsbo1oJC3HECX6SU1SVl0J3o5No1YFmgWtrlEhALqst9LvLjXtRB
         FRq+GMz+5nK6A/bkmENgwhBqORYcpNB/RnkEWkLSwsKpLVtPXFNlEU8oX6bbJi58K6PA
         uSMx8YJRT2FexVySbhuTOMgoQ6O+LmXtkqpwu3li4dKgyvEfV9udaxEl/GvWIyhuzCdw
         zAbu56xzCCdm+7QzGOSBut8DFjsqMFjN2wvHkJHnwDtGzE9ah0wiaxKR8Z3qpBfJKW9K
         OCJt0aObaJkOjbxkeDK8gHW4qVn+7x0L4geqCc0CMwGIKYqMx7Jgucejmjm1yWIB79fM
         gung==
X-Gm-Message-State: AJIora9uAoiTXZA5QDz3tzXJed+6wMtvRuitX7aWAD5oqHJBTfNlcppS
	2uPbGkMy9qC9FZ1ksgPyq09pJg==
X-Google-Smtp-Source: AGRyM1suCxCy+8DW200CWSyuFAXsy4QJ9tVOXFHRTeywutvEswLKZ/hAgeOYR/sNhbqvBoj6zAIU0A==
X-Received: by 2002:a63:9dc1:0:b0:40b:7771:c2ac with SMTP id i184-20020a639dc1000000b0040b7771c2acmr5135253pgd.39.1655943942707;
        Wed, 22 Jun 2022 17:25:42 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:f28c:6f86:743c:1c04])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b00163fbb1eec5sm13332705plh.229.2022.06.22.17.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 17:25:41 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org
Subject: [PATCH v2 0/3] drm/msm/dp: More cleanups for force link train
Date: Wed, 22 Jun 2022 17:25:37 -0700
Message-Id: <20220623002540.871994-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches do a little cleanup on the v9 patch[1] from Kuogee.

Changes from v1:
 * Reduce code even more in second patch
 * Pick up tags on first patch

Stephen Boyd (3):
  drm/msm/dp: Reorganize code to avoid forward declaration
  drm/msm/dp: Remove pixel_rate from struct dp_ctrl
  drm/msm/dp: Get rid of dp_ctrl_on_stream_phy_test_report()

 drivers/gpu/drm/msm/dp/dp_ctrl.c | 148 ++++++++++++-------------------
 drivers/gpu/drm/msm/dp/dp_ctrl.h |   1 -
 2 files changed, 59 insertions(+), 90 deletions(-)

[1] https://lore.kernel.org/r/1655411200-7255-1-git-send-email-quic_khsieh@quicinc.com

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
prerequisite-patch-id: 2fc33a2830ec84d922023fddb585728c48a59525
-- 
https://chromeos.dev

