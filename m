Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E01292F3;
	Tue, 23 Jan 2024 00:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968709; cv=none; b=I3r5q9wegFPQJWzFScZqgdi1P0ubW56Iu0Ufh2DGFGyyyFOj6SXzMjQVCg2JPDtF85PvbTcnoL9S6LyFl6nHa4wjC1AJb3GYwaLUxiakO5gPucRorVMwiZrQ97PH7LWUBHMHQu4lbFRibFS372/b17BBTbhGFLMezqgWC48RvK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968709; c=relaxed/simple;
	bh=zu6n9yNvXfV2pnGRn1mH7C7wO/4c17E8ObQb339TuoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwtX8bCS+l63SKSpL9pc/gz7w5N7wKZMw5osCjNz+6el72jM//ZmepzvEtgjl3PNA1lYtlRh63pk8xwy7SOA1cLHUi+vpM34tj+K/XRd4i5X4g8rbwq/OEwsC5Oz8mwckIsdzgHIdAkUCqObyAMrOTLBJgthu4Y0mydq4kwUnqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlrtQNyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlrtQNyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C48CC433C7;
	Tue, 23 Jan 2024 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968709;
	bh=zu6n9yNvXfV2pnGRn1mH7C7wO/4c17E8ObQb339TuoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlrtQNyr5kM+27HqbulMEH0esskkpA10YLWQu83fDEPZGrYo3vYYVfU4bthsyDo9K
	 z64xlz9Av7Ux194rzmULHuSXutOCFFX2rViCoaa6bvu+Zr6mtH94YSn/XADMvI/c2c
	 76N5AXq3gYqvgyt9FwHtvaaznVNZX5A8adYJCQr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/148] serial: imx: Correct clock error message in function probe()
Date: Mon, 22 Jan 2024 15:58:14 -0800
Message-ID: <20240122235718.161837241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 819f340a8a7a..024777e7aefe 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2250,7 +2250,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	/* For register access, we only need to enable the ipg clock. */
 	ret = clk_prepare_enable(sport->clk_ipg);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to enable per clk: %d\n", ret);
+		dev_err(&pdev->dev, "failed to enable ipg clk: %d\n", ret);
 		return ret;
 	}
 
-- 
2.43.0



