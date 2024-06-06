Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D764D1974EB;
	Thu,  6 Jun 2024 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683460; cv=none; b=o8GhKGRDXi8Tx22OJvNMDlb2sbO28yhJ8rd/hHK7UKk6fBX856ZTHbOzqeSdBaHDwE0N7rBQpBmFr+TPW1bUKeJwEc2xziaHtabjNy4irH4BT2i23RxBbXV3mTdueI/I8b9RZpBlAMWGfgZ3bM1i1GvvgvYMsA+y7oFkwt+Dj6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683460; c=relaxed/simple;
	bh=4NrrewIIrkvxLD98vGZWp8Zpwo/8PBKcdyDLlOGKqbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llhfePcXDPMrS3tamU4sozr18sKW1R7Pd5mEAu0KlRiXnyIjXmy42zlqfcH/KVeoS6huA5mo3TXHYTurYx6Ttqk8GphfzsAZYqFobITWstiYF/2O5YbMDlHiHO9CuD4GJ+6LzlCYKVgfhnWd2Qt35TbsCP22ADPa4zH8F6BtSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uy3dVnPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uy3dVnPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B567DC2BD10;
	Thu,  6 Jun 2024 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683460;
	bh=4NrrewIIrkvxLD98vGZWp8Zpwo/8PBKcdyDLlOGKqbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uy3dVnPe2qeqXn+WqFY6VG0O3A3SEY9/aorU52+g4jafL/410Z1dBo5KHXR79b//N
	 CnIFoiqKruVyWN6OcAdSYeOtHK21xaiViWfgr2UTGt0WRP3rE3tnpSkkkNoBTUBCHa
	 fgbBvHKkQ6onPSjW/pLmGRypygV/4ddcZ70vJhu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 405/744] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu,  6 Jun 2024 16:01:17 +0200
Message-ID: <20240606131745.451642420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index f86939fa33b95..6fa797fd85017 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -598,7 +598,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



