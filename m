Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1FF1C28E;
	Tue, 11 Nov 2025 01:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823928; cv=none; b=B/IfANPycY0209arvLvRxZGgf9aaWt5nL/flZ8TpF0N1PUWXt8T/Yx6yVNJip7iFx+FDwMyvucOFAqRL8mOaWY1BJmi/E6JhjW01Mjw29G4q0pG++MC2uAd7k4kVnpxlE6smPBPaiNmEd3E7sPz/oka9sMoiXzNXnQn7CCyBBbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823928; c=relaxed/simple;
	bh=mdb732vT4pTDJKuk11xLMvhk0tt5owTeEACDbBozp5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jzd9gFirKKKE5pweM9l1N+XYi1z6TIO+oleqAEwwxLYm0u7sy1G3cADo8+Qo8OOjA+0jnLVN/RxGd9FxWQJk1LNH/0hgXe9z1jTijybftncJQ5tUhQlrJ7co/icKCdwkmGOGXdB2RoFXSXBzOSkq0woLpyUGFP3xiNwZhDQ6XOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzKogZmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzKogZmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B7CC4CEF5;
	Tue, 11 Nov 2025 01:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823927;
	bh=mdb732vT4pTDJKuk11xLMvhk0tt5owTeEACDbBozp5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzKogZmAh3BsGEUKVZbpzB5hZDTiey7i8xDRCy4ZfuVK8ggxz7izR1FM/N7xM9DCM
	 fHiISZz3Tg9rFNzXqjE0KYYkym/+YHU5xciZnPmm2ccj0YwGTCd2t8MD04+3Lse4HX
	 7PJ1NQUOZ1mBWCwZ5Ym28myn7aw8OjsutnkRd4oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 399/849] mips: lantiq: xway: sysctrl: rename stp clock
Date: Tue, 11 Nov 2025 09:39:29 +0900
Message-ID: <20251111004546.084919092@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



