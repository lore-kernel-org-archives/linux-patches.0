Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064427;
	b=UdOEHPfJJlCKO9WdfzS8zqrEojf+JyXCed+iQbSwTASP6HD1ww1N7yOuziL11180IqF1
	 FuAje8xH/iGCyWZKideoKMDInSnYVPIheIQM+AyWu/LEH1y5SnXsGEstibFy5Js6uAnDw
	 vylDi55I3xv4mVHJowWya6pe1LW05h5ePDsYeN8zXau2Bimp8f+hntofAe3p/9kkcl3ME
	 lFuZhT/jkuSC0jtxPsHRBIF34znlLTxB+/9U+2QqwfDhbHnIFnusfxRmueSP2EwvbEg34
	 tI1ttKeiPm/vqtRdQv9eRaEQJsVuUzf5Q1kPboG7AQKBDjmnfX9pmyR6CXOpXtQ8khw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vyuwj3GOWzzdtZduFoirEKQARut/t/MRTl4Yeyr73MU=;
	b=BC5xZ3yyshTFNzMaBmqpF5lEO9clQK7Zua2s0PODndSTp5oiP82T4qmH8LMpQPcy+Sbc
	 EnDLXwMkwOCX1yeHvSY7QM4sUyxnHHDEtSBp4h16Dg0oND+allH+1+GoRjKWtCIm/aew8
	 fCY8fLQvVa7rmnqn8j64bkR/Kgq89VXDqHmt7NZVD3m+syeyyPPgXZS579mfmK7ixRLFC
	 8lJzjOjUsYHniae+L5/VfnvLc7R22XCZE1zKEHv+dnWiLWkkfqnlNo+n/URIjqS/uzQb+
	 cumCzpowzJavaHsliPndlKCKKR/6tscG2zfe4YykeTD0+QmYC4Irk99uxDFDlWqCAEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V4XwJzUF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0481D606EE9A;
	Sat,  7 Nov 2026 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V4XwJzUF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682351F0089F;
	Sat,  7 Nov 2026 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064426;
	bh=vyuwj3GOWzzdtZduFoirEKQARut/t/MRTl4Yeyr73MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4XwJzUFt1UVeJuds9Sqc4Qnqt8OuFiEcs2yw3trtA5LENKLs1LiTtJ6bCPun6mA1
	 KDmsl5QHq7p4g/YHYYTLEcvGfAQJFwpiYtdRbvqQD2Hsy356zXzK+tt0SGHcUrFwm4
	 faL+sCZ6vmX1jwlOXH5Yhg/hpR5Pp9iURZVNoZLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0476/1257] spi: atmel-quadspi: balance runtime PM and pclk across system sleep
Date: Sat,  7 Nov 2026 08:46:12 -0500
Message-ID: <20261107134952.597912846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 717e45f97246d1070cdf86ccd7a0fb872b45933a ]

On the controllers with a generic clock (SAMA7G5, SAMA7D65, SAM9X7 and
LAN969x), atmel_qspi_suspend() takes a runtime PM reference and returns
without dropping it or suspending the device. It disables the peripheral
clock directly. atmel_qspi_resume() only prepares the peripheral clock
and then reinitializes the controller with that clock still off.

On a SAM9X75 Curiosity board, the tested standby and mem resumes
failed:

  atmel_qspi f0014000.spi: PM: failed to resume: error -110
  spi-nor spi0.0: resume() failed

Reading the flash afterwards returned no data. The runtime usage count
grew by one with each cycle, and the second suspend disabled the
peripheral clock again:

  WARNING: drivers/clk/clk.c:1257 at clk_core_disable+0x6c/0xcc
  qspi_clk already disabled

Use the same runtime PM sequence as the other variants. Suspend disables
the controller and forces a runtime suspend. Resume forces a runtime
resume, which enables the peripheral clock, before it runs the init
callback, and drops the reference afterwards. With this change the
tested resumes succeed on the board in both modes, the controller
returns to runtime suspend, and the flash reads back.

Fixes: 5af42209a4d2 ("spi: atmel-quadspi: Add support for sama7g5 QSPI")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260709112006.390742-1-robert.marko%40sartura.hr?part=3
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260923012950.15651-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index ec19fa0180f00..96ed734b56218 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -1590,12 +1590,14 @@ static int atmel_qspi_suspend(struct device *dev)
 
 	if (aq->caps->has_gclk) {
 		ret = atmel_qspi_sama7g5_suspend(aq);
-		clk_disable_unprepare(aq->pclk);
-		return ret;
+		if (ret) {
+			pm_runtime_put_autosuspend(dev);
+			return ret;
+		}
+	} else {
+		atmel_qspi_write(QSPI_CR_QSPIDIS, aq, QSPI_CR);
 	}
 
-	atmel_qspi_write(QSPI_CR_QSPIDIS, aq, QSPI_CR);
-
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_force_suspend(dev);
 
@@ -1621,20 +1623,20 @@ static int atmel_qspi_resume(struct device *dev)
 		return ret;
 	}
 
-	if (aq->caps->has_gclk)
-		return aq->caps->init(aq);
-
 	ret = pm_runtime_force_resume(dev);
 	if (ret < 0)
 		return ret;
 
-	atmel_qspi_init(aq);
-
-	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
+	if (aq->caps->has_gclk) {
+		ret = aq->caps->init(aq);
+	} else {
+		atmel_qspi_init(aq);
+		atmel_qspi_write(aq->scr, aq, QSPI_SCR);
+	}
 
 	pm_runtime_put_autosuspend(dev);
 
-	return 0;
+	return ret;
 }
 
 static int atmel_qspi_runtime_suspend(struct device *dev)
-- 
2.53.0



