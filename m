Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829700;
	b=ojDmEeLXwHtgSN1J1/phkWwMJD71D8xoeKUeAiHda//dCSz10/88EAlNTyu7JmkVkx9b
	 B+m9uVL7OzPby+FhslTjGrCXnFMb4CLbB7pPOWG32UjvDECrK3njfO5qPZA+SqO7Upd3/
	 B7Meu1L3YK/ycm6R0EQ2SIDBa7E0t5Ij1vISQFyfOWlCOHhUio0Mn43msCDt3YilIQzgr
	 IRWqeyCVe/l31GkGJPH4r54eoRvJsFt1NfPw9nWOjn4uxB2FfrTLQGpM82IA8Ag/4blI2
	 IJmLRoa1ZrEiAJhwnq6qcMI/bP7PeyuWRkgM2y+GOV7fEq4blQOQaNfZAiOQpXhvlxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AbLOijNRYxXsV4UFTs0HhI+Qwd+RO5KBy2iFyafAGzg=;
	b=WEPif8yh0inKBTIn/YSmcEkBLhSVOiBYnoDLlttJoPEBCs1KwlzsvxUk1jfEte6msGN6
	 4eBHMVOk2L4P1zWpyE2bytOnSY+EBSifrPLVwrAT5jDrM/MATzMmg50ucyP1o0neFUUgy
	 6JkSGVLl4jICQGv5pep21L3h4ImbNAnRtnHpUFSu0HbrWIIaqbTjDLFK+jtEMs83BVvRG
	 dbXC98sCQBj9wYxMimYj+OBPI4xodJOlgW6rJBTDTFl+uJAAiiogp584bgv82+PclZYKw
	 DMANWq5rTM+n0S8cZddVsNW5TJOV5HNLO84zxySmDcJXKWMMdAaeP1L0g9bkmWsyqOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyhpS93z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB32606BA30;
	Wed,  4 Nov 2026 22:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyhpS93z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94991F00A1B;
	Wed,  4 Nov 2026 22:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829700;
	bh=AbLOijNRYxXsV4UFTs0HhI+Qwd+RO5KBy2iFyafAGzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyhpS93z7Adbgjg0Ps7KHDvSrDgjUF+TtOval5mJZpriUe78rYQMWF9/k5f3hshRF
	 K2P+kj13fFhjpCebyhKSjX71MlE5CBveW+vTX27RBkW/BQqC3qC5CujPuse3W9gGWo
	 oARZ98cqifMbdoREtPIAMVt3SHw3QSRumTxjxY3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Proshkin <oleg.pro171@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0288/1005] mfd: axp20x: Preserve other control bits when powering off
Date: Wed,  4 Nov 2026 16:00:21 -0500
Message-ID: <20261104211051.970332225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Oleg Proshkin <oleg.pro171@gmail.com>

[ Upstream commit 3756bf05c963563f1325af105356541882dd5899 ]

axp20x_power_off() triggers shutdown by writing AXP20X_OFF (BIT(7)) to
the power-off control register with regmap_write(), which rewrites the
whole register and clears other control bits in it.

On the AXP221/AXP223 (and the register-compatible AXP228) - that
register also holds the CHGLED auto-control bit.
Clearing it during an orderly shutdown disables the hardware charge
indicator, so the charge LED stays dark while the board is powered off
and charging. Other variants keep unrelated configuration in the same
register too.

Set only the power-off bit with regmap_set_bits() and leave the rest of
the register untouched. The shutdown register is readable on every
variant, so the read-modify-write should be safe.

Tested on a ClockworkPi uConsole (Raspberry Pi Compute Module 4, AXP228,
which enumerates as AXP221): register AXP20X_OFF_CTRL reads 0x08 at
runtime, so the old code left it 0x80 whereas setting only BIT(7)
leaves 0x88. Writing 0x88 at power-off enables the charge LED
while still powering off the PMIC.

Signed-off-by: Oleg Proshkin <oleg.pro171@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260611154629.76607-1-oleg.pro171@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index c5f0ebae327f5..85506813f089c 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1250,7 +1250,7 @@ static int axp20x_power_off(struct sys_off_data *data)
 		break;
 	}
 
-	regmap_write(axp20x->regmap, shutdown_reg, AXP20X_OFF);
+	regmap_set_bits(axp20x->regmap, shutdown_reg, AXP20X_OFF);
 
 	/* Give capacitors etc. time to drain to avoid kernel panic msg. */
 	mdelay(500);
-- 
2.53.0



