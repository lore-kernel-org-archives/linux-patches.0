Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030939;
	b=AFA7oAOVdLMUbJyb8LdcF4H9FrT42CekhjNkFFd/sWRJFmzvVPmSG5XiqrMuYzLZ+NUE
	 R3ux4mmpiMNkSGncCeSWn0x85FtqG0QKVK0CwwXN2vlrjaEqzF/wV2fuv9LOhLbToWDds
	 zk9q6tRfKrliD7OO1BTtzD+ux/MBp3RoBI4G9PFAdsaQl0BU3RnRm76sPktqDBc0DmuXm
	 qYLK6hhx/nVkCOu6+100NYCSkZxStJcfVOxqlAjhBOmb9nmxaSZL2wEesL0hR8sRvnaED
	 yc7LtLYibn1kQXv5v3ptrZkq7zNYUeCPR5youpe52I5FGza/YvxrYspgH0W9yfazRbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NKtvicOdd2AlKIxkN5tBeGNSbHMXdNJXhDIpe1lI8sE=;
	b=k80572aQ3jv5H6R07428FZGrhmgtFpp31gqEX1m+wa8j9b3UHvOGUhpFzHnKoW3jAqcL
	 9hXeeZ9uxotcXFm9g2qat4Wmn4J6RnulaS8hDed5dBiSQCxPKVdyHqBNbaRU51OIw/C7H
	 RjvpIymNoKgi2ozpQ1u1wUrNLQ6KNTb+79ZqERgAD2imCzleEyXciYmFbjquDFcvFobv6
	 2SWuEWglIFKf0oPoRF2ombzUbL/621/pLFljmtUK+Hl3Oj91dKKhB/wZjEV9wjLqA9XKi
	 0BWbza/3fe/txcEU86cO1co5J/k17ImhK6KL0SFBI3a1rrXGfgCZUl620Va3lgUsLuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OR+PCiN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE5606A7F2;
	Wed, 18 Nov 2026 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OR+PCiN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9F21F000C5;
	Wed, 18 Nov 2026 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030938;
	bh=NKtvicOdd2AlKIxkN5tBeGNSbHMXdNJXhDIpe1lI8sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR+PCiN+Ent3orXmsTOXaCWD6+0YV+noBuioMwm6FX63A05vmL7UekyRsdYLmFT6P
	 BUeHF6pgt25JLRYmR96WjlX7TJCsbgFpcvX7rVVz5kAmLE0gHBcOICub5K5sId0M35
	 xfoAEZvXmr0gVPzglPjGxJS/nR64JYKVoEHxd0cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0839/1756] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:49:26 +0100
Message-ID: <20261118150042.853338864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3e530a37535de..5b7159fe4e296 100644
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



