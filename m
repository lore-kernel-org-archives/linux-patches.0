Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060391;
	b=zrs0s+yf6qtbC9/yw1l8YT4MVf349jfiEocXMppNgvEwrYKZnQaUUgPoYM1kjA1mvF3Y
	 CoC4hi8ivE3TFh6JSd8961urwF+5eCyb3MhFRzOcSRLeCRCoHRTAPunVkr5PXWURKmPAC
	 5AEQIlkfDrp/xOc3U4PF6luxoDDRm3t5zLQmQcVnUwzPiPKh6GqPBeHfAzy70fXp4KboU
	 vDJVjWIqdRcy/hz5+ChZe6SWrloePn7v5AvNBO84w4BpAr4Sbby1e21qxle2LMthrL9bC
	 nMBBr1Id2Q7MlxHyN3bEvzch8E3PrjNNkr+RvipPPVy38KSlsR8zdu6WAcu5l/Q+wRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XmOKNHXw9ibpqU1AIPNHf0nbqAwsGGPOyAWZo10pVbY=;
	b=lMiyW/LQP2lnu/0uyeOw8WiruSv5W/4Cn49cvQUt8kcIK2PWE6asegEA2fXDd02r0NPU
	 lYSjn9uB4Q0+SM9pCdsrNOEWvH7G/1MtdKhdD9uy0w2GhrW9DUgy/+iEffP9GaZk3vg6A
	 an5xLy2CckJbMYTwYgHCeojMjgc5esWpnU686AWnpUDd8RD2kfPsbMyTZwc5EAzWyTUCr
	 BWJg5FbeDaRnkYm7u8hBNrbbZ2wyMbLwJbJVc3uT54pbFp2A2aS20OwBYSvMHtzsZnScB
	 JFlEv1A8DosPQRCacS2q5a1j4UKtphVcI6KMyOjbp5Dd4Ra0TrxKVPrYSe3QK2IEcXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbZ6g8jn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0293B606A325;
	Thu, 19 Nov 2026 03:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbZ6g8jn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550E31F000C4;
	Thu, 19 Nov 2026 03:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060390;
	bh=XmOKNHXw9ibpqU1AIPNHf0nbqAwsGGPOyAWZo10pVbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbZ6g8jne3fo5cxXFIANaXQl0AfScpiOQtbJsNsMSf8rcvTNY19FpWL32ORiSYylV
	 uq2kN6/Ht+JzqEvbn+2K+T3n3X4xpx/GTRVRXPUIIrhuC+RmVGXzIKoQrtaq8IuAKp
	 7rRbkm5GxP6+mJbPGLV4peYJA93T1W47LfG7TuRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1181/1848] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:53:39 +0100
Message-ID: <20261118150008.992527924@linuxfoundation.org>
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
index 7b78c4ba9b3e9..b232cb838a1d2 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -208,7 +208,7 @@ struct spinand_devid {
 };
 
 /**
- * struct manufacurer_ops - SPI NAND manufacturer specific operations
+ * struct spinand_manufacturer_ops - SPI NAND manufacturer specific operations
  * @init: initialize a SPI NAND device
  * @cleanup: cleanup a SPI NAND device
  *
-- 
2.53.0



