Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064302;
	b=mP9kenfpEZEoblbQ8SG8p9lZHsKLJqqC39Y7K/5+V6Mr1TePCS+AcqR+kqcgFJNXjVDQ
	 1d2Y6SwH5AmT9HU96LVpvGgeubpfyk11n4jMi5VCTmMFZc6SYea4GNSmBhfETcFhJfiI8
	 iB17oH68jLbMq9uYQvUy4ZiBiSOTWge3VodgHHoT3ULKUv8q3mvOaiTq69GWEuu5P8tjG
	 25HRYBttVoNPbKQiyMTCm8DAGVpKElE/Jx9TBNlWnGrUHFgf0Y1hlbMvP4Bj0xpY28vy8
	 +P6NKHpCJSG2i29nQWmCyX7PwOnDQrNnDzhBLhKsxvNBqdPFfJwmxl3ujpcgEj9k6Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hj25dSlCqOgbMA1eeXJ2z64ickT44YOZaM80DrdjDSg=;
	b=SSBYvPcfoQbT7DfueIikYcvVHkagUFAalYmyby6ahjxH8gyWB32W29nBxDmGReGHNOKC
	 pso+l5R+56ZT1NuZm94hIO8hwyWw8lPWUMuI79/m9IhxWoQthxMJSEza+gjfbAaX0LsyO
	 OgqulSBM9/owFH2D3f1lXhYLd9zb1st9esCZp/I0kOLJ3qPPPe0DKR7woJ3ysTLNU3IIx
	 WI4MVjFwXkKuZbzrTcz91BHI81RJdJ7AMzAKbDWQyW/WXy546tQPdprvI2+MsYbBKu0zo
	 eqmhjztR6H7rqTD8DCJ0fZxRfV1IcXeb1ZMEHTb3zZq3jzoGGW3s/S/QXxPd1oWlyfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0da8qHPB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37110606A9CC;
	Sat,  7 Nov 2026 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0da8qHPB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B751F0089F;
	Sat,  7 Nov 2026 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064302;
	bh=Hj25dSlCqOgbMA1eeXJ2z64ickT44YOZaM80DrdjDSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0da8qHPBbboIE8uomIbfN7EYikpsQ5SISSa5RTboGu/xYFf5DwPzQgeojjggEQjP6
	 4T4Ai8YKp6OlJBeJu5j7kMB07dhmyYTpdLou7+K4nGAsBhYU2cTnWJAyHOO2eG+s1X
	 3KaOkocxNez55waud1fFImR2QxTqTfynUgMoWud0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0395/1257] i3c: master: adi: free the IRQ before unregistering the master
Date: Sat,  7 Nov 2026 08:44:51 -0500
Message-ID: <20261107134950.452838992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b35386260350c..ad57b7500678d 100644
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



