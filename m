Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058332;
	b=jrdo2Ly1TfyVqJrNjvJcrrEHQNc8s9iVOfBfcnZFONYOdspQ5C8NgJdYVsjH3r+tVWKr
	 U1YvAy3l9qQLm5G0hETaLZ9HJmRhJGg/xKcH0UZJWIqxLBmW+wsTPTczP1O5u7280HIfL
	 1j0g33Z+O54MEUF7E2zqYS9B9iDXuUfBV+04dv9ivQeTJRks8J2MNI7mY5b5dEANH6txQ
	 6QO7yiEB664L+oR7aq79wjXN7qX334T+L2+NFl+d8Bw1Wxno7g9BeN/AhOij0nV7IOQeW
	 1nyCeYsBY/MauM/XHckKmY9MuIixrXDt0AjdkvaIgQfhASbwZnUE3bB5kJ2EaG8OwKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVyYONYIxSmFRpyyou7CnfPosHFzCdDHvM8wHr9f3Go=;
	b=e91v2PndD/g8JKru5fawm2S5xS2NEnAADfGlkGnxltB/D/VFHFvPDMQmUnKAqCo+OxDi
	 dZCxtDGDu2WzPyF5G7Ly2L/8/iyopZtZwT7/g3PpeKKxggRxLHjsiI4srE7OXv6DdaNUi
	 hk/HAj6Z0HEJ+8hwFUyhYLjxajtqyFKtQbGP4RaD4x3/o/LxfwK0c7GWHDhRlkMLbFwQW
	 chmZF3HaUAmBoX2XbSwMSBFFA4gqxpk9T5lD+XPxSG6DGaBHixo65HdmJiuiFPY3NoWUn
	 q9Qt9AO+KRqpx7uc/FEXIPQXIvNyz96RgH8V9370APbi8B6nMIUYwoYMEn67H69+ugg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1l89cLkv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91803606A31C;
	Thu, 19 Nov 2026 03:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1l89cLkv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FAF1F000C4;
	Thu, 19 Nov 2026 03:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058332;
	bh=BVyYONYIxSmFRpyyou7CnfPosHFzCdDHvM8wHr9f3Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1l89cLkvNuAPE1H1jtFMZisfhJiqEcZ1uK+VzWD1209wqCmaNjlH0nYktznMEBeYf
	 ohjwSUyvSlLn/ZNzqhRv3WPKKV/OxjAxgOBjG6V5OeVpUPtBwvDKek2zlmOpJJ/veL
	 JJuSDnbBoggNyGq5UleJEN+a+A04WAhNhoOgXlOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0441/1848] mtd: Call get_wunit() on the master partition
Date: Wed, 18 Nov 2026 15:41:19 +0100
Message-ID: <20261118145932.690612943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b2d88ff90e936..1a9bec28c6f21 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -488,7 +488,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



