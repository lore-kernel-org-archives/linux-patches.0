Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064866;
	b=tDtxTvPCisbzqlfQqQ9XVz67RpXbG0dBbuDMCK5lCRSnyD6/DRA+U+dGjTUuGrmjiM2i
	 +qTpPs69pZj7IEezbQ+0BfNlN5dx1x60+otbzwcBDoZpXTFfVFcZGDv7gCoWzIlBmeiLN
	 1q+OUFkl0OyzunkEV2IWOTHVTRDtA5yGsmu+crbBfYom3Ide7zsJFfQvpQCYJfESRBLz8
	 Lo+563sYTukBFBHYUUkjCR/9I5t9FuI6cRISFRnivvjJJBukh+f/zgkrb7VLcjrMEmlZh
	 yweDelJD5XbXbgpJ0WxfjG2tX95pNXMQn6+XjHh3ITmoDfIJKWGYsVbo57I2uCp6nFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpEq0iVJo6E0FJBF8HumzZsyraGiqPyvVATMtDtW/jg=;
	b=1UzQi9rKoVtf3VdLecF+Ts1whbarDaEMY7rizwW+jacT8stAaN6EesfCw8M3hWgmoJbq
	 EydBac7oMJVIGKtYqwhNx3emZSRVq0uik5EuGsH2Fxjm28AyKOZc6xWg65DuaFN+w1PfK
	 zthJP/N7YdA2rJcXCEK01S3RtVeacgwUgYlWsJ5uGEP5F+8dNVjciFGC3T7zTNo0nIF7B
	 31kktd6Q3c6mz6mSb+ZGWHzWEqiTDkpYpaf5VfgH3lhiwmwXEUlUx4JWeGUvlSHiC7XKv
	 +GiFxLVTFlFy5YI6WTwpzEoLI3/whadY3uMmpP0Mu2EtKxD0zPgqJkaw7KXSb9JDscw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMFtj6Oq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E639B606A9C1;
	Sat,  7 Nov 2026 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMFtj6Oq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923D61F0089F;
	Sat,  7 Nov 2026 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064865;
	bh=lpEq0iVJo6E0FJBF8HumzZsyraGiqPyvVATMtDtW/jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMFtj6OqMGioMbmWaYZh8JEhXOIbzYoMOE9TqxEGiOdVBcWrPvphR0Q4ovfzBtEaf
	 5/Z3lbLFO3Tp+ey4o2Wqw8AoGKdsovF63wNN8ubNt2s66Dq3VdBRBAAjkDgaVJyqfW
	 89MiIFZO51ktlsrTv3s24FfS2dyZP+DBYrvVZYm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0783/1257] iommufd: Reject a zero-length dirty bitmap request
Date: Sat,  7 Nov 2026 08:51:19 -0500
Message-ID: <20261107135000.941891661@linuxfoundation.org>
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

[ Upstream commit f6b3fd8f573e801066c21b2aec3d2e949e61e48e ]

iommufd_check_iova_range() subtracts one from bitmap->length before it
checks the length, so a zero-length request wraps to SIZE_MAX.  With
iova = 0 the wrapped value passes the overflow and alignment checks, and
the request reaches iova_bitmap_alloc() with length 0.

iova_bitmap_alloc() then sizes the bitmap from a length - 1 of SIZE_MAX,
so mapped_total_index is effectively unbounded.  The scan uses
last_iova = ULONG_MAX, which spans the whole IOAS when an area is mapped
at IOVA 0.  Reject a zero length before the subtraction.

Fixes: b9a60d6f850e ("iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260925161142.189813-4-parri.andrea@gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/io_pagetable.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 4e447ce74cf6c..283ab372e8da8 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -605,6 +605,9 @@ int iommufd_check_iova_range(struct io_pagetable *iopt,
 	size_t iommu_pgsize = iopt->iova_alignment;
 	u64 last_iova;
 
+	if (!bitmap->length)
+		return -EINVAL;
+
 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
 		return -EOVERFLOW;
 
-- 
2.53.0



