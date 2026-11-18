Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056116;
	b=g6w0J1G+QzPUanE2TA55KgbjGqm8yPxx+hXTOiL/iWlRoA6MM3gd2c+sIAmZIaUaLugl
	 SynJwUWtasSK8XhQRLs7iFqHMhsIA9hSD5jOCiYpZikelhMxkKM57eaO4c3Kff2ApUpCA
	 Gtd4h7/XDb28mlxFXEuTttjFGeXcrGaBtqwhdVLTLWej7ygXIQV503WwqojKVF4xefjeJ
	 MNRtkNHhDUvhqk1nI2CofDbeZK9fbmOMyb2qeJYMD6rNjI6i0NVAVJtOblbumDIn/Sd1C
	 D0lXIZN+bWKx1agq7vIs3qOwDYk4guwKmX0+oVqDt9jlrV1eYFq1Hl/las+B7+T/EfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SlkS37Ci+WFJTnfX7YweXXnS93EZ8c+UELkVNvH+dfg=;
	b=YJ6d6yiyxxo4v1GWJff077jdkxi1XOgOl/42HwUBZaXc02epYyLbSdLBBtzzsBA1WwEE
	 WGaefd2/kW6/QzWPpmHag+9Baq7z+uPiN+wvn0yhX9jd1PDXsCC1jrQoq5q/nRZgTaqbu
	 SOiYbXP6N6H4WxlzPQQB2ZYJwFuI80ONQqU5ESlVMJ6EdU/Y6pY3d2NnpyrFtyOknJQyL
	 veuYoTOoOrZfAkyHaA/1cdPthQ2yaglQ1Y/sek5j9m2ZQtHuISOLa7ffdJnhzqmRJTatg
	 VA+A328b1oF+b9zcvkKXVZS9K11qnlENhY8MaGNEm2w/YuB9nK6tZaBXFi9u7t5cgNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e56pvAm3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69997606A325;
	Thu, 19 Nov 2026 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e56pvAm3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73291F000C4;
	Thu, 19 Nov 2026 02:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056116;
	bh=SlkS37Ci+WFJTnfX7YweXXnS93EZ8c+UELkVNvH+dfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e56pvAm3AuhC7FbGMBDZlt28QAp2r4PjCqgpHwiDzXBU+o1QrB52XDOcRu+UYPCww
	 qKzOz6gBw8us5n/6f5AwXdTro8X7LHf1A5TVok3vajwrQ1f6WB/BF3UOfAanc7s9NV
	 6Ud1WkFYmEb3WDEjuHfyDi3NeGSXvLEH8+cXuTQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1874/2214] comedi: dmm32at: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:59:10 +0100
Message-ID: <20261118150126.245684943@linuxfoundation.org>
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
index 85a0f58c134ff..a7304c5502c94 100644
--- a/drivers/comedi/drivers/dmm32at.c
+++ b/drivers/comedi/drivers/dmm32at.c
@@ -585,7 +585,8 @@ static int dmm32at_attach(struct comedi_device *dev,
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



