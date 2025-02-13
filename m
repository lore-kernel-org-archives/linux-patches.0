Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB1226B080;
	Thu, 13 Feb 2025 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458156; cv=none; b=CLipA51Ex4VU5jOqTOfnFIhoTzdhBbe7+csnUvVoIID9jHB8UNI8OPGPAzvmMQsIDFJ0u3AdyPLg3lS+wqeUCirxPOgGWTuR1Dbp/ujGmwLanomKaGeL9uO+1bIhDQQBCbR9+Fu+7kDaG2sAd0Nap492sxgazOUVFH0Mw3dSosg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458156; c=relaxed/simple;
	bh=SnJW2/OoWLPXFlWY5uTI1ttnetqQH4pGGMXhnHi8d4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tloYiT8RFj1yZHYSv9ARNmPg431zJA8SPqVeqL8gMUaKfxvZoQd3LrGJB2dCLZGoMdljXZV1nqTn4ceO67CE/m3IgBg+Ry65TvnbKy76Wme+XJLpD/cnOMHqOfFBcYLr5Ux7I+0U+2SLoB5W8dmGMUJtzbTvd7aP4/I4aJeb7Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nkd9Lifa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nkd9Lifa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7551C4CED1;
	Thu, 13 Feb 2025 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458156;
	bh=SnJW2/OoWLPXFlWY5uTI1ttnetqQH4pGGMXhnHi8d4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nkd9Lifa8pf+1GZV6IWma3AZCH3lRj1flEzXT5zmSWo6Q5HBh+Y+LwrXL1REArXw6
	 h+sglEp5Giuh/GlFIM2tDfmaw9Id94Aqu4OAhUUzfY3/z0ydzj0G90VKfvq2UK4bWd
	 goCcQLi3iX1Kx9bnxivvVYeHtgP9id3njgx9G6/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.12 318/422] soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove
Date: Thu, 13 Feb 2025 15:27:47 +0100
Message-ID: <20250213142448.821121689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit c9c0036c1990da8d2dd33563e327e05a775fcf10 upstream.

Driver removal should fully clean up - unmap the memory.

Fixes: 0890beb22618 ("soc: mediatek: add mt6779 devapc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250104142012.115974-2-krzysztof.kozlowski@linaro.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mtk-devapc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -305,6 +305,7 @@ static void mtk_devapc_remove(struct pla
 	struct mtk_devapc_context *ctx = platform_get_drvdata(pdev);
 
 	stop_devapc(ctx);
+	iounmap(ctx->infra_base);
 }
 
 static struct platform_driver mtk_devapc_driver = {


