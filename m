Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062995;
	b=AngldJ7Y+AYYLjbRy2yL4oQGBZiryn63SkjB9Q63x5so/tYcW3JI2/WB0g0UlqB5UjOM
	 mH3uBGhKgMBy+gk/Vlu1KGY7ahFVJTvVQNHk1l75JJuBwmy7Cr+3t4DwE1OsEZMbL+ok7
	 Zmoh06Ve9cuC2XBnUWEP9NlI2MIeto/kH1PSD9mncJAz1pDYb+R896AWBw6mhX4oiRzkC
	 g0Do9O9lIhILK2fXlzoZLwKmCIyb78WSvrUIOGW5ppNwgfBtZwj6Q5PcCG2c+ld4KfuPF
	 MQseX21toTdM3zffuK+ZQDcktS6CK9178mWhc/sPqR2rQBwxOb13686yNhLIMbc9A4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8WzLQH7SEEWWQf4UeRxlyPkw3M5NV+dYeEvQJ0YhCdI=;
	b=ts5NmTkkgTywT15BuVeMnYJajIke3HThkVRNzhvl+a6x2dqPZNb0QlgVYmqotsVM0F7H
	 fYlJsX4KA9ygixqpt4PyMK70y/kt70vqhg+lRoXv9plBXouFji7GVWqjpwpBQrW68wNCZ
	 6YPaq6/OhUGqplFP3WF+ve7jEQq9Bve5pgJrs4S8Uxlmy3vmlN2lOe3SU1rpR82aQ0ftk
	 xYORTy+dz0qworUa3SrNHIzC4pYX4QVtB0sPbJcAkY4hSkCXamw6ZWrYWQTKzNs6cETeD
	 a7EBUOWr0OvYMFJsR5EvwMTyll/PzgM7+MvcaTnIf5mBZs6c5ExHs6i/b+GUYEpzo5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU7x+kx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51231606A330;
	Sat,  7 Nov 2026 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU7x+kx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8981F008A1;
	Sat,  7 Nov 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062994;
	bh=8WzLQH7SEEWWQf4UeRxlyPkw3M5NV+dYeEvQJ0YhCdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OU7x+kx6s7Q+cw+sRL2lr/dDTNfBmil64d0EKj2EoEEguPNEd6SznrzX0MyL81jKK
	 0IkYk9X5lXKT0OAHFRJY62523VTwx0Y2yQetV+3UFmC2tEmYO8N/vij3MIQhN/muvY
	 JxnlfQgbu0Qu502y45EATKmqzMgBeHz9XTHq/s4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/869] mtd: Call get_wunit() on the master partition
Date: Sat,  7 Nov 2026 08:48:53 -0500
Message-ID: <20261107134900.314098083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 51c8ed4893480..f84e4213b6788 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -562,7 +562,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



