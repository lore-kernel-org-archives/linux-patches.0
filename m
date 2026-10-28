Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214986;
	b=Fiu+kQmS1PRV28o6BGBbGpPCmtOWFYBa7+bojyZNWQpndXapvYnZvts/FEPeEBsTiFFY
	 RA2wPCffkrQYa3nAKEjQD5M/Sn3794x1asSBfL6hdERTrdOBzAfTmBwe/z8DhiBinp7QS
	 QyNTyzN1AxxBUJnJrX7HXW2d019BahpRjkqY4ugnxNJWQg5HvBH6WTdSOhh+P0yxyEohW
	 rqw1mYF2HwmPvuSXZm+K9vfhezNeL6pjqsr+2QzWyAXxkhN4g2hZRMWjJYMcuEgDnKEP4
	 TAwGBMML5H/kGPiIlMtSMdWRveS427gxxvXqPhX8pDEMqTLNHmdkd57G/0jhX5S8lHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPkV5kiTFwpco1bFOlPw7vg2+OztjgHrv2nmmaXdBG0=;
	b=0N8bUN5AnOybEvbyBJnFKcZD5rGov+rtTQ5JFdVhwwl+lESilfO3E58iQrcv37VEhXv0
	 EYu9uAi7BL5z9/dgn5WaS8dnSA17gB+7Hzr4IW9gSK7ocC43GWxMky/cFbhmhE47ujJmu
	 +ZoC/RIw66mJ3zjXl0QTTdkEbfuysWRK4kJGkYujAl7x6gASaS0rRRGRRA8nuEhJsqbYg
	 xDwb5lJ8mBc8cMeL2lDPRCoQL8mRRx4rX/1YNGv7NIJctF8QzxT/iXMmMr8Z77fwRV3eS
	 hXJJsTESLXApwJNGe8nw8iq0c5grXgo31a7kb2/rD9XPaP2XFDIun4yGS1zPrCbHe4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0U1C+scC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F828606A31C;
	Wed, 28 Oct 2026 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0U1C+scC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCBB1F01825;
	Wed, 28 Oct 2026 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214986;
	bh=HPkV5kiTFwpco1bFOlPw7vg2+OztjgHrv2nmmaXdBG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0U1C+scCnvXTT2h1dSN3kefidMfwTlsmVhi3d8VN5hLgZnGNqRvAf852DOlo/OkSJ
	 MTXev98MoD/BH6MhZLHgzpFePro0sfkh8cPdehOKAaf0dufjTNLFv2qqCWBmUGzoC4
	 e5/2GNdwKEF0cDvbU5H1fBg1kqQ30S1+RP15nluQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Luotao Fu <l.fu@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1053/1887] spi: mpc52xx: fix controller deregistration
Date: Wed, 28 Oct 2026 17:52:29 +0100
Message-ID: <20261028170523.370827620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0f997fdae819a8c2cc83bd4ff7d935ad76c727c9 ]

Make sure to deregister the controller before disabling and releasing
underlying resources like interrupts and gpios during driver unbind.

Fixes: 42bbb70980f3 ("powerpc/5200: Add mpc5200-spi (non-PSC) device driver")
Fixes: b8d4e2ce60b6 ("mpc52xx_spi: add gpio chipselect")
Cc: stable@vger.kernel.org	# 2.6.33
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 1f329dd60c16d..e556b3d306918 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -519,6 +519,8 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_controller_get_devdata(host);
 	int i;
 
+	spi_unregister_controller(host);
+
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
@@ -528,7 +530,6 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 		gpiod_put(ms->gpio_cs[i]);
 
 	kfree(ms->gpio_cs);
-	spi_unregister_controller(host);
 	iounmap(ms->regs);
 	spi_controller_put(host);
 }
-- 
2.53.0



