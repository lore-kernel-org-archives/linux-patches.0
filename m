Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDF767737;
	Tue, 23 Jan 2024 02:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975727; cv=none; b=K4V4Ww3QT1sER63zbTLi2jtEgeoz169I0PYAoT1GXvon0blZcCPcyUWt+BGWXKTw4g3wl/mRR5VhIW/90PZh6t1lZMXpX2wZFGhJ2aPTUumu8VbCIF6lhRIiicgu5P0A05bNLZFHMUyKiJ2B9k4qUHcwTCuWEOd2L4MGSm6qNYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975727; c=relaxed/simple;
	bh=j0PEU5W8l5D/LID5QGhmbjjlhlV17EYKQDE5dQRTbys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EU33sr3vZLNyHMW5yYPTfraQ+Nc5/5ZHHaaG9d95xbRn4pkDNvPc3suTRykD74JUSBH2tswQcEdA/uagTz3f0XrTsyW1qJyBTVOSyacwJwY7flryehfE/sGYOotvONWQYAroDJw2edOGAXThGpeAYjWPvWxDyVwHib8LRuCPlow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGYdzeRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGYdzeRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C1C43390;
	Tue, 23 Jan 2024 02:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975727;
	bh=j0PEU5W8l5D/LID5QGhmbjjlhlV17EYKQDE5dQRTbys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGYdzeRLBfNTFycpiVHCHydtLObd59N7XCfsZ9YiO63GriMtIQYjCGqRB4AmcHIE4
	 mHM/SuOBPiPw5c09FhvYXDH6eoCLq/e4uswU881NzJuQN/9aJ01EMkkK7raLHTEeoU
	 y29pFqJsyhNl2t7oahLhBzU+pz62ok12ULfS2qCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 511/583] serial: imx: Correct clock error message in function probe()
Date: Mon, 22 Jan 2024 15:59:22 -0800
Message-ID: <20240122235827.708323313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c084ac3bb441..cd36251ba1c0 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2323,7 +2323,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	/* For register access, we only need to enable the ipg clock. */
 	ret = clk_prepare_enable(sport->clk_ipg);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to enable per clk: %d\n", ret);
+		dev_err(&pdev->dev, "failed to enable ipg clk: %d\n", ret);
 		return ret;
 	}
 
-- 
2.43.0



