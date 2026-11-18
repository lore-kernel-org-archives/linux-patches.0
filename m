Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040705;
	b=lVJu/hICJQfKQp06n4K2gGhKsfSyjQZP2VTu2qa05Wjp81oDbrP6TRRrwsWv0cdQ+1hY
	 mmcbjqLfFe1tgxZmVlN6P5KK6EWCRVius5p5x7FIMoChrRFmWRKVPW9kbrfFwzZEsn9WF
	 OWy3Q7rtnOTrCIasob8HhC4tH1B2m4mV8/RRGEm9tCDm6CrLOTN1BuPGc07F2jY+NcPWS
	 eeal1ZAH4dp/43gQcr4MLu8agRJuS8uPTe9l1dwuY+GUMZWz8irdf9fesBQe6bjJWRmRa
	 GHtrUGCriNdtFG/2r1h+om9rwZ4m/73OULvrB3bCW91+N5DwIqCQ7Vts78Jl3rBVi9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADMYvJgJima7kaJsVxa/Mycb2fUFu3F48LXH2E3DoPk=;
	b=umIl6mIFIBjOaS+UEpK/8s8Bb/7/RiKrEZP/FtRhQ/03wQBrj5FREMGfxyvLVQmUyEdo
	 4weVAw6Fs7J3QrLtxB0+GDM6zBMhBlnQy74Er1vI/emEi1lwRsW9O7WDrtAMAdTaQDIZ+
	 CkmnsAIbN7vph3foWUHncdQ3wLHENZWi9xzo0uDQ3JYbvI1s7ZuurJBbn98ulBV90MNXV
	 45Dq5tJQu4hYnSkj2ZFRTRmYg4U25nA3wqfSh2NlLvFm5GwPdiaN9MAAnVrQtjARs4Oy+
	 MjPin0UdJh0ZrGw0axJV4RXkBbtFdsV9sfWuk8re3RPsa6g/xC9YquSA2Lxhb0xhjMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeHAVTCR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F83606A325;
	Wed, 18 Nov 2026 22:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeHAVTCR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C771F000C4;
	Wed, 18 Nov 2026 22:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040705;
	bh=ADMYvJgJima7kaJsVxa/Mycb2fUFu3F48LXH2E3DoPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeHAVTCRO9NDtNA8MqMvJGsBvt56R1ym2Nt6hCXhQ4z3WKjsQaEJpEBHStUTcqCAn
	 EsnooCiQsXX3E8pYZqBrx2ElzqxEDqUPSzeCLF8dgKVuuLx0vjG4e8fZF5qeoBGcwP
	 ti9A1GcHqGww6HhzoACX+lEvS+O9eF8OWam3GWkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2553/3318] spi: bcm63xx-hsspi: Disable runtime PM on remove
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150437.871420329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 38232bd3cea74845c2064eb9f7eac77fa5a21d85 ]

bcm63xx_hsspi_probe() enables runtime PM before creating the sysfs
 group, but bcm63xx_hsspi_remove() does not perform the matching
pm_runtime_disable() after a successful probe.

The probe error paths already disable runtime PM when sysfs group
creation or controller registration fails.

Add pm_runtime_disable() to the remove path after removing the sysfs
group to balance pm_runtime_enable() from bcm63xx_hsspi_probe().

Fixes: fb8695e3749e ("spi: bcm63xx-hsspi: fix pm_runtime")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924112329.1566051-4-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 87ec22627c6d6..3cb643340b3d0 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -888,6 +888,7 @@ static void bcm63xx_hsspi_remove(struct platform_device *pdev)
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 	sysfs_remove_group(&pdev->dev.kobj, &bcm63xx_hsspi_group);
+	pm_runtime_disable(&pdev->dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



