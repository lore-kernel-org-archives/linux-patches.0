Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060729;
	b=semkZ6fpF8YJym7HGZukN+V3gOFI26JDEPdGRGm987H6QRfogXe6g4B39FOISEQX4f8V
	 v0k70nGQikTD7PMIK/PyI6zmJzoEBZhUwSPJ598L75nHZieHSjd8T82RjWsc226Rh3zWo
	 txnhakvIw9kf79Kg5HaIM2qoC14UvTLbMfllaFRec0DkH6tB3T+MTMsHaRC1Uw/9FS4Cr
	 CAvfnv/sAQmfukjTXcUm1HrYgUavyKcbgl/KkGr1fF+Diq2c6i3ujm9O8gWb9zODyhgrR
	 zAjaSOXYdHc8TygPAEwz1Enixw2eNVwc8i1LH4jqejM3eMw15p0Uz6NgZtvNta7D9Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0h/yY7DW7mutaWRLzgHYaVdlKc72121gbQwHaHCQwQ=;
	b=2x6Q0ZlNa1tQoOq8louVWdcmMeozztu0ttmTvjaX26/WSWsoAlLyfpItOde5me5IEtj+
	 rQ9ukQtmzla3lWvjoiMrRTLYl7bCkW7Oa40V+GjOJ6hktXieakextBYW7r6UeQc1oaByE
	 yMXmeJpSj/titD4i/orYR5Tye2HANu3hH4AYYFeOnl0nTPOg4JXLN+lvAVFO8DI9uGrM4
	 MNq8RtHDCdg5P8zURlltKNJY+QFDJYeTCBZDD0tAkVqhYCNmBmhg7Ql623aLVYRa++J36
	 EkHpmm9IKzmQRTMFHYeEAusVIauzrRzL2aadJ27VPd72/e/QstDOIWVxYlwKAc3Uk4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqLrNUNy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9151606A32C;
	Sat,  7 Nov 2026 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqLrNUNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F2E1F008A1;
	Sat,  7 Nov 2026 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060728;
	bh=i0h/yY7DW7mutaWRLzgHYaVdlKc72121gbQwHaHCQwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqLrNUNyXlE9hFpx36+3U0H1+yS/nODh5oXbgRlY7hdaTF7uAoKqmZJZXZl9S0VXk
	 3OvCqA+9AKNkELbHZDCTz4rmJlsddlj2t+owoopCgHyvBIKVp8YRpbVGoPx+bGwToO
	 M2t8cn5w9d6uA2vmmHOi0X6HgMgN20o1rVYThY+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0148/1536] comedi: das6402: Add sanity check to interrupt handler
Date: Sat,  7 Nov 2026 08:36:04 -0500
Message-ID: <20261107135001.844814218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit e90d0550c5b3056c8821f5cd714f80902de0fca6 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler to
ensure the device has been fully set up, avoiding a possible null
pointer dereference of dev->read_subdev.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/das6402.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/das6402.c b/drivers/comedi/drivers/das6402.c
index 7660487e563c5..f9a778390ac93 100644
--- a/drivers/comedi/drivers/das6402.c
+++ b/drivers/comedi/drivers/das6402.c
@@ -173,10 +173,16 @@ static irqreturn_t das6402_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DAS6402_STATUS_REG);
 	if ((status & DAS6402_STATUS_INT) == 0)
 		return IRQ_NONE;
-- 
2.53.0



