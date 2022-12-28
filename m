Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1D21C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D85C433D2;
	Wed, 28 Dec 2022 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245044;
	bh=Rot839j5bGkGS38ssq/DbKfOFarLeXaWcMqbdNHXJL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSnPl4kmltuE3tFPcHJlJCeKjD+i4DaODl6Ng2QoONhWCluM6X7snVs21Rfg2GxI/
	 K5m9IH/AUFGFYRgUwzZp283cMJesu14m0nhZxM2ayheOIOcqOHVje9240gVH86t4Rf
	 XPESmZYXecYn7QVkTuvD/kfNdPw7Ozzav7LXIibg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Amit Kucheria <amitk@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0752/1146] thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2
Date: Wed, 28 Dec 2022 15:38:11 +0100
Message-Id: <20221228144350.569831681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 8763f8acbf8aef22a2321d4c978cd078aa3b8f64 ]

On gen2 chips the stage2 threshold is not 140 degC but 125 degC.

Make the warning message clearer by using this variable and also by
including the temperature that was checked for.

Fixes: aa92b3310c55 ("thermal/drivers/qcom-spmi-temp-alarm: Add support for GEN2 rev 1 PMIC peripherals")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Amit Kucheria <amitk@kernel.org>
Link: https://lore.kernel.org/r/20221020145237.942146-1-luca.weiss@fairphone.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
index be785ab37e53..ad84978109e6 100644
--- a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
+++ b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
@@ -252,7 +252,8 @@ static int qpnp_tm_update_critical_trip_temp(struct qpnp_tm_chip *chip,
 			disable_s2_shutdown = true;
 		else
 			dev_warn(chip->dev,
-				 "No ADC is configured and critical temperature is above the maximum stage 2 threshold of 140 C! Configuring stage 2 shutdown at 140 C.\n");
+				 "No ADC is configured and critical temperature %d mC is above the maximum stage 2 threshold of %ld mC! Configuring stage 2 shutdown at %ld mC.\n",
+				 temp, stage2_threshold_max, stage2_threshold_max);
 	}
 
 skip:
-- 
2.35.1



