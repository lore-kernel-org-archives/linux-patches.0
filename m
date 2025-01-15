Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F24248BAF;
	Wed, 15 Jan 2025 11:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938877; cv=none; b=M0p20K+41s/GPJZ/wyEGmppnUWy3zOzBC0ahnOlEJNJAVFMQvdNfOPyBs67k7opz2k1sztPuTSkBQsydrlB1OsCEQl5MUPueykhVdP3nsywVldlsX+uyRGi+krPFntniTvo6A8L810t8xKCitCbuEaiGfBq9nWFOSo3M7TIbEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938877; c=relaxed/simple;
	bh=vyqcikisDEEY9eixgAtyyq1EN998fpwk9AvJOt12xu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4nSNrM1LVcRtXuFB/3K2YBaooMgBqc5MUqDAca6fLeGpmJaVbgrd5xMAdDqVHVYSVl3CSNXRUpNqJklu8wO+Co2bJgVCQRQtPXTFfuFSNwGbagvTMT9utBZiw3JMg4aUPAqt0K/K2g2veoBUj0KutZ82DCGLcFi3KBUlge0Xug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Akc4vR9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Akc4vR9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF26C4CEDF;
	Wed, 15 Jan 2025 11:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938877;
	bh=vyqcikisDEEY9eixgAtyyq1EN998fpwk9AvJOt12xu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Akc4vR9XEgffYSVRftU9yRHdsYDW+JMGTbtkU+F34AJsrePBQGx1yoIpE1Kw+5JiW
	 ZFRGkDzFKgGB3JLY/LjSQqx/QFUTq4Z0wJFmxCWktrWGvm8R6fWmt/m6u3xTmi+0fv
	 HwST8k4Oz9Ryjkrae9evmScqxaFc1Bg20YPQsqp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/129] pgtable: fix s390 ptdesc field comments
Date: Wed, 15 Jan 2025 11:38:19 +0100
Message-ID: <20250115103559.300066372@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 38ca8a185389716e9f7566bce4bb0085f71da61d ]

Patch series "minor ptdesc updates", v3.

This patch (of 2):

Since commit d08d4e7cd6bf ("s390/mm: use full 4KB page for 2KB PTE") there
is no fragmented page tracking on s390.  Fix the corresponding comments.

Link: https://lkml.kernel.org/r/cover.1700594815.git.agordeev@linux.ibm.com
Link: https://lkml.kernel.org/r/2eead241f3a45bed26c7911cf66bded1e35670b8.1700594815.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 20c96ce98751..1f224c55fb58 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -398,11 +398,11 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
  * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
  * @pt_mm:            Used for x86 pgds.
- * @pt_frag_refcount: For fragmented page table tracking. Powerpc and s390 only.
+ * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
  * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
- * @_refcount:        Same as page refcount. Used for s390 page tables.
+ * @_refcount:        Same as page refcount.
  * @pt_memcg_data:    Memcg data. Tracked for page tables here.
  *
  * This struct overlays struct page for now. Do not modify without a good
-- 
2.39.5



