Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060594;
	b=HVzF+YM2Sq+H+xLEoRTOieArf2m+LpRrtwY0qIltG0GlekfUrZScVRgBov7EBmNmB85L
	 UbSORn9qxh2oki7b/NyFVq8Hzlgo1nPWRngJOTUqwzGj59eilXu4JbQzGbOrlEe+rnSci
	 wK8uJwDQ03Be5jTwRh56OOpAdGl8u3gMSJ2JhVLoHPN6BYteGJhX7u3r18mkHmbFfuayB
	 uD3zjUNYsu87VUmZrxcA6C+oWUFVYd2oDcJZV1+027Yn3S1pTPXJIayic55kSIrgv4VJH
	 OQMeDvpgYHiJrEZ6L1gCBItfeKsS8VywDHLwx2n8PejrITDs8Ycafbn2elDyU2pTk9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCql7eKpER7k7L7jtBXKadG0myfuA8vsB1LTMb1muAo=;
	b=u4VRC3S/z94J61smJ/FgOx9b1+WZs1xfMVYM0qdw+pcMqCiRkyfhBzzmpaEosN4ACrL4
	 Iuc7Vrjhsi6bdEEMfQG96sUATaL7eLMDSRXAadvBNAHUUXQwMu/nl24jgXA+1W0WOyoPx
	 9NZSb68+tby1eWN/0Kzv7UxF8ZRe87pZEa/SM5u2tQpHVIfopRnkqCUlYdEOSDAbOBI+8
	 54ZYCydWHdUHQJK4kQ6HT+uWLLpOGgOvT/QVD/ffA30QTjAR6ic+OtIRcYigTn4Qx7IIS
	 YpFVsKd3+xsANaDhKhRNcOJEc6tb28nu3o+9at7GXVwrbcyfoF1kRgXarDSgiLR82YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WldmQTJ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5012606A330;
	Sat,  7 Nov 2026 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WldmQTJ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F31F0089F;
	Sat,  7 Nov 2026 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060593;
	bh=jCql7eKpER7k7L7jtBXKadG0myfuA8vsB1LTMb1muAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WldmQTJ85TGeq7zJaS8lIG6To3Lan57H189zbahlFNURrE9DxaNc4uh6PrjXS2IsF
	 bnsapMTpVAD7gH/nOQ7mr13m2B3TIesKVvAi4eSqWCqQ1kX0YWQkTJJRAc7MyAcJhF
	 uAOHwubJS0KgUTAcU1oBmMV6cvk7bxEtNHjVIl0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0050/1536] spi: bcmbca-hsspi: return error from failed controller suspend
Date: Sat,  7 Nov 2026 08:34:26 -0500
Message-ID: <20261107134959.064691119@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit faa878d4805ca375738294bc52eae310eb287b16 ]

spi_controller_suspend() can fail if pending transfers cannot stop.
bcmbca_hsspi_suspend() ignored the error and still disabled the
PLL and core clocks.

Return the error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_54F5634545908FBA724E758054BF03953808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcmbca-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcmbca-hsspi.c b/drivers/spi/spi-bcmbca-hsspi.c
index c666172f2b05c..7bf50dd9a7974 100644
--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -586,8 +586,12 @@ static int bcmbca_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
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



