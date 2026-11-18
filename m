Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033757;
	b=VFBtxENOuk+DnMRZTRVVimeUVv3bfmbRpk/G0dnGEQxzKhWK/BZg6hd66DEAc7adKY7W
	 ZIwHC6futafoyt9VJLqYu6wtiS0PQoDw3Vpkd+4hJLu4Tf1SS+XRf7rhH6gjxkBERKU6u
	 LjpF+u0XSv5Gry/WnyJMTCybV/NEXoO+sijXifA9WSZV6py/fKWef9PDhbu+8RwhJ0/Hk
	 ZxeeFqquRFqSQW7/F1J8ZwPoUh+f0zI91oECAza04seAT3sgWhRP5mf375t0FwTWypDtv
	 JdzY3bF8CIBXtVxXymYGlNIrZb05f1KXNCCD1NhuvxVrIof+PTIb+x7ZY1Xei/mjqTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPdmSExmZ+D7UIvy/qTsjnuvZq3I7dn1/PXdK5fY7lc=;
	b=h3rsrQQxRe9Mm9VGK5Fz/oNZtkX6J8IdhoxEBtRnOR0PX+ijbLYdMkv6iUY5J4LSZK1H
	 ZAOSfXKUFp2AOF4hD5Ks0KN1iWcfCxHANnFwQe4yLp2m7tFTKrYa0UNnxSGWZMq48VrWr
	 7sH8Y22dvn1qP/+MxFXdHX3zO8p/utb7Y7HJA43v64nhLQ9Hpngds2Jrxex0XvBkxaQQb
	 5eLtbGxGFAsmqzrS3n9z1USGGPfuRL1vJKFOYb0XLaTwKtt6fzMtHgvVOjHkYIy143779
	 cVWmSyw4GbuEhFFdRiGHXSC9DU806VzXtmGcEt7nPB6/2JW16nneH6ZcrDInZHFINLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+E9KRWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A23606A31C;
	Wed, 18 Nov 2026 20:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+E9KRWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29821F000C4;
	Wed, 18 Nov 2026 20:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033757;
	bh=HPdmSExmZ+D7UIvy/qTsjnuvZq3I7dn1/PXdK5fY7lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+E9KRWySj9sVScU+AjJCcFNe+7aUR3Lvt+kMwyMCcZjg5UVvHqoVzh3JubOgNEbi
	 5Zl6VHsRVD0rJtvNRDkOJcdacESn2SLfHnND7sYcySVBnYprUhWE2p2GsT+rdosbzc
	 N0KwEK8GynIRdeRz6yioLzISTVuaMUBDuy97tfj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0129/3318] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:12:31 +0100
Message-ID: <20261118150318.248886036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



