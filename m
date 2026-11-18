Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042465;
	b=3UwcmNRYxQQXzcYsF6jhSW359mrWWCbQ2VY1/rudznev2EXH5Uy3hRGS6xxRYI1FF2Lp
	 9h81wqnWqNq4ExxcjkzA+eHJvnBEIjeMTkb3K+wPsRlX2aa7HFDEkUcpYSmaOlgdHwp4J
	 oN+f+3cruoDB2c8+jp+1IXUL39ref+cWgbvf54cU3UK3/64Uor4Kd8LfKbHEPhymh93YZ
	 DiRdS2Nrb2bzPOVxJohZ5caVnEssjvAjDR2I0wq/kX0hXE9gR/D0DezBXREH3w/0HR2kA
	 wE93OqbXo0cSsKi/lfYwY6QrJ0nejIZ04GsWtuENS/YIpw0LXhO6Xhl7M93WFVZ0gaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j+DUPEI3R8xbfe5X1JMzi8KEmGhjySl5xKmKH9cd+zE=;
	b=tQ0/5e3nECy2gbWP5nXknovdNAHmlsY28oz0QO9OMfjDdizzc104c9x3fowrCiSjfuEh
	 p8vwOFgP5vV+XlJ4R1XQc+xCXLjzUcs+WElG02F9xB2zX6oy+suP3qcmXwJ58MjVLFHwN
	 kR7GeTJl5+45LshPUpQE9Ro23I9jfYQpFmz5B8yVAcbN3TJPCGhfktnPCRNGbxi/W+RXk
	 2La2ej+9bES7vEIoG5IkB4fFZs7Pdxnbb4UYG2qsIe799jKP/sl28OYtUiyPGGXW+bBbE
	 ticZPQWm8pRjs8Rjr7AljpkuTvk5HbSfg9uz9EnP42AZ2NoftORZ4Ko6Rdxi//mBiQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztvVBA1q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80C5606A31C;
	Wed, 18 Nov 2026 22:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztvVBA1q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4181F000C4;
	Wed, 18 Nov 2026 22:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042465;
	bh=j+DUPEI3R8xbfe5X1JMzi8KEmGhjySl5xKmKH9cd+zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztvVBA1qunBQyCDRaOzizl/HyQtM8K0dwWJYP0h9kFc5Dm8zJdtVLPZqhJUMHurKC
	 8Dl1twdVoBBGST6+hv3eKe5F3TWQrHLvcTKlP1ATQxMI1JXmQ8Dd/EsUOQE/tHPuNX
	 G+1qQw8nXmyxK7HHuYyXB0OlsyENHAuhjWM9K43M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3180/3318] clk: lmk04832: Handle reset GPIO lookup errors
Date: Wed, 18 Nov 2026 16:03:22 +0100
Message-ID: <20261118150455.217990985@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5c7c0cbf81bba69695efa12e451f0f2ecd4b92a5 ]

devm_gpiod_get_optional() may return -EPROBE_DEFER or other errors,
but lmk04832_probe() currently ignores them.

Check the return value and propagate errors from the reset GPIO lookup.

Fixes: 3bc61cfd6f4a ("clk: add support for the lmk04832")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261006110501.57051-1-phucduc.bui@gmail.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-lmk04832.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk-lmk04832.c b/drivers/clk/clk-lmk04832.c
index 99b271c1278a9..fe7618563ae5d 100644
--- a/drivers/clk/clk-lmk04832.c
+++ b/drivers/clk/clk-lmk04832.c
@@ -1417,6 +1417,9 @@ static int lmk04832_probe(struct spi_device *spi)
 
 	lmk->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
 						  GPIOD_OUT_LOW);
+	if (IS_ERR(lmk->reset_gpio))
+		return dev_err_probe(lmk->dev, PTR_ERR(lmk->reset_gpio),
+				     "failed to get reset GPIO\n");
 
 	lmk->dclk = devm_kcalloc(lmk->dev, info->num_channels >> 1,
 				 sizeof(struct lmk_dclk), GFP_KERNEL);
-- 
2.53.0



