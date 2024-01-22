Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368AF12FF86;
	Tue, 23 Jan 2024 00:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969047; cv=none; b=dY4ioB10VzDTwMxNQHtGGsBTOsuAiyf+1cFuMhPVs7JMK/8uBJyKsntt/bCMhmvyXmG8EUK45kInwrhvcds5KhB8BAoeXoRrGLGCxiTc9SKaBSmwY6muhHLt2hxO4+hPMOD51xN9iU/jovr8HseRokMwutN+zeSlnIKlcMwSbVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969047; c=relaxed/simple;
	bh=jlLQY90WY2pUoWhvivaSmfV9MhszRQs2S6lzmrfIFQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvUoKuc5J8VOa6T3/MHXGCvp4XKArjXRo5gs+PWkX6xji9VoIo/9Oora24hKBJdGn3Hc1z+POg9oqlPWqqKsgvb6iEtsafnyqYRqCUN4cz2hHNuusAZmcrtdgxBUkboldMAoCh0PYd9g6kufUAhbeOFrYckDo20gQpTd/WTm0+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0e7rzbO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0e7rzbO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9214CC43390;
	Tue, 23 Jan 2024 00:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969047;
	bh=jlLQY90WY2pUoWhvivaSmfV9MhszRQs2S6lzmrfIFQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0e7rzbO7cAraqCNqiRa3u41AnEm5YoA4cRh2KFbqs5I/lXQO3COgpj/8yJy2Chsks
	 ZQZNS6shbQYdujmV4IAfXCT5n6SV3UjGL4mr+jCDGj97dPj5i0RPxqbdoDEmUWL3nM
	 TpgBMCzYD6pBg1SzCUdar2BbyorP5ITJ66Og/GFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/194] serial: imx: Correct clock error message in function probe()
Date: Mon, 22 Jan 2024 15:58:29 -0800
Message-ID: <20240122235726.913522628@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit 3e189470cad27d41a3a9dc02649f965b7ed1c90f ]

Correct the clock error message by changing the clock name.

Fixes: 1e512d45332b ("serial: imx: add error messages when .probe fails")
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231224093209.2612-1-cniedermaier@dh-electronics.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3f5878e367c7..80cb72350cea 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2277,7 +2277,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	/* For register access, we only need to enable the ipg clock. */
 	ret = clk_prepare_enable(sport->clk_ipg);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to enable per clk: %d\n", ret);
+		dev_err(&pdev->dev, "failed to enable ipg clk: %d\n", ret);
 		return ret;
 	}
 
-- 
2.43.0



