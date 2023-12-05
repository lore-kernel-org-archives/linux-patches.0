Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9586FAF;
	Tue,  5 Dec 2023 03:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKE2wM7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2B8C433C7;
	Tue,  5 Dec 2023 03:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746711;
	bh=TxfU98mcj7jUgZ6LXhRWmfZFlNjjlBHTpOy85SH97jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKE2wM7XDgdb4slmLAfknJ6qn3soX27HnDVP9d36RmXQxN9aT7Xtsh/Uszq+K2gqO
	 sVY3P+pPRcqFkT2qAsaYU3+jSpnpxxbCylQSTIFfA8JKkmLTDBCnliyDM1Wwzn1rYv
	 22b+wG2tk1O7ejKpDebp63Ae2aKBevE1gDFhvLKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mentz <danielmentz@google.com>,
	Thierry Reding <treding@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/134] iommu: Fix printk arg in of_iommu_get_resv_regions()
Date: Tue,  5 Dec 2023 12:16:38 +0900
Message-ID: <20231205031543.437415766@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Mentz <danielmentz@google.com>

[ Upstream commit c2183b3dcc9dd41b768569ea88bededa58cceebb ]

The variable phys is defined as (struct resource *) which aligns with
the printk format specifier %pr. Taking the address of it results in a
value of type (struct resource **) which is incompatible with the format
specifier %pr. Therefore, remove the address of operator (&).

Fixes: a5bf3cfce8cb ("iommu: Implement of_iommu_get_resv_regions()")
Signed-off-by: Daniel Mentz <danielmentz@google.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20231108062226.928985-1-danielmentz@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/of_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index c25b4ae6aeee7..35ba090f3b5e2 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -197,7 +197,7 @@ iommu_resv_region_get_type(struct device *dev,
 	if (start == phys->start && end == phys->end)
 		return IOMMU_RESV_DIRECT;
 
-	dev_warn(dev, "treating non-direct mapping [%pr] -> [%pap-%pap] as reservation\n", &phys,
+	dev_warn(dev, "treating non-direct mapping [%pr] -> [%pap-%pap] as reservation\n", phys,
 		 &start, &end);
 	return IOMMU_RESV_RESERVED;
 }
-- 
2.42.0



