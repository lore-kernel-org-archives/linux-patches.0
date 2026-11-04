Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829582;
	b=C7PfgJIjAnlWwef185M9xom1ZxZdykaU2ueBl+Q+R5+f2NUBOdf/hzSQ7qAn7IwqJt0P
	 su95QuG5pE9jnOYN3P2osiIrS8pHM0aQCevd/jO5GEBBJ5876SF+grO4bbS8uIB0RekVs
	 bneTkTgN1E4S1WrZFPnGKmL9tqMaRl6LBEQxkOxgOpJybEJLwgz89xWN593t79THRCZv+
	 Hpwiq0weje7/NZGr2rOSwsSDOZ1bJR73UzTdI3L8vdtAIQ4auhb+vWf4wrkAIp65BstWI
	 kIdPNUInIjrmb9LlDvoNOF7JmFQFrXfp3vQ7+6tWIkX2u84KXkuh4a/ilHYq6p65oDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s56BQbdHrHdyJ8hqPRbn4/69fy5UAuUcDsV+VPq2izs=;
	b=SepZ8SX+JZ4ko4ZQ7A8lPAJV+qNJF9BBjD9021d2vNGb7ON1LsVLUVF2yT841Q12xWBp
	 9b873dP2ilNYT23ggKC0OMuD7uc0bOkw1LwrMXmTD0PIwI/VyIY5+1RAAZQAQzp8w1dMn
	 7Y1G22iJ/gBOxGhZpCA18FJMoLeQBU3qfgj8iNfaZqyzCwEZnw9S5dFRS6wfXf7gWZDaN
	 IXCVgt5CCKtbSq8FehkW/jcN7Va/ja3KHK4mp2qmkg67v3WfFmGJpLroYno1FQXnA30G7
	 COGEAamwgc4hE0qditA5qdUbmGyIovh8kmgQqtqiRNG0M/tLMGzTyYumS2gNO11/xBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBv9wN3+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0339B606A33E;
	Wed,  4 Nov 2026 21:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBv9wN3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEC11F00A16;
	Wed,  4 Nov 2026 21:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829581;
	bh=s56BQbdHrHdyJ8hqPRbn4/69fy5UAuUcDsV+VPq2izs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBv9wN3+3my8vr17AVXlZcv6gnONTZnW93hS1foFiKw9MO0Hi6Q+73HOtjfWk+Ozo
	 1oEIF5mpMHOblDiSxx2S/+JWRNgrxCDeWGI17UOfEpVv+HdfB+k99WMabTfWsuds7M
	 glg+8UjtnfmFEaCRRUxLBBnGoznA5lokaLRhyb3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0179/1005] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Wed,  4 Nov 2026 15:58:32 -0500
Message-ID: <20261104211048.796518015@linuxfoundation.org>
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



