Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063062;
	b=HqzRaDqci9m5pvVUWircPmZ7BWbIq7yMIAw0zGDpWGSCaGn4WCuYpUaGEimE92E1lw6H
	 o3nJrR4HzeJ3oT2pz2ss5rKYGIqwPmzkuEuyJ2ozcoO6BCP3PxtiUEC1foIdP/nOYxELP
	 PusU95uhCT8iWPn99UsikWHBYAMTm+JSkiclTnRmeJk84yISBnka4MmrqLj4/jMwXPuTQ
	 AGBpPmyKXS/PQmqP1m/qavoBUYDnmjxK0bhMbepi+w86Ztgd9sbF7p1qGcZ8b7VJ8o2FH
	 rWPYmsLypLZCo/9NiCbmyivSkF2tm6UNcR1mI/0FCgwTtzAbStImrTOfggJuuRLo18A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gAD0Mgk90DtO7au4wcM5sO+01f71LBU/OxY/2rgrCAU=;
	b=hUtgeGt51kKx0km5r2xRR9lONJAmrYkD68HGbrKBD4REqJBsgK3so+vKXmhFI9uDEQ0A
	 kgk+hfR6l87fUl/vn6u23UTZCGdypj31czKaQ+W7c6opSN9FPqDIOGlayFj+BWXLGSoN0
	 LP8Tlqh+kO4yxtNqQ3uGYkyPdtSchBBmhgKcyUYcD0M1skiCRQiZZfwHEM8Qr3jGByQYF
	 lNi7Yxfk8xF/WbJn8XS/qkfjzHCulRL+2nMwgGd+JnHcs1qjxhIMvnke3vpyNGp/LrG20
	 /QqjbSBhIeYbw71PrjPqGJposmsGo1dW2G6LSb+UVsPnF8rQJXWYfJOrGo/LmqM/pTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lH3lg3FF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B165F606D82F;
	Sat,  7 Nov 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lH3lg3FF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD211F0089F;
	Sat,  7 Nov 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063061;
	bh=gAD0Mgk90DtO7au4wcM5sO+01f71LBU/OxY/2rgrCAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH3lg3FFOcddmBTqbHcaSyVoBkhz9TgiIzcYNG4jUtqwH0hJC23C8qbvphT7v0EH2
	 EsjJcHapG8+61NhHbvEdq2JIphfWNqCbS8manbuQRoO63Cq9FDmIOYQTnBfu282HZD
	 JqdZwgVEj6b80qrZXgOeEwmTl/aVbSaFIkL/v/4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 303/869] i3c: master: adi: free the IRQ before unregistering the master
Date: Sat,  7 Nov 2026 08:49:45 -0500
Message-ID: <20261107134902.839690314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 1c1e2d90aa452764df66bb1dd774aa0d06d89cc8 ]

adi_i3c_master_irq() is requested with devm_request_irq(), so it stays
registered when adi_i3c_master_remove() runs, and the writes masking the
controller IRQ sources do not synchronize with a handler that is already
running on another CPU. i3c_master_unregister() then frees the
struct i3c_dev_desc objects that master->ibi.slots[] still point to, so
the IBI path in adi_i3c_master_handle_ibi() can dereference freed memory.

Fix this by storing the IRQ number in the private structure and calling
devm_free_irq() after the IRQ sources are masked, so a running handler
is finished before the master is torn down.

This issue was found by an in-house static analysis tool.

Fixes: a79ac2cdc91d ("i3c: master: Add driver for Analog Devices I3C Controller IP")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260923085340.490776-1-fanwu01@zju.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/adi-i3c-master.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i3c/master/adi-i3c-master.c b/drivers/i3c/master/adi-i3c-master.c
index 178029769bab4..d6278d03012db 100644
--- a/drivers/i3c/master/adi-i3c-master.c
+++ b/drivers/i3c/master/adi-i3c-master.c
@@ -115,6 +115,7 @@ struct adi_i3c_master {
 		spinlock_t lock; /* Protect transfer */
 	} xferqueue;
 	void __iomem *regs;
+	int irq;
 	struct clk *clk;
 	unsigned long i3c_scl_lim;
 	struct {
@@ -957,6 +958,7 @@ static int adi_i3c_master_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
+	master->irq = irq;
 
 	version = readl(master->regs + ADI_AXI_REG_VERSION);
 	if (ADI_AXI_PCORE_VER_MAJOR(version) != 1)
@@ -1001,6 +1003,8 @@ static void adi_i3c_master_remove(struct platform_device *pdev)
 	writel(0x00, master->regs + REG_IRQ_MASK);
 	writel(0x01, master->regs + REG_ENABLE);
 
+	devm_free_irq(&pdev->dev, master->irq, master);
+
 	i3c_master_unregister(&master->base);
 }
 
-- 
2.53.0



