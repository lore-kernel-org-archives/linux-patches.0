Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015780;
	b=kKsk4f9rEScLKAS86EGo+THxsUcS/BmbzJTmsCH7cqwg04eLprPM4xKbpVQQ6TEbtpzr
	 1m2ArwJugjPDBOMxXA7kxP5cwJHNBZg4SvQZWJK97W/dtAMHO7OfffJfug3NbtVRgp09W
	 mocN4bflejLIYNSpZ472Owg9rE1abX5MpfgivIOmSdkX82c9uoMS2uFvAUjUmPaTLPEuk
	 BHvEVmeTpxz73QBHTqRGDxAAjlSN9YlAsSVXT+dRGKxqH0xnLP2f9+W6x3uAaBCQGdRZU
	 6k9D6LYmGCGOSPPQqPzJoLlP/wwOEfP4DFs5RQUxCoax17t7wWw3JQRFcbXwl8LhEsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0JcdPDFbh3YTbgBCDetL00LdfPp2EqeT+M56HFQZrcY=;
	b=Bo0ZrCHINMatUEbTfFmRMcD10yqOVSN7/sJa7ZWN0Yq0s4sYxsdctlLaJhx+/QKMzaV3
	 v75HN1FDOnp+d6exYmdrr7nwSrxI31qYSbh5iYzHK0EaCrDya8qHZyLE9Idag3aM7orb3
	 ttbz999wMK/QhXI58PHH39c6fgF1/6nxYcM/S9sCavrFxJ+BquenfkbnDWp/zzfn6u39N
	 7675W/dLJ4zehllpzmG6qtsDSkHohN3vnECPO3JiytROeZmwnWdCEQnva39F3jgx6iKBL
	 c4jAsnphEvpmARIwqPUyxWfTe0etSpW21I9pm8oSX7QW53Tbvf9+y3jkZn0tvEUXl8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l2jZ/pew";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED15606A320;
	Wed, 18 Nov 2026 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2jZ/pew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7651F000C5;
	Wed, 18 Nov 2026 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015780;
	bh=0JcdPDFbh3YTbgBCDetL00LdfPp2EqeT+M56HFQZrcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2jZ/pew4wC9Bjg+3soUHnDqe9c8CYirx/TFKScwTer42RQUnqz25gT/IhHE4SL7l
	 P0/t7GXxUJ2MNTN+5ssMKXTOIL0ZIY7w5DjbxZDU/ohyMZTExPARve9kY5IPxJTwKE
	 Dtr0wmEtnb4XdALKHerptkeRHPua9DJXZ95p4Z3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keguang Zhang <keguang.zhang@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0253/2651] pwm: loongson: Reload PWM configuration through counter reset
Date: Wed, 18 Nov 2026 15:24:53 +0100
Message-ID: <20261118150256.967593798@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keguang Zhang <keguang.zhang@gmail.com>

[ Upstream commit 0de9b836a3bc1cd30578ae2c4463d09afd85ed3d ]

The Loongson PWM controller latches the LOW and PERIOD registers only at
the start of each PWM period. After disabling and re-enabling the PWM,
the controller resumes from the previous counter value and completes the
current period before re-latching the updated LOW and PERIOD values.

Reset the PWM counter when disabling the PWM and release it when
enabling the PWM so that the updated LOW and PERIOD values are latched
before the PWM starts running again.

Fixes: 2b62c89448dd ("pwm: Add Loongson PWM controller support")
Signed-off-by: Keguang Zhang <keguang.zhang@gmail.com>
Link: https://patch.msgid.link/20260715-pwm-loongson-fix-v3-2-0aab2847eaa7@gmail.com
[ukleinek: Note LOW refers to the register currently named
LOONGSON_PWM_REG_DUTY. That name is wrong, the fix is still under
discussion.]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-loongson.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-loongson.c b/drivers/pwm/pwm-loongson.c
index f2fb35b7af2b3..98c809bde2b30 100644
--- a/drivers/pwm/pwm-loongson.c
+++ b/drivers/pwm/pwm-loongson.c
@@ -99,6 +99,7 @@ static void pwm_loongson_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct pwm_loongson_ddata *ddata = to_pwm_loongson_ddata(chip);
 
 	val = pwm_loongson_readl(ddata, LOONGSON_PWM_REG_CTRL);
+	val |= LOONGSON_PWM_CTRL_REG_RST;
 	val &= ~LOONGSON_PWM_CTRL_REG_EN;
 	pwm_loongson_writel(ddata, val, LOONGSON_PWM_REG_CTRL);
 }
@@ -109,6 +110,7 @@ static int pwm_loongson_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct pwm_loongson_ddata *ddata = to_pwm_loongson_ddata(chip);
 
 	val = pwm_loongson_readl(ddata, LOONGSON_PWM_REG_CTRL);
+	val &= ~LOONGSON_PWM_CTRL_REG_RST;
 	val |= LOONGSON_PWM_CTRL_REG_EN;
 	pwm_loongson_writel(ddata, val, LOONGSON_PWM_REG_CTRL);
 
-- 
2.53.0



