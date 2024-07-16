Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1045D53B;
	Tue, 16 Jul 2024 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144183; cv=none; b=TYH6RQ2A+mv5qmJwkXRQlSbPi8f8EVOdVmohHd7ExSU19/6jhYNIuEIfKIYvu7n/OTcyiykLROCAosNk3j/etilHF2EBe2h10qUYZIq4BUhGBldNsCeeQG25g0KuHa8L/cyi5U6/hpi5D79NuOYf8Z+0OYXhJu7g1CzG0RTQee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144183; c=relaxed/simple;
	bh=SZSt1XoPrwh68yZJJi2Yi7t/9e2MTuZ/2dYgHwcFYh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLFHPMo8UsERcnZkKk4yFt3xRYedzoPj50OmUkqEuttFuxOXnXyMqO49MU+7VXiNaMdcwnWQIU+7dS8+4heu5e2rkIcDnwZmSJqGpD7+lnBT5Nna9xRg46b8JDWMf6QgEnBvRm43yyaday2g8yeAdNNTUgmc52aMhoOMIRctLDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHoYs9+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHoYs9+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8CCC116B1;
	Tue, 16 Jul 2024 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144183;
	bh=SZSt1XoPrwh68yZJJi2Yi7t/9e2MTuZ/2dYgHwcFYh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHoYs9+cNo8sidxTC1rSb0zMh/sGUtav4axXI9rAd25+iUEve7u+RKldxYOs3poGp
	 b2P3FjCsVgnVb1TwzJ7QDOffu1XeNIOe7sEUu0cbvt0eyan1zlfrTaJp8At+fbMvrG
	 jV0D0St/im/VeOKMeh6KCqYpEmDNLoTUcDgYAQRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/66] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:31:23 +0200
Message-ID: <20240716152740.000587480@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit acc3815db1a02d654fbc19726ceaadca0d7dd81c ]

Replace a comma between expression statements by a semicolon.

Fixes: efc1bb8a6fd5 ("davinci: add power management support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/pm.c b/arch/arm/mach-davinci/pm.c
index b5cc05dc2cb27..ef078ce01db74 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -65,7 +65,7 @@ static void davinci_pm_suspend(void)
 
 	/* Configure sleep count in deep sleep register */
 	val = __raw_readl(pm_config.deepsleep_reg);
-	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK,
+	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK;
 	val |= pm_config.sleepcount;
 	__raw_writel(val, pm_config.deepsleep_reg);
 
-- 
2.43.0



