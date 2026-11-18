Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054798;
	b=VRXnAuU/ZdBcbDYAEqnwyKOsbUgRW9cZRhjR/ZbNk2XllcTNDdXohlCvGWqOd7A6QkFE
	 qSB5tUjZs6Ep91AeT77f2OnJ8SQIlUNLJAmmdtjax7e9EgMbGqfGRHazLroHVjs3ZfIO6
	 cIeaPlOcZS74oR94n5L5ZSCSj3yVjr8L6BfEMuBvod+RFubZ7ca2NfZfx6ca0JU42K6NY
	 Q0l80sr9tq1e972TorlRH5u14TuMsUzSOAMNpGaZsiXlAlOdGG1+HYbG4qDA6xmB3H7jN
	 A2VkwqxQ2A8qEC6yXaG8K91I+aYEEf37ab/JkHEtfqWpvd61rvkyOiIAj03w/79TYlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Lr83l2gP/UO0LK8pH1nPRMvTrdOp4/VYIrat6MZqh8=;
	b=QiqfL7JOQ/JxiLbH9EZ/i3RIq5qFAbVzyWnXOMVz+gSB4PEGDebvC3lN2hv40gIgliAx
	 lkHJeacGHRSjEsmOggRjFz2BqLvmG8PMKomeNtI3B6fNY26RLZdPaWvkBo1FFu9NVGWnM
	 w/1CLlvKTF3GEniP3teYAYiBCRBKbo7tmwwVeLbVavnn/NpRKUg+LTMX4Djnr2azLwOFU
	 6nQPilcB93gTI47qM0V60rDfnKwXhM8LO5FEMzO80T+UZS8JHE4lAQx7Kyj+s8sid5X71
	 uVAoOXS88DSAbFGjTheMNiE3n8nbtNaLAnnUATlOPWQKwLGxGMunBGCJIlAQCnmoRqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IT0Dbkrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA681606A31C;
	Thu, 19 Nov 2026 02:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IT0Dbkrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072541F000C4;
	Thu, 19 Nov 2026 02:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054798;
	bh=4Lr83l2gP/UO0LK8pH1nPRMvTrdOp4/VYIrat6MZqh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IT0DbkrzoVh/a03YY9OnBQMRu1uaGTqLoEve6rALcME48f1t8S316ot8Ktdaej4D3
	 +9ySZbuG9RnfoOSONnQt1vJU6RV2jCpRwfPmfHLz73bLlcxiR7y2mSImYV0UARaOCr
	 72rE4+1p9hxIhRnJG/PG78bmZxo+Rs7v0PIkxW/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1403/2214] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150107.408737917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6988956b84929..455cf0918aa61 100644
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



