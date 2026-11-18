Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052666;
	b=IU3wA7eKgidhD5lChQLOoigGton7hUDJj0ZjvfWvZfUYRRsinv6ciPFOy23FShmO/KyL
	 5Wv4WmnwpdTNFYur6DFqa8MZRlm7sPm/8bJNjnd2sp9qNAKue/2N298QYdu849g02PmLN
	 IsUSG/Ly3Fzj6jhdSGntAcrAvXbNOA7cLSe0m4+Xrj2gDhOMXNIj3QnndhFQMi4kDzHQ4
	 4A30NFn+eakNQj8qJf6ENOuXUJYVSlM6oypPKtuCA8lcmigKxW8njqlmMiUBXlZgykFAx
	 C6PGlBi5Ll+GTL5mb6Yzb4L1tcBibieHP2zadzzWQkfqlr78b+9ENFuC8d6wdPDMJeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+20IulfEnmA4nVBvG9J+yFniDfrPyDdgim2Kyx2nTE=;
	b=AWOykpuo+ei2IvuizmaEaluAmQvJkWLado1/q56nYnIvLftWOTmsbpcIV/1wzLgMpiww
	 6d54WunUjHe5KxVHYzfze7KBtbkcNZt0626UKAt4GBF3smPLyxs0U5NWqGvoUh1YhKETI
	 lMbiGZ6kc/fziH5R4FRmWOq9BY8pk+mObLTrTnL3eArVlQMSK+ipOICyba8PZGLMvpBgY
	 1tKSpBFtSwAsorW91pOvLd+YeV3Mc3EJTnPrLdMYZu+iDMLh4i71TzVgBx0XfYyh0xJkb
	 yJ8C9X/QZ5FFDC8zTrjrNdJF0F680HesDfxsyiltaaAvUcM6NlJeRpZhct5rOI73yjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GmjJpXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664B606A320;
	Thu, 19 Nov 2026 01:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GmjJpXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF4B1F000C5;
	Thu, 19 Nov 2026 01:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052666;
	bh=c+20IulfEnmA4nVBvG9J+yFniDfrPyDdgim2Kyx2nTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GmjJpXyRhC7V/YdUWXJGn9BVXdlWszIwMrJAxX+lYOq3O4vUj0KSgRD1myenmoPb
	 Dk75ju4gGmt94Jm1Wy0qyuBdCqEcjqEg5fZjeYI+X5oaPVbz+xWkGN5ZAb3KuDKX2T
	 HA8UBwzz5qTSS/EYfxl3nhCmeSeDRRU0ABBVu4ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0646/2214] spi: jcore: fix divide-by-zero when speed_hz is zero
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118150037.162590235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 7db773075501248893c22b11bedc6745d6d0be45 ]

jcore_spi_baudrate() computes hw->clock_freq / 2 / speed without
validating speed. The SPI core fills transfer.speed_hz from
spi->max_speed_hz when it is zero, and jcore_spi_probe() never sets
host->max_speed_hz, so the clamp in __spi_setup() is skipped. A
spi_device created via the sysfs new_device interface (or a DT node
without spi-max-frequency) therefore has max_speed_hz == 0, and any
SPI_IOC_MESSAGE transfer reaches jcore_spi_baudrate() with speed == 0,
causing a division by zero and a kernel panic.

Clamp speed to a minimum of 1 Hz before the division so the divisor is
never zero. The computed divider then truncates to the register field
width and the transfer simply runs at the slowest supported rate.

Verified by inspection of the __spi_setup() clamp and
__spi_validate()'s speed_hz handling; the division-by-zero path
requires the J-Core controller, which was not available.

Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Fixes: 2cb1b3b3ac0a ("spi: add driver for J-Core SPI controller")
Cc: stable@vger.kernel.org # 4.9+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261014-spi-jcore-divzero-v1-1-a8205d30f2d1@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-jcore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-jcore.c b/drivers/spi/spi-jcore.c
index 74c8319c29f17..e8b8e160d2e34 100644
--- a/drivers/spi/spi-jcore.c
+++ b/drivers/spi/spi-jcore.c
@@ -84,6 +84,8 @@ static void jcore_spi_baudrate(struct jcore_spi *hw, int speed)
 {
 	if (speed == hw->speed_hz)
 		return;
+	if (speed <= 0)
+		speed = 1;
 	hw->speed_hz = speed;
 	if (speed >= hw->clock_freq / 2)
 		hw->speed_reg = 0;
-- 
2.53.0



