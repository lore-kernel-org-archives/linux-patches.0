Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063402;
	b=J7bMJZyEDtyMQZIGDNK+IWvkC6wN0+jYLr0KEmg3fWaNaBGlb6YaTGsTdARomYPY9NVF
	 +nQeZeDa9YPMo7HImhED0K3+B1j5Ik8ji7HUUXrZcQkh6MN/xYytOPYhI3ii4LdgLvwWV
	 HKzLOmbEnMTZ0WI5yhOspsg64/uLVIhnrAqbQnjlCoN+09oqatH+03V6JPGp9m3MD6nQ1
	 6GUgi5Z5y9FvEsXInZ0ARhn8nIOU5laCVbkEainq8KiZCjfWZtxbhWF7jK57Xlx6HwbKr
	 ABCTXIWnygEXMesP+2pVU74kinkbdfyOMKkgbo0AZQhb63hOBmaqAGjp7CMw9rxQ6kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Saq5lLQx21YORjT2QPStU1WDYbtF6RoRG83Tt40005I=;
	b=WsVghxZwDrIxxcFrNqD1UMZ4jGIJWFFAtMD9S/Jvr7oK60byu8SC8wm7A4aqk3rg3t6J
	 fCDf6zOCfEoT/m8YuCzwL3wR3r/nD8JGBB3JIECM3jZWLqa2Zns4JNB7agPBr+1/E4t2Z
	 CcxSrkX0w/X+froXes77hFPFqsoBSQMRr+gmUgrHeDw2lx3uZyGinxXD58WXJCABIwkGB
	 R1J/KhhbHJqX/bXSls0xgAQEPbt/oku3KaN7FawkXEEyY02JOI9uFF9ZochtrB5Y/e+Jg
	 VmqVrTfdt4NNSQiE9JRjUt8XmcJQw3ey96M+XllrbPBg7XO2Jxif6U1D4uYLXAvMcsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgyvmo7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47E86082BE3;
	Sat,  7 Nov 2026 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgyvmo7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8130B1F008A6;
	Sat,  7 Nov 2026 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063401;
	bh=Saq5lLQx21YORjT2QPStU1WDYbtF6RoRG83Tt40005I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgyvmo7FbuNzZ8CQc8rL/1P+qkTvZzfBZ9QXnrdctIKf+RfraZ9Dzz+snwUlXFc0c
	 HTmBpi1iCugnqk06o+jm44YijIhaEr7wHob/LnrBzvt4kiwyllZUIaYLKcK89f/Pgk
	 cr+S845EqLHqwKP5h1yUPPHbT0mc0ZUx7syp7+90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 573/869] iommufd: Reject a zero-length dirty bitmap request
Date: Sat,  7 Nov 2026 08:54:15 -0500
Message-ID: <20261107134912.657131706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a4d7a9d435603..77891d4d65fb1 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -568,6 +568,9 @@ int iommufd_check_iova_range(struct io_pagetable *iopt,
 	size_t iommu_pgsize = iopt->iova_alignment;
 	u64 last_iova;
 
+	if (!bitmap->length)
+		return -EINVAL;
+
 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
 		return -EOVERFLOW;
 
-- 
2.53.0



