Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056113;
	b=ab5M8vrjKlAOCgpiJWsGjJfdSYj8eC8cUd8XWdXntTTXr4dGOgTI1/ysBsBKlWNpbINO
	 WDSV6leBpHhvZKTiOh8kecqEAWgk0tMkr47/lRtejM1kR6ak2OLfs5IRYYeerOI8cPFcR
	 CbC38+JbQ4VIsYyTnDW/kj+0uCQlw/ATg7r8Q/zLCD+pDjm+g5AVBpzUlXh+ux+U+IujX
	 NdkEUwQHA6xrPS6G26UOVgY3UA/g3I8bzoei9esIhrU5zU8GIQHJkuw+vX7TFGaTqsYhI
	 IgYV7QlDt7pFMz0n1qjMEExO8lL3s0C/XaLl1TL3/nvgtxQT3ex5/GgSqmTZdxbYz3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RFperL4Y2lhjwgapQ/NoeWPTRqgpHIw7L9PGmLU9nDc=;
	b=RI0aIeRcYYwZV6JDtGPlZx9hhR1IRc/iwoJQAf5aQSf9c/qEulaVHC8EhD+rio3tniXu
	 OXsD+09jwMJZcfXIdrDw6uc6deyG6Clt0x2lAT71FCrzvahzUyfQB3RtVC6WINFrHiHxT
	 eNeg3L52QD9dLkUF4rU9JayQ+AQ+WUFzpLUN2tCmpyGHvVrNuj7vkYbNlAeI1mcg3xUfb
	 8TPARICaD5PyZ3Lb5xwSoKtQ/NcmrQWMMHxM9NeOrbzdE5+SppKZonwf/quEnieos9ONY
	 PqNlRubeJYkCTyphdQAHvLVw23frs4JhWqGhmwuCxKoNt3pbQy9oyHu0oAVJOiozYJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkCWbTaE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86173606A31C;
	Thu, 19 Nov 2026 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkCWbTaE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB371F000C4;
	Thu, 19 Nov 2026 02:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056113;
	bh=RFperL4Y2lhjwgapQ/NoeWPTRqgpHIw7L9PGmLU9nDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkCWbTaEQ1eJhvnhgx+MTVBwbWIejHeczIgylarvXFmOuGxvT6Y6/gd8TZ//QHxg7
	 /4TzhgvGEaLkA1kYYt2BksQVDQ9XuDnnkjg0XSd3sEH1uRFKaDQNO8yug1gj2GsLGN
	 8tEpIr0q+HtnO9w1cDCJdI9iHEHAVz/o/rfC+U8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1873/2214] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:59:09 +0100
Message-ID: <20261118150126.209093478@linuxfoundation.org>
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

[ Upstream commit 81026c2b3f9096cdfdfa02918f94865629fb7f90 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. dt2814 passes it to
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

Fixes: a211ea977a41 ("Staging: comedi: add dt2814 driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-4-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dt2814.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dt2814.c b/drivers/comedi/drivers/dt2814.c
index ed44ce0d151b0..cfaa7d01a576a 100644
--- a/drivers/comedi/drivers/dt2814.c
+++ b/drivers/comedi/drivers/dt2814.c
@@ -316,7 +316,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dt2814_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



