Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81A56139
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 22:58:36 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id x23so12511173pll.7
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 15:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=WK5uBdkvj+rzMOTx0eBPWRcJ3NkDpCrdfS9GYKxjc4Q=;
        b=K/Dv61fWG2RK5uP019ajuvWGOsaYy/JwPd+i+ycqaCclO2jktpeGBCOdGEJwue7Svf
         LFuue3Jw2/IhLPZzIDc+oSEoPyjT7Vv75KikMIlx3sZGkKcI1jfYCdnz+tXgxvZaTRUz
         mdDnW/OVw+tIn2VPx14agQ4ltazeNCRbuECis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=WK5uBdkvj+rzMOTx0eBPWRcJ3NkDpCrdfS9GYKxjc4Q=;
        b=FY7gjsV+ArRW7ClFy/W0ewKJfq3POFyfNiYVRmC+4N1b+7LCPQLCYtqn8VfOrgA1eZ
         lQPyQpU/OzcUswkoFaSYDku9WPVwxYJbMDshcyY4G9GaTbi+iWx3jBIXyHqMEqZI+BFH
         9B5vPtlYqxsOC1drXb2cgtQKMRH9YFalrvInEZiFAvl0+o94acLBlfoApY5sY4ZBuStP
         t4BPYl3+2LMmCaphMcQaliJLY6XOrT+4nBP9MYdGoZ1qIyiP490dB4ZMQtS/ml1FrzdJ
         HeR+wmOfWOh2AVObQ6ykihuQ4qdwIAv8eisOgEPLpylv1zCabT3aRmUOSmkliDuRLHig
         eU2Q==
X-Gm-Message-State: ACgBeo1RL2ZVpAak2mVrb6DidMCUQJeyDez9jMdD+XuL+8B86UiCtfgH
	l2HlArD+L/6wslY15dKkqiy1EzaYe++fAw==
X-Google-Smtp-Source: AA6agR5BwgwGGR8CVgQETFRT37ajSM4Zq99RJV+txl3EQeraAhpPRS7nmypBzKJjaJBmUzqCHE10CA==
X-Received: by 2002:a17:902:8f87:b0:172:83b5:d771 with SMTP id z7-20020a1709028f8700b0017283b5d771mr23053534plo.159.1661900316268;
        Tue, 30 Aug 2022 15:58:36 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:5f34:2f6:2856:188e])
        by smtp.gmail.com with ESMTPSA id bf3-20020a170902b90300b001743be790b4sm10083539plb.215.2022.08.30.15.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 15:58:35 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 3/4] platform/chrome: cros_typec_switch: Use PTR_ERR_OR_ZERO() to simplify
Date: Tue, 30 Aug 2022 15:58:30 -0700
Message-Id: <20220830225831.2362403-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
In-Reply-To: <20220830225831.2362403-1-swboyd@chromium.org>
References: <20220830225831.2362403-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the standard error pointer macro to shorten the code and simplify.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index 3381d842c307..09ad0d268f4b 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -185,10 +185,8 @@ static int cros_typec_register_mode_switch(struct cros_typec_port *port,
 	};
 
 	port->mode_switch = typec_mux_register(port->sdata->dev, &mode_switch_desc);
-	if (IS_ERR(port->mode_switch))
-		return PTR_ERR(port->mode_switch);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(port->mode_switch);
 }
 
 static int cros_typec_register_retimer(struct cros_typec_port *port, struct fwnode_handle *fwnode)
@@ -201,10 +199,8 @@ static int cros_typec_register_retimer(struct cros_typec_port *port, struct fwno
 	};
 
 	port->retimer = typec_retimer_register(port->sdata->dev, &retimer_desc);
-	if (IS_ERR(port->retimer))
-		return PTR_ERR(port->retimer);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(port->retimer);
 }
 
 static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
-- 
https://chromeos.dev

