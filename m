Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052286;
	b=Y/EeNjK9/w6BeLb1+qRJUar5jZXU3lDNnQkQBN5vfYY24piUXAeM3TZ0h57vDCVDP6fi
	 EVx8pv3fVEhPPOTcsXsbSSE5XUazMXH7XdYzx1DOHlp+NhVJzFiTxBzBAqCqM4GzD+5kD
	 MNknLH6PCrqw3wDXXcsZFvvyWzYyjQa3pbXR0p68tHcr9cBQ2K6dFxmMcpyfK9ZR1e/7s
	 cg648TscbJ3dsKumzCAD9PQcsJGGgwTpfhJ7qKPMvF8kxudR39uLtJBZWWKdM5YK00YDY
	 qNfft9SuiJU43euIYMn0AWpd9RVBSdWde0ZZlnF5F14wT023ENI4Rcc4r9Y6kgp0vag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XcW9DkNJazaMh++at0DwGb81O/l2PjtkZjXoB+EUBnQ=;
	b=QSCXxIF1xgebgFNGOywrORIJnYb6VTGNG/4ZyrEhgo3aE3qIDcnuhFyjwxqpsX7MIDa1
	 LRx3eUOtMkqNd2xQ8ZTpyAu1/vfidwpK7fmT2XIGqXND+QTHyCxo9g1VpFk1hnS8fH3B6
	 /Rbus09ImcluB5DI4E7ZuUtU7sUbkw2H7Gym1kTRokls8jqNxjlrKFiDqjxUTPh7yqApf
	 7pcYVFogzJVyIYXRCTk7DSOPX1X1wh+hog5cTu+7Q+AetN/SEz21Um2dT+7KgRJVTfIxz
	 YMMOToyI3KgNH8wjuZJ56jM543Nkur6WbIIz0dHDh0FEqObllEPfTzrpYut2Y2VJK1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMeMTpRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48097606A320;
	Thu, 19 Nov 2026 01:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMeMTpRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A82A1F000C4;
	Thu, 19 Nov 2026 01:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052285;
	bh=XcW9DkNJazaMh++at0DwGb81O/l2PjtkZjXoB+EUBnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMeMTpReKqs3yywnJCXlQ49Nc1vDru0G+wPH7BZzmi78CjqRcHOgMsgJgrDN0alac
	 bbzHHmDtL+0Rlr5eZpfF/p6JaaARhBQ2WWl7Uv/BNyc2WxC38nOEXBGu3cOAradEQV
	 qipTj0eFOO66RURjJbGJwk5PrMpU+sREQZHZoFLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0472/2214] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Wed, 18 Nov 2026 15:35:48 +0100
Message-ID: <20261118150030.068296479@linuxfoundation.org>
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
index aa59b884206e0..624403ccba113 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1642,6 +1642,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



