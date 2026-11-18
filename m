Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050534;
	b=4N2VxXhErcrxKpPWYfp+l+C6q97jv+mSKVffajUIG3+53hSrwAJsVH//U2ku1VvCouo9
	 iXxytf9+D2NY60hEZec6gYmiwU0AjUsLNAC33MzI4759td6XWMlB1toSWgsYomgLSImoo
	 apoJPTCgFvdWN35f1zQvkP2Bjnpx62b6/7FmcwWX7cvkG5FjN/6/0rwqSraiFqamskMoo
	 Txd7oirFmhsgrOKI8oWfxDIV+Ycvz2WfolOGcNnt6TaDN/2jPdgBZX06TDduDjn1bj2Oo
	 OF7xdblmfH9x1lASl69sy0LcB5tPYHGCebwsDIQVSTX01dBk9kbZXUaiaHh6F/n4J1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6groedCyM8HSGG48bzhXiWq5IAnJ3fCMJitm8kZX6vI=;
	b=ZOsTenSudu5X98JgtqEmGwNG3dF4TutNo+nxevvQo0pE8MIzoCG04le+vXVa/m06HvQT
	 vxKw8A9WVg4+XuDr4FZZX/WL7BJS9cMc3rv+rXADtebU9lIgYgKQIevw1vvzYlQysFuie
	 DCCQkYXdw6cH4AZIQO1Shh+A8voeCXoTpGUhlpCnTvXPRnwp9IWJCYlUAH2PM0MUcirJk
	 7hY31sttrCbdHqxl/fbylpjb1UOKoteTmf5p90sOKRc0xF0qRurd+LtOg/hUNPf+vPjKs
	 FOCEY4kFxhZlVVsQqDdxpOu1RzSXuUVlTC0SdLNu4/t7Y01ScVuZa82p4Jl2deBq2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFqQawde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF9A606A320;
	Thu, 19 Nov 2026 01:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFqQawde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0181D1F000C4;
	Thu, 19 Nov 2026 01:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050534;
	bh=6groedCyM8HSGG48bzhXiWq5IAnJ3fCMJitm8kZX6vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFqQawdeLyFAIPqk++iILJpj5POlowQ8uEMV2zaOrfGKiMDhB1R44bbVoNn1LZzSV
	 l6/t7c2lbh4Sa7XOAJBR0EyDseHO2CxgA2oSXItKdw/N5wE1vK6JeN/WmZVQBN9tkW
	 JZrWY8j3EeXlCP04a7y0cIsHq28T3gAPi2z5lwQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2741/2857] clk: lmk04832: Handle reset GPIO lookup errors
Date: Wed, 18 Nov 2026 16:02:55 +0100
Message-ID: <20261118150340.308601675@linuxfoundation.org>
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
index f416f8bc28987..8828973c366c3 100644
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



