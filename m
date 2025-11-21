Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8993559C9;
	Fri, 21 Nov 2025 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733433; cv=none; b=S+RfpJulnpOYONA0IfkIZFpv3fIVJ0xgQT8bNxuDKslPQCm4C0JJBQsriU395xOfEvnjfNRjl4idjjgE+k0SIjDaBIL5z+NiY31cDKi+RZmSedDRyTgUOsaGa2IfWhAfEBeV/Mvt/e1jWsu8rQ4FSloHPwzZCA/ORQ3qlHnN+2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733433; c=relaxed/simple;
	bh=B2RpMgmhgf8vqSwBSXm1THZt3nBpK3fnie48C9mmego=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6LETe2WZ9YhnAkP8i5lefserTv64RLX566k1g9Va2TLeNM6gmxKFk+it+QVJQldWL4wEPfS5XpxklLAATB6YMlLVndFvBzMy38LUZZPeauuDbmyyD/Waf7AQM+A4G0PISOyOtvQlrDyyMUeGYQRvd1QP/+l9j82CTBS1GFsxt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDDYllzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDDYllzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F022C4CEF1;
	Fri, 21 Nov 2025 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733433;
	bh=B2RpMgmhgf8vqSwBSXm1THZt3nBpK3fnie48C9mmego=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDDYllzvSigAdaukYFBqsUsWBy/7Wn5LgoQKYW+/VLHgp7Ria8S0i5XLOsaW/GRp+
	 IFJV19DbXeXHGMfh6Xze6N0t8UQ0b+vTFwbrC8JBG/JpUwRON9yKQX2CcgBrqh5lTn
	 9WYeZLkbER6ONc5bTl9ZC4E9zGYRXF9ntZZsOBiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <baohua@kernel.org>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.6 467/529] dma-mapping: benchmark: Restore padding to ensure uABI remained consistent
Date: Fri, 21 Nov 2025 14:12:46 +0100
Message-ID: <20251121130247.627632215@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Qinxin Xia <xiaqinxin@huawei.com>

commit 23ee8a2563a0f24cf4964685ced23c32be444ab8 upstream.

The padding field in the structure was previously reserved to
maintain a stable interface for potential new fields, ensuring
compatibility with user-space shared data structures.
However,it was accidentally removed by tiantao in a prior commit,
which may lead to incompatibility between user space and the kernel.

This patch reinstates the padding to restore the original structure
layout and preserve compatibility.

Fixes: 8ddde07a3d28 ("dma-mapping: benchmark: extract a common header file for map_benchmark definition")
Cc: stable@vger.kernel.org
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Qinxin Xia <xiaqinxin@huawei.com>
Reported-by: Barry Song <baohua@kernel.org>
Closes: https://lore.kernel.org/lkml/CAGsJ_4waiZ2+NBJG+SCnbNk+nQ_ZF13_Q5FHJqZyxyJTcEop2A@mail.gmail.com/
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20251028120900.2265511-2-xiaqinxin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/map_benchmark.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/map_benchmark.h
+++ b/include/linux/map_benchmark.h
@@ -27,5 +27,6 @@ struct map_benchmark {
 	__u32 dma_dir; /* DMA data direction */
 	__u32 dma_trans_ns; /* time for DMA transmission in ns */
 	__u32 granule;  /* how many PAGE_SIZE will do map/unmap once a time */
+	__u8 expansion[76]; /* For future use */
 };
 #endif /* _KERNEL_DMA_BENCHMARK_H */


