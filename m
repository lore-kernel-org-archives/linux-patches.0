Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544112D9780;
	Tue, 11 Nov 2025 01:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823572; cv=none; b=Sqi29VW9+yZE64dt7ECSaWu0ytZD4nk1w6EdwjtnxUdt6txVcHps5YZTjyozI+9fMB59tLsx5++1Xbd/ohvAD+yQCcdG1qQlp0Qi6DQq6Wt6LgyZyc1sbjB1rX9AGYTaYn4x/78sebultti/CFehAXQWn36iJSARSamvnNC2UAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823572; c=relaxed/simple;
	bh=3TlaJQ6kPlLj+xPxfjt0AaQY4vydvKhsBGOGxlpvnYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRCq/HKNHedYfgfn/iGV++OevtOvt9G/HU852D3yBW+fTFObw5bPpZCYtCTT/mbYEAwjlZKDO6XXk6rO0viH90mYf9kgLoqrmhMACzWmzTrS51d5CrBgX1rE8vh90iKvpSQxCeGDrx1FGA2bYqqZj4WAAydxeyAmykvL7AQkMX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dwtfsh3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dwtfsh3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6FCC19421;
	Tue, 11 Nov 2025 01:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823572;
	bh=3TlaJQ6kPlLj+xPxfjt0AaQY4vydvKhsBGOGxlpvnYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dwtfsh3iGAQouseXHnKI2cIOragFMplRQkQOrH0kZHeyPUX48vB1eumgOTtz1O50b
	 bexD6Vl0HNiMcNARmk+RKP4P45K5Plqw703/6ZUZBQQD+TLYzW2vM+qijK5HMPbPlj
	 RF90fKAvKrAxdiCOVyb6BxyUz2nygmBTx92p7awc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/565] mips: lantiq: xway: sysctrl: rename stp clock
Date: Tue, 11 Nov 2025 09:42:08 +0900
Message-ID: <20251111004533.005140197@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6031a0272d874..d9aa80afdf9d6 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -485,7 +485,7 @@ void __init ltq_soc_init(void)
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



