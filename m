Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036616;
	b=d+KcrUtHkj0VJ3xm7pwX1ZP4Yf3bsk04BnkOlxStcpp20MUP+NsgHN1aSUMvMlEksVQ+
	 yq2peComhPS7qs4qdbg6WoSpGnNCsfx/WgV3R4dxFuKGXWbuDAIHX/2bBaDei12idasQ/
	 swM4JTIAHDXLP5LvmT+spKPX3mTiAbN1RvDhqjUMG9gocpmeqZb+gY1alZkShv184Oc3a
	 s6KUmYomrt8IgAv0dbMszywSvuhlz8IfSzGxN3LHsBM2yYQhXquu9rCZebAEwTKDvMmhe
	 sxCTAHc9Kdv9v/OgGc3Y91wBsc764rOTRy9eKQsSbgvKVZ8krbcAXLcIrrZAEsC6YLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MCgjnNqEicz8vVNid0nsq/uXowo8ntpw6YlhPv71JVE=;
	b=fpWP53k3phb7/bKw1Lkm6toYhW4EC1NR0gsBrxlMKHgbSrOppHSNWihNqvArQ6S2xZGS
	 tL9k2SHaFFEU549KKiUeql6epc3s6+9iqfnMsnJt8O0zGTTF15v7dRKHyL3HxK80P35oD
	 t2Sr89DZhk97b2z/BI93Cjc8ZgO863A7x6NJJpe+HlnKzPyshzM8QjAK4Tp44tg1fR+Bw
	 OEIYO6o7ntpBJ5Kyvq3KYzKMFyWEC7oCT2ddq74xfj70mSeksHTX9lB5Otg5QTABxdn1v
	 8V5o1TLRcwWTn6uDY/OcWIR61EaGo7Fa2ScDzAwZjVDz+ylQ1JZ3xF02EiB1JiUaQ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uj7TPnEp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA7606A31C;
	Wed, 18 Nov 2026 21:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uj7TPnEp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665151F000C5;
	Wed, 18 Nov 2026 21:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036615;
	bh=MCgjnNqEicz8vVNid0nsq/uXowo8ntpw6YlhPv71JVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uj7TPnEpOGYRyLCR5cIa99t+dLQackCrAhS3+b3V0GWgHCdQkrdZFRaQUoRrcoCtD
	 ETDnAgEGALbvL91c46SOWnmWV0zSzIqNdpysmU+piPzx/EcCptUtt7rK10OQaKNaUP
	 GZ9A8K0kKkIWKDVUT65Uhd7E7gVBdfZx3PP67FKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1124/3318] spi: jcore: fix divide-by-zero when speed_hz is zero
Date: Wed, 18 Nov 2026 15:29:06 +0100
Message-ID: <20261118150353.754947826@linuxfoundation.org>
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



