Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED28835FF4E;
	Wed,  3 Dec 2025 16:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779287; cv=none; b=cmlKAJA83wIj5hNsiGu0OI29CpopTDimdOvsCFKXKctkqxTljo/Z7nR2Pf7+RbhPHfx/gx6QwafrfOsMeVePQlrRgbfuXlHTGyB+CB0aFOKeBcfP3trYqM4Fq+p2wVNqWJu7Wz9oh8LjmInuEuDn/tj49G8CYWc1ObWkeWCTPsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779287; c=relaxed/simple;
	bh=8ksrxM0X2EwX/ADCXavUfqQduh4CVbOmGBDM7s+Z1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obr4SUfnucrfeM5V2sxuEFZdbUDS1f79lca7fIM61MbOiIJJpV0nFFO6r8LSdqtkaVsSlcI+FaESszWRaWQHGioKgvn4nkobhzGqQyL9yLgHbTwX1ptG7isXLyttl5/VzSl7AmS4jo5k9ntZMrRiJkOKvpTkPDqzcDpMcKgeYM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/Vi8Yli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/Vi8Yli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D607C4CEF5;
	Wed,  3 Dec 2025 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779286;
	bh=8ksrxM0X2EwX/ADCXavUfqQduh4CVbOmGBDM7s+Z1bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/Vi8YliRVbAXC/8BLvIJWwmyh4iOpDd12oCaLV9+Z2+ccS790NU7DpJz0WEKIiUo
	 /9SbsNodqeyE61rrPBR8O9hxHubgYiqKuGHT3kvOGWI7WuJG6BVVWSIw/7CmDBQ42F
	 GsIyDAgVc2cnCylVfAuzAEPx2lnvcZ2eiHV++m18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/568] mips: lantiq: xway: sysctrl: rename stp clock
Date: Wed,  3 Dec 2025 16:23:01 +0100
Message-ID: <20251203152447.285929249@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit b0d04fe6a633ada2c7bc1b5ddd011cbd85961868 ]

Bindig requires a node name matching ‘^gpio@[0-9a-f]+$’. This patch
changes the clock name from “stp” to “gpio”.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/sysctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index edf914393ad96..bcda4fa9fc87c 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -467,7 +467,7 @@ void __init ltq_soc_init(void)
 	/* add our generic xway clocks */
 	clkdev_add_pmu("10000000.fpi", NULL, 0, 0, PMU_FPI);
 	clkdev_add_pmu("1e100a00.gptu", NULL, 1, 0, PMU_GPT);
-	clkdev_add_pmu("1e100bb0.stp", NULL, 1, 0, PMU_STP);
+	clkdev_add_pmu("1e100bb0.gpio", NULL, 1, 0, PMU_STP);
 	clkdev_add_pmu("1e100c00.serial", NULL, 0, 0, PMU_ASC1);
 	clkdev_add_pmu("1e104100.dma", NULL, 1, 0, PMU_DMA);
 	clkdev_add_pmu("1e100800.spi", NULL, 1, 0, PMU_SPI);
-- 
2.51.0



