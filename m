Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C6224E016;
	Tue, 29 Apr 2025 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946976; cv=none; b=H1C8k1iS2i/2WmWF8vTaswfMLWgdN52JaYRuM0fweTMf4NJWyZE9yO6TAgEFWdQgEDxa3YPOq3vpK68YrArdobNkCTNzUXXQJ+D2HaqoI7Kp6QuYo+jh+O5OvYX+jjfjJ3o4r9t/yGKNbc8k92r/wGrvgzJWaQeOnuMXPIL4pAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946976; c=relaxed/simple;
	bh=popHIAKToT7oJkRzUb0pE7Afnt1rop0G1FQWwG4g4Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0Nbnxav7lb/MZQAY9Zq5h8goQUE0lfyKL0Di3KHpau+Yr7HMA7an1uZZtDmePzeKDf8zdGYNGtDZEIxaAHqR8/N+6q2B1tesooTcUsbsby7LaAF2m/0UIVdrKAvVaPfUrCekPH7jU6Zn3KmMrMsnou20x5Ti+zV5hWF74bK2As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYuaAgEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYuaAgEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2CEC4CEE3;
	Tue, 29 Apr 2025 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946976;
	bh=popHIAKToT7oJkRzUb0pE7Afnt1rop0G1FQWwG4g4Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYuaAgEafZnZzo93fJSqFXPFjeVezn/ftXrSwDZAB+ple8mjKY8EXcZXL3quxhv4e
	 cNsuJQgCPQ/MKzR5eIuYXndgOMckkNxBMU76IikXnBsItzESWTzWTCG254HD11Cvrv
	 7zRB7bvgh0kMygbMSzThhWYOZ7m6/3u1uudP8KdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.10 100/286] pwm: mediatek: always use bus clock for PWM on MT7622
Date: Tue, 29 Apr 2025 18:40:04 +0200
Message-ID: <20250429161111.968711540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit aa3c668f2f98856af96e13f44da6ca4f26f0b98c upstream.

According to MT7622 Reference Manual for Development Board v1.0 the PWM
unit found in the MT7622 SoC also comes with the PWM_CK_26M_SEL register
at offset 0x210 just like other modern MediaTek ARM64 SoCs.
And also MT7622 sets that register to 0x00000001 on reset which is
described as 'Select 26M fix CLK as BCLK' in the datasheet.
Hence set has_ck_26m_sel to true also for MT7622 which results in the
driver writing 0 to the PWM_CK_26M_SEL register which is described as
'Select bus CLK as BCLK'.

Fixes: 0c0ead76235db0 ("pwm: mediatek: Always use bus clock")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/Y1iF2slvSblf6bYK@makrotopia.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-mediatek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -297,7 +297,7 @@ static const struct pwm_mediatek_of_data
 static const struct pwm_mediatek_of_data mt7622_pwm_data = {
 	.num_pwms = 6,
 	.pwm45_fixup = false,
-	.has_ck_26m_sel = false,
+	.has_ck_26m_sel = true,
 };
 
 static const struct pwm_mediatek_of_data mt7623_pwm_data = {


