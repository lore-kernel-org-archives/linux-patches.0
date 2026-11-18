Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051121;
	b=vN3BmgB0QdAIEyVzkzX/qSoaDJQ1wqoYoiJMO6h06Kb+mfKyydOqytQSd36vI79sLazy
	 8gUoXN2GE3FfKD/Qz70Kze8OeYQgjKgBZU8NgemaIOXj+bHRWSG3BbsJbpDG8HQsWQ70l
	 TKmDU9TIfbKnBQCEkNOzWfSxc5EppMhDbiMzaQgomn1cwEOsPW8E2kemo/RVK4M49Us+z
	 Iq2Lju5BcQm+g9xCBUvedOk9Yy9As5PWyR1H1q6D4+H7H+NKlBPhhl2DKAwd6SN1mTFdQ
	 g5hPhktzckDZOo1t7FGhXO5nen4X3Y4imXe7l5da4iM42Gzl1usOxa+7knPPeG4OzfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kcSz5DGP9fRayI+qKnWcLDYXJwByDAsoRP5dggpRCPM=;
	b=P3QAjmezGVLtdR9ZpzCu6pbY1nS30AxmqCeWBUtHgjY8N0NOm5LurRTxZZdb5qb5QK0t
	 gmku3RIyiMX4cRHDO86SiUagRUT3VNIMZcQ4e+lmN5D4oeu6ObguEHqUwzT8ARpegkxQX
	 9E/snuk5aEMLx2tb/4G9PAZVQbXatSrffNkIw9ofUe1EV0EoK02ecib+9mW7WkM4WV+ce
	 mSSyAMgXBYPJPefZSnECeB1rR8y5IbwOGfNYfcr8luhIoKmbleAEafqMwHP5OcXpFTo1a
	 hT/e8UxT88oe15d41gKtdZNtsD4BGkRnM/XJejB8W/FZTU+LuNxPVbG/n9wLuL+bmLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0vyVz3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EEF606A31C;
	Thu, 19 Nov 2026 01:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0vyVz3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE031F000C4;
	Thu, 19 Nov 2026 01:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051121;
	bh=kcSz5DGP9fRayI+qKnWcLDYXJwByDAsoRP5dggpRCPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0vyVz3PNYFMH0MA7XFkmgImm1wyD4xUfQJQzhxpaFm1skV2MOT458iChMeWj2ab2
	 RmLNCqF5amTWDbBcEHlLbegYyS/q3uW4wLH0b8TGFsrRUx/S5Bwr6wxuaRh4oEwTGK
	 SoEDKw2e0YJowBu1UnFkb1azDhohYmTm2v3gLpCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0097/2214] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:29:33 +0100
Message-ID: <20261118150013.832544596@linuxfoundation.org>
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

[ Upstream commit 1bc9538df6be8dac8727179d8bcc0d880648361b ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/quatech_daqp_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/quatech_daqp_cs.c b/drivers/comedi/drivers/quatech_daqp_cs.c
index fe4408ebf6b3b..c6d0e614d63bc 100644
--- a/drivers/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/comedi/drivers/quatech_daqp_cs.c
@@ -212,13 +212,15 @@ static irqreturn_t daqp_interrupt(int irq, void *dev_id)
 {
 	struct comedi_device *dev = dev_id;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	int loop_limit = 10000;
 	int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	cmd = &s->async->cmd;
+
 	status = inb(dev->iobase + DAQP_STATUS_REG);
 	if (!(status & DAQP_STATUS_EVENTS))
 		return IRQ_NONE;
-- 
2.53.0



