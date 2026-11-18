Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039412;
	b=XA2U/F4z0kx5AlNl0ZZvbVTobBL37pnt+OSPpq64Q6DiurH3CX+YSTIYzGkon9MrS+3L
	 fYtiEp2yedB1F1bNiAmwydox6hNvSYSM3tbIClN2yC3LCK4HCJiQBQ7WasSieTVzbTvZe
	 2ks0fuOguFjMcoKA64erUaBlP9VIu9T2zcSJqyH7l7NkktV1TYsq8xeLecIZQrSqPKOHo
	 8RksJYh4H5F4CuXFKPT0o24uKovky9bksEWNW9y6c0VHcTY2YYwZAIjev5BjyPwqxn9QS
	 WtSQDNqQ6DgSN++OOvgN+IVfTXmyb1HENcncuLTLEyc7knioLNsMCv0JKxnGOcMIINQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMCJuPncOr1/gZeumkAWety2OzeJxZ1uBGc1L2I3nwI=;
	b=SkA7ABDvGr7/fVoqoLp22Z2goZdmMZ8S9PuYHClaFi0paMWwFa1tAsFOkPjbRaHj5ZJT
	 caXS/tFGoo3FGhhJQ6/r1bk4vR359Qb1sYdTyjdArtprAd+5qcZ6+UNidAJJVdeT+0Jru
	 klqZ31lVverwQVqrhvz2XkSEwgo+0wnel5SbcIJnPryYeYOjaw4cGdI9W1pZmHfXgy0J9
	 l0PASn4BDe0puDaipQqh6MuDOn/KKpqX4x98lUTDbrLDrBefulnGifPRlWuJSX758D7zL
	 CKdgUdspjllS+k6b8crWukEigOJeGNpJM3D0NtLm24abTERXTMytquaAah/Cx6Ddxzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LR+eDQhp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98CB606A31C;
	Wed, 18 Nov 2026 22:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LR+eDQhp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B061F000C4;
	Wed, 18 Nov 2026 22:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039412;
	bh=YMCJuPncOr1/gZeumkAWety2OzeJxZ1uBGc1L2I3nwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LR+eDQhp5HuUSVm0+oQQHouaMMQDHpLZ1QJW1Cg/xSIlk1UTwblArPLO2qo60NzKb
	 SlRuGEtI50vfFBseUFsDOEM+r38UM3Ue/H9qgl08eOUBPJqdER+vrwSy++i9cYJUEk
	 gkshY63uRAOVJvdjTQiCnxpkXP1SC4aaFYjI9JUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2089/3318] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:45:11 +0100
Message-ID: <20261118150424.770537824@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 7e874b1750a40f3dc9a629aeb72eba09c77f77e9 ]

The kernel-doc heading for struct spinand_manufacturer_ops misspells
and truncates its name as manufacurer_ops. As a result, kernel-doc cannot
match the comment to the structure declaration.

Use the structure's actual name.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/spinand.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 980e1fdf67eda..4a2b3e448bb72 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -230,7 +230,7 @@ struct spinand_devid {
 };
 
 /**
- * struct manufacurer_ops - SPI NAND manufacturer specific operations
+ * struct spinand_manufacturer_ops - SPI NAND manufacturer specific operations
  * @init: initialize a SPI NAND device
  * @cleanup: cleanup a SPI NAND device
  *
-- 
2.53.0



