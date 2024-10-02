Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E211D172C;
	Wed,  2 Oct 2024 14:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878719; cv=none; b=NmvQlzSFq4cvlSNn0R8fANQ5iy7YhwJGyhF8nZxNkNmnxxtaLfkKCrrG4GTvvuVP0TB1aDOIgWFfCFkgeG3gBH4tiXWv6cmhp1EI5B9P6UbRoi1bW4yqzRoRmUDxBY62om1NPzsDARnMHEZOiveJP4f4VX9NNS4zRt00Y3i15Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878719; c=relaxed/simple;
	bh=lV+3An1Lb85tnfarReNR0QrIYy0fVy68cqPlk3cBv+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTdKPnPn4sUk6clusQJc9lmmJaFUxxSiPkPv0MxbclpD8Ohh+WNXG2j4DH4eJS9al7DMEsCtyj3XVFtX0bqqZc8TH36gTmUsr9x+2/HGXv/sIGdhYimfwTszj8CQsrLmbNLDE+w9kWo3HiHd9q0ykIMbcYmVzx4mR7TrEdLdARA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbvCnbyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbvCnbyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED8DC4CEC2;
	Wed,  2 Oct 2024 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878719;
	bh=lV+3An1Lb85tnfarReNR0QrIYy0fVy68cqPlk3cBv+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbvCnbyxGpTdPJvdTLNUWVWPWBd7hsksO60IRWcZW8Bq14phGyzyDu75RCpWorxy7
	 EgLYLOH3jgis9NB9IeBIAP8IQ7EA+lkd5vPeqLZJIvUT4C3GAbQH5pu/c8R/Ms7E9/
	 7TponRX3i0lk3CvsuFzMfU/grBFjxPAOMCtIjoSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Bar-ilan <eliavb@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.10 479/634] iommu/amd: Fix argument order in amd_iommu_dev_flush_pasid_all()
Date: Wed,  2 Oct 2024 14:59:39 +0200
Message-ID: <20241002125830.012135411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliav Bar-ilan <eliavb@nvidia.com>

commit 8386207f37e98453e1de3f51e50eeeea089103f9 upstream.

An incorrect argument order calling amd_iommu_dev_flush_pasid_pages()
causes improper flushing of the IOMMU, leaving the old value of GCR3 from
a previous process attached to the same PASID.

The function has the signature:

void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
				     ioasid_t pasid, u64 address, size_t size)

Correct the argument order.

Cc: stable@vger.kernel.org
Fixes: 474bf01ed9f0 ("iommu/amd: Add support for device based TLB invalidation")
Signed-off-by: Eliav Bar-ilan <eliavb@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/0-v1-fc6bc37d8208+250b-amd_pasid_flush_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1550,8 +1550,8 @@ void amd_iommu_dev_flush_pasid_pages(str
 void amd_iommu_dev_flush_pasid_all(struct iommu_dev_data *dev_data,
 				   ioasid_t pasid)
 {
-	amd_iommu_dev_flush_pasid_pages(dev_data, 0,
-					CMD_INV_IOMMU_ALL_PAGES_ADDRESS, pasid);
+	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0,
+					CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
 }
 
 void amd_iommu_domain_flush_complete(struct protection_domain *domain)


