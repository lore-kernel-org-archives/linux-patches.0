Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA2934D38E;
	Fri, 21 Nov 2025 13:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732687; cv=none; b=YrOJMNK4MYSozQEbqZTjfCuRSIf4RVq8ToAcTfXoli7TpkrUsh2Nc1I/fsgKUvts6szrWJOEwdGRLgWFtliPwG+ur6TrCKanbxsxVhw9pnz1dbPu3tuHCiN2mQ4SJnjpF5Bfvmfcjp49jfFEB7GuiUO3E8e9GExH/7hSDXhHF8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732687; c=relaxed/simple;
	bh=gcMgInKFkZS5zk+JzAUxASSrTtH5GuHTXHL+VKi36sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PpOqEbclVydiRo4Md3F0Bczu2kwtYW15jd4FRxxJcyFu9ZoynPbFi9b/AqG0RNXV3hLISoGbVouENf3nLzPvcRviyir3D+7uPO5/Sx0aH2xtwrgUN3ucaBMIF4ppZBcXzAqoGhrLbBTedK0PSSRHiArnr0u1hSYkIF8lLr/EARw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stUgOPEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stUgOPEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90792C4CEF1;
	Fri, 21 Nov 2025 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732686;
	bh=gcMgInKFkZS5zk+JzAUxASSrTtH5GuHTXHL+VKi36sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stUgOPEkWDzOJ4i7ZNhoT1Gai2lst6l6yua+UXXg49TWrk/YJGvLQbtdZ4/PjT9vw
	 p5pkAVgkpDFd1ih8/GdJMDqMqEN65POOs9G2EbIoXK84OW1ftbJVigYJdcZHryA8Mh
	 1qr5jJzNdOs7A3Tf7HRxPNkcCSGQxpA/+nAulsA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/529] mips: lantiq: xway: sysctrl: rename stp clock
Date: Fri, 21 Nov 2025 14:07:53 +0100
Message-ID: <20251121130237.210396816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c72b59fdf98c..492f375bf1290 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -466,7 +466,7 @@ void __init ltq_soc_init(void)
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



