Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016676;
	b=OaVG2pq7eK8uasU1adFmE5wqgu2uJbdti2kgh0RnYiqy6HFwsNsTAVbP7lZX0LMPV1QJ
	 XIpjSm/UG8Sl3TX9MP19Xrgh9JHkCEcEm5fTByQFeO76nEQjCbXgHf6FJ/D4wf2P50CaG
	 aFyA62xKCAW4It4A8l9LCLRMjgxnpH97w2eRjpRFpwS+TeVqgp0PewjATS3xzpTMmAAjI
	 vBSAVDnwzeNKk02C8FFHrh6NxCPUPhIVvnqvIFTnCM1MUyx9ze3v0VOGxC5KNHwD4MYv0
	 6BH6BiiTRPFYKCX3cBGI9MQo3cRWTFM7uG9rLSReKK6+GfhmsLDTo3kKzfO8fRAIb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0t17yJJMG0zYNWvRbMvvV2cVfSen19Ar7QgK9bD8cgI=;
	b=wz+1ZPvragOzgrJaWoeUv8/t+bDPiwiMG+oL44D9Gse/p1rSga+kjpHOZXZs/+I38TBd
	 x9EAODfQSfK0UjsggVvi7QHYqa919WgCwYNkUHZqTQBpSIOCDBvZoKWJKr5IezE5kmyOG
	 XyQdFq4nnNz1x5YxwA9zDN3REHz9J46znoKCgOzDoNnJoGSq9W3rWkBJK7K92jYMjh34c
	 Vu4EYo93U2Ox+5+YgsZygxVc08Olk2w0wNBsu5QRROWIm9Wyi6yjSIReeqOuNxJHJIL/Y
	 dkvZe8eI88gRes246i/5rxg+cCyvBefLnn985qF+ypRj7hTtqa74xmcb7rTFajW5fhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psLbSwXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7743C606A31C;
	Wed, 18 Nov 2026 15:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psLbSwXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5A31F000C4;
	Wed, 18 Nov 2026 15:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016676;
	bh=0t17yJJMG0zYNWvRbMvvV2cVfSen19Ar7QgK9bD8cgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psLbSwXd0wsBeaiw+DXUZkFUI5SQzdb3SE4EsEcfChV61Bpj/zqjc0KnWWXDFxeNv
	 PUXk/YZuV24hFsldT9CSrkS8weQInG4FZNIS4TS62Bk1CmLeMzdT9WGBBRiHpUOxXU
	 lfiL1VMnu0IG2sT4Rze3KydNa/mFdbeZnJG1tyHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0614/2651] drivers/thermal/renesas/rzg3e: Fix signed integer overflow in temp_to_code()
Date: Wed, 18 Nov 2026 15:30:54 +0100
Message-ID: <20261118150309.816530980@linuxfoundation.org>
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
index c44f5b8858d02..4acee4eaff05d 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -194,7 +194,12 @@ static u16 rzg3e_thermal_temp_to_code(struct rzg3e_thermal_priv *priv, int temp_
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



