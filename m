Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056119;
	b=iC3Leyl8zr3z1YN1zENUx/3S1fOJsJ6Mw4xMWGyCsOjNbLJJ1y0mQiCjqflLeRjNJwBi
	 PPCoOB54B0oLS1PLakGfXPEhUKJ2SnGQKBkEX6so3JcXNyWTyhxnsG9e7AOBGvO4Qz4iG
	 Wlnwz4rKlQF6MPej0Tn8ZYxrfLV+/lVGo+uvNyfVo+pL2o1wy3vGOeIsZ75J8DRLIuh67
	 JKVPytg5pNGxrDYtkAU7Zr+5O7X0zfqdcTA97p8DYgSCAzefRIeKU3oLCLcUtjaq1dkt/
	 t2YzhPh3H5O780z4cnYFYpMvFA7nOsL9oMFMQaG/ddrhwzYgL2YcopSMEOlRZyoROAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fXGp0lRLRG/9kqK+h8zlxmq7vM1wKiUfgxv6DIues60=;
	b=aCAclnsT3rT9EEQovce8hcvgmr77WFjrG5obc3AkVa50t0M1utfj2BjQiOD4YYXWInFx
	 GWlFXSekVzfIJZspWQRjkH5XGo2HanuExnoUW4WLXHAIG0vAIer5RmPmd5KHZO+GYs8rP
	 6Ls4+5RHVwYeJdgFJyAeVRTC58xtV144wdYspA4+P/I1Ho2ghOVbXHoL+P0K4vweYQiyR
	 QsQxgyVI1lgAUgZ/Ko/Q6wSOKSGrGhtZDG5nkfJQf7ZDaW0Zq6SwAkAcW9nfPGrQuvDTN
	 vtxNZlsZJTj8VJmabKq16KPcWgLiNl3OJWta6pDVFlMD8mwQthnL5wOrOnImENtfQzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLeuiRA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5DA606A32F;
	Thu, 19 Nov 2026 02:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLeuiRA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CF01F000C4;
	Thu, 19 Nov 2026 02:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056119;
	bh=fXGp0lRLRG/9kqK+h8zlxmq7vM1wKiUfgxv6DIues60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLeuiRA4qvhpb/gjz0Lz7zCj/VBS7YHM02H2ZS6e/0wUVpJu2Px9b4iswQPPMxtYH
	 KZuAbu+HoYXw6YsoCX3GDH3s9lu6YmT/FhN2/diQfv8TGH6/Q/feaxqBFJooG6TLQl
	 a+9M+hlKTFxjdZ4lza7yYFl1+Jy0VQu1IYSws82k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1875/2214] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:59:11 +0100
Message-ID: <20261118150126.282769707@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 23c6fc62e754f8bc412ceb5c0d9aaa14f2c9ff31 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. pcmmio passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

The board's interrupt is routed in software rather than jumpered, and the
driver notes that "any IRQ from 1-15 is OK", so the ISA range is exactly
the right bound.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: 6baef150380d ("Staging: comedi: add pcmmio and pcmuio drivers")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-6-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmmio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index d1cd4bc7f36e8..1ff08455d42fe 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -684,7 +684,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmmio_reset(dev);
 
-	if (it->options[1]) {
+	/* the irq is configured in software, so any ISA irq is OK */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], interrupt_pcmmio, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {
-- 
2.53.0



