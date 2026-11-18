Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043265;
	b=R4HOmJ1rs3mNlePWQVk+eFg1hXnRDXwVBieBk2F46+oav+hK9LRaa+9JIcJXAfLwQ/Ea
	 I5TfE8hiO43izfQVGP3fhXeYOSBzAxrqp3VT9xU67gxDnVlYxLRFpJVjk3Z3YJB7LsDLT
	 jQAkevsWT6cbycVUINCQt/OKRN8lboa2DsCmflvetTm98ouWJc2K8s31x7YPfR2AT04Pi
	 wGV4INCa65wynX+ZzWGLnNfe6OfJaatLsYGT33z7BRe9MhlbKcGvaNXhfHkHwMSq5egG9
	 +4znl1lP14sQdvm0GrwuRJwasAV5fGgyXwYA6ESP9xoBUSLENddtTPZNSspFVutuGRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bqiP70fyv86B43560bsDYJNc/1QNHQEuZ7gXfiPJJm8=;
	b=etVdux54v5B277oJ6WIQ0htPc6TcXzZOC+VM7BrCgPl1N0WXcKmjpd6VYIjFCNdq8TV5
	 trp0MHmz7mMJ1jZDHDzJng5tZCE1P3zCn35riEq4/LQ6wL4t7pUAYQU0yCtHqemPB2spg
	 q3lFh9A30lQtpz0lDl2OkJ+XZKADj1C+muAF6v6u92rnhwAlvmW8YCdoub9R1J6BFYJiu
	 QJMU9KlWeZDaPq5F7VaIh3UtWYV09KEN8rW9GbjoODbOlxAR6YFy2aEjJgUpK6rPl/H0A
	 30PoVqMW6V9Ap4d+YiPzNJVZYA0KjSkYtRb+cDcK9DsjnhyKaz2IQtxXJBJpnPanWvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tri75/IW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59773606A32C;
	Wed, 18 Nov 2026 23:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tri75/IW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F071F000C4;
	Wed, 18 Nov 2026 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043265;
	bh=bqiP70fyv86B43560bsDYJNc/1QNHQEuZ7gXfiPJJm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tri75/IW0n7PXssffFI/e8dqD82G79Vmk5VYHL2M00yjIYG/Ll+vvtzOhz8ujhZyn
	 dCxdxk48K3wV6/XEy2dsCp8E+UadHNYsn7g4eR0YKTuQWpqqVxpA/dq+noPzZl8A/L
	 z66L57d/9CPPq5LS2SaPr6oK6JNLas+qylMQICuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0108/2857] comedi: das6402: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:19:02 +0100
Message-ID: <20261118150205.143580128@linuxfoundation.org>
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
index e730668236c26..c6d28ff45725e 100644
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



