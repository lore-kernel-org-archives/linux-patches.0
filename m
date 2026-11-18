Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051132;
	b=UjS7BCLrsOR2Cc11Wf0BCJZOKEYVbPMT5cAUvIozOacbs7/dlzQeddSvqvE8pXkuKe6R
	 jTKgOcz9iSp7iL2HPoATZBEXvbFIfDNHFoF9Im1KCUfIBIw1MNaERaTxuLtz3nJ0rCb02
	 8mXEu5f5arskenGRbpMmA2eHwWkP1C47K3DxwXQmQOBaK4rygD+vfHx/gIECNWbqHdGbJ
	 U5+ip4Rzd6K5GED1VWtOv0guZsvKnC6nj6DQtaowrxSCCl7u/GjOVSKL/rxzCCHc1BNUv
	 Xpp9v/U2eiVKxHUeTNEMq6QGF9kD8Hq8DySsWBMQofmhhqJC4fOQUYD8SxIHGNaaOpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUmBL3Qs1In45hc+RdAh/+aJMV5HqdmG+xAs+28Qq3A=;
	b=HfYU4996L274ljULPD25FKdQrzhqSXmRiyPaVwVjwc2rkt6FMF18HxB8AdE3w8GclDl8
	 gDBR6Vr1vKqsPrrE5C/g/qM5uhW1qhRpGlj10VuJkXS9bTFdnAMINCxyqROSCoNHTp+SE
	 hBgd7MB0USFw4CE7Tve8AESbLCRsuQ1X+gdzvTRdTPGiSDMItM/2W/2aa9xdgc0MFiKiS
	 V7ADsEN9+oEGjXNsOwfgLuHjtVXZIz6q11L1Qx/tvnacv4GejqsWR65gl9PKLxim5ZefD
	 BpMz43bYuQrgJNmANJEgzXgsMmXQhA/NwI98/oy9OCB+AqLTX5l7qxUjkiim30lDDwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2qL/H4h3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0BA606A32C;
	Thu, 19 Nov 2026 01:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qL/H4h3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F331F000C4;
	Thu, 19 Nov 2026 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051132;
	bh=hUmBL3Qs1In45hc+RdAh/+aJMV5HqdmG+xAs+28Qq3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qL/H4h3T+YGF2lEw8ykK3k2hfTLVKtmtMX1uNIwiCt0R5XoK8E7jr6va3q5FTq5W
	 +DFARgRhJheg0hvG1RWPYx+lS10OrYZCgKssjCxhB7ntgDV4j0fFu567Y/JP1UWiGL
	 il/je7SdgzjzyebFCWdGWk5+TPg6ygv2vISVWy8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0101/2214] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:29:37 +0100
Message-ID: <20261118150013.974878189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 60c9c683906bb..e979cf430a111 100644
--- a/drivers/comedi/drivers/aio_iiro_16.c
+++ b/drivers/comedi/drivers/aio_iiro_16.c
@@ -60,6 +60,9 @@ static irqreturn_t aio_iiro_16_cos(int irq, void *d)
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



