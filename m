Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061640;
	b=YDY2TOmF0h48JSpb6ftvmazgl3mAGz2YLO9r0XQw80vnaW9vI8mzX0K9hnojD+m8yOJh
	 kvLErws8JECkZ1OSc6RHblGUkepu39wmoYBGBjOcIcUamu806SA3hn/eWzTaM1hjDIea9
	 yN2vp7zcHBRcEPUiTkmR1xwJ6h/8QLxMD5aBrXUfhWKWq4yJbey+lgl+lxlWbF0vLmiJm
	 PXaa/HJiC0jdro7ClTZTLp2qVlorXXOPM1woUOPQ/3nEZRUAotdzdoySmLXRY/BwCpJwk
	 l/FB0IS9z3lsHuqHbFvwOk7urUpvkuXEeZMh5HTehkgpxmOPZsgkQyNJBOo7qRckR1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6lfYlIiQxMvAYnsL3fUAWLlcKyItXCgNgAkeQAtYm4o=;
	b=QqgCVRuvAVmTwtCuYY2FhGVtazf5A1KcrwobKYtl5pINh6/wtw94YSvzEl3Oe+Kf3v5U
	 0cVqsDv9PvpKZ6x3pIQ7fYsZlkEOCGNGa64MACKuuK8tNh4+XSNEnQf8GFK6CiVfSF6x4
	 82g5ICCSh2rI3C/GAbEqIsaujEUUKqxxPvKlxyg9HpaZPCaKD4y2wocTMdibxSwRUSxxR
	 mSOJhwPFYWUwztVJcLQ+XIbIoquXmpEHdYLAQNcGSEK0P3x6d7XJuFoAoqZlUZ+JVr3/O
	 49UZQf5v1+n573wOUBnu/HdNVUspzPBG5exhIz/xotZ/N+85nvdLbANIucVleHfp93Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RY2wKuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEB8606A32A;
	Thu, 19 Nov 2026 04:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RY2wKuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F3B1F000C4;
	Thu, 19 Nov 2026 04:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061640;
	bh=6lfYlIiQxMvAYnsL3fUAWLlcKyItXCgNgAkeQAtYm4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RY2wKuSSBu3++DLcOk3A/LGmc8xVfSqVOxKQ+tFPnKpEbPKAiULZOZcu9lrjq0Yf
	 X/fOoVnpJXwrZuwwXf7CM9Vt+E3G0WBYmaRS1bq7arsrt8EgKDRqLCT8iB/tMqillj
	 ptj3IoLDQFWuvvRhMNBeGXxtU7pnapIuNWS/JKH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1598/1848] comedi: pcmuio: validate the IRQs supplied by userspace
Date: Wed, 18 Nov 2026 16:00:36 +0100
Message-ID: <20261118150026.371466265@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 9c325b21bba99e597771137fc11b9427c86618d8 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. pcmuio passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

Every interrupt this board can assert is a legacy ISA one, so the ISA
range is the right bound; it is also sufficient, because
mp_chip_data->isa_irq is set only by alloc_isa_irq_from_domain() and
mp_unmap_irq() returns early when it is set.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

This board takes two interrupts, one per ASIC, so options[1] and
options[2] both need the check. The existing options[2] == dev->irq case
is left alone: it covers both ASICs sharing one interrupt and neither
having one, and by then options[1] has already been validated.

Fixes: 6baef150380d ("Staging: comedi: add pcmmio and pcmuio drivers")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-7-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/pcmuio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index ae12a70534151..9e3af643e8c44 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -546,7 +546,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmuio_reset(dev);
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		/* request the irq for the 1st asic */
 		ret = request_irq(it->options[1], pcmuio_interrupt, 0,
 				  dev->board_name, dev);
@@ -558,7 +559,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (it->options[2] == dev->irq) {
 			/* the same irq (or none) is used by both asics */
 			devpriv->irq2 = it->options[2];
-		} else if (it->options[2]) {
+		} else if (it->options[2] >= 1 && it->options[2] <= 15) {
 			/* request the irq for the 2nd asic */
 			ret = request_irq(it->options[2], pcmuio_interrupt, 0,
 					  dev->board_name, dev);
-- 
2.53.0



