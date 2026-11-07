Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064946;
	b=dX0gy+M0iO4OZWNi5Qh7HLQPFr7Niv+4G2StJ0NBhGnnAOGqaLlLMTwv4bMG5uOZQ/qw
	 1P1mCFcXMQ13U7vCoVb3woX07Jg6vF4SI93Pv43h8I2KE8dUlWQ4JARyLQnhccDGp+ncX
	 pFQrsXDSgA0dYvr7a+y+15qwe8VA0CI+u34WJ54VI3emdHnoofOWYHnXYZi2JMFL7wx63
	 O2KnxNNv5B/mkrrwvT0+skmJj4SmkH30lbKAJTxuy/GMYl4TKzR7xIYQLeRtLt9ULXf81
	 /GUbmKFfd73PS/6cluANEnzuIapXjUyxm/OpxyZ0W5bNzd2OmqRrg345ND+iFpJyzlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IKMF4FNv2WTfdf/MQ9oPdTBddGmjkOTuCelqp7+Ztvo=;
	b=ECjtg278FoNfzSY4PxyMowc3h1+DC8snkg0cPuYiDbQg0EiAJ3gMRPyfclifWcswIh/A
	 8EXczShXfEj0VbGMKmbErt5iXh+8us/RqY/ELU3oEyYp0ShntFFEr25LIu/50vL1t8kpm
	 QVqkbKrUbCSgYEo1fpmlsjcCyhod8UvHN03IXxKPU0v2rZZZwZSrv5NrJObi6xhoSgmDQ
	 mQ5aoFotQa/DK0hvz2DxxKFzJwbCe5zNpugdQb7Zw8cCLPkCXuA+2dIRJb4jsdUY+N3Ep
	 W6OlOmzYyAkGc3lLiMy3vaJw9/Igychc6HTUu6kDCMinsRJe2i65wROnjbm/n1vf01Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pXEBFvAT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A172606A9C3;
	Sat,  7 Nov 2026 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pXEBFvAT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53DF1F0089F;
	Sat,  7 Nov 2026 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064946;
	bh=IKMF4FNv2WTfdf/MQ9oPdTBddGmjkOTuCelqp7+Ztvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXEBFvATy6Ofq+T6Ir8HolE91R9Ydw7YIqRid552lJjID7u9VCW9FljaD1v7j7NEz
	 pAOayudjP7Jk+NiYNpnhaXMe78hJudtFx0zyxWZSvk9E2195ZOE6N/nEV95PP2lb59
	 jRxzC/xyoFFH0u6tVicBCVL9D3PuO4UyLPmcmP30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0795/1257] spi: jcore: fix divide-by-zero when speed_hz is zero
Date: Sat,  7 Nov 2026 08:51:31 -0500
Message-ID: <20261107135001.287578460@linuxfoundation.org>
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
index a75cd61ec7a33..fc87ad98e4e7d 100644
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



