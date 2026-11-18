Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036114;
	b=J8tSt/M2PXNlVGS5AoiqGBpfGhsICLlrykMna4TpxWqks1ldSTXURfj0SwdtfKqmNOzW
	 jjw5FqSbQWzUQd9qNpkPnFawqn+eSKG+E+InnE64dDJQUhXFGJAw3AZJwW4ONSozm5PCM
	 MMsnh8n6Te4N58yqGeXLFB4m0hn+gsQ1tVklUahbsoSqb/jVvpDweQNh0SERABdhS8Z7m
	 eseT3wxseB6Jl8SAiWL0pf4ETsp0TfrLxuce+zzb/miA0LHORaxqkWaasLbJTv1NrZBVe
	 f3OkzlXNlGsZpGPXIkOwY36MTQzgpR/H6x+oV7kiHspg8jYMdl0o44gL+UM/rAAFMLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kb0AxYcFwKjBgOO7/KUlg3jvYmS2N18+dTthmXB6bW4=;
	b=G1yE81x4VyUhnaFnHcUNG/5Vwgcbc1zZq0wBCjTt01tDPhu0sfIY/8D61y66K2K/aFtl
	 kc8FhIBYZ1o+i++Qh6Byu956iLVqH9n7rUXqw6ONQuKmQ5H9EOSkkIU1Kokm9pZ3+PR0b
	 La8pZ8n4jLEwKXOBAyREyrKDckMMwRcsYNmcBPCQIosWC714zgTC5tLcWw+x6G6zkkJS+
	 5izGGlWZj95xE1/PgERm3aHT4ohx/FbtZnSK26wgbFUJaDe3Jos2uWFEaBuYirngzFdpP
	 MdGunSuaH72NgpafUASnsjpCSpWb9/M1XcPKqLrmFBKaZ/d09BKqyP0VT4gVMIJ0cgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAzACb76;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D748C606A31C;
	Wed, 18 Nov 2026 21:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAzACb76
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C941F000C4;
	Wed, 18 Nov 2026 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036114;
	bh=Kb0AxYcFwKjBgOO7/KUlg3jvYmS2N18+dTthmXB6bW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAzACb76Fn916TAwr+nn1IevGyePXgv/vSGSk2o9LYmu+/AjdnUjVSxbmj+C1YjxD
	 2OuLeWqRPNWZdBs5ATNa56Fpdob1l/aqLk0+4bPEZBiS+/Nt9H/XDsqFjkbRaudnfV
	 toYvwUhGhWjQ7O9hA+xFqjIddCterzT/KaYQxIG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0944/3318] mtd: Call get_wunit() on the master partition
Date: Wed, 18 Nov 2026 15:26:06 +0100
Message-ID: <20261118150347.910697817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 904f18430e8cce829cb9130eab7a93020e33fc89 ]

The code checks whether master has get_wunit() but still calls
it on the child. Fix this.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 114127e08739d..d9a0caf1f01b4 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -511,7 +511,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



