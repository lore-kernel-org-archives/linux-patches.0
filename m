Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031638;
	b=WXiIPOGkSIBoxuiDyD36O6iB+iP0Ssjsvl9gp78yAYNJApsmsPlREtOQAA83cB05E3i7
	 5y3H7eVc2Z5XfdkqDwEXIv7tl9Yq8jLZ4nuT4PuOBRRnE6TSKF8i1iDtXsDojP2FVETnk
	 5JLWLoM7T3UFCkNEeApqibXNmph0sU3eibNaOh9/HuZsy9/x9pRxedXhpYpS14kz53YuH
	 YM1Y0BNF20MF4ijDsW98tjIJIqRYSOq+Vah5JQ0be65zNE08JEzAEsG90ag8NuKy2163K
	 JnxXECPntNOP8O4Fzkz8DtBS7b4jeZipzHRQdqyKDrO1nUvbtuO8MRTElfoUaAWPfew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmTyuRlk2pPeGUW+ehKJdcGKW0EyWZlsI9kA+gJse/Y=;
	b=d9vzf3uF8CWZ1aOZaYC8iA2/6aqhgzGX1Z9ohl/pVy69NPE+D21EprpcHsq51EsCfcJQ
	 WuwXY3taQwqA5UWkFfputxcPK1Nn4v1KIXKaIUL5+ymJlcQlkU6Va0t25zNbzenTfh2dX
	 cy4igAKJlc6k4QljPNAHXRsiMAgaPjSNRiVW2cgTN5p/mjfNbPQa2tjyitJVALsAAUNm4
	 908hz+kN0f/nbzXqbJHnBjmzzLlI3ltNvgSp857vCE/yT3PFOOeNlI+aXXugnLEl1vhsi
	 1/HkzuyQ7N7tvOm2auKzf+jaxy549hrXML/a9Ay9Lz9yFtjoKGfHGaOrUVw+tq/KNmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVuweKbo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596B6606A320;
	Wed, 18 Nov 2026 19:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVuweKbo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A193D1F000C5;
	Wed, 18 Nov 2026 19:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031638;
	bh=qmTyuRlk2pPeGUW+ehKJdcGKW0EyWZlsI9kA+gJse/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVuweKboS8QNLYG4T+ZpuCfqnE3KmhTG9aRErrgrrCjAVcbJsY/Lwkfqm8QPPabdZ
	 W98An50M3ecYLaeYWRbI3lH/b3QpeVlO36YywowvREKhaI7KAqRegBpC9r4U7crKwO
	 X3MKvzs+bp++ZKLBxHmCR0PDjaXj45BwXLC5OT4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1128/1756] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:54:15 +0100
Message-ID: <20261118150054.994203126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index db9cb3fedb48d..cd8b02e6ddc04 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -683,7 +683,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmmio_reset(dev);
 
-	if (it->options[1]) {
+	/* the irq is configured in software, so any ISA irq is OK */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], interrupt_pcmmio, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {
-- 
2.53.0



