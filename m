Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015769;
	b=D6fJ3m9hO3HD9kxa3rdooZJv2BuGwOKkkdalDnvUOs6BXw+lFhvcI/IXUHg+YawdP777
	 YKZjiZEuwEjiqZJY46Mo70rS7OpiERugQ3yuwQ2f6OANBIZ9WkPOKHe7VyaU+ZFadVymn
	 bZ+cPYs4Y9obzg04pFT0bkQJ/K5LtX1kNv9UIq2dibZR80lW7CqT2/X9I6guAEfQhpiz0
	 Vmx4TN+XAFwULNkQUPfed/krdi6DAMhbeTtfXITdJRUzOetJyV0/Y0WIIuWMOzQj1YCDZ
	 H6E4l3j59VUdCbjCfp97amWG5Ou1S4hCJX1HSMmUjtrGhXt5r2YBm+wyWw8NTfnhiHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tl/M4JaF6Oq9/kM1qZ/128+HIPOcsRvtAq5/y56vlkw=;
	b=iBCTXVtNilzbKWAPnQxNP9LbzIG9FZOUQOiW1VmIeesee6k49qOxQVjn48tu0yFqgV8n
	 O+aS3CFV11ZAB986YaB87B+PJYlrMHSaGoGFCxTEDwVx7UDq/RW9u9qZ8hMldsrrYb3do
	 nMx3kfp/q4IWxG4unVT6iy4MGw/JMBh2axqkcZfoAkgcT9LmdsqXelOlwZc4KwC60jK9o
	 E/xOZZsBfMZHQUPlIcGuWxXNDEKgRRr9doe8bkhlcSfne7M2CDXkiSwTj+N+aoAjbCHPk
	 /XhLNJSwBAnGlkR3N7vjv2e8z8YZDGjrzAS6H9l7EVPwDS8ggopvQmwkLMyL9vmiy2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSdFhc5y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B240D606A31C;
	Wed, 18 Nov 2026 15:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSdFhc5y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A8D1F000C4;
	Wed, 18 Nov 2026 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015769;
	bh=Tl/M4JaF6Oq9/kM1qZ/128+HIPOcsRvtAq5/y56vlkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSdFhc5yItgIxsP2ueO8SWGSBe8hmNZ3DbtkbzhdsrEDR2MioKY3l25zWCBYt8LS8
	 sZTcqndhklWIIiN37DThYLU5L+JRyn8YaOZXmXKIhvl+uw8+HXyecLeFNAnYZ+NcQW
	 DvyjeA8a1mqi/DhmpswzN2gyBJXjQa8WQj0FpEWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0289/2651] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:25:29 +0100
Message-ID: <20261118150258.310941110@linuxfoundation.org>
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
index 5f4c00ae72a72..0bd3f30ea57e9 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -399,7 +399,7 @@ struct spinand_devid {
 };
 
 /**
- * struct manufacurer_ops - SPI NAND manufacturer specific operations
+ * struct spinand_manufacturer_ops - SPI NAND manufacturer specific operations
  * @init: initialize a SPI NAND device
  * @cleanup: cleanup a SPI NAND device
  *
-- 
2.53.0



