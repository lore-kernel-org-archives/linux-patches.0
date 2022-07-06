Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAD97C
	for <patches@lists.linux.dev>; Wed,  6 Jul 2022 19:14:45 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so6912512pjr.4
        for <patches@lists.linux.dev>; Wed, 06 Jul 2022 12:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rmyIuGz4xgr5RGO7XFrd0kJyn+/e00wc5WntWtW/Wbo=;
        b=lONXGA0Oa94we1VM7SSu7upm24Oh6HuikccFcEH52YRtWEe8CoVmmJw6AlYuEhyklh
         GhsqRocP4eFVQvD8NknHWpsvJ20dKMNLUp8qwtWaozNM7OA2uVx9cz3ROUU1epoBvz9S
         07+zyYz+BjlojJI3SZUG4GbsjOnPHRpGMAUp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rmyIuGz4xgr5RGO7XFrd0kJyn+/e00wc5WntWtW/Wbo=;
        b=K3d7rFaWQjfSWOgWIhtZ9f1jXGDaGrgcxm1kYDFG1WmZhdBWG/Dt+eZDGi67gJwtpa
         KwJdXY7p7F3k1Jbn2FSpfrRWHRzD60wbMZBuVMd0QT/SXKDLIZgll2r+r9/PaOFDHo1n
         vp5DaCsfCuidIvy4FVBBZVJKIMhhsqjFy4kOA+Hn3/HWUwmgnaqiQY5nVquy6rZOWK0O
         auyN3XDshrsolFi1+vm+uYohnELq2PRLLzycwZAp9o7kvkWXzVs248/m2iUAmRwfVxDU
         UPs7Q2b8FKXj4K80TGVulEhfUHQkmmJnc4q86PgnBdnWnQa/+VcBOW+R5Jk0AA3sG9sT
         y7VA==
X-Gm-Message-State: AJIora8W3Ktee1gAgaC6z3Gk9qxRPC4juT9KQ/A8zx5CsideVl+Wz7JF
	KmMJ1p5CufmB7E/Q9nkf4dzGvQ==
X-Google-Smtp-Source: AGRyM1s4Ik+wpzNwQpGqqCRJEELSjtoAI7uTiFsZlXwgvkaUnMOhJxHPZHTcNWqz5GJbIRFES3lg7A==
X-Received: by 2002:a17:902:988b:b0:16b:fae3:fcd5 with SMTP id s11-20020a170902988b00b0016bfae3fcd5mr7996093plp.109.1657134884659;
        Wed, 06 Jul 2022 12:14:44 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:a20f:cad4:2229:c6bb])
        by smtp.gmail.com with ESMTPSA id n9-20020a17090b0d0900b001ef8912f763sm7051714pjz.7.2022.07.06.12.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 12:14:44 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH] drm/msm/dsi: Set panel orientation when directly connected
Date: Wed,  6 Jul 2022 12:14:42 -0700
Message-Id: <20220706191442.1150634-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the panel orientation in drm when the panel is directly connected,
i.e. we're not using an external bridge. The external bridge case is
already handled by the panel bridge code, so we only update the path we
take when the panel is directly connected/internal. This silences a
warning splat coming from __drm_mode_object_add() on Wormdingler boards.

Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This relies on commit 5e41b01a7808 ("drm/panel: Add an API to allow drm
to set orientation from panel") which is in drm-misc

 drivers/gpu/drm/msm/dsi/dsi_manager.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index cb84d185d73a..9333f7095acd 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -268,6 +268,8 @@ static int msm_dsi_manager_panel_init(struct drm_connector *conn, u8 id)
 		return PTR_ERR(panel);
 	}
 
+	drm_connector_set_orientation_from_panel(conn, panel);
+
 	if (!panel || !IS_BONDED_DSI())
 		goto out;
 

base-commit: 15b9ca1641f0c3cd74885280331e9172c62a125e
-- 
https://chromeos.dev

