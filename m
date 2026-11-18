Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049061;
	b=JebF3o0LYdWKi8ShrP+EdGFppEUxFZlw9NkDpt5pexkzud+EeFJGUmmR/i0Hax0lPJW6
	 1JLJINo667e1G1hEgLF9R5LJ17BPLB6x/MP/BZCUMfwXWISQ0EakuApLePMTzGweCKpCP
	 Gt5Wdo0Eq982b59sfBKd4gS9lylkxZB3ZYlCpk8YVXc+w2EcrUvCfwhXYC+ZDgpQj9mil
	 FUObdNJfQlmGpV57+oQ+zxQZGuoxVAkYHP/ak5cD5j8MCSAp7vC8DJVJtxrwzhCjjUbrB
	 wShnxVf+ufaFctb/6JUqjgxYTZi4DXucOA4X+adV/AvFhmpDZC3/tuV+OtvlGRWyroA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fYa8vTFMG3gJfUBFPp+U6JKySiQ0gpw9zrc0jDA6OuQ=;
	b=D1dquiU1xCeEPMdxzqju9RQIHATZFUB6L9yohPTvOs+KU+97EKDtfBHJOw9WhmxWEU8l
	 pzqxrRRB3C4UrmcdMe9kZbuxnk81b45i7GluOuj/9qNfIg5R6IxGwV3vrzb7w56N89tiA
	 wO1n2NNyWbX639fQa8jiVKVVkK0qFxK4gK/mioR2tsH8lO9CxVlucffgXW9MmG0pIWKO8
	 chOxXTdrUxYKp6rrOhXd7D45IwqyVpr195qNA69PuZy14pV6ZgSlROYnx8Yg5bFSkFBLs
	 ZamQ1ds682/kqjcJ/UaHSjotgQsycFt+vHlqkTgzGXt9gT4+THvglE68bLkVUiq8FMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cuf+S7es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489A7606A32A;
	Thu, 19 Nov 2026 00:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cuf+S7es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955831F000C4;
	Thu, 19 Nov 2026 00:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049061;
	bh=fYa8vTFMG3gJfUBFPp+U6JKySiQ0gpw9zrc0jDA6OuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cuf+S7esRzWW7WvXzZgyLmfAOsEiAFhIdkYMrpt8WsFWQy7zYCAH8CyZSnhiLtYbL
	 GymwgbtwxhK8y/3FwkP9MosBa5QjTkOBbYsomH9uibsZujmijuv+Wheq2N5FlwjSBl
	 EBqFkcpL9fwdMY0TlRNn8niLUkYdFESMXhzLfcPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2216/2857] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:54:10 +0100
Message-ID: <20261118150321.209443053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit edafb2e4642b72b0f86ce5990d5c29c116bb642b ]

AB8500 defines CCConf bit 1 as CCDeepSleepEna, but AB8505 reserves
bits 7:1 and only defines bit 0, CCPwrUpEna. The fuel-gauge driver
currently writes both bits whenever it starts the coulomb counter.

The Samsung-GT-S7710-Skomer and related Samsung product trees use the
same unconditional value in their fuel-gauge drivers, so they provide
no AB8505 workaround to carry over. Select the value from the detected
PMIC variant instead, retaining the deep-sleep enable bit on all
existing non-AB8505 paths and avoiding the reserved bit on AB8505.

Fixes: a982362c1723 ("mfd: Support for the AB8500 AB8505 variant")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-15-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 681b25fc14a3f..1397dbd17c5cd 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -456,6 +456,16 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
 	avg->avg = sample;
 }
 
+static u8 ab8500_fg_cc_config(struct ab8500_fg *di)
+{
+	u8 config = CC_PWR_UP_ENA;
+
+	if (!is_ab8505(di->parent))
+		config |= CC_DEEP_SLEEP_ENA;
+
+	return config;
+}
+
 /**
  * ab8500_fg_coulomb_counter() - enable coulomb counter
  * @di:		pointer to the ab8500_fg structure
@@ -486,7 +496,7 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto cc_err;
 
@@ -560,7 +570,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto fail;
 	} else {
-- 
2.53.0



