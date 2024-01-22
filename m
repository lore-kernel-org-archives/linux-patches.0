Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD096313F;
	Tue, 23 Jan 2024 01:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975022; cv=none; b=SodZK9hFQ98YTxbTegMQd8Bqw7Zf/2GRHvpNVIstkR3Z5bUjcvQaRHL15JGpWEWtGy+siu0BNTcJrcicH616jUzbm/1p2hI8hj6hAiQbOpIcvfTivxHmwe42b8wwCHWk8JeL5zufh6maAD9/yTszJYKgZb2jbMyst/EqzWjO9Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975022; c=relaxed/simple;
	bh=MKRn9BYvnGyJ5uAk+HDYsi44KDCz41Ib8nWvgB7il3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqlym94I6kd1wZ54EtCONssAm2sJCY/lCc1I5UOt+poKt90nIkX8gFtPlMhaopWK0KqkAZuaKMfcU9qzXvYq78bd0dH4m/Qv4m1SaguCxYv0wS1kLEhXEMBcB2ypOWd3Y23CzP5+i9Kwz9AXmTa3FdMZVLgqTsfi2iZHBwmpWvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2YRsuGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2YRsuGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7BEC433F1;
	Tue, 23 Jan 2024 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975022;
	bh=MKRn9BYvnGyJ5uAk+HDYsi44KDCz41Ib8nWvgB7il3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2YRsuGZyk0W9MSiKPSvH4VTCmJW8i7eJ/icZl90e16QJivuH97dlBO+45sYrQu3u
	 w1IFiOPGZSQz+8lsuJ1uHkFCDG+QFCPiiGTy9ORJJ3S9oyVLMQv7NHHFgH7nA+V4XG
	 YLfT+vyZLS8UfhfXKV3lyCH7715fP7eZZ9M9pyR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/374] serial: imx: Correct clock error message in function probe()
Date: Mon, 22 Jan 2024 15:59:43 -0800
Message-ID: <20240122235756.277655292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 52f183889c95..4504b5fcc171 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2318,7 +2318,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	/* For register access, we only need to enable the ipg clock. */
 	ret = clk_prepare_enable(sport->clk_ipg);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to enable per clk: %d\n", ret);
+		dev_err(&pdev->dev, "failed to enable ipg clk: %d\n", ret);
 		return ret;
 	}
 
-- 
2.43.0



