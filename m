Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024314;
	b=i7JUWTsglEvWVAcyhRm0uA8WJYcu4JMDqf7hyjsDCN+X+fUJ4YmZhsWcC/q+HKOeskuH
	 xWFAKELG9pg3CL7bLb2JzzV95A8LS+bh3xsN0J7Q6WvicJJDfC88nVhhrt9zzrycz+V9A
	 2ar5t13vxJaTCsgVsf9ShFZ28oM85TfzZBfvzEiwcZ60fhug5Jra3ncYucgyeqjwMJXX5
	 dqgvIm/O5VjdiaSwj098iuiB25uPVbbZiL6FKbabuJXmvTiYzEU0FFq1+whU47e78yLX9
	 Abvr5SaO9pMU8y9hRzrLRIdA6xBg3cXSMehq4k7pCJYu4RCS4tVo4/VeCv1qZ28oQ+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eezVMh9XaQ+nSxOjxYXri/4xrrgSbIsqyUdNVM6SpMM=;
	b=gyyvYJ1mRzrTZmX3ZPK9BFQpRm12mowUfziezARPAqy11zQe6mFrAi/PbkO37/Bs6fld
	 ezpk5T9m5wGLpUfEQrO0Trpj5wxMl+mAfvBYWuCrdaTacvu7Hf5M1UPe1HKDXPdk4aTQT
	 64xLsKnHXoEWT0TFOl8SwNErdwEnDrdrwuK/Q2IQmfCXg9/XPGht/WpQXmNp/xVlxHceu
	 HPo/io4BEkhQQ/rKj71HmauCKeTXipY1yAv/TNTo3Ya2m/4C6VR6ofZ0fZwd205qJftTB
	 3P9wd+zq0sGP9G3K7JflvizZsR+hoYR+/Dg+RP3ynquiN1VarX3D9KMwcUejSpYdDiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXeMSbDh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FD4606A325;
	Wed, 18 Nov 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXeMSbDh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD121F000C4;
	Wed, 18 Nov 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024313;
	bh=eezVMh9XaQ+nSxOjxYXri/4xrrgSbIsqyUdNVM6SpMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXeMSbDh8w3vGsZqi041DVQPd+g2CyqrkJYN8+UVjUtI71HUp/WtukiYCFDBrsu+q
	 hFyK8yGAIvZAjPFB4dnaiG4ggAxnQC0vAh0cDQA+e2YjyMKdcElG7eMEvJdTQnoCfG
	 yJYjsrjOECdx0ckemuAeiTvCPXTVUKPZNcZDxfCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0680/2151] iommufd: Fix iommufd_hw_capabilities reference in kernel-doc
Date: Wed, 18 Nov 2026 15:40:15 +0100
Message-ID: <20261118150146.581633024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 54dadb030c7e2350957855d3995de05ae02c2e66 ]

The kernel-doc comment of struct iommu_hw_info refers to
iommu_hw_capabilities, which does not exist. The name is
iommufd_hw_capabilities. Say iommufd_hw_capabilities.

Fixes: 7623683857e5 ("iommufd: Add capabilities to IOMMU_GET_HW_INFO")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260911231850.20737-1-kmehltretter@gmail.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/iommufd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 65e564965e98a..f958562bb0a13 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -680,7 +680,7 @@ enum iommufd_hw_info_flags {
  * @out_data_type: Output the iommu hardware info type as defined in the enum
  *                 iommu_hw_info_type.
  * @out_capabilities: Output the generic iommu capability info type as defined
- *                    in the enum iommu_hw_capabilities.
+ *                    in the enum iommufd_hw_capabilities.
  * @out_max_pasid_log2: Output the width of PASIDs. 0 means no PASID support.
  *                      PCI devices turn to out_capabilities to check if the
  *                      specific capabilities is supported or not.
-- 
2.53.0



