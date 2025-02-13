Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010626B092;
	Thu, 13 Feb 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459747; cv=none; b=RAQpOkOK0gxg4JKb2H7bUXoo5dgAPFbWCgrI+4YRpW0SkEFHb5kf/Ofa73iggD8WlE43De0TmwnQjplpTVTIch4eA1xqm0I2z8wpUM7HVbdGETHqWr6txTs2ZVcCv7FVo7jwwwmFG6AOLOK2mtnjoewu33VIMkadDNuFH8AmLI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459747; c=relaxed/simple;
	bh=EGvv89ttgmMJsEhsd7cZ+MOvltNry3VejOIUAPVYG7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asjVwkI9JQVxBIQZ3xsFqh/rxxuKQ0Vtl9YCU4niYBu+cjs/WtbA9eobeFa33s4u+KyMiPSsuEuthMQaeiwaO7qUjJbOPeA80rsTd9LR8X/7r0u2lV+JxU1jllG+132TRAlbcmhFeceZc/0E8HZBlb/IwvfdRdFmbUaQV9NIG6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5Djj2oM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5Djj2oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9E0C4CED1;
	Thu, 13 Feb 2025 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459747;
	bh=EGvv89ttgmMJsEhsd7cZ+MOvltNry3VejOIUAPVYG7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5Djj2oMhz74ld9qxDR/hQwI9bt9YvgDfpZcHZFS/a36aUPQoju1t1e+KwMz6EHOf
	 LIDMU0NqYT9VsOrmIleQpc8aBZipTXnG4XJVBPGN3GUd3vqK/bYNfnGDA7MArBGxpt
	 iM12gjiJ9TgZ0VQ8BOaiX40lVaZDXgllEkMfWJyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.13 353/443] soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove
Date: Thu, 13 Feb 2025 15:28:38 +0100
Message-ID: <20250213142454.238370700@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


