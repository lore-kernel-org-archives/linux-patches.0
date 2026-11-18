Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031635;
	b=A1XpCyGSASu9sVVj44VhwGYWiePdnCRNNwKNCpgnUSMYGMcjXOQxV9MYT7Ti1aDlr5Bg
	 0dtFRV3+gJZbwoc16WY1ix69gwfLdntX9L2NqMAIYux6lDbPhEXpNpxrH2+KqYe/N48ik
	 pwvK9or1Fu+HqlgiVl+TRz2zbq6D6xpTVPJh0QrRrU0ApkNfTiIsA+KpkzeY834nTIjyZ
	 gYUjL2de5PzKf7g5IjMmmYwlxxwUcE/Vnz5b/Xd8axUrcoxCsNgPdMq4oQ/MenYXvQTKn
	 A9gPpTFAgOxL2lhdLNSH3U6UQ/bWifWoA1BvTwRGGYLR978BIx8ZxjcKK3mCFQysI1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6N6qdmfnG1WiTFmJM3vXqGqxAazRKodLmjINa2trD+Q=;
	b=oQNNjsubpRXzeSyaDMUf7+ATD/bu95js8cQGheO6bqxHuR4unmW9KkE9yx56ge1cOjvO
	 87vTnfsVBgek6v+Ht4dGkuRdekj4sCS+liJxUJO7rseP8MSTbH0+uwekGEGlmlRpOIz0g
	 WzB8BOKuFYw+dfSTcCPtM3XloLuBLLjnyTsBmREvuwEyWtKSmn5EyV7X3/BT5DAD30Gak
	 01VmIpY8aLD+h5SS5Sj+UxFTO2bXtWKwckWYgOgFoGH+7oFn/D5ucatDWQcXLZ4YFYoYT
	 qnACglSllU+9fLXl62/ZZz/HBro6iKaOrnQF8NxjTYpKtJGlrc4h6VFMCxcMsQ50d/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1xQW1SW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA49606A33E;
	Wed, 18 Nov 2026 19:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1xQW1SW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02F01F000C7;
	Wed, 18 Nov 2026 19:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031635;
	bh=6N6qdmfnG1WiTFmJM3vXqGqxAazRKodLmjINa2trD+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1xQW1SW2mp8wYuZed3I8IF3KDmQcPRMaLCpYOvURTcwt3cwS1vbXG0Et8MEI6Ukp
	 d/O48BRYckvBwJC4diW5YOQePWvAL8JfC2NYZE+oBBxAaJU+SLIWJALboft0QdUN8M
	 yyfNQKMsOYZMnVjDp5hUSBBVxuJUHe2d2wMkmJEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1127/1756] comedi: dmm32at: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:54:14 +0100
Message-ID: <20261118150054.954878220@linuxfoundation.org>
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
index 910cd24b1bed5..240d0711b6c2a 100644
--- a/drivers/comedi/drivers/dmm32at.c
+++ b/drivers/comedi/drivers/dmm32at.c
@@ -584,7 +584,8 @@ static int dmm32at_attach(struct comedi_device *dev,
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



