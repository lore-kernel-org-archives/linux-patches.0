Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018536;
	b=Mg9oA8nRF6gsqnr63vEPlCuhuqop0ayoRNxyPqFs7LXRtv/KlgpfjgSziR1jTarSPgni
	 nqtTjMsP+DSvrEwbCA+EMTl8bfoFGsX16ODf9yd+0z8ec01GNeLPKZnIlUpx9hG9pNZLC
	 YePNP18gJynPQaqDTo14d8vvcVYu3n7kdaInvMSeKOtCrjId36wDV4z/O18iN+7D1Pq/1
	 dnbw6TZtrRa7+9FmpvnoJdEY9N5+y8ZXYuZDcnQFfPJWQlFAhQrtsm6P6GSPXJGSUIN7K
	 dC9Y85Ke2w3h7cNNiJYoBz3WgSJgUsTxmoREkM7v9gtUd+oyNRbwl3bkYZqq9fLBuog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cbxJuCjfVU3ztyUZLOgNmEBh2xBqfaOOnNoKWOdBwhg=;
	b=1AjQwY394sxTLJRnN5wc0dCYAz358tirr6jY/mmWzuAgEIw2WEwCD4qLb9/XsSMNCv/k
	 iqaqtrUOjy6aGORLRWO6HxlPhN+bWg9xpoDOzBIxbbHqDhHXPQZS8qC2FwJLyVGKyIBe2
	 2a4mdAPv+iIaKTENrzqgMCfHo3Iko5H3kX27ADEdDhNb1zKyJaZ3q5IPW5FEyVRuMwGMJ
	 /rlHw25ec6ew1wTDR6mFebiPOMtIckqOrQQnw9LRHtYaAuQGBAz99b14eCXsQ9YFZjg11
	 K8sOXowVJ7zIZdq5dJsch90JzBHkLJcAAKxgYiu6igvnpZlOYZ7ML8FwJ3uaeujYZlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4CimJ0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF71B606A31C;
	Wed, 18 Nov 2026 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4CimJ0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560801F000C4;
	Wed, 18 Nov 2026 16:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018535;
	bh=cbxJuCjfVU3ztyUZLOgNmEBh2xBqfaOOnNoKWOdBwhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4CimJ0blGwn8qC5K7OQjXWGZh/G5jvLBhwc8/ovFIN070pdVNOD8h9NbwxPwVJf+
	 zPNLiobvOSSlhJhTXU53OUdhkG90k1ns3aQfP1xSeJBIC+wseMbJec0reG0CJH10PW
	 /Jd9CpYvHKWpHYlNXcOZu3eoMK0KuERkl27cuizk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1276/2651] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:41:56 +0100
Message-ID: <20261118150333.885169594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 15112c80318fb..7e8416adb2ce5 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -451,6 +451,16 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
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
@@ -481,7 +491,7 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto cc_err;
 
@@ -555,7 +565,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
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



