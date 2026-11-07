Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062002;
	b=v07A9AypR0vYGP4qgGrdNU2RK657prqNbyVYZrs2CzFXpYyCurCg3EYM42pN1GxQs3Zi
	 tc//s3byy1Xr3OuMeZ2rXJwawE0/8gANHse/lqNjvaIzCptg1Q9BCBh1L4m3AOef8D2US
	 CjBcIu9YYqtUuXUN+1rqjSDvjsuYrvsmODUqHN49Tgw8CAX+DwYYKQydVlUB1J+u6xIUh
	 D+JFvn5/++jYJF/aMwpGuBTVLioPdKYc7AjBsBU8XUGRyKekzJqmuLMFYbkhlX9rVV3Ew
	 DoBabiW1a69lmqPIl2aqmAOu+A7j3cy7zDUhljv71mu1Y9uQQy4ufa2OIfM7SLtQzWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VLbAeZb/sZV9CoCETsBUa0X08WQb9upn3JhHmGxjJIQ=;
	b=wfcuAH/nmRp+CabVNayEaqn03kmwDoToK6BX4m/ylj5U2V2qrp32AEx0pw0++8QjTWCe
	 WGC6G3NBjIy++0AoUIRBM48bDOVHjd1Ol0ZKBNn8f9wldz/f5uYpRAtApuw+Z+1d9y6aF
	 ae9LFAvMQ6X885H22VUinGHr2CUSKt+u9IJWp2+G4FaYc86KpFSXELvD52DkZW4tt4qQt
	 KQWKsbgr/kVIf+HF23eB6K8TpA649zmTR0hbETeD5Nk8OfKncctO1vGSfFRucXUIxewxv
	 Mx+uxxkM3qQha9NYaXHV3/6FYxx+rvejGK77r12513T9i+8GgR1JVv7I+Ch+CQQwsxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMk+wKAz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364BA606A335;
	Sat,  7 Nov 2026 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMk+wKAz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A2B1F0089F;
	Sat,  7 Nov 2026 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062002;
	bh=VLbAeZb/sZV9CoCETsBUa0X08WQb9upn3JhHmGxjJIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMk+wKAzhpGR6QcYLHGSpcVqWoOPpzpmel3OW1nODw6FaOj+jPT/vmgLhDjAmivL2
	 grYiDUPnYZ1E5BKL0ibFz3vt/o6lBDIap/0OGWbBW+jDg+061BwOpOH6fBwqoRU6Fk
	 aDLldny+DJyAbRRA0WToJy+tXZnWuYGuhdD+Ukcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0954/1536] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Sat,  7 Nov 2026 08:49:30 -0500
Message-ID: <20261107135024.448229548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 136d67af97178..ead73f3beea13 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1631,6 +1631,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



