Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829394;
	b=tXbNS/0wBrJe1r3tw1bfdRaTSfehpZ/JO9kchJRUIwMZrp0++CeJ5LICZ0B2pM5VeoK6
	 27fJTaHHjZnkdJMaMyxKMYSoK3DgVBoS2YObLsd7IfSRej2c1du91Fdy3kX+95MwEBOLW
	 +GRj0V+1kbNOTCQoUj7nGujmKqG6rY3gy6P7ulOXbu4Oy94WvGlzcdHNxNJSmSd86cqIL
	 M+cbUkFWhgNeZs69dpy7BhML8XmSZN2NwhWII7sOl/mhPu8XbZIpe3PHlG//jhazL7S5i
	 saiBPK5oIg2LA0Z0FbzJ5FboOghrIta07aDttWa/joSwVZ9TEml+fdv7rVg1Otr/7Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lOE3ftrFtL7OxQtM0iyv0u7Ji4p4ohQQ6YtVOq0Aub0=;
	b=1Rqll/mSbSaYqYHO86/1t9Z76wMw7QlWgJT3WywM4x+pEm444LqmdzjekY/U4/uvyyga
	 WeF2gM1XgERm1gxYmCC5+ScAnG8QzYxtAKkX72S6f35jyFwTRCGdqpSUzRgrDqZ9V+M7D
	 1dAKIPi6Zes2CQMAakrgj8sVHjUhte2XIABo8lRY3jSwEDljum0zlCcHOvdvEHFB/Mir6
	 um1esoidpI/M5hjQybXe45+v4A0O3n0Tt26W3NJf0+2NmWgF63uJhpu96cJB0ycltYdlr
	 1ae8or8sChGRMxfcAQXM6ROsW1lqEQ6UfHXGE1gSZcHAmmDQHrNlmcO6AY/wz9rcOcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kAcTbNw/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8933606A865;
	Wed,  4 Nov 2026 21:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAcTbNw/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589791F000C1;
	Wed,  4 Nov 2026 21:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829393;
	bh=lOE3ftrFtL7OxQtM0iyv0u7Ji4p4ohQQ6YtVOq0Aub0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAcTbNw/98r8XXX5DhVRcCVHoGPhFdBF787kRG9fgWtOK6K6OKczQ6mOPqM/l+JHC
	 uTPpNTOMnV9LgqGXPqaJAa9CD8RmHnyfvr0frEdOLjV3F5KVqQmiXXx1vTxR1LWNTK
	 ql2EuGdTTejP6fUX2/qNGmoy2OdVnwBMtwU9u4Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0049/1005] spi: bcm-qspi: return error from failed controller suspend
Date: Wed,  4 Nov 2026 15:56:22 -0500
Message-ID: <20261104211044.965895138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index cfdaa5eaec76d..ae5545be0a45c 100644
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



