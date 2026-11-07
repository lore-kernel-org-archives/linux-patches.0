Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064865;
	b=vi1bwOgUnv1i/NmoE9m9M0njoOrEIpB5vLNI7qdFEXU9uB+aqRgh764jFyZzAGP2jitf
	 wx3GcnEAmMh9KJic8scBUZNXcAQSJaT9zx64ir++1ugBzkRtYannCJcZAXlq9K7nsrJiC
	 DSLtV1db4UZHyLuON2fmnp2vD3JLx0iqk3PaQZeh4pxy+jUbvBc89NX2uEwj01AvvhSpz
	 FxXbLRqWodL0rWGjuGxyoHofarkJvgTvQneLdSj3xs3NEpX+MOSppRyNc2DKS1CkyvIOW
	 an5eqGz6ZqQCsx67nTcnvnfSe0sbqDAlwAdbDEvstp6TkW8parE1y5aTeTt5N17Kt0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4CJWef3yISEHLVtZk/10yilFRSNrGS62n0eIUZdKa4=;
	b=dPssnGyYp2XB/fXq1pSfb1LjoHo5FmCkGk/CRxN7hMbbFehVNwvg4u87jtOsZfOF9KN2
	 H+jsRNJDZGfdxQeUwTlMjzgVzeaN/GdnI8/TvZAcM2lJZ+Ctcp3tT33xHm4WQSs0AmRfd
	 bMFLj8kztzMB5Fb5vdg+Qu9cAvjZGSMHELCp5EPvppem1dk04MuyqZtyBcFWSIgeYM7oE
	 M56cETB8+GEWXSn1JD8FtaUPuqYGeL/BB8ejjctJidI4c4/bA4ANl6/6VFhLvY9S1YrXP
	 3+hzvejugH0kdPR6qiJXe4LMRz6tvZ7rznP+dQIbu0lJt4yrEJ0HP6y1Nevp7yqRv7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RgGJZqZr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB6A606A9D2;
	Sat,  7 Nov 2026 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RgGJZqZr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639221F0089F;
	Sat,  7 Nov 2026 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064864;
	bh=Y4CJWef3yISEHLVtZk/10yilFRSNrGS62n0eIUZdKa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgGJZqZrxhPr1ca+WpX3aPnCGrArauklZDQERxgsi9Bt0a4WoexA2K4bsdfNMCw3Y
	 sXsWwN3bu6KVRzV1f2WqB2Tw00Y9RiSjfdrXIgd/as6aWlaE57WwqnqnuPicgWnpXE
	 jjhzgfHMvdtjNvh+sROAjzJ9PsV+71ixuf0Xnph0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0782/1257] iommufd: Keep dmabuf PFNs MMIO when filling another domain
Date: Sat,  7 Nov 2026 08:51:18 -0500
Message-ID: <20261107135000.912576235@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 769f2cd9226c96619d77fa16af84de74cae41b6b ]

A VFIO PCI dmabuf mapped into an IOAS is mapped with IOMMU_MMIO only in
the domains present when it is mapped. A domain added later, or a copy
of the area into another IOAS, maps the same BAR as cacheable CPU
memory: IOMMU_CACHE set and IOMMU_MMIO clear.

Once the area is in pages->domains_itree, pfn_reader_fill_span() reads
its PFNs back from the storage domain through batch_from_domain(), which
adds them with batch_add_pfn() as BATCH_CPU_MEMORY. Only a hole in the
span reaches pfn_reader_fill_dmabuf() and gets BATCH_MMIO, so
batch_to_domain() programs the later domain with the wrong prot.

The effect depends on the page table format. io-pgtable-arm maps the BAR
as Normal cacheable instead of Device memory, the AMDv1 and x86_64
generic_pt formats set the SME C-bit on it when the tables are encrypted,
and the RISC-V format with Svpbmt maps it as normal memory instead of IO.

Read dmabuf PFNs from the recorded phys for every span, before the
xarray and domain paths. The phys range is always available, and the
read-back from a domain only serves to avoid re-pinning user pages.

Sashiko pointed this out while reviewing an RFC that plumbs the dma-buf
memory type through pfn_reader_fill_dmabuf().

Fixes: 74014a4b55f5 ("iommufd: Have pfn_reader process DMABUF iopt_pages")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260716154123.32DC01F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20261008125206.11990-2-parri.andrea@gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/pages.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 404f31d8f7291..2f6153108add7 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1178,6 +1178,15 @@ static int pfn_reader_fill_span(struct pfn_reader *pfns)
 	    WARN_ON(span->last_used < start_index))
 		return -EINVAL;
 
+	/*
+	 * Always read a dmabuf from its phys, even where a domain already
+	 * maps it: a domain can only report CPU memory PFNs, losing
+	 * BATCH_MMIO. last_hole aliases last_used, so this covers any span.
+	 */
+	if (iopt_is_dmabuf(pfns->pages))
+		return pfn_reader_fill_dmabuf(&pfns->dmabuf, &pfns->batch,
+					      start_index, span->last_hole);
+
 	if (span->is_used == 1) {
 		batch_from_xarray(&pfns->batch, &pfns->pages->pinned_pfns,
 				  start_index, span->last_used);
@@ -1201,10 +1210,6 @@ static int pfn_reader_fill_span(struct pfn_reader *pfns)
 		return 0;
 	}
 
-	if (iopt_is_dmabuf(pfns->pages))
-		return pfn_reader_fill_dmabuf(&pfns->dmabuf, &pfns->batch,
-					      start_index, span->last_hole);
-
 	user = &pfns->user;
 	if (start_index >= user->upages_end) {
 		rc = pfn_reader_user_pin(user, pfns->pages, start_index,
-- 
2.53.0



