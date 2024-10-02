Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F171CFEB3;
	Wed,  2 Oct 2024 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876782; cv=none; b=OT8yEoUNYEt4E3BKr2ZOzCNJ5aZEj851ewZw9Ps++uXHxZ609t4jj9A4VGX/X9tuybNTYyvxkmOw8RR4j+/CXKg7CcJK6+LbVItcRQFYQcin1JW0fWFFIqItdOGxFT9KoZ8nNSzUdRE/H+TtjGcl9AK4zVtDk3N7PVmt9sNyqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876782; c=relaxed/simple;
	bh=DQNPnmzzriAWRbAFauxLlvupCDVxRWc+zi8Jn6/+hs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2lVHeXhpbIBYGY2cuybBS8UcHQHSHA3byVL4f5bZWKnPUc50MDGma/JgN01XPUaePj4RWyTHHfXbriPbmNobZwe/QY7H38T7dRqKidb9C+7MebFxEud8lbg9KUT79b11mj7w3TznJPWVwoVw0WZ82PjgdNnQx2eTxspbCwKR1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRxceme2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRxceme2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00A3C4CEC2;
	Wed,  2 Oct 2024 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876782;
	bh=DQNPnmzzriAWRbAFauxLlvupCDVxRWc+zi8Jn6/+hs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRxceme2ePOSUtSH3NDbrxT9y1fFGguxf2EiGQs/jT/MyYLm+h5+uG+cwYeQxYMrq
	 6UKXMD/4fAzRk4RFBQMt0MyOqNcxvpXYq1+11ouXvDUBpFYwmzms525sGStEAzDlV0
	 ouzlCnSrPT4VbbKcyX5tCbei9Suxfosha6qGcYI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Bar-ilan <eliavb@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.11 528/695] iommu/amd: Fix argument order in amd_iommu_dev_flush_pasid_all()
Date: Wed,  2 Oct 2024 14:58:46 +0200
Message-ID: <20241002125843.572665959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


