Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060734;
	b=HCFtRG9zO7rQpYYBvijbDJV8xMWNbWWqHDEW9MvruWy9wGgSSYCCeYM1stDMsKhsgdoM
	 uFB+qQpwDCsYlAxmQJxGXqIrd3f7wLLmtPOxOu7XT8YqLQgVArxpEuz8gpGQI2+CkWIeK
	 9/uegXk9tbDZ+vVq65Iq+6exAxFYgnx/w6iwq5N/QJJJ8ZWuL6MBlc/vebUBfJLkLaIa5
	 MKUAVC+oXGl2jfknHQAi89YxO7yB8WFFx+RVEAe87O5yssgIQGgk0YPWwqc2oBNFG7nYa
	 LYWi5fKesAEGGcwt/dQpovnl3xgod/Ms+coVdVJbSvlZ9IhaFsand2IvVuCCFCBk/kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdgCb6/Tccvemirywr9QCyOJm52LlzYwtLiBaNGjw5s=;
	b=QE9h+KINSpDUSKqIBv2JAoRrjAclShEPL2HFW+Cu6gutmDeUg0SiME3hGsjfBY+gku1l
	 wCW40Fdd3ERtln/7HYgR9OQrCxgUgej0P1n6QIY/E1/magsAUki0HYVxbXLR1duPwDrlO
	 4ij7QLurIy8vWBZfu0Xg0qsMiBiHeCWGpzlgZwtvgd4/tNZaS2KEbkPDQBxKJkpKq+lRL
	 BQoU2NQW4WxYqJyUFsVLCkOziyhsZSA5pU3Mhi2WhRZlQ9dxFIJoxZoUVMlI5K5TuyAbn
	 5itayXt/wVDcX07frZ95Phe7dYm6l5t8HP8EVOEWS2fZsZ2TRwWpWEaKnkLcfX0SlNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4Qd1bny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE5C606A338;
	Sat,  7 Nov 2026 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4Qd1bny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4BB1F0089F;
	Sat,  7 Nov 2026 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060733;
	bh=HdgCb6/Tccvemirywr9QCyOJm52LlzYwtLiBaNGjw5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4Qd1bnyk/gYeT9NAZPBIlHuiZkYEglcyf7dTo0+oxXLW8nJbII6QY92YgAgyEJVK
	 pFjedyWvDyXsOYkbZpEd/S35HVwWEYBXwAFFvkdh/kw9YjQv0BiwCcJTOUuG/Z4IHF
	 8TZLVyafwmluwgujbYWkvAUZA5ypb7ksvz93YbXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0151/1536] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Sat,  7 Nov 2026 08:36:07 -0500
Message-ID: <20261107135001.923224870@linuxfoundation.org>
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



