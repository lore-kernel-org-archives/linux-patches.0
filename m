Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023971;
	b=bAmS1r8zCnq7ScwTpFHBAwSuTrfsDl2kpG/oo7Yry6sGMm2pWZUsX88hrZjC20uQwy58
	 rL+p9KJM2bFY728hdrMkxLgsyA5Vsbn1vEIJOWNJEeosLEGG8RBhXMi7cWUO4LflxR/ag
	 MoL5dducOVR/JZfRY5+y7aepDpMafjru6TxMgI3m1yhIDI+VlT04drJBPgjN9O2VI0cHB
	 FSnvmDOesopnTkAzsbux4b2OeRoQ/2eBm7yuYJfHAJonGkV4IdLiSMBe2r+EnbECLKCfI
	 uY9YxAAQVXEc6hpazD35U+PBWjxswn4qLrIQ0PjXaDBrEn4kEnSu856YyDNuoYhmg/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=trKP1TtW2YBnVT5AEgqF9JkQq3PUIuS9RcdB0IMfRQU=;
	b=M1DgBSOpULT3mMqC2YjSMah72PG/r/gi8CYZprQeA2IWeW1KBVuSUSu3ViZp7H3Hlf0y
	 rJnZGUTbKXPE49OdztByFyPgxW5t6+uSuZQyJma8FTPdujTaEOvr019lNHCCtTwk5goYm
	 4M7WpO39QjaBCWAo1hwxlyHwZ5lXDq+tp3XQhH+ckshcaokX/n148xF5+KmaY37ZZcSg3
	 BNakGe7PJ6j443rczywHj67a6cDzMYtq5CHEooDGUbw/fKKAffgegXv9eqYSM4oX2Lb7l
	 pkRF5AImJo6wl180/KA4VaO9IYnpfKc01NuVxxRYPgOrykAWsH01SKfZlWGl/d47Vbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHTO0wPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70C60A260E;
	Wed, 18 Nov 2026 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHTO0wPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168451F000CF;
	Wed, 18 Nov 2026 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023971;
	bh=trKP1TtW2YBnVT5AEgqF9JkQq3PUIuS9RcdB0IMfRQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHTO0wPGq9Z8k61X2Nmo+SM2OF3Xuwr66X3g39KOU/fJTs5LA+GW/aL3/uwuVnQBZ
	 L+miL2bYwVwKVDBciTF/7Bu3qAlOQ294/H9LPr7+2DTNn20qK2pv4dyytPYyu9Dv4V
	 GNSaMFYRMhKsZ4ihSA8kXRJUBX46PS2quMv1R6LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0557/2151] drivers/thermal/renesas/rzg3e: Fix signed integer overflow in temp_to_code()
Date: Wed, 18 Nov 2026 15:38:12 +0100
Message-ID: <20261118150142.250148279@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 84f0e14e6261ef718e6a8583073097ad9ea70e14 ]

The thermal core passes -INT_MAX/INT_MAX as low/high trip points, which
the driver then converts to code values for programming the registers:

numerator = (temp_mc - info->temp_d_mc) * (priv->trmval1 - priv->trmval0);

Although 'numerator' is defined as s64, the arithmetic is performed as int.
Because of this, the multiplication overflows for -INT_MAX and, because
temp_d_mc is negative, the subtraction overflows for INT_MAX.

To fix this, cast the temperature to s64, so that the arithmetic is
performed as s64.

Fixes: dc67521c20b7 ("thermal/drivers/renesas/rzg3e: Fix add thermal driver for the Renesas RZ/G3E SoC")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260916120003.87018-2-ovidiu.panait.rb@renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index 246ff368b0346..53fabda23244a 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -189,7 +189,12 @@ static u16 rzg3e_thermal_temp_to_code(struct rzg3e_thermal_priv *priv, int temp_
 	s64 numerator, denominator;
 	s64 code;
 
-	numerator = (temp_mc - info->temp_d_mc) * (priv->trmval1 - priv->trmval0);
+	/*
+	 * Perform the arithmetic in 64 bits so that it cannot overflow for
+	 * -INT_MAX/INT_MAX values passed from the thermal core or when
+	 * userspace writes arbitrary trip point temperatures.
+	 */
+	numerator = ((s64)temp_mc - info->temp_d_mc) * (priv->trmval1 - priv->trmval0);
 	denominator = info->temp_e_mc - info->temp_d_mc;
 
 	code = div64_s64(numerator, denominator) + priv->trmval0;
-- 
2.53.0



