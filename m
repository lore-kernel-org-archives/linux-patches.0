Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019811;
	b=zR5uDdRGcUp5mN1k4J0LIAQh3/hOOmuCLD/k+GN4db80GsoxDasK02DNP/EyRgmP9HSw
	 EihtA3KriXIxvjMBXDQBASOQK3d7V1XvqKr3ZKCQGylGT+uN2l+MfrOxEpTha8tObUIG2
	 Y5H+FYMMkMAFwe4X304pL7MBUniZuQHuwXiNDg+2T2HEExn5wUnhJvJa36wCQ4LNnw/fL
	 lhL/IZ2rxl8ueQibf1K04aqjBQPi+kq/u01wRu/qdMuxg9zxHs//8t+2qceG3byx9HTLr
	 UKGxn33qI8Ly9z4Q/GNSL8yu7Kzrj+sssxGwjS/kwe4TOG2SYI2IPsd6zoCvFEJ8Mgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WN1NLfnbUwAiXO3T96W223fxvE/P2yX3Oy2sqwySWGA=;
	b=tUCy9APBbvp8dBhQPkIEHU1Yi+rWzSke9aris6vTnol7m0a/jFN0U25KA5QXokpeQOv6
	 89HANotZWlPpGy4bKzVaKwgaPk8q3mIz+KKFUqt1ngUMU2rVGGo83AtznDbZ/3JWcTIBH
	 oHvajMy4x7vflPoI45rZJZUNU/0Js87kottPw6mIqFNnHdnzl5KPV5H9PyB2Eq8NH+OWP
	 H9FzAPIVDQOnMG29091jkApbMEFDnTQermDY3E5JrT6KrF8fnPqErz1haIb3EdVt1PhvN
	 6iZ81WaPkKR0BZ2AGHCaaRFXUbZNRjkPp80DzaJMqHHmBhWruvAtEm3ki0/O4xa0wOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrXRFhlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0E606A32A;
	Wed, 18 Nov 2026 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrXRFhlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF31F000C4;
	Wed, 18 Nov 2026 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019811;
	bh=WN1NLfnbUwAiXO3T96W223fxvE/P2yX3Oy2sqwySWGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrXRFhlv3CqRzLoLu4A6ckyyCMQWkVLrms0ppT71rwcCKyb2AprysyrIIzywX+RoB
	 X45GN8hu+rKAX92iLysZ128HAsVCc61ajEvNC7Nx8VMXgHeUFS2T6aVrJtjfb9m6ru
	 jSfLfQo5p1CLCUpbsVbZgwb9D79cN5cFIGDWpA54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1729/2651] comedi: dmm32at: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:49:29 +0100
Message-ID: <20261118150349.871130636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 797d56d7f90864e67424f8e82639a9b3aedf37e0 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. dmm32at passes it to
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

Fixes: 3c501880ac44 ("Staging: comedi: add dmm32at driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-5-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dmm32at.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dmm32at.c b/drivers/comedi/drivers/dmm32at.c
index d1d9f75e168f2..c6a6ba2899e6d 100644
--- a/drivers/comedi/drivers/dmm32at.c
+++ b/drivers/comedi/drivers/dmm32at.c
@@ -600,7 +600,8 @@ static int dmm32at_attach(struct comedi_device *dev,
 		return ret;
 	}
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dmm32at_isr, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



