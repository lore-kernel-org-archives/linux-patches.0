Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057315;
	b=Kl8OrNCENA5kUA5On3wKo+7ntrfQiQoJa69dnOPPdvlbmtMLk89YNLhWDVNGSo8WgAc/
	 TMn4M9NcaUa7aSdhiUKIQ2i+2ukbBlRRBcmHVtnR0j8M6StXJ2qHFbZEQIlu/NqnDDv5J
	 pBugs6RpczjYJEnrFogAOFiGREkDBwQUdJuBNTXjJUhCfFW9WkI94cHBsrt12A5CLqdVW
	 x72OQQwe1+Rvff84VG9skzOo2NXF6obippA73sgFrREFIbl/8IRTGkydbVsDMu8mXrWrO
	 NmozqXyMKQeVfMB+QEuzEvYcCdmjxuvWoxOtuFMn7+a1oDU0N9OuVicqt2dajoRjN1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5OCndS6Qx1CpWDHYlx6mRbi4iAWEEZG9qbaUXjKoYl4=;
	b=HRltduDZcD8YrpzGMW3nkU7+nl7vh1xCXsIvLfnkLQqkd6H0ZzGAX1BZybfktjljOcL6
	 nNibPzsg90sjfvbJSx5B+a/nkgjIUkF0OC2BVQQOqiZxFZQHXUgkZEJEtw7Z/Gg341gBN
	 6AS2G0BSWjPpaMgU2dQVfJSDZ8DiegnkuWNNdnG6BaxCSRuSqpORNRD91fdaY3YF/2mRg
	 LHgp+gMCvZsIW0Lfj5BMt11UE6izlzitET7pPffSsQXHsAKIWgJhZrABooTCfSrFZD+d1
	 hAU5olVbtcaoMUBH1wX/m3+ONHAKVZs0BZ5rvY29ggkUTMO8wXCZ/IzNEHg2rDdlE+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h4cnia2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B6560A6F54;
	Thu, 19 Nov 2026 03:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4cnia2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997FF1F000C4;
	Thu, 19 Nov 2026 03:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057315;
	bh=5OCndS6Qx1CpWDHYlx6mRbi4iAWEEZG9qbaUXjKoYl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4cnia2/XyD9H8SIG+0w2WAcW5EDe10Rt9gDcDsFNsUXR15TiTSZUL7mxNdnmmU6m
	 Zn61xDXb/QYfNVN4ygvhwoFjCmtn9c/l6rbJMAleidH2wl5eoTdM96HqMbdgFNx7FA
	 9AA94Vbng/IpTmpZE2IxUViuONhXkLvFI/JElbkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0086/1848] comedi: dt2811: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:35:24 +0100
Message-ID: <20261118145914.730495534@linuxfoundation.org>
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

[ Upstream commit 8dda63825752ab19fcbc2a19ecab91d128112415 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing dev->read_subdev, which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-4-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/dt2811.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 0eb5e6ba69160..d94d3c64e264b 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -194,13 +194,16 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DT2811_ADCSR_REG);
 
 	if (status & DT2811_ADCSR_ADERROR) {
-- 
2.53.0



