Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051138;
	b=u/exZBMTEkAMdsmJns7Kkkuo+qLqDFT5bd/8UUZQrEbByUEuAV/wi7CsOiIxh5aVhOg6
	 p5YPnRjpKoYMpi5OsNNttDkwBseLpZYIIDBEFLH03d58bCmtaSxBzSxAAdHRgSDaXOFbG
	 pVSbICYMIDBjzB4kx7t/31UdOoDjBlIQjmQuu8jmW2avdQdjw6dZ2f1u63f1wuL3ZQTmg
	 XIYfm7C8XJysalakA9r9wSeAyfWl5JyNr/lZ07f6dCjK3XvwwFoKkp38D0L2OvN7Lsp0c
	 l11ah79Y9J8jYGfP712xslgb7QGYcYSt9imtUXy5wK7er9flWqxA1FsnqW4L3MoWC4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V2MyKhN9P0OGpbZ5v6LDlAcP6g59I1pWeXjnZ8YQGME=;
	b=V92x9xCZ5sGd1ThKmaJlzZxJ7R64JhVEff9jQTDHl5PMpG+jn7LvE+IKiur7I0+VGilP
	 RhirZOI4Pn6avACHmlnyzpTvUO5iLyMJ1DSkWAfTZYJUSZMR86u8B+LbPKo5wpiVbZKG+
	 uM5m/PIja/xfF/mk1PnFeSUxAROqrBCxPH99j+lUadt2Lucrgy8tn6viy6kp5ULE9UdTd
	 pIT1XcUSehPHZJk4jAOB2zp6slaB/958FowVp6Q5/yrCYQgPROQZb8IWOphAqRlLBpwrv
	 ioFWTEVTD3akpIXLF4eIx4X9RmuXJYZy/SXlSrlAOlyn63k8SEGh2LL7yOtJDu8no8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPDhDa2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C70606A332;
	Thu, 19 Nov 2026 01:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPDhDa2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4901F000C4;
	Thu, 19 Nov 2026 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051138;
	bh=V2MyKhN9P0OGpbZ5v6LDlAcP6g59I1pWeXjnZ8YQGME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPDhDa2D1CUWCIWIQqVz5MmizaUf1CkKEr4gFT2Fw+bietwtna7mVs+8r4PcH8fCe
	 kDpAPT8RH1lhxHzX6b1A/9tMPsd7smreaqeXKTnmVBlQC68rZdg4kJu45rOOxtLoeJ
	 QLRLlfdkR2zXr7oGvUx2MQV5CNe6RzYlIXtVmwIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0102/2214] comedi: pcmmio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:29:38 +0100
Message-ID: <20261118150014.013282535@linuxfoundation.org>
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
index 24a9568d33788..d1cd4bc7f36e8 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -363,6 +363,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
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



