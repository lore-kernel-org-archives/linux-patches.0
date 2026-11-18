Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045539;
	b=bowK4Mm2CPvRQAgW+6rkyJUFDsYmooIyrMIhFCSWoMWtMlW6htt/P5ZsLi4rSR/3MkEM
	 /7JGMAnqgSj4yGP9tHKHgyucapNHqvt9I0zH/SBxa52xlLwaHnxw3ZLelBL458uac7Q8q
	 EFHN6m07/hfgqabBPXFHSr7DSZR8oc+Ol5cshnFcf4doyFqCr7wPtCEfFkqneGIQv2PNK
	 b5GwMXgYokN4dzs+742Ed5aLolic9jMtgIF1yQZpo0KegbvlKgRNdYx+MFGxhdi53gzgb
	 tXiMFUaM94xtZgonw9Y0OLU7tgGuAwDqg3YusPsC6Snl8RC6rOxdGrcwtav+EKQdPiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VDEuCehc+tZh+YjePramtwrlJgjD6m+GI67la4nOUeM=;
	b=jzTCbwKZz/Et6XDPxu+0bMlrutgvWzjduGt6krLIXLjTJI0z+0GFnxBYfhU0AAHTEvsV
	 93keA37AyPq3K3wvvSo1LYPvmdeA+3IovAQBJV6pq3xnMr1GWmd+WGkcnWpkYvOKcrGeG
	 VWShXbIoG1j7cc8E38Xywj6TapnFeElHKKMn6USs/5cYJGvt8cauaXa6N/OcuhPgwZmKW
	 LucVcjwoDf96Qt5lMfBjQyoJdIemWx9XrqfBQW2t25QQCPTv3f2m+PUcIqJqUZ0rYfwQI
	 nObfwTpeKyupKfVTlfCucnH8nQ1nlYfSxO0VR3eBhN05fzyrdeTWK4LBf+lFZjXrL7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KLpMpzMU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDCD606A32C;
	Wed, 18 Nov 2026 23:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KLpMpzMU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F68C1F000C4;
	Wed, 18 Nov 2026 23:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045539;
	bh=VDEuCehc+tZh+YjePramtwrlJgjD6m+GI67la4nOUeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLpMpzMUpXVfzdmxyAB5k2Q8RQfryjjL6fTu7RDK3zQE6tJlgk5r+baSEPVO7wNGs
	 zqW/ZmTYDTQmtoAqObyUvqhCBjt+HKteZ2TnKcOszw6Wy7VQLCwO3W5gE28VeU4gun
	 psuQqfinAHxBEz6E9VLvDsETY6tHFEllW51lk8UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0960/2857] spi: jcore: fix divide-by-zero when speed_hz is zero
Date: Wed, 18 Nov 2026 15:33:14 +0100
Message-ID: <20261118150236.167864568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



