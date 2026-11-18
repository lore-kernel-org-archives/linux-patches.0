Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045174;
	b=ZJ7o54kTgDqdJyGVE9Yj50uULfYevVpEcT/9sOK+ptouJMNp/HJpLPJ3XsCMZ9mkZcOR
	 XATbKFRVs4x5CfKMPLkyLtbZ1KEaDlIXBjSGPEXM3PrQU9dwvuWJruQGwvj0HmpTOtmmG
	 rG+fE0TfGRhvEicHNyPMLtqNWcnAqqXJPnywEcK8froI+4nepBcchF64UhQ9k+clV+BZn
	 LB7763w+bPCckA8f8euT9sT+CxNN1qPFRojXRkQeMYaSvw39f52tvrDU/LzqeCOnIFAfk
	 JBwHfzKWuUWzVxq5lJTCYXk5F7kMEZN/a53KZorJvkh1jfuAC7uxMWIJbVpzYTT0Q0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nMA5eU0kiwuzehldCkeIsKA7czU+ZIVQ+OE1cguCxIA=;
	b=Lmy3QhqrQU3ROIxDp38HS9OYhnnRQHifmNMlkCkglnSrYC2NqaE/pYjItYnc5IaBOLlz
	 Xpu2TNfFbIybALtK9vi92FPqtO+bIvUmKVpejQc2OkLcYZ3Evfiu40/W6Zu8o8K+4RaoK
	 GZvqDWgBpgnhKq1wzzGvxb7jE9tJJlnX10nz/a5uIhSJA48sxmy+xK7wv6ZXH+npyS0XU
	 nhR1yC6A8yMAgRBM+HkKxR4RHSIGO0fupCPkTgzhNps9YpWzrnlqBBep363w2G23RjOij
	 5l1CoXjCe/H+fYP9xbhp2n/EkFLtjwMM00CeQP/38MjXoUi1Yxwmbt3X8POb4u8iaww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCMHPhuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8F1606A31C;
	Wed, 18 Nov 2026 23:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCMHPhuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5111F000C4;
	Wed, 18 Nov 2026 23:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045173;
	bh=nMA5eU0kiwuzehldCkeIsKA7czU+ZIVQ+OE1cguCxIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCMHPhuc9TQ1yAJ/kZDtxzp0QfPuwW8ZyyGbSrdoDGG8Nr8GQmOqaym7viFi3moVL
	 S7d+iMLPSzWl35Csv+UDDGFxUgVstHJjOmO/4Q5oxxfpA0JpKhvv8l5ys236oO4/ry
	 aQZVShigqN9hBjs4hLGtUmoyh/BRsD7TyZeWVvPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0827/2857] mtd: Call get_wunit() on the master partition
Date: Wed, 18 Nov 2026 15:31:01 +0100
Message-ID: <20261118150231.350230591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index de21679528449..544ae46d95c25 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -510,7 +510,7 @@ int mtd_pairing_info_to_wunit(struct mtd_info *mtd,
 		return -EINVAL;
 
 	if (master->pairing && master->pairing->get_wunit)
-		return mtd->pairing->get_wunit(master, info);
+		return master->pairing->get_wunit(master, info);
 
 	return info->pair;
 }
-- 
2.53.0



