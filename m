Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064824;
	b=o+Ij28v35EXobi31wpTqk/U8QtWDrVAwxhQPfDmNK3Ol1Dp34laReoRyxeMHd9+dCv8D
	 Zw5xJajXvb98DdsoQQRhxPDWb31xh2G+JXJa1Fihse6uitXJqBVgFBuJ7yERc4Um4iq99
	 EeJIHHrx1g7uOijb6e1Zo3fo/qLSYdtaBf6wIA7nPHeRA8Sec4iOt4jtb24d60TLkn80W
	 Frz4YBK5xGfMfhX3666cdIIdIkTIoUvSXcygKVL7cssdmzmMHsuGXu65nJtkHkfa+k7HV
	 WDJL/4KmJRUtSD1W75Gu2rSUQXnnZfqNlIN9T3fs6yYFQ/BX2ZLNi9Lo9rOlSoJkJeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8q3+1ky0NX/nhOHuhiGoTSpiLUjMCk0+GwfXsSn7DTc=;
	b=Kt9IbI/pRJ0ndsxnO98EhkzISgZsWbAbBjiSc/Hk9TrlTEsjMZM64fmcMKFpWgMhXNIF
	 N+G+IcJ0+3uczqKbz8h90cWVuglcCikgfnGEkagQadospjcUgj54fHCh9EZV4t14RPb8g
	 J8XZwKAjxa3E1jsIOsvaq9/kkueygALxsGaKkbMjwpRz090vTAC0LweS8Jj8ZwuPWpVSJ
	 axUaY1FEGL6nQq6Wo9HsRQPURu7wUTunKC79KQiP4yNSzHARCLx15A8ub5O/9yvQ5XLFW
	 6eaYHcmhogN//zt9kvAylXsPk2TY4SJakID2nHGHZ1MV2XKpHTS4ooa9+CbO5RBa3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUjyQBLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06108606A33A;
	Sat,  7 Nov 2026 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUjyQBLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF3C1F0089F;
	Sat,  7 Nov 2026 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064823;
	bh=8q3+1ky0NX/nhOHuhiGoTSpiLUjMCk0+GwfXsSn7DTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUjyQBLVkKf6bI81CGAOPz0jd2aivy3s6P8oTZH/aMemLyUf7j+bAPJGwBJzQfib9
	 JvGMpt/TFixsT4MSA4k/GtRPBj5z3v0Q/eZoDN6aAiuv1TUToLcheoAKRatt1X4RLp
	 36riN5IAhj8roHEh5oMdEd+HglJqfpYQS3JLu7aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0758/1257] iommu/amd: Program device table when kdump reuse fails
Date: Sat,  7 Nov 2026 08:50:54 -0500
Message-ID: <20261107135000.223253170@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit 05d62be400f3ae0f6856f6910a1281e67cbaabcf ]

Commit 38e5f33ee359 ("iommu/amd: Reuse device table for kdump") made
iommu_set_device_table() return early in every kdump kernel. That is
needed when the previous kernel's device table is reused: the base
register already points at it, and on SNP-enabled systems the register
is locked.

But if reuse isn't possible, early_enable_iommus() falls back to the
freshly allocated table and calls early_enable_iommu(). Because of the
early return, that table is never written to the base register. The
IOMMU keeps using whatever table the register pointed at before, while
the driver writes entries into the new one.

Only skip the write when the previous kernel's table was reused.

Fixes: 38e5f33ee359 ("iommu/amd: Reuse device table for kdump")
Cc: stable@vger.kernel.org
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index edcc187b8f14f..102b7b5d2021e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -390,7 +390,13 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->mmio_base == NULL);
 
-	if (is_kdump_kernel())
+	/*
+	 * A kdump kernel that reuses the previous kernel's device table must
+	 * leave the base register alone. It already points at that table, and
+	 * with SNP enabled the register is locked. If reuse failed, program
+	 * the freshly allocated table like a normal boot.
+	 */
+	if (iommu->pci_seg->old_dev_tbl_cpy)
 		return;
 
 	entry = iommu_virt_to_phys(dev_table);
-- 
2.53.0



