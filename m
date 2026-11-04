Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829587;
	b=qpwBX6u2XCrXD3XU4Ga5HNZB8Lmz8aAbaCKpXuZIe2JeqnmdDegq62ILwqFCJ6Cueuoa
	 DqCWNgpKOgMS7kwQiaXw37zHlWX4duhOXQZz+6uids5MbpmENIuzFrAOGljTW+LALX9jQ
	 B3lSfi7ZxLVPm0hCHDR1T2BiJ00m/BfofgW0aWJ/yRrUsC7IHPM4dC8Z9ZfCIIa1H2gh4
	 R7eywBbZXeV85mJrCOVIYpi7fJzpXmilbWCm1FFXvLFLgxMY+ykxw3q/tXzUPt9VSFJL5
	 rfqKTK4+4Fv9cbv40LO8DAjeuY/lczBKDfxes/PmefHQ+kQk43DN3qNn2tk4ud+vTMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Wj6du2UIernlAAEGX4Zm/zR7NRxQ53cT+ZwyA3SJL4=;
	b=f/qOsc7K9c63Pev+ttuKfyd86KVN6L16kQQgeg0sy8/j4B0NYwQy75Xn7CkiGWzVXjBR
	 kj4JvpaH7fnPJ+Qh07NvnfRrQfBrDkb1B6YkUAJLLURV6c/mZ0rghSmqGS9RJBtSQMyqR
	 bWH2sjCKpZtolubBjrWr3Nvp/eAH1cAHxOIy92ctIW7/2Wc7bA8gxQCO6EwtpdSlMB6PX
	 RmCRR4tVmLdT1g+GKm1xAjjLf39KDqubuPc3afwEoI3foeNtRcFxRxX8+DAtQSKIUhl+M
	 F4laI4slGQUQ8+9mv02J7WbGm/cQu+h9uq2T+4XBgx+FgcnPICOj3lPGBeKdwcczpkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwPXlY8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00886075265;
	Wed,  4 Nov 2026 21:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwPXlY8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCA11F0093A;
	Wed,  4 Nov 2026 21:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829586;
	bh=4Wj6du2UIernlAAEGX4Zm/zR7NRxQ53cT+ZwyA3SJL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwPXlY8nEPAZcc/MvqyNsFa4sI2j5G0pgX+9ls5WdU6a9v+7plxUpBzB2qIdZvbuD
	 345Ar0jSQMFzCbknXiaGXH/fI0F/tgl/ugFsMGHLK4zhxVHaskgNEL4/3zbxqNBzmJ
	 /8eD6Qv397xnoPqv8sq2Q/fDP+KrbAC/CPz8SXGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0180/1005] comedi: das6402: Add sanity check to interrupt handler
Date: Wed,  4 Nov 2026 15:58:33 -0500
Message-ID: <20261104211048.824433609@linuxfoundation.org>
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



