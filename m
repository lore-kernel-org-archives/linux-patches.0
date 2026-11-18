Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033746;
	b=njnyAOEaPIsILQqyThsfxr7xr1xjKpyxUwMmoybo3pWxVAIzCSC/RHRRDqUqCAevc2mW
	 w3rSqoIS3oFR822419UwE7ttGeXCQyt8LXapMkAfl/lad7FO7h7vnIXm0g6LwJmYgaWts
	 +ZjDgzS4SnEesdkD0q8ZOkjTAJM+Q6REKqAuOjrVfKOwbYmoNZXZoTNUNz+ZwJatmRsYN
	 bDz12yeJ85wGuif+Tv2owU7nQd0GGasziqSJQx4IjMiiSR5jXMsgB9MSlBeYsK3Wuk/Rl
	 1pwS4vUxR0FXPxYnt9I8u20efXSZXll7SbwjWirTexxrlYZquAj/JrPgLOZDZfV0ItA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4G6eBPlR22LQPTOGuuHm964ggW2S/rMElQ6kIlK5h4=;
	b=HB0SVlIFXe0Z1EiaPk2Gp+iiJiRTzn/RW6JCJZqaTECWfPItTsE8p+skWZ6WhGCn8qtD
	 UrHVzD8Ialkcj7ZKr0Cz7jp7U8sYW7LIeQ+/NBM7tZfFWtCymUA+Z4IhJj/z4CmaLB/cC
	 /JqkpywgV8MhEERHjW25H5yvQ8Rzv2+8OyWVZDtMFXMo1qr7KpDLy/I5/yK0UYuY+AZKm
	 BRgZOFT5wgndNnmfX9mqgPFtwr9awv8tueJoALuCKEDJorZzPqtNtb0yR2OnG55s5CoFv
	 ZtN4wi/16P9sYCrvwt0kUDoHjl8EYGXeoe0A0igL6f/O/VxKKaWheCZVNaFVBSbtUTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwSQrAMT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85078606A325;
	Wed, 18 Nov 2026 20:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwSQrAMT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74951F000C4;
	Wed, 18 Nov 2026 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033746;
	bh=L4G6eBPlR22LQPTOGuuHm964ggW2S/rMElQ6kIlK5h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwSQrAMTdK/kv25oVl5Mp+wD9ntFMbvD0wRae1fg3T1hdD1mgYUSIOVQCxDdBCTBw
	 IMmFj4OHM3cz2B1G2GiXcYkcb7onb1Zq+4flWY/8bGaom47s8WU/pdyPMRSjaYAdv0
	 NOpOGhRiwkbzISCfMNby68TB7AiG9cVMia2CaFAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0125/3318] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:12:27 +0100
Message-ID: <20261118150318.102694597@linuxfoundation.org>
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
index 2a76c75c513b8..d5e3e213e233b 100644
--- a/drivers/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/comedi/drivers/quatech_daqp_cs.c
@@ -211,13 +211,15 @@ static irqreturn_t daqp_interrupt(int irq, void *dev_id)
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



