Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062394;
	b=f44MYRXXa1RkK4V5cpHkGS5a2ja3keufiLbXVnnwzmaagySzX8sKiWDJd/gABL4lFVxz
	 kph0Feule725JUucNiKlmJzfBiVkF+hLZYyQ/hot7Fi42nbyLZz2M2Np4H150sRJx07Ik
	 QQffCW3QMqAB15cb8BGnm9ovmzVwvsQ2twX5UMbSQRdVYbuJ/26cirYgxThpluZiCu4Tx
	 azLF8Z+eg34U9cuLQD0bEsrBCu8bTr5QSuXTYQA0WlWmyFXU84k66PRHlCDQlfX9LwHEq
	 mR3x8yYMsQZB3C3r8mloaL8ZNVS7eMslslb67lsmb6FBJ7vnoFp6f664ro0LKPpodAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LIEPEa4lX+ZFty3Ku/z3ZLWF29NngmXWgjvARfIT1oY=;
	b=Hw6N1MpV/mOhgztykGKw+fiYkHUyJQK+BE7YNdId8lPTjKCg+z+kX9fWfE48zYapZRI9
	 +eEPUTr303qvJCYCJ10M+yfEzNplMasAOquJGvEe8d2sx4rk+otN+dqsVECCwZk8gDomY
	 GqVS0Jo+7v7qkDXSpK+FzvJKKF/FZ0PyH4eZOTtPcwJHSNWJR9SjW4VKES96JSVkJniOE
	 RbMmnJN5bwaOBFJ5tO6dfU44FEYI1i6aqDzobgdNjkzR+tj1NYfqqYhUr1Zol4uiGWSLn
	 FHOV8sJTgIyDW/6RJVECdkmf3P/ABrw/GNftMycnkgAgHIHVEoIxjWSfFn2tjeXcGyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5grQ0UJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BF4606D839;
	Sat,  7 Nov 2026 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5grQ0UJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839851F0089F;
	Sat,  7 Nov 2026 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062393;
	bh=LIEPEa4lX+ZFty3Ku/z3ZLWF29NngmXWgjvARfIT1oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5grQ0UJ4P5kfn/qbBL+mvYRAL+M5pd4v96FSW9+4FNdPw7UgGLh6z4C6MHZhMUAm
	 HyqVM7+zcS5fijH9N28PoiVB0Lv+ov8LYO6+vbmK1djkU2jengStKpqCChtLjl7FZH
	 59gjmHKtUeeW0wwO7BFBoNGfOYsM1IW9+SgVhAns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1312/1536] spi: jcore: fix divide-by-zero when speed_hz is zero
Date: Sat,  7 Nov 2026 08:55:28 -0500
Message-ID: <20261107135034.648943974@linuxfoundation.org>
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
index e37ca22e04ba6..2bde899eb2b49 100644
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



