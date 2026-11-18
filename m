Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023564;
	b=iyVpJLRpQPIWV23Qt5JXvVlihrWev3I/BWV5Tqt7vRnYNYtvBUh6wbJSG5qCNJdDe9rQ
	 E9QOS3kw/H2BCrGjFwBunWjNYVtKdv4dr7Rbte87lEK6yTlN6zaJp/+7yrWlkSoGN2pC6
	 D4QmLKma9ONGYoaq2WiaWs8t6tgMzl6tmZKf4s2V5toOMYfRfmpiLLh8ehGNNF3otMj33
	 NUSbhFKVWMyqS2oe22bkLi5GbK9K4PKAnhAcVijrr1UMwN3DcDKwZ4P545eZjBKwFMy0L
	 NnuzjGD5FR1zh3DSn/KhpZJ01yFW0G93OwmRXzMYXQfrwpi1dZDi6Tda8bYTdKH9uSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YrJLR5ulKaHmV5kCMDSUAjXAlyOnUF5HGU3duOb61B4=;
	b=3IDdZ3q9Fd++9rIzFCGTg2Tp29V3GukJXrgtYFXhpwbLrQduWmBbFZwb+OgdpgaTIwuj
	 PRzKzZuvTSgOCsx611fMaOKa1K/7uuBs2qWjaNIRM/GQn1Yli+3U0JzBhzlDzsmPaIDDT
	 H6agYO98X+WJ5SQrozlGNwmaRmmgbwV7dHusr/TvbFbN0c/FZ4cwhMUpIOLKxHoqyWoy6
	 86uIyzD+oYDtvs6SU5KVA3CK9oerg/iWW0UmGTmQJTj7Q8TgIlevJTAaMoDTy2ptMjcdb
	 hRbF9XRmhPmR+QKmzwkc91v0ke5J7C8VMm62PPmIMDmEojY7aMx9wr8mXOBWpLw7gEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTYqhz4r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E0F606A32F;
	Wed, 18 Nov 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTYqhz4r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261CD1F000C6;
	Wed, 18 Nov 2026 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023564;
	bh=YrJLR5ulKaHmV5kCMDSUAjXAlyOnUF5HGU3duOb61B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTYqhz4rZZvYCmz4F0IEyQXZXnT8rZ4aWstKfDXfBL0amxobOUxg9/DvJFM3caApP
	 /95Qd31tj2zzeAVYqIJOZd6UbSnJ/thKvMIhFopUR6DlerRG9SBZGhD78yulODMOYb
	 OPJgSZsKPmWw4/5+fFukX3ERoA4b7MtZCUaVNrVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0413/2151] clk: mediatek: reset: Fix device registration kernel-doc
Date: Wed, 18 Nov 2026 15:35:48 +0100
Message-ID: <20261118150137.102902935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8d5fa37307ac1f0612cf17ac0ccabcc258cc1526 ]

The comment for mtk_register_reset_controller_with_dev() names the
older helper and documents np rather than dev. The new helper takes
a struct device and obtains its device node internally.

Use the actual function and parameter names and clarify that failures
return negative error codes.

Fixes: 761bc64003e3 ("clk: mediatek: reset: Add new register reset function with device")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/reset.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/reset.h b/drivers/clk/mediatek/reset.h
index 562ffd290a224..b09cdcab0c4ba 100644
--- a/drivers/clk/mediatek/reset.h
+++ b/drivers/clk/mediatek/reset.h
@@ -60,11 +60,11 @@ struct mtk_clk_rst_data {
 };
 
 /**
- * mtk_register_reset_controller - Register mediatek clock reset controller with device
- * @np: Pointer to device.
+ * mtk_register_reset_controller_with_dev - Register a MediaTek reset controller
+ * @dev: Device used to manage the reset controller resources.
  * @desc: Constant pointer to description of clock reset.
  *
- * Return: 0 on success and errorno otherwise.
+ * Return: 0 on success, negative errno otherwise.
  */
 int mtk_register_reset_controller_with_dev(struct device *dev,
 					   const struct mtk_clk_rst_desc *desc);
-- 
2.53.0



