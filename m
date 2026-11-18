Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058312;
	b=FkwKno83iOxFjequX/X+rF/QM9HVLs77o9YEfi3caAEOeUUUr2Al4/ylNxLOah2KEsF1
	 achrYypGcNet9RCXekoGcEmfmGhK9lv+tjVRHEQW544aRVc98h61Ht1Zm3vP38SryT+V9
	 cI/tHVTN5SAx4m5FUtNOQuoFy28ht+eZnrmDcsU4dP4l/qHyUyfFxdwhPyUkbu7VA7Y9w
	 E3tSRgiHZI4JgJfOlhGjmWma/sIea/C1i1zi7ZEfMaj1zIfZpQgnjXnShZUakawlLaT03
	 EfOinOskVo1W5/hk4gJS02LyZAnrWE2h4uW3aZCI22GWbLhjoACFpe5iOKfu1G6O/rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aSwnSkU/zDo1wpw2uGFpcOyGnYnfdmuY/YGCBgnrcCQ=;
	b=gTzOUlTyVPrgFnEhFIk+LnPQUwSb32a9FpTtz0+yGHgUFtlZ5KlL4wShIe4uLSkqPHOp
	 ZtSr3CX4ESpXzfzcI2zH7L3E2oFFPn/Yvh0spHjIVgtJcrYcteISHKRZvqc3Z087MnDAb
	 5iCSuEAle5SN+pObhNboC/+r2CrlRHg/njDgKSl50zSBBMg08vRTwxUGw9x3pvh5yBd3W
	 4GzMmc7gf44r7rZFTipG3Q1a3iURlNvGALjubwznGyZsRMOJlwDdYRKOTnj4hE8pxkwDn
	 Jq8KuQKWKb0kclsYK88O4F7EVB3yiYy1AgtaFPIZNUomqxycuBcFZT+sqzKnv4sfM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiSQQO0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9123606A31C;
	Thu, 19 Nov 2026 03:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiSQQO0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073FE1F000C4;
	Thu, 19 Nov 2026 03:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058312;
	bh=aSwnSkU/zDo1wpw2uGFpcOyGnYnfdmuY/YGCBgnrcCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiSQQO0gWQ6TJGaZZiEkfK3JuUKtNFgC/RAZEgOFPlrPKRg5k00z2aV4A9AhEjwhG
	 2Kr8hhTNBJe9JGF+sZUVmAznZM6ibVXg+DRCnvEmdiRYXClDH4p9fR/8klY9eVLclR
	 wmDf13Npz0cpfjhyl8MtQjMjLtYetOCKeoM+a3tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0439/1848] mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()
Date: Wed, 18 Nov 2026 15:41:17 +0100
Message-ID: <20261118145932.474160655@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 521ad948e04934b2d70ae899bc016bbb38802e90 ]

init_l440gx() takes a single reference on the PIIX4 ISA bridge with
pci_get_device() and drops it again right after the lookups, before
the flash window is set up.  The pci_assign_resource() failure path
then calls pci_dev_put() on the same device a second time, releasing a
reference that is no longer owned and underflowing the reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 832b880d1aaf8..85cd273ce0654 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(dev);
 			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
-- 
2.53.0



