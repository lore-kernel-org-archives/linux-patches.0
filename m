Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210587;
	b=T8Kpsf1UWzzdHpULH+ztDK36qtdz+DM/44POcRGqZ/sG3eEg1XHSZ3AAwOCaZhq3pfMZ
	 xLYnCRLSXsQgxxSNh/T6gyIZMTcp+20m+4kwHZ7jwiF7oBipoSul0xXQWPX95iHfI49y3
	 1l+2o0Qk+imXQe931jxhJvW8rusHL8CqlM5SULcC18+gV0C8TuVTTRzw03m/evjhIhA1E
	 M/nmyzogoDeqKifEzTzXYGPC8IqN7+fh7Q4oSfV9Qg8N8Q7tQTpuMp53gRu1QaX5wAeKH
	 6CCTmsIy/P9PHcnxSBLDXZyitfJN/7uuMxz8wiFy4a7zEFl7CwGOmyYJ31FdH6Br3hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QHaazYS+RVsl8W/MKbQnTiCyzbH3guXMqIa+WDJ3WyA=;
	b=DUsB1UcvOpB+JbP++KLnYSA/XnERic9ujoubEy9m5ZiPTzhbkOzr8cwPgitpItuhF2i8
	 aMvEk2l3PfHBGNGCVaLTvcNy9rkFLDDd5r5fPeQAahTS3+H/KkYgfu29MnVXtkqqugkOp
	 CNNYyt0VXlec+I73OtkS0j1VZK4HOlRzM1yH6/b7cn8HWVeVpy9PdbOMNPLoon57793JN
	 hizb3BI9E1bGLPi0eHKkpQWKzWIuenojbmtuQpHEXZ6uS19IrgL5glTxj8Fex3yM6OvHz
	 1s3Qdr8mDouHADbdUGqV3gOIQ+Of8ltfpD2HW1zj+BEGLUB5kNd9yK57BTFv/LKLjkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VohDI67s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23C8606A31C;
	Wed, 28 Oct 2026 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VohDI67s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD2F1F01825;
	Wed, 28 Oct 2026 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210586;
	bh=QHaazYS+RVsl8W/MKbQnTiCyzbH3guXMqIa+WDJ3WyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VohDI67sttqAdyqsJ6QuwqsvfTU7Cw/OekuKKx2U1mHb5ugNzhBZoGEnHHLd+nnOW
	 SqhqECR8LGmnJcJ6CP3YaeclhtSrdz26jfBaceLgYaV2cxzDGgUn+1yH0UNI37Rpob
	 9jcqYJ7yTRdhhnJWgmbXO2lmPTyy3JHUm0TCyu70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/571] spi: bcm63xx: disable clock on resume failure
Date: Wed, 28 Oct 2026 17:53:43 +0100
Message-ID: <20261028170009.830123172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 2b62c2c134fa32d9d3a9e7323c8ac74518eeb4ac ]

bcm63xx_spi_resume() enables the controller clock before restarting the
SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves the clock enabled. Propagate the error and disable the clock
before returning.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260804071831.860784-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
[ changed spi_controller_resume(host) to spi_master_resume(master) to match the older API and variable name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index e57e1f75cd9f9..1dc579d9e3c4c 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -669,7 +669,11 @@ static int bcm63xx_spi_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	spi_master_resume(master);
+	ret = spi_master_resume(master);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



