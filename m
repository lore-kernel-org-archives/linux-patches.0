Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029347;
	b=mCvQEIpWd9VIM1s0fxbzWpkcX54a9idQD/wQUt4fpv5qvPJmxNOOk2sTdtqzLssf7s45
	 wlQINjmDV61LTMjKTlZiIgOmZn8uvp+HvCsB3oFHObga/RQtyI2VsdiUn/SU9j8U/Z1ef
	 bcLex3M8S4mttmE9VhxuX6jUCg5U7GV+0sVA3gaWtDNNor/LvVawGpUhJb3zPm3M9zjd/
	 ZBPCkqVkN1cwe1FGq16K/01OeVhnjhzGQbxpDgsy1KNSkYStCmQSN4MgFdSNyF6WMDwss
	 3zGnpALTbtdpKf4MyJV8nGpE9HseX7NMGuML06ZKjyRsSY9eEWIM6pUx21odW4sQzSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EqBPOs1gO9nW2RBoJIgVAe2LJilj+NJopE+SHEiOKLA=;
	b=JSErFRerc5JiaV3VCHgQqSLaktT0nGDbTpUSNSs6hl1LTQLKu6OibZQKeuxvUyxhUuz3
	 +WzKhq638JCqAXVOUUaO7Zcx2znNilRR6/xu90zltQUj7p7/cU2Bh/SuS0TXUtnFo9PjD
	 gyOojzCrMguwmI4JtmVc7nCcMk3pNnPksKbrVBYSf9lbsxD62af5Op46PIyHK8clnI/QH
	 Sryu/IcwGLXb9xt4Uy9Ir/BEhGMk8+qLZPOTi2ka5ApwKZJUjVRqC0+hCXVwaOxq3IHMd
	 B5cEVTsOtd5a+JkhdDAMTkpDNdLEpiXHXLep+OCXtVVec8Hw6I4BZo5SY0eIpunS0EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+EiwEgY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3070606A33B;
	Wed, 18 Nov 2026 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+EiwEgY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202991F000CC;
	Wed, 18 Nov 2026 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029347;
	bh=EqBPOs1gO9nW2RBoJIgVAe2LJilj+NJopE+SHEiOKLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+EiwEgYvLiqDiOAtrjnkFNULzyBYN4AABpvYHpsvaOatPtSnfPly2naq8B9uIGYm
	 hPEOaadU9yfyD9G0ag6o8OwQxC19uszQG7tjZhQrW2qJyCE/wpTfoTtmIsB920v6PP
	 Ym6aJP9spCEfNesCwCwr/YtqDJInvpVJxTn+1zZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0271/1756] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:39:58 +0100
Message-ID: <20261118150019.202849545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 4bf33cefbae5f..66f8d52522350 100644
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



