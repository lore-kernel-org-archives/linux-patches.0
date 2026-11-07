Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060849;
	b=19gGPPD8kgmuzyNqHVqD4MKsIW0oG4u6aH119iLfzLRTyB85KJ1QH5Pklg0TKOx84Lna
	 d/5QQOQZmdvC3v4FSWcnkH5ZTf4h5bLVNYeViPJDB2VM1d+zS508/KpaY8UimwDBLMHCd
	 zKQw7QzEfhBVW3sFq9kdjcyMXXFKiGdSxwUas9k3W/xV2n9m2Q9ZZfbNHPNjrx5kZNuz0
	 XtZJV4V5OXM1ojezui0HcrLfwtIeVF87tD6GifNwPsemLcY8OnOkCp0GvjfYAeI1yVr/s
	 lFRhkRWzMBWmxdDENORRzYx48DXfWiBAb6I0+D/hr2Lfw5ltXDmPGsrUD4qJKajooTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yZqmQoAQLCq9roUVhGanOET4j0qUzliAMIY+eOy23M=;
	b=l5OZ7uVCgnzSNQBL5qotc4rLBtc35qEGU9vsM+burzhOfuBOUau4jKLXctRU1Sljp4t2
	 G91iStC32ziY5gRwrttZqKYXuyPpg9rRlcxncj8Qsob+gf+pef908/y/A2MUNvfTOteur
	 pVbDzFzvAgFYE7cy31Casyt5tWPLlH0ogmlvDDwGbxWJfIHOqC8gSkBOYg7OcCMd/uFoK
	 HGlbypTPv0tFsg0oLZHQ8rTmArrX5+eekxgn2y1brAbtlC8GBB+9rC8ZRVnjLlydW0iGb
	 EZaP1BrLe336f1NHEdad4KjGLtmwRUiy6gdza83uEWrhkMeQHi2i+fqn4KJepw78URw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=welsnLC0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C424606A326;
	Sat,  7 Nov 2026 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=welsnLC0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F321F008BF;
	Sat,  7 Nov 2026 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060849;
	bh=7yZqmQoAQLCq9roUVhGanOET4j0qUzliAMIY+eOy23M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=welsnLC0vr8wms3QrS8lge/BN/LsXAyJBrXvJg7xy6IenXQ5vY++vwNwUG/i9jiA0
	 RYJxUIW71gtzEk6O7tLcZ2/8S7CFUkKfqb5YkOTKne9JrH5HUKxBVL6zypbykMy/4H
	 L/dH+9xAFw3fukvgU4C++6yCQs/Zg+a/IEfxJrkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Proshkin <oleg.pro171@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0236/1536] mfd: axp20x: Preserve other control bits when powering off
Date: Sat,  7 Nov 2026 08:37:32 -0500
Message-ID: <20261107135004.303164701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index cbf1029d03335..f1dcff165f613 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1231,7 +1231,7 @@ static int axp20x_power_off(struct sys_off_data *data)
 		break;
 	}
 
-	regmap_write(axp20x->regmap, shutdown_reg, AXP20X_OFF);
+	regmap_set_bits(axp20x->regmap, shutdown_reg, AXP20X_OFF);
 
 	/* Give capacitors etc. time to drain to avoid kernel panic msg. */
 	mdelay(500);
-- 
2.53.0



