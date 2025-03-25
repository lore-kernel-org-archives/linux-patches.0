Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B74F28F939;
	Tue, 25 Mar 2025 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905578; cv=none; b=S/pbaPnVFcQZuIofqkvaCKvLBuFFr50N4ifG1GapxIDMKsqO9fq9oGKDigJxPeY1Kn2a+YDJpb9YAkA7E6zZLjijvA1pm8FIbyL09HvSm1Wcgj1NUgF981u/OvU0g0bc0QkXE5z95Lj1fCCRrf67RwmxVQmMkURpqGDL10kRL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905578; c=relaxed/simple;
	bh=JYAFiaS/EYHzD/a7bgFP8GrD66A3FepF33gRvf+de30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMs483Mr+4Veb2L4jzAP2Q1CGs0gNbqOWLtDn9N+H4GwHIa4rgKvh12CeNccWpztYiDI1WyuD1OaZEVrdHasX1Aaz08WqlLRgNzlmkBlSaN/78mu8Wx2opQbCBOncCXeYYlpFVwawZlhM+fDJfKi02hwcrNmDmGlNSFaEGfyJC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoaEgMkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoaEgMkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E93C4CEE9;
	Tue, 25 Mar 2025 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905578;
	bh=JYAFiaS/EYHzD/a7bgFP8GrD66A3FepF33gRvf+de30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoaEgMkQ8I+gGRLqjGJHCd4EPjdpdT+I7R7RsSEWbUTfXrVmNCCY8p93hqeY7Y1m4
	 h5ioGk7Rnb5onR8XTPFOdF4/AB6OdgSVytAtE3lWU8XqAsIKts4PyP/fdx/7NXWUsJ
	 3webSIN6M2xx6uBFSbsEcwdZ0vEaklLaWbAAHsbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/198] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Date: Tue, 25 Mar 2025 08:20:13 -0400
Message-ID: <20250325122157.975417185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 ]

It's sole user (pci_xen_swiotlb_init()) is __init, too.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>

Message-ID: <e1198286-99ec-41c1-b5ad-e04e285836c9@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 0893c1012de62..fe52c8cbf1364 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -112,7 +112,7 @@ static int is_xen_swiotlb_buffer(struct device *dev, dma_addr_t dma_addr)
 }
 
 #ifdef CONFIG_X86
-int xen_swiotlb_fixup(void *buf, unsigned long nslabs)
+int __init xen_swiotlb_fixup(void *buf, unsigned long nslabs)
 {
 	int rc;
 	unsigned int order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);
-- 
2.39.5



