Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048062;
	b=JbNzjrtnvipFXHeohCdQgLSDqWw3sgmPK5mDfFw8TVartA7EAQQCIFilF1ollUum3qxb
	 bkxnBxqFXIxWRQS59Fyq9h2bk9SBsYp+TVpMszzdj97SPsd7sH2ZHmxlHglK+ni8DHVqT
	 qTVpEn7R7lsPpt4DeK2ueURuVYpEYFJH0crqFcW4C1YNqxdc1rLoJza71UQr2FFpNdKG3
	 naTkp220RbSI5AlF1jMYCXYgvD+Xs7COSVVlQDSRIAnrkMc1UVli/IhLGhUjotYzvQO0N
	 4Hy7A+jQt2P+AnGzJ/IY/C5lcnESF9FU8/mb5gEK6kba+aWzEFvyJsDISFRtl0qcpxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sy/seoZZQ/1jq+saYI2uNjxnTPB0w1YJ0S3M/dkWldo=;
	b=MlFDWPVU5cJFFNvKs3RffoWL/yNIdkkS02W1Q9Lr9OQr7dvhRFKwx933uaAjheOtha3N
	 h9rkxtSJlEKl0nhFQhSd7xwA3AQfXdSe7k+vaErjRMmNMpI18455zpiwbLL0Kr6jQ1KAL
	 FhxUkdxeBAcGFCu2oTqIJlIkPFMlbFl3u/RqZwkQWVt/QeXQ2KNowlzkgqQJfoPZN8il9
	 7czS8+khn4y6LD8WsVwkhp+ekfu9fD5pDcJxn60FtuTxs3eDIM5eFRM76IiseD0zRXCHF
	 Y3riZNMRCSjv9a+cvhQKl5jing+Pr7NKE5bKN6kPB8SJWxcSAIq8PNyIsvBoElwFzbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fzr9CFoE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5E1606A325;
	Thu, 19 Nov 2026 00:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fzr9CFoE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9301F000C4;
	Thu, 19 Nov 2026 00:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048062;
	bh=sy/seoZZQ/1jq+saYI2uNjxnTPB0w1YJ0S3M/dkWldo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fzr9CFoE0PkBvz7o8c4leh4kXmKiAyjOgWVKjdGtSwbjzQYtwedaqtVjqfy1ct9cm
	 ea7PrjvmjxgPdYOMMF9TU7hySWDgeSqay6UynoH5t709Ef6Rql0bDCaTjMYCOB6Cwc
	 Wk86ZgC+JzxLOA5+78zfpvyaxztwdAQVrkr7qh2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1821/2857] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118150306.834633060@linuxfoundation.org>
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
index 6d3392a7edc61..57f4a3b9f38ad 100644
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



