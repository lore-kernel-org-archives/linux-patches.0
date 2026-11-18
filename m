Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022269;
	b=oeViXdXydskSOX6xAwI0+qcIc5PjnjqxQQ5BG7AAUml9eS/eu8ixbAYm+KOWJNU97ctz
	 rAY1CffEVrpBWkc9Wls4jQfXcpAKevbc8NdB6nmlFPRGFoOnRQ3/PiGJZlG4D8gEl1x95
	 fKH+SdCXd29+byflGJEMGNHEQiVjwTxNwBTibrJR1KS5REVvQ48mzPnAi4b/8L3YkzHjr
	 Q1At59i7e4c6rory8zrslvbWpbGpuHU5XOmMeRE/6TnxjLvmH0WCCUuPhckh2HQI/G2/q
	 Sr+TSTOMLaanY+YlDY+rQguBk+eNkhyyRqam7+K7UHa0C2mIEz//2xuCtbutond7YPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3UticLRgrKKbSEdni6MkFvrlPn3WT0K4dnZ64fvSsTU=;
	b=lnpm+nP17LQ1ev4rZLv041zWFTAqgTiTS59J6VV5pDvwPBFtBQrjQp4dv2oSKt2IhR5g
	 NgRcZnW1TNfWVAAhONmj1VaivvAB/7qEULk3ZDmlvNQCJCDS4OETUjuHjUcZcjYwh7pg0
	 fW7bIOwhLZCi/mqKo95tOeaU6cWlH4B2UtOpqULvEYECby0/bfkVEZNXBpkNVoAgua5am
	 ywui/epdXzb9ux3LA0AVErF2nzCAXdqnBRqThMNgdNpwP4mXZS39zBBCkP4SZlPuN69tW
	 hGn8Qond2FlE0IZJmCyLx/7g8oqNgaRvLHfZoYIBy84CxkOuH3uoew4BLrO9pMphRaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUvzVYoX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FE3606A31C;
	Wed, 18 Nov 2026 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUvzVYoX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8DB1F000C5;
	Wed, 18 Nov 2026 17:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022269;
	bh=3UticLRgrKKbSEdni6MkFvrlPn3WT0K4dnZ64fvSsTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUvzVYoXgjDim5u6wOnEkj9cVfrrjiUXk1JYxoBi89WBdKa8xxekb8x4dj2/dmKMa
	 jdAfi8MUEOfa4xW/jU1XW+MP9LMSjSBb2Wv1eczfXWvVIw22w+WJabeVkO6b2/wqvs
	 LsFYmGPvZQVy1EPwSCiTNQpTSdkNqOxtRzf6eLE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2602/2651] apparmor: remove unconfined_profile() check in inet socket mediation
Date: Wed, 18 Nov 2026 16:04:02 +0100
Message-ID: <20261118150417.939138798@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 1f5428b9f9bfb9dab6828015a5254dcd7c582a01 ]

When a stacked label is used the early bailout !unconfined(label)
fails, and the individual profile components of the label are checked.
This can lead to aa_profile_af_perm() being called which results in

  WARNING: security/apparmor/net.c:263 at aa_profile_af_perm+0x228/0x3b0

on any inet socket using basic socket mediation.

Remove the AA_BUG(profile_unconfined(profile)) check, it is not needed
as the code already handles the unconfined_profile() case. In addition
also a comment to indicate that this case is covered.

Fixes: 89ac6aa752ec ("apparmor: push inet mediation into profile callbacks, and improve auditing")
Reported-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index a333e6aff9262..641d181544ac3 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -260,7 +260,6 @@ int aa_profile_af_perm(struct aa_profile *profile,
 
 	AA_BUG(family >= AF_MAX);
 	AA_BUG(type < 0 || type >= SOCK_MAX);
-	AA_BUG(profile_unconfined(profile));
 
 	state = RULE_MEDIATES_NET(rules);
 	if (state) {
@@ -268,7 +267,7 @@ int aa_profile_af_perm(struct aa_profile *profile,
 					 type, protocol, &p, &ad->info);
 		return aa_do_perms(profile, rules->policy, state, request, p,
 				   ad);
-	} /* else */
+	} /* else - not mediated this covers the profile_unconfined() case */
 
 	return 0;
 }
-- 
2.53.0



