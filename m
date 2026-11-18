Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058133;
	b=OKToz3/hoxkji/sp7jwfTMm/ObQHhxdrCWYCh95aJwkUbX2VVQd368krJZKk1Ow2SrKC
	 EErxPrRANnTYfKn7XvuEgiXWh9bqRmJEeZSMRjkN0xBYtWzFv9FC/pWroD73YxH+iXmkc
	 eJhIyjSMLjOaGrQ1CUzUpNMBqljvhDGasKMhU7f0vSWOiGhK9XP71alIJZZjEAKAePFvs
	 8IVOWs6wTmnVn3d42LVSKT8XLumwz3mIESamIZE1LSPXJWslnJt48mp0rzI+iU7/8EjQb
	 5nv0gPLC6ldUdwOEiQe9lIl051cDsFDx1J9r97iBnitwmDGWaOFYHX/eSOuAyjel16g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HGPrT894UDWTbAVJeTvMDXlRO5nH3CWpkWdcKKqTdV4=;
	b=fts0lSIzrIJVag+tkGLvUbvxnPjJ1RQMxc3FBaShaPCtvYvnKVj+LuaH5U7yV4x9VgYc
	 a8qFRyVqQHfK1lU82o8n7g66dR7YY36uAmMfFSyCbMj8rwRpps3vSaqo75jtAA9B4GzdE
	 fho0Tv6Yg9L9o4LVaTd2DebYuxS8nGMOo+RAJehn6ublhpIukd+vG/Un2ewo9+ABDQoJG
	 h+iFyvaumANjuUYTfEwB9mLphH/BMnBZP43ecrdsvxc6tOrtK0AE0q56gY3eap5OQmxL8
	 V5h8Hw3kJBzGz4c0tPPHUuegreq+X+/NXLUY994ip4ZFx+Gqkv1B3PF/xWjyW1nyQPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSnpElTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FCA606A325;
	Thu, 19 Nov 2026 03:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSnpElTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A241F000C4;
	Thu, 19 Nov 2026 03:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058133;
	bh=HGPrT894UDWTbAVJeTvMDXlRO5nH3CWpkWdcKKqTdV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSnpElTiwCaAmmBhHW6Cqe1ZN+bKUyW8NNshFwVCM8qtzsaSis+FuRQZds8bUJR7Q
	 pXXzqKUCoBAmvvtKocH9iDnzs4M0MYge3hX+UbKzlJLrUSnUvh+0WP8cXx8B+kDMuQ
	 MHQhb/BPqxhAZK/DsbLqecfGFWUjVyaWX1TB4UcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0377/1848] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Wed, 18 Nov 2026 15:40:15 +0100
Message-ID: <20261118145929.262797522@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit a3c84084a73e170374b7dd493947efdef4ee57bc ]

When nand-ecc-maximize is set, the driver selects a 1024-byte ECC step
and divides the available OOB bytes by the resulting number of steps. A
NAND with a smaller page therefore produces zero steps and a division by
zero.

The older controllers also provide a 512-byte ECC block mode, but the
hardware documentation describes that as an ECC block size within NAND
pages whose supported sizes start at 1024 bytes. It does not document a
512-byte NAND page mode.

Reject pages smaller than 1024 bytes before deriving the step count. This
prevents the division by zero at the point where the incompatible
maximized geometry is selected without changing explicitly configured
512-byte ECC block handling.

Fixes: 4796d8655915 ("mtd: nand: sunxi: Support ECC maximization")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 7ace279778db1..eea4e8c2b6293 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1620,6 +1620,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



