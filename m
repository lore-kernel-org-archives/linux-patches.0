Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829591;
	b=YWOV/AyrFabjtVNAaHTHkRmGQnUIFulbHaI4K5HxIVepxI+JJmChhBtm+p59pdKvXYyg
	 KIAHgrt5KEID0qpPuqTr/xsB1cacBXiyjz1VKBokQIbIQExJBGXPo255IqNMZA+0p7Vsi
	 JnD+n/GYHif4uyrXUlXKOBeJpKH4tHLrggZR9QuWzRYxJ1Fb/FtAxqo4Tqclwl5VvEXRP
	 kGBUR5+tXXmwxXiqAS0QbeP3FDuQSBEbwZnF30xyb+wFDFg8ZU0+aZfcG+m7G9A1+HfxZ
	 8upSOJVC1z4JkXPM5VIWxo6NGecc7DlLAHDK5x8P42c5xPCNASpdpB4aCP6va5wGQ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0tNB1t3KfOEfy627GPzGz3ol68rvA8p8iYF8zR57tU=;
	b=vXCtn2aKNd2yxhGIkWF/4fHlzik8ShTFPPd+1cC7CnOOjhaH9RymDprJnpdeWkdYkIB3
	 y854zisyHMLncJJi26tN/tgFKmS92n9QJcDfJHJ5tIPh5/We+lJh2Hcf/nW66s79gR44l
	 LvTOSfiAikw5aWtpEm0wBZoxCE2d2UvwN2DW/fb7BVs9nq1cbdUm/NcY4w4Q5BDgikvRJ
	 m7ofOckkI9wJ33U3kF9Jii7uv1qDTtG1wfQPSaGM74c849JbI9c177GajBl4Nkq8N2prQ
	 6klYXHf6cclOOqurrvAgoyb7HzWbo5iEu73+tUymnlwbP/g1QDnAp9pTKngzLlTCSGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEMEpnTZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A45607525D;
	Wed,  4 Nov 2026 21:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEMEpnTZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0847A1F00A1D;
	Wed,  4 Nov 2026 21:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829591;
	bh=z0tNB1t3KfOEfy627GPzGz3ol68rvA8p8iYF8zR57tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEMEpnTZFQgfJXbk7TC9xNXpC6lbYCI9vcTicXirZl8f7mXU1rEyyeSemwujJCNCg
	 Ntmm0N8hJ5jUWMsmFy0kXYAcXE5eG2ZLD9dJVYrM+SyMJikB5lGrlOlzPHqZY6D8m1
	 MlYbge5FxGTuvvIIeSWw5KbDOPRt39t8OADFaxNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0183/1005] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Wed,  4 Nov 2026 15:58:36 -0500
Message-ID: <20261104211048.908364128@linuxfoundation.org>
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



