Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045943;
	b=r7wUfK/Ji82rlbq6OvbGskOKVbkcLymSATLql5De5RgpSPcFmFb8+3Uuz6ZCeZ6I9NVC
	 tO4Hyy649youZKIUxQTR0bwGh565QS6wu8oKE8XDP63J9hPg08DcpyAwGlI1KyRWrKdbw
	 IlEhn+JjaO+JX7it355N5JncLX+fUH/CGPdaZHkzmRWEFDjCIsnkRgMwfFIyaSbR6umZi
	 mIEZ7IwvqIeyk0h+gWl/YNqSJXCE5jyVuPf9GBVQMZC2zkhRR7nGLTkHtklfdzYD94JTh
	 lBW5zWUnG8MXuM1QHkcZjwRPxb8SSRRefq6cnIcO97PWIkgGRmx3gvHxfnHvr9cwewA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4uz1mS9SelKE1PryoHPPH91pmRf/O6n5cbCvPJc55M=;
	b=pxW1/TCW3MOHo8rS9VPhanNCAdZRYpzBkOBTTBdTfbNyB3lhB1xlYlYgYN+QNJr9IQk3
	 d9e2r4pHCtkPIY4CcQpJQzJ8BzJwxE/7Gxwwwz/MIrbZ8sJpSrzqRFreFTotXC6FYaZM6
	 ZYQHNe1ZRU+xujrZkOW2BjOAt7DXnttTC6sJZLYt8e0ZoveI9ln8W1fzayVwP3t6dn3GK
	 2HVGg73fdmA1AT/OUKvKF2V0ol6Lc7slqsDIKPTytzcrEKlAel5spU5iyb4LghqPcNh4Q
	 Y3EK/NlqqvgJef/VDGmzSM4b+wDqRBhdwp8V5g//NXZx+y18Q6Lg8keHQiNgspxLKlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKl6GpR1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED344606A31C;
	Wed, 18 Nov 2026 23:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKl6GpR1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462021F000C4;
	Wed, 18 Nov 2026 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045942;
	bh=L4uz1mS9SelKE1PryoHPPH91pmRf/O6n5cbCvPJc55M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKl6GpR1H9l0C2cyDDOCs5wi+BQ9U4W2aklVi+nNlBv+z0NqGP+aH8b8/NdEums/C
	 uRUxWNO41vTaoqhhZuJFFBifyXmDLPK7xXyrWKBGEQIuD22IdHGbRZG2EK0r7+qyI1
	 GdxYbrg8bhyXgL0pnnh7c7q6lw8sEtWu8ArSVMyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1103/2857] mtd: rawnand: pl353: Fix debug prints
Date: Wed, 18 Nov 2026 15:35:37 +0100
Message-ID: <20261118150241.349104433@linuxfoundation.org>
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

From: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>

[ Upstream commit 2b7baaddf1bc3e39206a0354449fdc349945b86b ]

They are partially incorrect since "software" engine does not mean
hamming, the "none" cae is also falling into this print, and on-die
means there is some kind of hardware support; we prefer to use the
wording on-host vs. on-die.

Fix all those prints.

Fixes: 1e06dbfdfb85 ("mtd: rawnand: pl353: Add message about ECC mode")
Signed-off-by: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 1c23ad74b225c..48886a89ea28c 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -974,17 +974,19 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
-		dev_dbg(nfc->dev, "Using on-die ECC\n");
+		dev_dbg(nfc->dev, "Using on-die hardware ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
+		dev_dbg(nfc->dev, "Using no ECC engine\n");
+		break;
 	case NAND_ECC_ENGINE_TYPE_SOFT:
-		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
+		dev_dbg(nfc->dev, "Using software ECC\n");
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
-		dev_dbg(nfc->dev, "Using hardware ECC\n");
+		dev_dbg(nfc->dev, "Using on-host hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;
-- 
2.53.0



