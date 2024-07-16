Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3236C19E832;
	Tue, 16 Jul 2024 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145446; cv=none; b=ohpeqMvnkbla5aVmpSDHItQp0fvx3L1GBEEBM8+CTVINldLaSAiYPkhzr9JOViPpcajIudnBwAGEurOGRrJbQwwJBQpBIUdNdZ/FC1DczXghRctxUoW996vrg6FkbOjVP4/nA4A+LrrnUEXjrmm8MCPqeDOqFEj7VzXWvHkfMgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145446; c=relaxed/simple;
	bh=gH0mpI3Y6p/rm99Tjozsv9/bgDB2Qh0cVrazGQEQx2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzuDvzCBjrUdKW2bFpOLlFxeQ8tEr5zWolgY1cWpMgyuLPpD2hlIsj1q2DkFpY1Z+fAJEao8A6QOs0Hmzmyvs5mc9zJ2m1Zj461sOWvJlmPvW2sJbXHw+G0qEqsiqrct65dz5odGCWh+7iazyH12nsHPR1CbPWhxwIm53gJOnGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBLOfvm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBLOfvm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE01C4AF0B;
	Tue, 16 Jul 2024 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145446;
	bh=gH0mpI3Y6p/rm99Tjozsv9/bgDB2Qh0cVrazGQEQx2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBLOfvm78db9Mg98HjxAuN+RExSHsE0kOD0uUmd5u2ZuvmNPsZ8DjhyiJntSZY0I/
	 wCF2Q3rMdyjZTALYYyFPNFUdroJjtPnckQmxucIfpvZphFVRiAfNHhc32NtCC8u3/7
	 r+RKhMpSQIfUkaic8B1dulPPqx+uRXbuvTCrJ+Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/96] ARM: davinci: Convert comma to semicolon
Date: Tue, 16 Jul 2024 17:31:47 +0200
Message-ID: <20240716152747.900659905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8aa39db095d76..2c5155bd376ba 100644
--- a/arch/arm/mach-davinci/pm.c
+++ b/arch/arm/mach-davinci/pm.c
@@ -61,7 +61,7 @@ static void davinci_pm_suspend(void)
 
 	/* Configure sleep count in deep sleep register */
 	val = __raw_readl(pm_config.deepsleep_reg);
-	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK,
+	val &= ~DEEPSLEEP_SLEEPCOUNT_MASK;
 	val |= pm_config.sleepcount;
 	__raw_writel(val, pm_config.deepsleep_reg);
 
-- 
2.43.0



