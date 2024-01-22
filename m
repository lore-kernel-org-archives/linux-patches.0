Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689CD4E1D8;
	Tue, 23 Jan 2024 00:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970015; cv=none; b=g5/iL4klA+rXpFuEYUw80O2F+E9dGBV6LydO0YC7svOCHVl7aoHIaitOjGphG2xRwiOT3Qk4VK0sHS0KNW8TbMsuUIeR/naoMOhhBVt8BO5uaL3AMvD9zsPnduis8QR2UoUv5ZMarVlKVyoqOQCHWxzMS7nD8aI78XnZzhNhxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970015; c=relaxed/simple;
	bh=KPHNmeWFCPcl2u9XDCFWBVpFt3VUX3wzPsAqqi82kRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzyoRqRpQKTLMerwZlIkX69QXTLPK1qQNPVqTGhy9vFA8VTF5TOhfhVtZWX4HbtWGTKKPYu4maIcvnFym1CcWFl9HM2jtbEuE1YiUIN74MD2HQAu53+wOi4eaOtNAL73xokNVGZm7EFYp+7WNis0ktUCpWEtFvl1YNTthjbNaoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGsVTW5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGsVTW5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114B1C433F1;
	Tue, 23 Jan 2024 00:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970015;
	bh=KPHNmeWFCPcl2u9XDCFWBVpFt3VUX3wzPsAqqi82kRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGsVTW5p6l/o9+DNMTgt7+R0vMMGD520V2T8W5maoWrS4wSXrAt7CAB0KYSq0efd7
	 gt4yUyeWowsDibkrYxa8Bi8c0Cw86H+FEEEEn4JDvvX4Gx7vc5OFEmI5Hab6jH3FIF
	 ogQj0ksfY0RgzLgJqHT6gjiMOR4pEozq2vZCAUhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 563/641] serial: imx: Correct clock error message in function probe()
Date: Mon, 22 Jan 2024 15:57:47 -0800
Message-ID: <20240122235835.774270526@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 16207b9a8c81..81557a58f86f 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2315,7 +2315,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	/* For register access, we only need to enable the ipg clock. */
 	ret = clk_prepare_enable(sport->clk_ipg);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to enable per clk: %d\n", ret);
+		dev_err(&pdev->dev, "failed to enable ipg clk: %d\n", ret);
 		return ret;
 	}
 
-- 
2.43.0



