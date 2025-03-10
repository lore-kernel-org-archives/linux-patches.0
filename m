Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A49227EA0;
	Mon, 10 Mar 2025 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629592; cv=none; b=eINWUaZMHxEHJMWbEVILXqjnm75jZEULhpfJdprTmblGR1mu2+Glsu5WAIg6Nhcjb1G/vc6HH0UeKBMDdKcM5lLlxpe0y4DGh9La77LsUeaDEamzNqL7x8Z2ky5piddbPpUg/UjqInfwpQblqKCZNk3vpl/XW090hN55hvFDGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629592; c=relaxed/simple;
	bh=m0XOERH+x7UblF+aGJHDZLrf+AWUTHhvEKYXU7XrLY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8ktbPTo1hHJ+WbP0miDMVpL0mSFAdRoPzYXy1BnOC1zo8AFBcrAXi4cmSxddV0ruSplYx2tBT75PDX0uDpFb+KSxkqfjJO81f1n0tDohbnIvfLhevb8CqvwL1xDpz1eC6oBRy73osGz/NHaEjwKgA1+n4c2Q3UqR8QW/U0o/2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQPKaa0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQPKaa0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA31C4CEE5;
	Mon, 10 Mar 2025 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629591;
	bh=m0XOERH+x7UblF+aGJHDZLrf+AWUTHhvEKYXU7XrLY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQPKaa0n1r8qOYJfj8xDe1ZOB16vQGKrvXb/ZMwyEOA/534/vgMvvxa+psFGzkPaj
	 pc76sSn60UdgqbAvtpEv8Qv08JtqXuqnwlqGNBrubwY67qVFHFEuwdT15WpJ0gMiwk
	 88ABpG7ce/yd0SvG/ZPx46t69jTxfuwGfT8yQ7wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/620] xen: remove a confusing comment on auto-translated guest I/O
Date: Mon, 10 Mar 2025 18:03:12 +0100
Message-ID: <20250310170559.270634035@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3359c23573c50..03c9ec0212c9e 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2276,12 +2276,6 @@ int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
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



