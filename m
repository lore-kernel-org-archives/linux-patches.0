Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026390;
	b=DDahCg+dN42DRgk2VX7X8op9JH0lptWkjarsKz59NKTfeTrBEf9QauAfapOQx4EDrA2l
	 FYPZG03gSOcTYPw4QnU73WoNxxS4Smm0fwuxH2LgjYHYiuZj/UiDvfkvEgqNCnIG7Baw1
	 CtMCFQaW1R6UB+44Ag+ekvLvGKDc1jNrlB5LA/wjBXp8qSDY3e3mkyQ28uLICwhciP/gY
	 co5auQq0ZCiXVIsbTC6qkCmxEadUgoEfI8QHkByQ035Qyl2sC2kZk52SJkqZR9n6HIVTP
	 RZfAb4PhLuo9W26a2hnw6RV8gFvT+KtqFWbcT84qR7LfaO3RHZ44uN0X1p0KaLTNEXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ch5ZfQRivh62MIbHfxZ5XG+oBK/5UWhc4FZXTEmNwIs=;
	b=dqLYi6aMEEyAaDtOrcPjS4OuKPemHWJrmk38vhoy9gc1sYIWoGqHDGyC99eNh5xBczK1
	 lXIvgIVcW8ENliYVYW2h2+z5Q3XyIvnt70mf/BHQkhQxGxuzEVltufg5LWVfTQezfZBFF
	 7EahpmTwkpwVf71g5UP2/bHHRGPbUW+qChIJ9AEX8bdCrrgJ931fSYJ/M6jPkq9a2DRbj
	 XSmbuL5On8aFOiREaT8UBUO6AeSwFpay6ZHw3bjmgYAvBX5C82X3lne/2995/vV6Z05uV
	 p59KXotvIfYy8KK+jWdqQrgQ6RCKmSz1udxzLkLxC5swV1MoUXHWaxZf7iZf/3+u4Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRimYYUS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EEC606A32A;
	Wed, 18 Nov 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRimYYUS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CDB1F000C4;
	Wed, 18 Nov 2026 18:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026390;
	bh=Ch5ZfQRivh62MIbHfxZ5XG+oBK/5UWhc4FZXTEmNwIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRimYYUSCCZ4RPiabV86EYnGR0OUMKb7cRHuT8Erv0oLHVG3IeOZhCqQ2jCaz5V03
	 gjJTmls4xQ+zHCh+wTPQUEPdhqdF2pdMgUj27iMbitqDCEREDdpGGbg7y87McWFg1N
	 fyBfkuBasHHw9lxFZVJD5oLDTIMRwfXcS3EIjPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1416/2151] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150213.546712786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



