Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057165;
	b=bvHiRUZ63Nidg8NzG3iATBlqRs5kgYVKtUqM8fRZawhwUD8icSbcRo1ix043ramU6/Lm
	 cM6A9jkgfWNfsYYUn8wbjlP1qI1SgRkzU6HXPCA+XjvckWdg7YjKYdWO5OVAGPy1pU7yB
	 ipuWGk2MSfw4th9dagQp/LE9e3ZkEv11GfpvOrOZRqARlgc5xmM+k6RaMTd6afI8qDtzf
	 jg2pBnB+CeBMJ4C05AvJwnN0fWwzToiCCJl95Fh/u15zaTsI8c9PYeG7/onO0Z0T/7jl0
	 zOr9wBtPIoQOItRm9OyrZGSadmEEFYfNQHtcKScRDBzY9NAMfwqdaElCBNAiV1phZKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=577UN00WsrJFxtRiTEGMGZzZr/GH5lpJAflpBVtg4TU=;
	b=35oORcnYxXO7uL9bib5y3lWe92wIbxfRnmWuCiSI8/ICqNT/KCe8zaArQxqcNMT5Besg
	 qIp/s2JA6ZK62TyJilmHJDuUyO/SLNfxTGtVxskhG5732AkSUngd8Df+R7DFBfNc4lGMk
	 dsC0vIY0ldtEZVdpLiEq1CTYjHLkaMrY4anABzduKiy+0sFN26IE9PMkAy8AiwZ/eEoLL
	 Akd2jJ5FotYctah/CgUWPSQN0B06Bc1zqGhVRoo+ccMBuG6xkPODhFUrZh2uvdDVErdRi
	 donYJGJlX27uuD4BcSw4j6TGY2LGVmYvVyHVjZvdJ1SH+wT19/yNUD5OyAGf5HzJZxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1xsZr9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76945606A32A;
	Thu, 19 Nov 2026 02:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1xsZr9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78121F000C5;
	Thu, 19 Nov 2026 02:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057165;
	bh=577UN00WsrJFxtRiTEGMGZzZr/GH5lpJAflpBVtg4TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1xsZr9Ept630fFx199CxQZM6Fgj/jwZLs2KRs9frtE+EdhqKP+SkMfJUAu7m84lh
	 zzmUqShuUpprRMt2ZZwOejua5NpVWm/apFGbBNmZhEeXX+IIa6Mk5GXCUBEt/7o2oB
	 MoLZ3waZrdPTopskBItqdbWxWrVUM2Tn+qiwaddE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0007/1848] serial: tegra: Add missing clk_disable_unprepare() in tegra_uart_hw_init()
Date: Wed, 18 Nov 2026 15:34:05 +0100
Message-ID: <20261118145911.538693417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

commit 38f28cfe9d08e3a47ef008798b275fef8118fc20 upstream.

Add the missing clk_disable_unprepare() before return from
tegra_uart_hw_init() in the error handling path.
When request_irq() fails in tegra_uart_startup(), 'tup->uart_clk'
has been enabled, fix it by adding clk_disable_unprepare().

Fixes: cc9ca4d95846 ("serial: tegra: Only print FIFO error message when an error occurs")
Fixes: d781ec21bae6 ("serial: tegra: report clk rate errors")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Link: https://lore.kernel.org/r/20221126020852.113378-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index ccc6106a5a253..3b86272cdf390 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1060,6 +1060,7 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
 		if (ret < 0) {
+			clk_disable_unprepare(tup->uart_clk);
 			dev_err(tup->uport.dev,
 				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
@@ -1081,6 +1082,7 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 */
 	ret = tegra_set_baudrate(tup, TEGRA_UART_DEFAULT_BAUD);
 	if (ret < 0) {
+		clk_disable_unprepare(tup->uart_clk);
 		dev_err(tup->uport.dev, "Failed to set baud rate\n");
 		return ret;
 	}
@@ -1240,10 +1242,13 @@ static int tegra_uart_startup(struct uart_port *u)
 				dev_name(u->dev), tup);
 	if (ret < 0) {
 		dev_err(u->dev, "Failed to register ISR for IRQ %d\n", u->irq);
-		goto fail_hw_init;
+		goto fail_request_irq;
 	}
 	return 0;
 
+fail_request_irq:
+	/* tup->uart_clk is already enabled in tegra_uart_hw_init */
+	clk_disable_unprepare(tup->uart_clk);
 fail_hw_init:
 	if (!tup->use_rx_pio)
 		tegra_uart_dma_channel_free(tup, true);
-- 
2.53.0



