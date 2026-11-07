Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062383;
	b=Hya0J1NuxSV+OWmj44SnS0yFEWIN8quuDr+6HkO6JtxOw0GsgWl4QCC5cGUMGWtaus32
	 Ce6TAV+Z/iu8AAgCj8VE2PQgrT9ngCu1V3dkatffPLafCXRGruy9lM6a1pz6eF3dTJ6gz
	 jkgldcKvkLcRlf3pf0Et0nBFtGrgRzHy8x53F+trPyRhkovmJALqUIsrSXkl/7pNHZySX
	 ynpA5kieVHtk0Ple2y+C4X9n5paw/u6ZcxBh8e4aLMKaww0gwDOLT7X40WO3BoqatW3JT
	 CLwf9FBMKM0ZT2zUWxVWdqsPrZ1KfxFz1OO0jxM9kro3LfVMv5QIJOtMOjZsz0S44Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CHo4FBwessL5tN4NdqlpwVoPlKenNTjXhjfGevQsK/I=;
	b=kFE/40P8P4R7MJEoZwEi+LFPus5EyQvvMHCCgSFNny8Jnh1xlOUR6B330KNfoH9H2LtK
	 dmEdr88xwLFnIUKsYP/YBOoao0eTWdx9kM45msqUUFG6jS57N+Ahd8Oq7NQN9un5zBm/o
	 bbH5fUmh0hMDv/Q7iXrkpTVsv0MJQRZ1VxriOojrejf3JQA0Lof9TxICdK6xBPbK5ztYa
	 ix6orRglW6gO9BdNmrcdqRp1SC/sgPRzu8glihekSAcFZkU3wL9btdsQzecFo+I9e0nkt
	 AAukGnE4zpeEHSoNAj88f/9Pa2GIImO2bbcUGYGxwTtzNay4D3VivDkv97ugz5H1JVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6tilBYj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FFD6083612;
	Sat,  7 Nov 2026 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6tilBYj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581CD1F0089F;
	Sat,  7 Nov 2026 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062382;
	bh=CHo4FBwessL5tN4NdqlpwVoPlKenNTjXhjfGevQsK/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6tilBYjc9T/hsxN9v+WJgsx2/Qk4gj/Ef7BbRB4lxzyLlDfQskpgJZ17+TGt7c3u
	 UFfpi3TJC+RSfdjewC6bBhweWPukScr4U+XWLR5haHt2AjBuSVpDGm0suGsv70Fdb+
	 uS+MN217PIINrqfbRT69tOaL/DSUI3WCPtGf0Fbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1304/1536] iommufd: Reject a zero-length dirty bitmap request
Date: Sat,  7 Nov 2026 08:55:20 -0500
Message-ID: <20261107135034.416026824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 83b953f3b327b..177e8e12f189f 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -521,6 +521,9 @@ int iommufd_check_iova_range(struct io_pagetable *iopt,
 	size_t iommu_pgsize = iopt->iova_alignment;
 	u64 last_iova;
 
+	if (!bitmap->length)
+		return -EINVAL;
+
 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
 		return -EOVERFLOW;
 
-- 
2.53.0



