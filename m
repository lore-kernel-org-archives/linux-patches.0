Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67F67A
	for <patches@lists.linux.dev>; Tue, 17 May 2022 19:09:51 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so2779150pjf.5
        for <patches@lists.linux.dev>; Tue, 17 May 2022 12:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WX9lP7cN1XhMLxAyp1fuinpNzyHjtW9iix4zXAbknMw=;
        b=Z8ufLbQ+4mZKJyLdDDFC62aZ5/hDqWVFsdPEZUe33bzH3AdGyPj61awGDS5cNbbHDg
         W0naIEoFAgkHlY99tWGdn5v6aLiFChtOCWg8sJMnXMl7EZ0442nl51aORC6xH7dmy/JF
         XiGHxnjy8cCUW0mftFfTsk9zgCOzTxU4pzhd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WX9lP7cN1XhMLxAyp1fuinpNzyHjtW9iix4zXAbknMw=;
        b=dpUI3zTDYTyqCH7iAEpmqr/KVbmcnV0HH+UMf9ctJ0I7LKOfJw5XzVBnXDO1dGMcbo
         3DJHPk3995/DMuuzZBA0gYPvJh4p8xiV3TG1PI/CU1+O09UG6+kkB5exxpWnOoQgcUsU
         F0x6y8Q6aFD5otJGqw4TxgNtn3meb4YWL0GbwVmkcJukusrroVSEAweEeihdMP/dUzOh
         3GZChKK1DaidGZeV3qlcLLRsEbRgVURBhta6iurnFk0I7I/RCU+B2aEdc8WRSypE15LV
         DsiU7s/HtUo4WP677rgM4ggdmB1kvAaS0kYI86iqF9u/l9ce6C1EdbexnKOBMkpbCR+t
         5f/A==
X-Gm-Message-State: AOAM531BQitBPKfYac4o6sE82D5M5QL1YUP6AfZM3mj6ojyK3edr+LrN
	laqL4YM4D/2VvEfpWqIr8OszRw==
X-Google-Smtp-Source: ABdhPJx+Bj9KO0Av1JRLZUrA6agVbkgI6FASmev7Quni+bS7dw7sIuv6+UWHsrp4bEZdBmdbt5QrIA==
X-Received: by 2002:a17:903:1211:b0:15e:8208:8cc0 with SMTP id l17-20020a170903121100b0015e82088cc0mr23524064plh.52.1652814591197;
        Tue, 17 May 2022 12:09:51 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:be81:6c26:5643:b3d9])
        by smtp.gmail.com with ESMTPSA id f16-20020a170902ab9000b0015e8d4eb246sm9498265plr.144.2022.05.17.12.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:09:50 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH] clk: qcom: rpmh: Add note about sleep/wake state for BCMs
Date: Tue, 17 May 2022 12:09:49 -0700
Message-Id: <20220517190949.2922197-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sleep/wake state doesn't need to be set here because of specific
RPMh behavior that carries over the active state when sleep/wake state
hasn't been modified. Add a note to the code so we aren't tempted to set
the sleep/wake states.

Cc: Alex Elder <elder@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This superseedes a previous patch[1] I sent that tried to fix this.

 drivers/clk/qcom/clk-rpmh.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index aed907982344..c07cab6905cb 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -274,6 +274,11 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
 		cmd.addr = c->res_addr;
 		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
 
+		/*
+		 * Send only an active only state request. RPMh continues to
+		 * use the active state when we're in sleep/wake state as long
+		 * as the sleep/wake state has never been set.
+		 */
 		ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
 		if (ret) {
 			dev_err(c->dev, "set active state of %s failed: (%d)\n",

base-commit: 42226c989789d8da4af1de0c31070c96726d990c
-- 
https://chromeos.dev
[1] https://lore.kernel.org/r/20220412194505.614002-1-swboyd@chromium.org
