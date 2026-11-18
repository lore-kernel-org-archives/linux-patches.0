Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026393;
	b=yH1RpYDnJ+4jkMg1lwjoQ8QvDS+sVvCCrvqU59RZsxa6rxZjYmRpJK1S1HYWtzfM02im
	 Ncq9HR7DpCIKfttZl0iwZQFX3Xawnq/6RkTq1FzfdTioyZKbibblPiY0Nk6wSobhOQ6es
	 azw/54kug28pJkGU5DKNwG3Z/wVoGOZHKF+6Seoa2UEILx0Rru7GZYk+5teGq0FaMI/2g
	 DfC1V4OMoRvSFyUgtX/YowroLQTIt+SxMjknSqQLRQpIO/uKFItZLyVm8JZgeGW7D28Jr
	 6lVDsrwgEFnsaFDKrS0flN3VP//Tk3nyfBvfsKh2Wi6+D7r40MsNGqTnlTgUD2+Dadw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=esdiqAncHolPzc1+87IIYNfMwUOKLgbP6yWr0Bbf+tc=;
	b=i786Z85LoCRmaeZ6JcsOibtuc8zp9MEf03vPmMSkO2O8MAWSVR3dcH81UOMEy0zeMW5l
	 +WWQi5lSj7a+3YImOmdpLvAm/YGOrVg/7+KlmT5cb2WA3HpVsW9mAd4joDTj8ShklSmTG
	 iDhk5+NC5uWQrGbQf85u5yC8nu++KSbD14hJojhkAda1DbkJDgHCj2QhtxnYdu/6lecMW
	 bubOnX4bq5ZCNOTHZ236LlMNc3KNO1J+sHAcATPFfRI81LPUDHOVH0Wd67sBLPu3Woj/U
	 Ww67Ti3pTY93B/M6pmms6Zr3A6njUS8IcEYOEUHX2mqNFOYCvmVebr41NYSyCtGWZlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hv4AVlhg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31736606A31C;
	Wed, 18 Nov 2026 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hv4AVlhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8977A1F000C4;
	Wed, 18 Nov 2026 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026393;
	bh=esdiqAncHolPzc1+87IIYNfMwUOKLgbP6yWr0Bbf+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hv4AVlhgyjzhKceN4ibGdk3QlTLEBe5O/dgMhRbs/d/xtSXbtnlSZNltCu5mzQSJ2
	 DQJWmqwlxZl3sqbGbZRvX54H/0JSj6BIPcCyI32yT73JBnSdtIIi2CYLCXZMuNcqdU
	 eKpKFJVgVGMG3z/kJKY0fUjNoer+59zXEOEi/sRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1417/2151] comedi: dmm32at: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:52:32 +0100
Message-ID: <20261118150213.580434755@linuxfoundation.org>
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



