Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062132;
	b=Au4RkgLM3Y2PfiI8998Kje5RF3ZqPCvhAymQ45sER3t29vbJocOoex+fsmTeaCyXIY2W
	 cXM2ZFHwRAHGmEU73uwGbt1CwvFoypqgg1oExO9keJhWnWC4bPXksUXmeNfz77nGYNq7w
	 6IlAnAM6+sFnS5a2bdHiM5fnLsywxF6kOpALDum1TMh+Nil1EJG/nb4VCka/L7ASVe2Oo
	 hd7B3M69syibf2UP0ODuhIhJAmwsJEgSxv8zWoCcypgiauIvvDoLj/sPfle6VWOr1lBCt
	 KbMd/cNTc+BTB6r/jsoQXZyeNxXQSacHjNwIpfT9MR9Ag4IBFF3bMhwxz6RWuQAqj4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/DeCY6clkYwnR3FYM9ysb55J9dIsY9nFe31G7T4f8S4=;
	b=2jIwkOXgxUZA5FcO7KC6fXcjkI84aBlyn+G0SDfJIiiNStQem51Zv/U+aFqcCFefLe3H
	 2+hq2zvDzFMOCcdXVpyld7LQmFUrDu6XBEYs0PmHszMEEwcgFpQ2cDkJNXv9lYyRzl7LH
	 KUqDIJ3Zn395T9Apm4SmoBPJ0GwhrVI/kw+/VocfvLTTREf0oykES7RDTyp9r4TAUOMvQ
	 vIW8BUTOP2Sluh8qLgW0akQUtlYirgCYcA8+erAa4JytwfwYEmJYvuS/Zk72rX69bXgHU
	 l3CDftoktsKAYL1OEqYWmkNtOBfkkevVN5sYb66pNJPQk33BgQWF3Dfshc7qz4+bqYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRe6UC4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCE360A6F69;
	Sat,  7 Nov 2026 14:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRe6UC4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A07A1F0089F;
	Sat,  7 Nov 2026 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062132;
	bh=/DeCY6clkYwnR3FYM9ysb55J9dIsY9nFe31G7T4f8S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRe6UC4jscIqP8GKqGmiZVIWNmi9IrP1hxkAWWGOHV9JSaVm9ivTCjNOBJibarZvu
	 7cpxhiSP+nng5gBGG5UYnEciSNzrsBzysmoMI47ORAxYz+XnFOF/0kWAn7Y4VjI8iU
	 rVlVqaxfUOVPXGnUjp3f3qpbN1RVPHlMRQaXq/eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1073/1536] mtd: Call get_wunit() on the master partition
Date: Sat,  7 Nov 2026 08:51:29 -0500
Message-ID: <20261107135027.829961226@linuxfoundation.org>
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
index 12d31ed27b4ec..6bda8b9684920 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -512,7 +512,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



