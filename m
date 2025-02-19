Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408441D54E9;
	Wed, 19 Feb 2025 09:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957305; cv=none; b=ZsdUuThUTwB9HXi6x1APqkD/+AL3YSUzVubCqTxaX0gLGVneycC/H32lHj+dODFDw+PqjLB2mkqI5HQ5USk6T9Ib+KtLc/7X4bMmMx5Jo36HgWisqGvoB/tAFMXIvJ8Ysb4EFLtdq4+Ge9grsyNB4j2RIed301ROBXYffMTr4JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957305; c=relaxed/simple;
	bh=PqSmTKYZbgAzswlSqoXGBFqITDTLhRzEmZ+vN/Q21t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi8S6z8HNpKNw/WSXCiG/CvRE09BTI7stDm/ItP8s6YfVC/cmmYmSzocxpLjHczBoB9OFcQRXSnlRea8vkrLrE4M0nwnHi4RYiKVCvrIaYOc9854S1SlOYmQTgQFyrmrlWmn7xeDeg1HBvH9M4Hg6DL/6su3hPJ++aUaIJAL6/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGpIdJRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGpIdJRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB61C4CED1;
	Wed, 19 Feb 2025 09:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957305;
	bh=PqSmTKYZbgAzswlSqoXGBFqITDTLhRzEmZ+vN/Q21t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGpIdJRwVMFxG+k7ARj9TigIax+gGcDZidarI3xZDx4oe0hpnrkSsXfCRN6mcpnaH
	 sGsc9AOrn07xd16IHD8xUoHv5pvpeYZZGYe6oFnSrEbGktKMZQ9EyA8ZbobGWAyBb8
	 qHSFZ7fZabaWVAUmDlpfclMBPTphHd441vHx2ZnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr.tesarik.ext@huawei.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 479/578] xen: remove a confusing comment on auto-translated guest I/O
Date: Wed, 19 Feb 2025 09:28:03 +0100
Message-ID: <20250219082711.842496075@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee29fb558f2e6..22b619f89a1d7 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2302,12 +2302,6 @@ int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
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



