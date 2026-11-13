Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590693;
	b=UJsSdszA2ghM+MwKw+oSra8R4BP6bR/7vx8KwSANJEPFHWGJk2E/cfzt28lCjiZt1bE3
	 g0PcjQmPdPaR1hz3JQYCUq1lb0QNYSTAu8gedPBvnemHzpKhB29CNnMRYMqAIySljkVgl
	 4r+/x2e2t6RsvHO9AjQJmtobvQWjQVX3Cs2WKyKKrT+2dAGsn4j67Je3Q/IV5nWSi+k10
	 Z4L/5lpOpR9GeHd3km4kdjRPlTxHkb5hrit85KSudLhNro309ydAe0BcUt0CihaU8rn81
	 vPRaVeWuX45S1g2UDjQNXPVg4LPXNUF+VDXuVMPkPIjMrDCX/X5r7BTLb7vYnAhIG4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrO09Hb9s0c1+a8CneuxDnpmPpyNrBgVRR5/x0ergw8=;
	b=NGC6CoDuzNxvb0+1Jib9WMj5Lacg0kgH1LaCGRQ+egSOdoNuBeMkzNN7cELyqD1riWUU
	 b4fap7ZrGD4FynIvKarv0JyCitK2Ci3R3ifRA6PGRzCjk384Rjzrn6RfrIO+ZUcm5+/WD
	 600Sya04uBSoKFyCVoVRG/8R3ZjW4Fx/vTcAAaZn+ZBRAJKzTGIzDDYvjS6JgdWRwE+hX
	 nJTHB442mDCbW8RRqCFYvHpbY4vx0wCayqNUWJiiODSxjDEl9+sIqrUcwymuyIPxRphlb
	 OyuNLf9YKiwGmVT0nBjepu5tlUMeihdbkjn0P3nDhoZALE9ThkPo/XNBb4rF9TbKELQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WOhV/5WE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E81606CEF7;
	Fri, 13 Nov 2026 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOhV/5WE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833AB1F000C4;
	Fri, 13 Nov 2026 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590693;
	bh=vrO09Hb9s0c1+a8CneuxDnpmPpyNrBgVRR5/x0ergw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOhV/5WEBPqA9wyM6QlLXINvg1VHeaE32jNEJX+56yaHR3I/A3k81U85BnoMJRBei
	 EFLDexAod5aYFtTzzh6H2HuULXXIjByn3gWiFY+jgvETJ2GbNpUpuJU6r5kjp3TPp1
	 COYC0PJTtRGI9Iu9m20yidqccuFbH/6JfHogqyP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/686] spi: atmel-quadspi: add controller init callback
Date: Fri, 13 Nov 2026 10:51:35 -0500
Message-ID: <20261113153840.689807068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit cbbd5a945e85e7835ac5792d855d85c20e40d1e3 ]

Allow controller variants to provide a custom initialization callback
through their capability data.

This prepares the driver for variants which require a different hardware
initialization sequence without adding SoC checks to the common path.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://patch.msgid.link/20260709112006.390742-3-robert.marko@sartura.hr
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 717e45f97246 ("spi: atmel-quadspi: balance runtime PM and pclk across system sleep")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index d7a3d85d00c2f..6c2d3c00409bb 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -256,8 +256,11 @@ static const struct atmel_qspi_pcal pcal[ATMEL_QSPI_PCAL_ARRAY_SIZE] = {
 	{200000000, 7},
 };
 
+struct atmel_qspi;
+
 struct atmel_qspi_caps {
 	u32 max_speed_hz;
+	int (*init)(struct atmel_qspi *aq);
 	bool has_qspick;
 	bool has_gclk;
 	bool has_ricr;
@@ -1156,6 +1159,9 @@ static int atmel_qspi_sama7g5_setup(struct spi_device *spi)
 	/* The controller can communicate with a single peripheral device (target). */
 	aq->target_max_speed_hz = spi->max_speed_hz;
 
+	if (aq->caps->init)
+		return aq->caps->init(aq);
+
 	return atmel_qspi_sama7g5_init(aq);
 }
 
@@ -1571,6 +1577,9 @@ static int __maybe_unused atmel_qspi_resume(struct device *dev)
 		return ret;
 	}
 
+	if (aq->caps->init)
+		return aq->caps->init(aq);
+
 	if (aq->caps->has_gclk)
 		return atmel_qspi_sama7g5_init(aq);
 
-- 
2.53.0



