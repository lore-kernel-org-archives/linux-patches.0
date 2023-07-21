Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF11120F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75602C433C7;
	Fri, 21 Jul 2023 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967215;
	bh=qMctiIhFdm1UJKR2caz8af/qpSbzL9udYa5leDsWI34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02Ucsqo7i1dUfM02W8cVQTLYnuAo+XH3fDLjMqTPTMv9QDO5fN0muIuutengTCa99
	 yom0jJSghqzrr2LpmNhXjToUxY+v0b2e3drlqSVXclZcKoqo0LTNo4O855PNnUd0l3
	 PjY2Vra+3DiidU73Ijpc8ygrd4fFMZtRm/pqPHSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 077/223] pinctrl: amd: Add Z-state wake control bits
Date: Fri, 21 Jul 2023 18:05:30 +0200
Message-ID: <20230721160524.147094733@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit df72b4a692b60d3e5d99d9ef662b2d03c44bb9c0 upstream.

GPIO registers include Bit 27 for WakeCntrlZ used to enable wake in
Z state. Hence add Z-state wake control bits to debugfs output to
debug and analyze Z-states problems.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>
Link: https://lore.kernel.org/r/20221208093704.1151928-1-Basavaraj.Natikar@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    7 +++++++
 drivers/pinctrl/pinctrl-amd.h |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -218,6 +218,7 @@ static void amd_gpio_dbg_show(struct seq
 	char *orientation;
 	char debounce_value[40];
 	char *debounce_enable;
+	char *wake_cntrlz;
 
 	for (bank = 0; bank < gpio_dev->hwbank_num; bank++) {
 		unsigned int time = 0;
@@ -305,6 +306,12 @@ static void amd_gpio_dbg_show(struct seq
 				wake_cntrl2 = " ∅";
 			seq_printf(s, "S4/S5 %s| ", wake_cntrl2);
 
+			if (pin_reg & BIT(WAKECNTRL_Z_OFF))
+				wake_cntrlz = "⏰";
+			else
+				wake_cntrlz = " ∅";
+			seq_printf(s, "Z %s| ", wake_cntrlz);
+
 			if (pin_reg & BIT(PULL_UP_ENABLE_OFF)) {
 				pull_up_enable = "+";
 				if (pin_reg & BIT(PULL_UP_SEL_OFF))
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -42,6 +42,7 @@
 #define OUTPUT_ENABLE_OFF		23
 #define SW_CNTRL_IN_OFF			24
 #define SW_CNTRL_EN_OFF			25
+#define WAKECNTRL_Z_OFF			27
 #define INTERRUPT_STS_OFF		28
 #define WAKE_STS_OFF			29
 


