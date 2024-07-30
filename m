Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F521E86F;
	Tue, 30 Jul 2024 17:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359069; cv=none; b=QXFr6ROy+mcxZCTYZ31ED9ATD9BZIRNKfKV8RZeAOheswjTG0Rf2RiaaVJmKTGhkQJ0/4QNg7YlwLqci3+NZgV/hW13Ii12loi5dC9DZf6P/EcX6i6b1R58qV5hIcWmyXKI8gVCN8IUDb003uHNFCK1sD1VFwJ/aD+oe0T8APHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359069; c=relaxed/simple;
	bh=2voThsJzKv9toQoS/szQff0ucJFT1VRuV1zqyACnSe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpt7wtMWWpnlPJtRnu9AUZGhJeOpY9u3jpSGasYAPKUQ4VD3xsdxQyQmvNdP03d7TzAFLzX1ZyZqXDsPWAgALWM84iC0LaTs45W5fCKrO7KIEF8GtJanwPui0uhlkxqW5Ej6FKaVvwzWySaQpf/oT5nyYpkvP5U/Rjre4Ud4UOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkyDUTjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkyDUTjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2935C32782;
	Tue, 30 Jul 2024 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359068;
	bh=2voThsJzKv9toQoS/szQff0ucJFT1VRuV1zqyACnSe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkyDUTjCQOprefBiEL6foza8Igr9iPxCnVKFnMvJ6ezjOiD7LoEJgT/diw5S6cVWO
	 +JbW6MI9Gs5cbqmYBegxj3bHJJKWyj9jrDGLemUAg7qj5/L95Tv251rZQK3on21dQA
	 K130bo/9i8TXANSyVG0yUTVoHHFowYlEVxOCTMfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Ochs <mochs@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 429/809] iommufd/selftest: Fix iommufd_test_dirty() to handle <u8 bitmaps
Date: Tue, 30 Jul 2024 17:45:05 +0200
Message-ID: <20240730151741.644405911@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 9560393b830b415b2151b3dd8e065257cccbffa7 ]

The calculation returns 0 if it sets less than the number of bits per
byte. For calculating memory allocation from bits, lets round it up to
one byte.

Link: https://lore.kernel.org/r/20240627110105.62325-3-joao.m.martins@oracle.com
Reported-by: Matt Ochs <mochs@nvidia.com>
Fixes: a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Matt Ochs <mochs@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 7a2199470f312..654ed33390957 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1334,7 +1334,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	}
 
 	max = length / page_size;
-	bitmap_size = max / BITS_PER_BYTE;
+	bitmap_size = DIV_ROUND_UP(max, BITS_PER_BYTE);
 
 	tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
 	if (!tmp) {
-- 
2.43.0



