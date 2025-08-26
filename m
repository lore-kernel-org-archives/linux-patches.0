Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53242267386;
	Tue, 26 Aug 2025 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207290; cv=none; b=PYz1rrvXcoQpWUp15vf3kEfjKXmhXlGn08RWCM5ar/RWAxlqQJ7M8qGkFZtkwYqOHczpKYX1Ywpqh3I2iD2O+lFxSFBcKUkZTpsEjx5Saw2thdO1+Kwwct23jao1oROpXp+y3ox0AXqHuV3adJPttueGIS8QodmSJzamD6NvfS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207290; c=relaxed/simple;
	bh=h0pRl72BqCl4CaRQnTAgzXlp/2GZoZxHXmLjiDdNd9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGVdkP9H77WYG3KVneSLtIeqH1P5hrwPqq5pSic8xBiNqiENBY8ZSrjbSyGaH+Nmrc0Asq/LjSxjTOsAlD9/+9xJKLVHv8xYF+h2nJ2ouQEuH1HPKk+PdmxSoThVtiU1eZCJU/47OxERHoH1NtlHEu5K5VOz2Y4E3yESDa4yF9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUz0ukmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUz0ukmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63E3C4CEF1;
	Tue, 26 Aug 2025 11:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207290;
	bh=h0pRl72BqCl4CaRQnTAgzXlp/2GZoZxHXmLjiDdNd9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUz0ukmZC/1b90bPRVTET3Lb4z5PcUsrKlkCdjRAaCXx4ZGpxNWmcAnln5Bq4t71s
	 Na6P2WFfkqr9DxG6cosC7Q8gW0tIpVir9b6ppnYuNDS64A8smJE7auSVoKSY11s7bt
	 gOjSq1lNc1FL9f4EuugD8DhcNFfPa+HylHGnSqVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.16 125/457] parisc: Rename pte_needs_flush() to pte_needs_cache_flush() in cache.c
Date: Tue, 26 Aug 2025 13:06:49 +0200
Message-ID: <20250826110940.463628079@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 52ce9406a9625c4498c4eaa51e7a7ed9dcb9db16 upstream.

The local name used in cache.c conflicts the declaration in
include/asm-generic/tlb.h.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -429,7 +429,7 @@ static inline pte_t *get_ptep(struct mm_
 	return ptep;
 }
 
-static inline bool pte_needs_flush(pte_t pte)
+static inline bool pte_needs_cache_flush(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_NO_CACHE))
 		== (_PAGE_PRESENT | _PAGE_ACCESSED);
@@ -630,7 +630,7 @@ static void flush_cache_page_if_present(
 	ptep = get_ptep(vma->vm_mm, vmaddr);
 	if (ptep) {
 		pte = ptep_get(ptep);
-		needs_flush = pte_needs_flush(pte);
+		needs_flush = pte_needs_cache_flush(pte);
 		pte_unmap(ptep);
 	}
 	if (needs_flush)


