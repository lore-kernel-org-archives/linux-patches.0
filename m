Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043273;
	b=mQAUSN0BdapjEaimqXNHtq3hpbFaey/nyC9jS6BkUXUKhOduCr8Ql8/HHh0/in4AkYL4
	 YPRQ274B8HJ7bV/gyzS8X4Mw/1hxZq+yY6hg8TqIbIix9bgfGcgnJrY3mX0zF093jEByD
	 sc2hbkl7o4ptvevxhMXwOZ8YGffSfW3vX1HrpSWiqTccsbanlOB1Px41rLK/fm+2UCQjq
	 OzpuDOk11Yqi/jZcbUCZzhfKJ1U5+7NSH88qoGrZkAJTEbfKW1xqKZ+eH6wu++IuZei2+
	 j+pOixZRJvywjc0HjPUM102SF7wVou8M2fdRyTPo5jb1y1KadNY4+UaWyg6Xcx9dWxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JvEMzAKNdvTjUF8D4tfEfynhfGtwtYa3w8ysBo5Zagg=;
	b=u1wBQuW2fgM65cDRcUx7hQ0kzG8swf4BK01jj1RNsICR+GutejSEqctQS0T0vC3tAP4i
	 0yzg3+Xrl3BADUaR7cszw4A24PEftD3LNxn9mA+MM6+jHd36X9haXECWHbWlAdFjIzOhz
	 KbdpRxrZDEw8JsRiwYS3SCm4+2upNPdylGhphnhTV9QBgSghEMbzHWod2gj/wI8Jwhk5t
	 z1CVVNvtHcJx0Bo+Ghzsc7ZS+2Ku0Mt5Q96whe0FFFWT+AQw/diVF7AheQ0VjQjeqjLSV
	 sxG5H7PmuGIK7ml/PVuArxRrcJm/E0wSnM/ERaQmxVqGNQJNUsViRur0xZ7IGtV5apg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnj6gLXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB2A606A31C;
	Wed, 18 Nov 2026 23:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnj6gLXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B091F000C4;
	Wed, 18 Nov 2026 23:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043273;
	bh=JvEMzAKNdvTjUF8D4tfEfynhfGtwtYa3w8ysBo5Zagg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnj6gLXfskYFcHCiHWVSeywcDMmlBwW41FrV7EF4S9eQrLD6CuQhmTN7aOhbSTH4n
	 HzSGdMgt/qNenMF+ke9l9I+HkHyzbDDm74V98sctB1VG3441b9W4/AdqlSRkXH4vdK
	 /ctCWxavAd94ix6i22PV3/cUfh4XuYVNt7ESDIR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0111/2857] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:19:05 +0100
Message-ID: <20261118150205.308096051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 1ca44751915134f19e8627768159781e75b5da50 ]

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
Link: https://patch.msgid.link/20260618102949.26607-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/aio_iiro_16.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/aio_iiro_16.c b/drivers/comedi/drivers/aio_iiro_16.c
index 739cc4db52ac7..fe75b7e1ddcac 100644
--- a/drivers/comedi/drivers/aio_iiro_16.c
+++ b/drivers/comedi/drivers/aio_iiro_16.c
@@ -59,6 +59,9 @@ static irqreturn_t aio_iiro_16_cos(int irq, void *d)
 	unsigned int status;
 	unsigned int val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	status = inb(dev->iobase + AIO_IIRO_16_STATUS);
 	if (!(status & AIO_IIRO_16_STATUS_IRQE))
 		return IRQ_NONE;
-- 
2.53.0



