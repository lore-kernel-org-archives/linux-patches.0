Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043870;
	b=p0RxnqplWpExwbjvvQa24zA9XhtPBULXIOOTIUTcS0efXjrxCNavcMM74V5doF49+TpF
	 wx3AnBzMR90s+7btjIwiBDPnJgdSW1hf/tl5rSgSLeMeULFantDMlwyJsbJInfdxJOsvj
	 Wm69GtuZMJWlUSRWuAh2ZSJRS0vKO/pYrjhOj/0Pelw9QYgNwhuu5xOmQNkiARVwvGgzB
	 s42YmzFY1k/A390pdZLquP6fvLwrkZOhXP7HwL44byALbWjzW0RBXY7/mmnD3cl5fTuil
	 q8jrtBz2fgD+CGVhprUcBVMXmVLzDu8RjdRrnudPts0nLYDt+T8K00BBZI5AY554xGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q77V3CFgiWUoIj4sRPSg5Gn6NiUKRdiMfojHDoVpYtY=;
	b=CPil5opFteXzJZ0r+FP23unoL0tgzE8eegsHhFkwCHXY0P/YjoKAR0fp5IcalArWLuIP
	 vTWqF3JuwZa7OmwHUyL22amM1aCSIXrpnz9PVWA3ZhKpHfUl4c3NTZIDZkIDh4kpVptG3
	 MfaS869RxP3z+hTg8KFLOOl6FnVkjzOODMzySW8jhU7/ZtHT877s1+hwlHp0j/zGlsbmP
	 4fFpTy9BHQiXnSWm+gy2PDoiqv6t6lsiT4U9moWlz4fTRQCP/6i1Smaue2Y3hJ6yD3yYG
	 3gbJtqbapbPlIk7LFHoMIxqpZ/1KV2dYqUQJEievFD646T6nWsB2f7sS7sIvrItxKQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zA/Odygw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A27606A320;
	Wed, 18 Nov 2026 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA/Odygw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97441F000C4;
	Wed, 18 Nov 2026 23:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043870;
	bh=Q77V3CFgiWUoIj4sRPSg5Gn6NiUKRdiMfojHDoVpYtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zA/OdygwUAiJV9Ng+MLb8k5WDySo+6/GE2EmdROCwiHuHfnDht2jA3T+0pZMyqaPV
	 gwidQOHIUEQ0U6x5KoR2HWN0v3u1e1WiNVOGT6hMxmL3zZwptlDKjdughnt06Cnf3s
	 4KkGSNCL86D9tMhbJDFbx42VhYsTCcSK3izwsPWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0324/2857] mtd: rawnand: pl353: Add message about ECC mode
Date: Wed, 18 Nov 2026 15:22:38 +0100
Message-ID: <20261118150213.108958202@linuxfoundation.org>
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

From: Andrea Scian <andrea.scian@dave.eu>

[ Upstream commit 1e06dbfdfb851170b243d6498e442b449324c664 ]

This just add some information on kernel log about the selected ECC

Signed-off-by: Andrea Scian <andrea.scian@dave.eu>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 80ecacd054ff ("mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 04e62c3ab5975..929dc759c6b24 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -975,15 +975,18 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
+		dev_dbg(nfc->dev, "Using on-die ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
+		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
 		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
+		dev_dbg(nfc->dev, "Using hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;
-- 
2.53.0



