Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033508;
	b=a+NIjD5txqMchL8ZRuveQyYABfjCkS/R+Ve1xWJVdwG7m9Uf25gjqGUPKk+ixNdWznoA
	 WTR4Bdag+GbR8glLWVStT1JpVU3KRFBdUV5MHD8qwnBH6FT8EqBhzAn4aww2q7wbzLgir
	 j8fG+yr2RzoXcxgq/xBInaCWla7mQmJijeBqIQnsxHBjs8qFNKC6nadgfWP+FqATTYQwD
	 U6hZFQ7G/HnRVZAltqXoaEcDAr5We1JnjJb4HCT77Im7ueA5MKKydNTj0WamjARCKT+aU
	 4l7T+K7lXCGtYgaQ31KHFwjpQOt9sixYKHvuEQDPkM3dohY2q6k0IoXBqhtwGgxC6Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cSDBixnavGt35aImNubEbLF+iO0ge3G8jBF5kWeoOhI=;
	b=wJB5JD2VtGI5d0JSlRiWA/8/WyL9BIsiXxAYZ8udHj1tSvMBkak9AgtZLXxwMXo+xMao
	 AbEJiyw3j+VR5okezqB/ES/Xxg3MbiH1XofZtWOlPSReT5+8VNnrE5CiDIGpDB3eEdiqY
	 POf1OJdIL2uhJ1M2xjZqszttSLxlEhl9QpAOWHrheq0furyKQnQDAfFEhDuq1dvoG+jo8
	 ydCw4V5Ed/IagkQ3b/6tU4yld4kpD88zHOzs75SwNLcpiy/pXzvT7mDwWxKcKlHoxXfMs
	 wE29vbKgRdYng6odZMUUhgetwftsgdgpAWihopYSoSVusXTA65Z1qOy+SB4sxlqQsSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IF2LG0Zp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC239606A320;
	Wed, 18 Nov 2026 20:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IF2LG0Zp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243051F000C4;
	Wed, 18 Nov 2026 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033507;
	bh=cSDBixnavGt35aImNubEbLF+iO0ge3G8jBF5kWeoOhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IF2LG0ZpTe2GpXH8p/aOKsy7XVVglo4G5YEjhar4qby0UjYFc5Yt136OD5/VL7qDq
	 2ngVHsO/4aAPMz5oSu6KVidf2dQ4YHEkqgftIfWHJIffS+E+UjXNC/+gZXDjkmnpFB
	 10YSTWrp/NPofnnwQRHhx2EU/vap4he3pTEgBrFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	William Zhang <william.zhang@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0040/3318] spi: bcm63xx-hsspi: return error from failed controller suspend
Date: Wed, 18 Nov 2026 15:11:02 +0100
Message-ID: <20261118150315.062058269@linuxfoundation.org>
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

[ Upstream commit 3b5414d76a0381db77b9694537254af7acfa187a ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_hsspi_suspend() ignored that error, disabled the
PLL and core clocks, and returned success.

Return the suspend error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Acked-by: William Zhang <william.zhang@broadcom.com>
Link: https://patch.msgid.link/tencent_B5A06807924A77C8690730EBF7A052AABE05@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index f5a8edef7b7df..87ec22627c6d6 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -895,8 +895,12 @@ static int bcm63xx_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_hsspi *bs = spi_controller_get_devdata(host);
+	int ret;
+
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
-	spi_controller_suspend(host);
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0



