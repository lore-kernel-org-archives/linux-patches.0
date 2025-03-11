Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CCB25EF80;
	Tue, 11 Mar 2025 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705831; cv=none; b=sXD3ZvxVHAJyOpqUoKddRDawDyBhtfHsrA+aED+n4WdJQUUje2vb+IMCpvMFV8DxqqbE9ID6J1qmHtChGzHgxLce2aTRD3XWpyiAKpPQI76ehnQv1k3cCmFeVRCaUYFYcmSyjM120qUY4Im4xfqlhvQNtpPFKzorByLiKY8lp+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705831; c=relaxed/simple;
	bh=URZ2u/xfnt4GiM1rgRJ8ifEF4Es3IEMFw+3jH94r8J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHK1owQlOQkxYVvEREuAvA2u6B1LO2u50HenNfPrRLzYRmqk6qkmkOcAp/Ad990CwdA2HhA62RJN+yTD36Gf0MOlaXHnonM7Nexy0CY0keigYIMz92KksWEwbJhqsZW/ZFrFtE1adRdesLdLeWNvF9B4rUkFG6jU7fj5StBDv2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ky+mWpjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ky+mWpjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F20C4CEED;
	Tue, 11 Mar 2025 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705831;
	bh=URZ2u/xfnt4GiM1rgRJ8ifEF4Es3IEMFw+3jH94r8J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ky+mWpjBoju5OdciVXYdan59Y0Wkedep5Mv7FfsfQjqZbRh6mxqf19P2esSS/u/tC
	 Zi2VkwtRberxa0cKx380p0qCmL8jKmBtTDiJCNVftp3UnsMzvXpR4jRGb8zSOda92n
	 UgzxHsYKIdIY25+Xvck5AI4eUv0CPXpW51pmDjGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/328] xen: remove a confusing comment on auto-translated guest I/O
Date: Tue, 11 Mar 2025 15:59:00 +0100
Message-ID: <20250311145721.666151323@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Tesarik <petr.tesarik.ext@huawei.com>

[ Upstream commit d826c9e61c99120f8996f8fed6417167e32eb922 ]

After removing the conditional return from xen_create_contiguous_region(),
the accompanying comment was left in place, but it now precedes an
unrelated conditional and confuses readers.

Fixes: 989513a735f5 ("xen: cleanup pvh leftovers from pv-only sources")
Signed-off-by: Petr Tesarik <petr.tesarik.ext@huawei.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20230802163151.1486-1-petrtesarik@huaweicloud.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: e93ec87286bd ("x86/xen: allow larger contiguous memory regions in PV guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/mmu_pv.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index c8dbee62ec2ab..5d54a75eb8781 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2592,12 +2592,6 @@ int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 	int            success;
 	unsigned long vstart = (unsigned long)phys_to_virt(pstart);
 
-	/*
-	 * Currently an auto-translated guest will not perform I/O, nor will
-	 * it require PAE page directories below 4GB. Therefore any calls to
-	 * this function are redundant and can be ignored.
-	 */
-
 	if (unlikely(order > MAX_CONTIG_ORDER))
 		return -ENOMEM;
 
-- 
2.39.5



