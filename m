Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061886;
	b=cSWfOoS68kJoZVqSLIvUHUObgFRQp5crxejxmvxx8meWd/tFmOFnRD4o1KzNwEB7GG/j
	 g/csDjYc/f7yE06kY4naFAc65R/bAjQg1JF5ar3ayq3WVKuUefsq0R+MaBJOYEj1izA+n
	 Ih95WZTBeHtgf7mEsfB+K3f7SL85kZYQd9wo6ztkIVzk+sUdCBQORkUT0dp5DwB5pnFZS
	 df/hdssOd0TvVxmn+LYC/rloTCd6h9tNoMpkHs+i85OgHQrIJMwIn4JR8Mwo7KFyY7Gko
	 FLPDFaIE/zQKn01PUCv7YgA17I4cTAEv8Dp4dwn6PPua43MDwfkz5lz47V/hHnpNf3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FkgxlnalMx8hnxsmCNf2YRCE0qysiKH4dGq79zeCzc0=;
	b=g1DcR9L6UGzwGl36m1lzKI/rQ/c8AoiUz0TQ+W+/Mm9zBJyXqQF05i9srfSMj0Tq9KD2
	 27sJEygVw9EC4ey9lGYBhsdieY7NLwx+QjMs2S6+p1jEYgI+oAJ95SVjhhIz33A4wMsAr
	 L+e562a6YrJ7QwWB5GROm7wMLAMYSH0RoXnSLSExFnVkYwPPb8Xdu0a191CkqaGHtYFHv
	 gha8jfBC9+zfIg8qVl0chkaVollJ/pqTz0nW6O1cQYS2CIu46HyBsQ8/Jrs4p3DHKA1cZ
	 Zdhnb3DbZCASJlQO4Oz9rc87J9C9ZY72NnEphE/nz85ASO8xKX38NglBtRAPo/AxzsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJ41Qdcy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25AB606A331;
	Sat,  7 Nov 2026 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJ41Qdcy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891D31F0089F;
	Sat,  7 Nov 2026 14:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061885;
	bh=FkgxlnalMx8hnxsmCNf2YRCE0qysiKH4dGq79zeCzc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJ41QdcyX0j4WROFnTBzhyBLmgo1kgRqg40XlMm+iyL+FbXw3dt/TROhGqURjSwbC
	 NAlFhp4FWMB62qPM1a8wU5x+7gyyrpCcQox0s1JB+icwD3W8kzBL/m9/X/9YaV+Bdu
	 /BqR0OvNri7oAWe7raykc/7A6+7bLCKVv3AdS0XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0897/1536] media: meson-ir-tx: Ensure clock is disabled on unbind
Date: Sat,  7 Nov 2026 08:48:33 -0500
Message-ID: <20261107135022.827253105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1517326fcc9dfdb9acb24f42472366ac1b4b8237 ]

clk_prepare_enable() needs a call to clk_disable_unprepare() on
driver unbind. Make it devm managed.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index fded2c256f2a6..6beb9e97453dd 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -288,11 +288,12 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 	if (!np)
 		return -ENODEV;
 
-	clock = devm_clk_get(ir->dev, "xtal");
-	if (IS_ERR(clock) || clk_prepare_enable(clock))
+	*clk_nr = IRB_MOD_XTAL3_CLK;
+
+	clock = devm_clk_get_enabled(ir->dev, "xtal");
+	if (IS_ERR(clock))
 		return -ENODEV;
 
-	*clk_nr = IRB_MOD_XTAL3_CLK;
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
 	if (ir->clk_rate < IRB_MOD_1US_CLK_RATE) {
-- 
2.53.0



