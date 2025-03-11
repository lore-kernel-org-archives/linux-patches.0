Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09FD25EFB5;
	Tue, 11 Mar 2025 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706984; cv=none; b=M+Nmb3rQ2v68Y+5sncRYOmnCizkCDzm3hdh/pSMBZpOXjxz714W7gNkUZutpVfgOrr18yXHKap+qPUlzX+BRJpbrMfXP2PlvzmYH3uktyNM9+KlzRZq4HmyA9c4/2rrx2Dtb/rRF5+vN0IQ/c0pqLKxuM5Vcd/Z4BhAQE+5pcfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706984; c=relaxed/simple;
	bh=rp76qovVxbGw1/jzSagNgPuQNXSZsROloxvar7OCMKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=patKXw+FdeyCOKzIX/d4Clt1S3PbXcloOvyeQ0Z46w5CM59h7xWwXnqWo6n4HG3ystcxDqfFjOVUZf1L5VdTJkbHrK7TlK/jLnYfQpOblTpw6lg14ooZn+aQMRAn0BOaetMlWlO54zGLD7YhsPCmlyvM5WLol3R4/Cdi2HGp+CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceMXQD6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceMXQD6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56704C4CEE9;
	Tue, 11 Mar 2025 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706984;
	bh=rp76qovVxbGw1/jzSagNgPuQNXSZsROloxvar7OCMKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceMXQD6tyzQwZoJpPzrJtxbvKRYkfN3b1Xx5VPmIKwKy3YBRch4ONHL7hv3grk/5Q
	 DTItH3DO8yI3zoQTmV6mYunROXHCC31f/WZAcgds8ZqRB9Pcw7CqwH3v+UCXHPpLld
	 A2jXLjneI1yWOu5uDbxsPtEMv5NUuboxP6F4sPk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/462] xen: remove a confusing comment on auto-translated guest I/O
Date: Tue, 11 Mar 2025 15:58:21 +0100
Message-ID: <20250311145807.651323771@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cf2ade864c302..b9844ab6086ea 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2274,12 +2274,6 @@ int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
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



