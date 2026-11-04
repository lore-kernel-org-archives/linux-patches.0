Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829590;
	b=LY/ERDB/wavczEgNVFXA1xzFBjdkg431FXbg6SsGx+0EDxB2WJ63ZPLV2rGQsx0EtziM
	 /+9IWj16Y9nzS/UiHXIC9WB2wWzyoikQ2LWApkEJ940IBBlcVWXG/TzcPToz1A7BVudKM
	 FUtikrnI5JcBt8Ry01GheEEUyk/WffIx5GyjMWgKqobJSD9uuRk+2d56fQDSuhlrgLuXn
	 PanVPfczu4T3/pPGECIRsaCFR+4dMV3v8j/0PEWCj3wgbwZMeWZNEiLIwUIQr1M5rjUBK
	 OYGeOWEHPTu26gi/jIHTnJQz2LAl2DGAyCgDm2N7vgiBPENK/uVV1uQyj0sIGFq6pEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YFCkq1on6bOH6dmp14fkZ9RoAeoOhBF72xk4SNm91w8=;
	b=4JrKxlBoTRchHkvPiYx4bYwd4dw19kPiqghBAYB2IUzVkPMYv44Vin/OdPEveBNItTSk
	 HXxgmGw5bdm0hqSTBk1TShw9jBzARoSaQUhfWTZJx+d/zwJ2T2Na6b4C2g+OkT5zZuhIG
	 BUALzefUiKl/UGmb8NVA7XvntGt/4ZRv8kULvrzfXN0LrIkGjJZTXDyIX30LviuuIsmYB
	 zCN8paufKTx6QR7Ja7w0ZTCzjrwG678r7uCklgN2pr/qv10GDesG0gnXMeFkmWWZRlN6S
	 4maRlg0BUPFwp2/WZOY5/N3xu+F8VeE8Uz3U85vqlaKFvV/xap6+TjvtF2OgruFYuTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e4vKeBu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C08607525D;
	Wed,  4 Nov 2026 21:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e4vKeBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7901F0093A;
	Wed,  4 Nov 2026 21:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829589;
	bh=YFCkq1on6bOH6dmp14fkZ9RoAeoOhBF72xk4SNm91w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1e4vKeBuJSlbgie6H3zIoRazd1CbXyninXNSJqbzrijZVggYvy+SVdjUoizgb9ZS1
	 BxMDGt9Px6hlwq9MWmDx3WJx3Z+kP4cuHC1xsxSLyIj/TQE8cbkOHDYGl+NQlkUhTX
	 ZyTh/ExPn07CZHCwDNs6L7edM8RJjy4R1wBSJzzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0182/1005] comedi: pcm711: Fix sanity check in interrupt handler
Date: Wed,  4 Nov 2026 15:58:35 -0500
Message-ID: <20261104211048.880454635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit f876cbfe3e066bc9e3f3210907bd534be82946c8 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-7-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl711.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl711.c b/drivers/comedi/drivers/pcl711.c
index 0cf3917defe79..33407da84ef45 100644
--- a/drivers/comedi/drivers/pcl711.c
+++ b/drivers/comedi/drivers/pcl711.c
@@ -181,7 +181,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	unsigned short data;
 
 	if (!dev->attached) {
@@ -189,6 +189,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	data = pcl711_ai_get_sample(dev, s);
 
 	outb(PCL711_INT_STAT_CLR, dev->iobase + PCL711_INT_STAT_REG);
-- 
2.53.0



