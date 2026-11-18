Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057312;
	b=tL2ezk92CyTaN+uSvcuodTV0KM6PAnmbK3Wwfm5qu544nVNaYvJ9HvJ4nnRpQlHRCfC9
	 uIeOdLuBrZLE6NOV0lT2Pm5bgL9tKpDYwUtUe/PDzkQJVMX4Dg8BfMmzOsKQQyHBu1lvC
	 nJbdf5yosfJDggxOVLRvjPQ1KlnxXFj+da6dNpwHWtk+3ghO+OZwY5c2lXiYvBjWBV75o
	 TWqE0/oC9qV54C4LXCkalV4RBkx0rQMwAtPOCOz4SEjk59+1dGzuup7XDGZlqEijKTNuE
	 B8OtaxE0Tj8v0Se06bEq/xRk5mDjYrNjA1pB3k5ulbfkU9oW7fE0/UKAXJmVHJs8rKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CXFabkO/8kxCG7q5GixAxjKWbj1PxNoQ8/Me4bWtnnc=;
	b=nBgSuAtApsFPowUuN4jyllOTsubWjRYPeo1v4tPBOFWQ0aT78y2SJwFAJyM2lET3fKXN
	 fBfq1wMdofbcpTSbetChyWIJs4bHZSElzDYTEDj7JEEjEkiX8SdBX0CnjvVKAWtyiPNbq
	 UBANo9xOvorLrjMoa2U4gJ1L8HZTltdu7+7GkrC/+Zj439q5dENqAgoWrrDH7o61dBa2J
	 BO73Coe5XYx4FZLv7Djx8xD/4LMFMw2nrxuJ5JPsTus7UyPLegaReMI3y+CnTrxUVaF7T
	 g0oqEH39EbuTgR1kHGN7wUSoKToj4Mo0jV4SthX4m4jN6mJdKHzz9GJNkz+GuHVgffA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIThjyr6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9060A383B;
	Thu, 19 Nov 2026 03:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIThjyr6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE181F000CB;
	Thu, 19 Nov 2026 03:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057312;
	bh=CXFabkO/8kxCG7q5GixAxjKWbj1PxNoQ8/Me4bWtnnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIThjyr68I3T3C0NYht7PK6tlAGpOkcE10tOfMHV2b+znBfSV9TwvZXJXpML3rdZo
	 aoIr4+vcV/4wsXGmTlgiqLc495L0kHgCzIJHAIYsO0ThxIm32oKzeW8q/I3CKM7/Kv
	 tpZSXCeTs4q+M4QDFTAIY85i+kX+ZygGcm4cjoRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0085/1848] comedi: das6402: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:35:23 +0100
Message-ID: <20261118145914.700053693@linuxfoundation.org>
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
 drivers/staging/comedi/drivers/das6402.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 927d4b832ecc6..fee77c5b0e097 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -175,10 +175,16 @@ static irqreturn_t das6402_interrupt(int irq, void *d)
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



