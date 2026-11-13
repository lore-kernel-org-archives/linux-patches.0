Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590695;
	b=QP4QPyMwWO9pvyRMOpPO2gYN+A7D5FxAw3m/jyYtNgeqxMWosizsfvI3NTJopAxTUrEd
	 gLJcHnR4/V243u3rHifbxHhoghtWpfIarMOzOsTB0Nte3jVrh1H3av6PuLZbryAqdnhxC
	 br+mThItMyJkh0oSmOv6XxhZxmVizx2++vlckZ+U4yK7rj2EJT7J9rhfT+adFoyRoTlkz
	 ACEpvnUtkUIvAOyiVQMqQQPceUWiM6RGSJCAgoDlJyvTGttzFIrZcOB8GwyWqKXfojy5d
	 QJWxorr3F9ARQfCqmG/rarYMjWe1Vx5cD7yGSuMLlWWXVX3LH/4QPWOSIGAgonYxgBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y0NTj5esc8j59NxJ7Rx6qlcjkBJ+xnHVJ6oZH8l/ju0=;
	b=zlEfYub076oIaioQ1ESvV3p0/dvLsX3YyFmCTC42H80xWhR+cEP7MmGR5S/WwOevmyps
	 B/eecWi0AjqOw4+GZysvgBFQyDeod7v71VVCZPzbSaunIY6375w/UabmM650u6SZnHG30
	 KnpOdj+9oLAfgHeFqQMtFl0UKEBVRI3rBXY2IYRbypaLapm6fq58VWfF2iNVM2XP07jt6
	 YTXimwWXTq9QL7+4cUUkUcA5IBuaSdlcVaZfutv1GD1anlmunyzmVDAsfzWrx0WyaR0i/
	 pBcgxjSs3gKp/zQolRLMAaDjb2o1gIqncHHrUlNXwDUm58TcTwUEKYRQ89bkM8FkbTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mnh+BwWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E2606B222;
	Fri, 13 Nov 2026 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mnh+BwWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0031F000C4;
	Fri, 13 Nov 2026 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590695;
	bh=Y0NTj5esc8j59NxJ7Rx6qlcjkBJ+xnHVJ6oZH8l/ju0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mnh+BwWyEYDV0mcga6nxFfcc+GutwvydCpE/F5BtVfBeYxu0GmOFXAxxsB+2/zLBq
	 SlqxxqM0feI78nLIbrafQqSwxJBfkoMwRkyDz3vlJUrt5bqKZT3MxlEVoHAHIcRV6T
	 OpIhCNxAGe6rKIDCAZSfcpyI6w1PIxfJn2SdT5I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/686] spi: atmel-quadspi: use init callback for gclk variants
Date: Fri, 13 Nov 2026 10:51:36 -0500
Message-ID: <20261113153840.724705375@linuxfoundation.org>
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

[ Upstream commit b881f1d8d1dfbc4480776d3b16f80261a5a68cbc ]

Assign the existing SAMA7G5 initialization routine to every generic
clock variant and dispatch initialization exclusively through the
capability callback.

This keeps hardware capabilities separate from initialization selection
and lets variants override the sequence explicitly.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://patch.msgid.link/20260709112006.390742-4-robert.marko@sartura.hr
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 717e45f97246 ("spi: atmel-quadspi: balance runtime PM and pclk across system sleep")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 6c2d3c00409bb..a917530f81741 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -1159,10 +1159,7 @@ static int atmel_qspi_sama7g5_setup(struct spi_device *spi)
 	/* The controller can communicate with a single peripheral device (target). */
 	aq->target_max_speed_hz = spi->max_speed_hz;
 
-	if (aq->caps->init)
-		return aq->caps->init(aq);
-
-	return atmel_qspi_sama7g5_init(aq);
+	return aq->caps->init(aq);
 }
 
 static int atmel_qspi_setup(struct spi_device *spi)
@@ -1577,11 +1574,8 @@ static int __maybe_unused atmel_qspi_resume(struct device *dev)
 		return ret;
 	}
 
-	if (aq->caps->init)
-		return aq->caps->init(aq);
-
 	if (aq->caps->has_gclk)
-		return atmel_qspi_sama7g5_init(aq);
+		return aq->caps->init(aq);
 
 	ret = pm_runtime_force_resume(dev);
 	if (ret < 0)
@@ -1639,6 +1633,7 @@ static const struct atmel_qspi_caps atmel_sam9x60_qspi_caps = {
 
 static const struct atmel_qspi_caps atmel_sam9x7_ospi_caps = {
 	.max_speed_hz = SAM9X7_QSPI_MAX_SPEED_HZ,
+	.init = atmel_qspi_sama7g5_init,
 	.has_gclk = true,
 	.octal = true,
 	.has_dma = true,
@@ -1649,6 +1644,7 @@ static const struct atmel_qspi_caps atmel_sam9x7_ospi_caps = {
 
 static const struct atmel_qspi_caps atmel_sama7d65_ospi_caps = {
 	.max_speed_hz = SAMA7G5_QSPI0_MAX_SPEED_HZ,
+	.init = atmel_qspi_sama7g5_init,
 	.has_gclk = true,
 	.octal = true,
 	.has_dma = true,
@@ -1659,6 +1655,7 @@ static const struct atmel_qspi_caps atmel_sama7d65_ospi_caps = {
 
 static const struct atmel_qspi_caps atmel_sama7d65_qspi_caps = {
 	.max_speed_hz = SAMA7G5_QSPI1_SDR_MAX_SPEED_HZ,
+	.init = atmel_qspi_sama7g5_init,
 	.has_gclk = true,
 	.has_dma = true,
 	.has_2xgclk = true,
@@ -1667,6 +1664,7 @@ static const struct atmel_qspi_caps atmel_sama7d65_qspi_caps = {
 
 static const struct atmel_qspi_caps atmel_sama7g5_ospi_caps = {
 	.max_speed_hz = SAMA7G5_QSPI0_MAX_SPEED_HZ,
+	.init = atmel_qspi_sama7g5_init,
 	.has_gclk = true,
 	.octal = true,
 	.has_dma = true,
@@ -1676,6 +1674,7 @@ static const struct atmel_qspi_caps atmel_sama7g5_ospi_caps = {
 
 static const struct atmel_qspi_caps atmel_sama7g5_qspi_caps = {
 	.max_speed_hz = SAMA7G5_QSPI1_SDR_MAX_SPEED_HZ,
+	.init = atmel_qspi_sama7g5_init,
 	.has_gclk = true,
 	.has_dma = true,
 	.has_dllon = true,
-- 
2.53.0



