Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033502;
	b=Hqa0RsmW8ReVe5Q7BxWfLMbdCpsyColXBkw9uaXOYg36qjZ1iBm/vt+HwOKyIYBSJfRo
	 VzFuyrWr3Fb0dqrU6XLw92TnjP9QBFbHX40IZS5fEKgUTj60gfHay0Xgf/gfbP04PCzvZ
	 w8ydVy/iz+39G7A2QSUXY+S0A0LG2M3CPl04qbAUyc5wZzNJVtjYP63+/HL+XQzOwr7Jq
	 x3s3Bna+fgQG7453aN7NDSBgxvvD0nAKQmvHJ6U7q4hZx6gQwxQC8ROYVd4W/oj6NSQHD
	 yLv6eEDKGoMcyCoen1jL1AW2t35g4VSSIlbN2yCFO3K9kZQxWSWNRJpmB65suS6eK9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vlkgi1qio944rSnygvmMeZEtR4fzoQ7WDhhYEeWyd5s=;
	b=dXyJHRW8yGTzRK2y7rcRPQ5Fcd+jXEMV9JRecPIvHGyDdiXAUnZJSd1mTQZagFCNgQf3
	 xCQzbsKJQ9pGLAjAleoMWdygdsdXP/quoTHiApEdkOXoHFYGqWxXpkQYnGqxWJI9a8IlG
	 QWM14UYvtrkUj5DUeZTWzhn+iX+aWrjOr6BCFFOhWpRu/WzD4FEbbf9MJ91zZu4+jWuQF
	 MsiRq3ikYmkrOt120sazcb4pGmpQoiHpsraVSYiqQnmQ1H9xOOhijgcU3ciaKBmeaX2gK
	 ez+YwunuHwTpwXDoUrEtPRjGK8+5rEdDKfNKsDPZXpZSH2RpM31V65T0S9ze/DMprQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOx74BmX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB54606A32A;
	Wed, 18 Nov 2026 20:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOx74BmX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1571F000C4;
	Wed, 18 Nov 2026 20:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033501;
	bh=vlkgi1qio944rSnygvmMeZEtR4fzoQ7WDhhYEeWyd5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOx74BmX+/KOOScpe2GDBWAf/E0N5E2lYsw0XLpuHKE5xSlAadq5FtWM0dMDkFZ9Z
	 Z1JlQqAoyftAq/7ygGJK7GgPpQVzo1ktVmTSa5RlrVUcr3epitoA6AYHqWqL7O7YWV
	 WeHFe2wKHr+9YzUx0bWufC31VntluhTbHGOmo5KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0038/3318] spi: bcm-qspi: return error from failed controller suspend
Date: Wed, 18 Nov 2026 15:11:00 +0100
Message-ID: <20261118150314.984761153@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 44d09ef0ba690ac46d17eb05c12a47a5dd75e231 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm_qspi_suspend() ignored that error, disabled the
controller clock, uninitialized the hardware, and returned success.

Return the suspend error before tearing down the clock and hardware
state.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>
Link: https://patch.msgid.link/tencent_21BF5F9512F56D45FD9018BAF14ED2805808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 0407b91183caa..cb1809a5bdb3d 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1694,13 +1694,17 @@ EXPORT_SYMBOL_GPL(bcm_qspi_remove);
 static int __maybe_unused bcm_qspi_suspend(struct device *dev)
 {
 	struct bcm_qspi *qspi = dev_get_drvdata(dev);
+	int ret;
 
 	/* store the override strap value */
 	if (!bcm_qspi_bspi_ver_three(qspi))
 		qspi->s3_strap_override_ctrl =
 			bcm_qspi_read(qspi, BSPI, BSPI_STRAP_OVERRIDE_CTRL);
 
-	spi_controller_suspend(qspi->host);
+	ret = spi_controller_suspend(qspi->host);
+	if (ret)
+		return ret;
+
 	clk_disable_unprepare(qspi->clk);
 	bcm_qspi_hw_uninit(qspi);
 
-- 
2.53.0



