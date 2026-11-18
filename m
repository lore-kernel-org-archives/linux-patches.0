Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057321;
	b=cqa7cT/u0Ju58vjgsuwR2QCoML2SoNj/mfGAJlDQger1XwK2x3tL7jDEAzJuXBzZ12E2
	 oYe20MINhkFworr/YT2OVsiw3+j7pp6vMR7QqUnvG4NA4DMzOwP9sLDyc6ktB6C1iiDo9
	 9EZKKEkwgryD+sOmu0POs9yhv4h1dwR545PqhyPvZBgEdtinsyhUqpd9jUa2p/CLO0bbt
	 o8kV7c5x4HjemPhRMqMRUuINEwXuuePXdPDps6lv44dPchyliGNytw7/11+waHfSqCD09
	 OCREi9Q51wFS45Rc6X9vmhojyJ8U/XWhH3uJPttxtJQHPb5QCS8n+oR3N+lvFwlncNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=htCgyTMcSrKWLNsxF05zodbLiCIqTGl5bNUlLFTAi4g=;
	b=SNnPFe1/AcnpgATLtmYjf6yE9NB79aNTX2E4Hu1M9sYHzpdQKsR+ekROtTvnMm3Ahpke
	 ZCFe4h+3hcZ5EPZ2MkeWp0e1gscE5KFetDYCI+E1Dj/Co4vAx8eG+nbZBiH0vjiL85q5b
	 GxTww+9aW2+Rh65r3FeR1PDCqVafKx3vyTaWM0O7bRfeZ+I/BRC/hDocqy9F4omIm5j2k
	 MPO98eKOx8hC3MRBuYVK0xX9A2YA81IZPnInGIsxq5qiY+8Fp9FDjJRQWhLBX0CAkB7P2
	 /2Lft7Jw9AbMxIoDLieYKxM/WKL7365PyxnjSNsOZp6bDPsSZeUahS990KkRgBQjWDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x64Cv3Wf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE40A60A5BCE;
	Thu, 19 Nov 2026 03:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x64Cv3Wf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE201F000C8;
	Thu, 19 Nov 2026 03:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057320;
	bh=htCgyTMcSrKWLNsxF05zodbLiCIqTGl5bNUlLFTAi4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x64Cv3WfpogU6DL2nnOUChawJIRI+Zr0YDTNf79mqZ46QXclL4EfSxrDuV3d5uyiP
	 Ft8W6IO/U6+f31PLoLw4xkZ4gPfA9E9BRvN5HLhGwqBxbvgT69YYHQZ67uheGEob/F
	 W0sOGnSlz6qNfcr7ceN1ugRZktIgGfmGwCAr8jvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0088/1848] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:35:26 +0100
Message-ID: <20261118145914.811200997@linuxfoundation.org>
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
 drivers/staging/comedi/drivers/aio_iiro_16.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 60c9c683906bb..e979cf430a111 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
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



