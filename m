Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060735;
	b=ObSpJm8qW8FJNwTy9iRSQeASqF7bt1cg47ceWfgNfnW3Cv4LN+LM1xnHrUdD+uNV+ArC
	 svWjZ6iFYvMkrlS2C+hwcHwzoOc4FAJV+DTi75csMvPz8wPA3mmfZFeXT7NJuXQnekOr8
	 5lJqwdS39H6PCQ4u93nsSe4yHQoxsCfiQrTfI2aWOjmwJAO6oA2CcnBzceOOrAGsbczYI
	 ncW0PDFoiGdgUFV0D3WJl1p56GkrmW5p1X5FWjuI/9qkU9tONQ2y3V6AUxMf6fO79KxXV
	 xNx2eQRLQs/vwbqS8IF4uEjg42J/fALziP/hyIC+EA7zVT2+ErOFxV0d/9u5wXObLGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKYlVO4BPJtPK9kAGekUAMVHdkP2x7XntsLMdvh85fo=;
	b=kkVh/rrDXDCSWHClfvneEPV9WT5yJgE5pTHsDbupDu566J9bpWca/7XrGiU2BsV8++Ia
	 PtRuul1awCIJzHXVKt+KEAXr3vGV+LXygafVmU99oDzw2sBlMeiyNofGTIrDxTenfFPGD
	 I3bqO9WvP3ekOkzTEKAxxrHsnXRRC97UzRoYZtXOcgVbAzYAI+WV+gmLQe/zJPvMjBFLG
	 2uxgUIPMWIVtndP4UFc4M1Q2vuSOKSldIdmPu887MW3fZbjebvpiH6CTkds1Aml9QkBs9
	 1KXoHu9/XyJjhaphY5InuOcbfs8sNTfBsAX7xvmRfcIRVfgaubD/4KN93e3adYmFl/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tQ2m1sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C424606A326;
	Sat,  7 Nov 2026 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tQ2m1sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED391F0089F;
	Sat,  7 Nov 2026 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060735;
	bh=EKYlVO4BPJtPK9kAGekUAMVHdkP2x7XntsLMdvh85fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tQ2m1smXwp8apUVvqVjHCMnq5N8IrbSiPiN2Bp7E7xS4Eyqu8aYrn9+jjjVTpk+9
	 4an9NNd/kLF7otHIHgeDAqJiS0VytQFilxCO+95SMSpb6TuPd2YRHEyc3cXESCrhwt
	 H8dacY4K6u/N1aysYjpqBKLsfR/yMhWKOLoqlU/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0152/1536] comedi: pcmmio: Add sanity check to interrupt handler
Date: Sat,  7 Nov 2026 08:36:08 -0500
Message-ID: <20261107135001.950719694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit ea72e2fc9026f375314421ddfa4dbdc49432a899 ]

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
Link: https://patch.msgid.link/20260618102949.26607-10-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index c2402239d5513..db9cb3fedb48d 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -362,6 +362,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 	unsigned int triggered;
 	unsigned char int_pend;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	/* are there any interrupts pending */
 	int_pend = inb(dev->iobase + PCMMIO_INT_PENDING_REG) & 0x07;
 	if (!int_pend)
-- 
2.53.0



