Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056950;
	b=JGDx634tP9K5uRHTl/GOn+MLHz8vHiC1GbkvF3pORjwfX8kG7RAuRQ1q1S0eEQofGpRe
	 AWt06RKK666s8PqVKXKruBnG3gC3DvNjzLboosuS62iIwQGcJT2jUoyYUgSLOf5dyC382
	 uu2fbutm831/g1UgR79lLqUI6D6eSopxsosaZCT38fwDBMZg96DO634l/MbTIMjQTqdf8
	 7kwVUtzaEAVytTb/h1M5Yy/S1xuhu1TuR6N4K8deVL73qbbDcR8eDQnalYv8TarR4DPMn
	 TcpJuVyykU7uFuJOvDlTa4P3hg68zgz6zFE0m3Pps2t7r8Icdn1wtAaX+9Qh2GZQgxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7PQjVmGrhPjaPvjMrlURL9FksHgAwgBniPJrnVPczU=;
	b=oxR6zu5xlXoPeddi9fuk7E9B2xzQULFqsFPhS9uHJcHYDy8UK2raBrCGgU/In6QcMbKw
	 82MZC/pR533F3ibYDFimb2XSfNab1zhoeEQjy3rFQFkIplk2DYJ0j34E9GefBKf6Rza8R
	 QMpfrEeyvtiScUkhSyEO5cnGFy5UqAB9zhYy9C5K9+tO31USqYHtvl8Wuf4l45rfpIgny
	 y0SLMQQJQ7WRUPXoz+mRN5WZSx/Rqwvdc8EXhcIyxRAsP5l82olUCvy3vXwSNz/ZG6FJM
	 BTz5AXB/QBYSMci9PQrGkPPtMkWSbWGRvW9H2AA/0rAHdsgfvvxAbry5ZWfzyWbPQ7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvMnEBvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17C0606A325;
	Thu, 19 Nov 2026 02:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvMnEBvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAEE1F000C4;
	Thu, 19 Nov 2026 02:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056949;
	bh=h7PQjVmGrhPjaPvjMrlURL9FksHgAwgBniPJrnVPczU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvMnEBvTHNqYplz4PHXbzBMDd/uJqK5WWUZk74zCFFW9rB4XDRxntdrrZRxFk1QYR
	 fzBkZnGw40sE7vdppzer8cRNpyFUZ2JGo6DLPUnIL+dBOE7F40mwEp6YC1tS6Wx0dS
	 ZYVNLIJnvA6siqYQgCoTs575i/oDNVI1T01tgq0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2129/2214] clk: lmk04832: Handle reset GPIO lookup errors
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150135.731532290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 8f02c0b880005..cc539eeabbce8 100644
--- a/drivers/clk/clk-lmk04832.c
+++ b/drivers/clk/clk-lmk04832.c
@@ -1404,6 +1404,9 @@ static int lmk04832_probe(struct spi_device *spi)
 
 	lmk->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
 						  GPIOD_OUT_LOW);
+	if (IS_ERR(lmk->reset_gpio))
+		return dev_err_probe(lmk->dev, PTR_ERR(lmk->reset_gpio),
+				     "failed to get reset GPIO\n");
 
 	lmk->dclk = devm_kcalloc(lmk->dev, info->num_channels >> 1,
 				 sizeof(struct lmk_dclk), GFP_KERNEL);
-- 
2.53.0



