Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023187;
	b=ffCgj8rh7KRCff7nvi9aYiwmxA+krGRB7mbAwNsyVTDGBOeIc1V56i4/7u7NMleMRhcx
	 Y0GcYJETX3FwXyA/x1//ZS+PBaoVyAyEHm0V//SRYVWt/AfJO60FFJ/ensq7msdFB6y2A
	 r9PDE4EfYGuCdsDSBwuhDHcAtG+Ms1UwOYt2TCs0W/r2/BXmRffkdk3L53Te6us6MoZiA
	 9m4C/FUg9PPLpAkcUaJiie/F3tKnKFYplKcwB9LGvssXqKUr3M9lqxeUxff3NCMkAR4Lh
	 sTNCvSG7C/rjuU734o5HCP6btKC4uEel1Ii0ABuE9YEUSYr2kwAWnfMFa/ojhN1FkEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zMy8SHATwogNVyK2bBZsXaQ+O8N0SXWL3ZuGcKLtAXQ=;
	b=fr5hL4IDWICmBOkq21I6hVBv8OTU8zQ6KwEHQAV4YAhxgqQmGafPGw6FjacS0i5nNuUg
	 2ysVmuRLGF5VVFE937LIjakUN6/w5Eof4/3IW/cbN2To3h4qtKDjD5ZUCDxyWBamIRVpf
	 qFznYDtXLu5LZ83bhwRvB5K070wnik0eOdFQqDJ587syhP4z5ILh+/DzMJBi+iiu7gvtp
	 ZDfGGnXC6jydiUTaHZ6B7F5tpoTtqy60DnbqMWY35oj2K2So1V/fw6YiPnU9a8Tt1bVRZ
	 DRHxkb8Rfe7ntNJrVS6lMmhJaC1Cn9YClU4htU9F3ld/JH7jvnEliMS2OfendNt8yxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPlMjTnI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5544E606A320;
	Wed, 18 Nov 2026 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPlMjTnI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6F01F000C4;
	Wed, 18 Nov 2026 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023187;
	bh=zMy8SHATwogNVyK2bBZsXaQ+O8N0SXWL3ZuGcKLtAXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPlMjTnIhzBRs0XrTI1RUGQvCKF2sKOWifhdI9PR1skfm/m3WlQgF2G8Ql+5TKd1Z
	 ESePP5suw348oqkw1jF98AGmFceqHnqDOoJPktWRdq3sXkyzqQJAS5MtY71UIcUFgK
	 x9C+Fr/DiAVcjBFXX/nQ6JWWEJIU6HLMJZAftl6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0243/2151] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:32:58 +0100
Message-ID: <20261118150130.630144327@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 24fa0eadc2e3c7e9397924197dca7777ec08b8d7 ]

The MP886X vsel is 7bits, fix the vsel_mask.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260901043123.5401-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index 9ad16b04c913c..bbad6207ad7bd 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -267,7 +267,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->min_uV = 600000;
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
-	rdesc->vsel_mask = 0x3f;
+	rdesc->vsel_mask = 0x7f;
 	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
 	rdesc->ramp_mask = MP886X_SLEW_MASK;
 	rdesc->ramp_delay_table = di->ci->slew_rates;
-- 
2.53.0



