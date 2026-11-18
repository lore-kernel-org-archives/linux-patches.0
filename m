Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055001;
	b=GjG9HUIlGnWiZh1/I4UktBtrk3+kcrMmrvW8TLHg1c4NQBgiFaIaBUGznHZDQpBTBkuh
	 bO61lqqXGsOcz3Vs7UJsZP8cdy53SAVqmf7x6pyoEMzmsuTJ4eL7f8y8qWUGIR1lyF5ad
	 2BFIyoP/UP7oUXD7nzkle/3xstTSGpNjAwIJQe41R43Nx4x6waCXslqnW+iaqUTY4R7p3
	 8E4obD0RWCWgLtwZ0yG7qxqw9IV6/93RrfLWAVtrWERXMI77miVQX/JnN4FsIVt4hwzg7
	 um44ot0Hy00xC6nhWcwm0L06Fb6/Ot9RO8sCPQtC+6dWtYzUeOLLIy+TGN/OuW8MJVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DgsqgvJJ76gabp0r9ffpLKxya0H25pX6yWHI4sS3XkA=;
	b=RfZyC0F05DrhDI6qvDWFB/W0jCMOJ6qXt381i1RGy8wzRyFkWg+lezJF8T9yguuKUQKR
	 g2eAzod6TQEsWB/UCrlPB2OSTzjOzr5ee55pPnAHm3XlTB7jQyomWvvWgbXk0ncUsFi78
	 6xkq5TrhugAyCpRMw1NIdSIuSVoduSHBtig9b5hy1c/0Q6mwf0yREqafqXL7kSvZHJnzO
	 qEEwENWKt90VrWHo3JQGtl8yOZIkiSM6ORVaFEMOhdM3wIls/G6Ep4xw0L9EIiRCvfNWW
	 sI6fXYyFUw+fqqg6KmpAm+qO51voSr3ilBQ4r+HBgziYoCFAojaF8DbLJMNooWfHD3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qcy8uVd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06FC606A32C;
	Thu, 19 Nov 2026 02:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qcy8uVd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4379C1F000C7;
	Thu, 19 Nov 2026 02:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055000;
	bh=DgsqgvJJ76gabp0r9ffpLKxya0H25pX6yWHI4sS3XkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qcy8uVd8Vk4a/d9/wwGlSBXuKp+xfHL4mCtpSJBNdFYgl49uMYjyjO6geAfAE2jJZ
	 E4CBZRPQr4Mq1dFiqfOvbzQ54b0dSyw0DXuclmuXMtWIUDwMLweUOjDKIuwtrnsegE
	 82yQbuPg4Oypkn9QxYvLjF0LwRPoYkIzWh929c2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1476/2214] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:52:32 +0100
Message-ID: <20261118150110.212599197@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit cce46902ea9fcd585cd200fffa3166f63bc571f1 ]

Check the return values of clk_prepare_enable() for fout_bpll and
mout_bpll.

If enabling fout_bpll fails, propagate the error. If enabling mout_bpll
fails, disable fout_bpll before returning. This keeps the clock enable
count balanced on probe error paths.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/tencent_B0189529F550458590E3BA614EAB800FBF08@qq.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index c491cd549644f..85c05c9c75332 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1304,8 +1304,15 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
 	if (ret)
 		return ret;
 
-	clk_prepare_enable(dmc->fout_bpll);
-	clk_prepare_enable(dmc->mout_bpll);
+	ret = clk_prepare_enable(dmc->fout_bpll);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(dmc->mout_bpll);
+	if (ret) {
+		clk_disable_unprepare(dmc->fout_bpll);
+		return ret;
+	}
 
 	/*
 	 * Some bootloaders do not set clock routes correctly.
-- 
2.53.0



