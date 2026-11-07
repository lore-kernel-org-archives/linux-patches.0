Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063921;
	b=wkR3dABl9gsIKyD08sB3WJVDMeYQCaGSmS8j+5GP4yWvz6VyLp5+Ms2+35+ZUwg2uNfr
	 JdeXKL6Hsrpub0/6A1d7sAJZoEBhrkVHU0ilnMThI9zEUGU3HbMXyYmUhkartes17giA7
	 iy8SciJNrepiS9+4gwj5otUsv8IWqvw3Ox/kk1CuoQDfGqu29dizqS9mQR0+irFo8iGg1
	 aEiLG6OEZeMn3h4taH+esAbA9a9AJpYUNCIYwFDQ7uk3ERlASKD5HbypsJAMKRGI0q2qO
	 98xlVJgE9z6SlkrT5KyYFAqGfPLQAEdCCZwA75UFsMNicraFYejrni3ZxI4+E9/gRrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKeZQX6YgkzT/MrtHXgEtZ/UyDF552SsT+ApVbXwt9c=;
	b=MZY/Gp5+VVqiIN5QfdObLfyoLDL8M1xlpbBZTDhuYtiYhT/4kk7sn3KvlMaDj59Pis2i
	 VhxL9RXvjeMlDzKC5KGDrNE7yzuk19UII6EfFYb8maMLKrQtiy0emJoprQnNp310gQfSW
	 ScKLZcDkH4u1bfHnOnKgJ3wT27I6jYJBcQ6kFKNGVbZbGB3YA8p4x6hEWgjlUYfcnMoRq
	 e8682Dv3BRVslgHlZWPlfDQlDTgrHBV+Ldkb+PZ5M+h+YSp/iaTi7zwVcZd7c4cqPZNBd
	 ueIQPXdF2GLhr6h/TUIFQfZw8KG4M+duqNNQZD5+RWSzH29E+mTZFqJHpGmkI0km0fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VtzeBzy+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13D2606E8E9;
	Sat,  7 Nov 2026 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VtzeBzy+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8001F0089F;
	Sat,  7 Nov 2026 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063920;
	bh=MKeZQX6YgkzT/MrtHXgEtZ/UyDF552SsT+ApVbXwt9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtzeBzy+XeL8QZyaDWjdrdj6tfeEL2zk8h1b39qWAuMmkjiuz4TOWwWcfca4oWCmn
	 /zpSJfxmxnhtqeID4VG7BIIODfUuRN99b2i5IStG6PRi5IyuMHbuAOMvMWgvqlgv8e
	 0nHQojEwP5Co37dZZ0joYWKmyBuO0FtkKTzKDSrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0116/1257] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Sat,  7 Nov 2026 08:40:12 -0500
Message-ID: <20261107134942.546911174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 45ccbce91551b..4f9c229c34bc0 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -2077,6 +2077,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes = mtd->oobsize;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



