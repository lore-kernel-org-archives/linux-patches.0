Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031632;
	b=GJWrODa5CpQFrJGxBfhqJKzgPCvGwnNvW0RLj8yIEzQhml9RTfgkZABI5jriXJbjX+tB
	 W4CHueXgYXO06mHgnMRp6hbV/+2Tc5VPWu1+lry6o3MBoKP6Nlo0fJ3gEQzH+9TdIrg1n
	 S13n1m2VemyHAm2nhTfdp0v0zhFV2rLiY3NYJMJj2Cno1D3kvsM4jV1+rud7dePachIgh
	 KLN+7H7m6q6xG5Cj97QfiwDWtA4T7SA0DumLJ8saFhyO2Hg+vJUK69cAfUvY8zoJ6RK+k
	 +HSy2DX/ssIemce90yR4dyW3m8Onzaa8PVBFqQ/Vn7kVs0Ip66hfbfInHudbz2i7gUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WBgfu2qW0bNmnrR2AITxEwZwxt6sKT6o4maC07sgvA=;
	b=FyFS7/vAIMTg+oUascZQTMqwGbYxhnPpJRcjQuJWFk9/6NX/6cqM4hQdHOoafsaR9TRd
	 GxfsoxI9Ogvl+NGmQT+Jq9iLQNqGw5O/BM+1S1iYb484IzVkQjUHpz5QMD6HObySlyTfC
	 OGgAEuruX8NnJDRf5IcomqcR0kHxxsHhobT7yAtWQk8ahaDZmdH5Jt73zCjv85t4C//vQ
	 /I7MeW52gwXsH6CmfAp8VmUqJgfLyNUSSLm9c1+WOB4YEdytDOwHnsugNGMrzXPWnNCni
	 lDYENbM9DCIAxdHtkkJNRGkTXvh4eyNFBtqZ/TwRWAIohPAPr+lLov8/XuqleXnBcvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3XRTOv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D73F606A32A;
	Wed, 18 Nov 2026 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3XRTOv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3841F000C5;
	Wed, 18 Nov 2026 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031632;
	bh=6WBgfu2qW0bNmnrR2AITxEwZwxt6sKT6o4maC07sgvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3XRTOv5FQRfUw9lQICH4ro9GofMSJCisRH8f3rBxhaOMI0nLH5sI4MGSMUwwdbLZ
	 iNFaYUtoK743qqEMwKuLVy5TPnXhsGOf55SE4AXflbI6+YczyrlZAxU1mBdxGGmAER
	 ZCMnjtfzgIvCIGpz23m8iX4eg940gR0qT5Ybz5as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1126/1756] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:54:13 +0100
Message-ID: <20261118150054.921811142@linuxfoundation.org>
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
index c98a5a4a7aecf..3e734e343431b 100644
--- a/drivers/comedi/drivers/dt2814.c
+++ b/drivers/comedi/drivers/dt2814.c
@@ -315,7 +315,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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



