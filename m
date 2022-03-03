Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8F36B
	for <patches@lists.linux.dev>; Thu,  3 Mar 2022 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B57C004E1;
	Thu,  3 Mar 2022 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1646333065;
	bh=3O+xj138CKdSRUjGT/Vt82Xrl+Z2mQQ8p+Q3rCPCPbQ=;
	h=From:To:Cc:Subject:Date:From;
	b=BfUHnONYl3vtbDnVUTjjryKV4FphJ1R8XnmmZNdDzDZm1R44ZTNl8qHI5z7iuBhX2
	 5ievjiz0wLG+6qyX0aZLRlasloKj9nHdgdHSWvaPoDrVF2F905TQ3+bPJq89QAyw86
	 +fjnbUpDpOKlqLi37JbZB4jYs+IGG/ydVxV8rE8VrJG4Qfdxk9X9jIBUP8JojXGFF/
	 fuGZXY1x4gggZk4RkkGb2W38+kVZMT6JQ/XaiVmozAUqLaKpRD7HHmcaizvaeWZyzj
	 dj+6xRAVZXFflJRnqXiZ5lnGvOmaCVVDuezxp7y0DGc91Kyb33U3/Aqxpp03nOSqfc
	 F3voKhLEp+Esg==
From: Nathan Chancellor <nathan@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] clocksource/drivers/imx-tpm: Move tpm_read_sched_clock() under CONFIG_ARM
Date: Thu,  3 Mar 2022 11:42:12 -0700
Message-Id: <20220303184212.2356245-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building this driver for an architecture other than ARCH=arm:

  drivers/clocksource/timer-imx-tpm.c:78:20: error: unused function 'tpm_read_sched_clock' [-Werror,-Wunused-function]
  static u64 notrace tpm_read_sched_clock(void)
                     ^
  1 error generated.

Move the function definition under the existing CONFIG_ARM section so
there is no more warning.

Fixes: 10720e120e2b ("clocksource/drivers/imx-tpm: Exclude sched clock for ARM64")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/clocksource/timer-imx-tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-imx-tpm.c b/drivers/clocksource/timer-imx-tpm.c
index 60cefc247b71..bd64a8a8427f 100644
--- a/drivers/clocksource/timer-imx-tpm.c
+++ b/drivers/clocksource/timer-imx-tpm.c
@@ -73,12 +73,12 @@ static unsigned long tpm_read_current_timer(void)
 {
 	return tpm_read_counter();
 }
-#endif
 
 static u64 notrace tpm_read_sched_clock(void)
 {
 	return tpm_read_counter();
 }
+#endif
 
 static int tpm_set_next_event(unsigned long delta,
 				struct clock_event_device *evt)

base-commit: b22a1c270f533e30bc5d5d4cab6199a2cbb07b07
-- 
2.35.1

