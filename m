Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044847;
	b=HMC0sk8PtM0tZJ3kZcbcsr7faOQrGhATbzPgSsU/C/voQxe/i71YGrPu562+iYigXfE0
	 n4VVRxXQfHxnNDgh+1h2Q3NtkH4h7p/W3sZXDVVwRjfyxZtbc99okelqvMw+/Q2bPhrNw
	 2T0KJlZLnft6JwlHSjKQzVe7J12gAw4ir+xeqRWvnPPZ+AaQ1dhOhnifwqQmePIdJLxh9
	 E8MXWmUHWrQzXknZmyqPwhv/aJBWAaVZb+vvqu6HYHGRkbNB5CHgcgO0EE7y20LEaVWWs
	 Xupndf2kQP1JyDCKR8i1v2nuKnAPil9VvA48fQnOHzBAltA/szKLGTOugugeOovIx7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mp+Ju3xditM1kBZq1PQoo1ACIdd9u3tpmGscaDzGgZg=;
	b=1OfUsihsyydNDds1L3X/dVtRMUqmhp5wR2kDFzVycWSNF4JZ5VziIxXc4WjIFCzFCSfX
	 FKu9PrgCDKQbeTSBjcQRt5i+yFLziK7zG1yJpMXn/fjSj5+Y9qT+Da9ZlBFxyFiFDIvSJ
	 S5FFziTH6tBTHeeMm63F15JFTQxcSfnkuyDwW6SYHljgOjnlof0H5eOIANZ7CtI4c2M0T
	 +p39QUJ+1ziRzhGo4f4wUv/gyDwQhmkoBHPzmI6W7D9YgynAOksXwVp1Pk7FFweXa8LZF
	 8OgTiHeTLTci+DGIasl808Qkjil7gwtEruU68NbpRJ++u8XHIKRh7S2hQEY6OKEU0aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M1hZ0UH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A49606A9D9;
	Wed, 18 Nov 2026 23:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M1hZ0UH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1621F000C4;
	Wed, 18 Nov 2026 23:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044846;
	bh=Mp+Ju3xditM1kBZq1PQoo1ACIdd9u3tpmGscaDzGgZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1M1hZ0UHj2rliGpWWe9/9x4NYOxhkK0jxSxhbdVpc3Pu0roGEC5cRNoGKaHxViZQx
	 sqDFMuk/kPY7VoImoXOs8VQUrUoNsuihjbcqWyDOOXrcMgHMFQP3yoeVUTPMuOX925
	 SfnwrYtzr8N6F9q4yBvFKY1loIYGXubSxH6wOtdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0712/2857] media: meson-ir-tx: Ensure clock is disabled on unbind
Date: Wed, 18 Nov 2026 15:29:06 +0100
Message-ID: <20261118150227.184445511@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 1517326fcc9dfdb9acb24f42472366ac1b4b8237 ]

clk_prepare_enable() needs a call to clk_disable_unprepare() on
driver unbind. Make it devm managed.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index abdb62b16e980..5808f65aa8353 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -288,11 +288,12 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 	if (!np)
 		return -ENODEV;
 
-	clock = devm_clk_get(ir->dev, "xtal");
-	if (IS_ERR(clock) || clk_prepare_enable(clock))
+	*clk_nr = IRB_MOD_XTAL3_CLK;
+
+	clock = devm_clk_get_enabled(ir->dev, "xtal");
+	if (IS_ERR(clock))
 		return -ENODEV;
 
-	*clk_nr = IRB_MOD_XTAL3_CLK;
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
 	if (ir->clk_rate < IRB_MOD_1US_CLK_RATE) {
-- 
2.53.0



