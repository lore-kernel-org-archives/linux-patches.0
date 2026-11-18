Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017120;
	b=0qStduMb++5R+WXXh+GYdHF+ngU/RE6ChQaODbPfU8AHJxnRV6KSh94mCWBmEtmknUUy
	 B2xGp7+J1A3B++4JDXzBQei2hOmxWsje0+y6VryNTg+OcO7hCH/Xt7bLEJS+t5nXt83ET
	 pRJDclf7KoL9IzcQwoNPNzionIenHS2FhQXSBpyYf3F4sISjwMNRcFcRxgqZp53MVujJx
	 biZxvfwwQTt+GEf/IF4//i1mV0HAY48fTVUXUiOkPCDWTOFQ5zFExKlIaywnRJF32lZ38
	 PR77E6zWYMl7Nyf9Ti8Zk0vUn9ShUNh2HqQHGtfvWeqZNebYt8C4698StiHVFb4WJyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zNO0hB+WhbYHCaqNm33BBQ9C9Pv3lnd4scs1ezuqHNE=;
	b=QvQPi7RO2GHWhzdSIX+wJFlbEP1r/QyziiLS1ah5gB7pnZJ4ldwcJ9/ZzSyqdeI/300C
	 PZhkX2WhzrZv/CLmMLjXBQInb6D7VmK8FrrKVsiQsHc/Bf5Z8ydgTAlclCiW6qtn34nsu
	 3aom8h5BGj21Lj9DGkPfSSVxGTH3L+WhxfYEdCKJzDGVmMpH4fQebyMHafOI4KC1+Fuqz
	 DP8RpkJvuy2RxcmuGqTAyc/w3eImRIGTYZJSe3F5o0+PqxvzMw3AlTfAohBjNjIsnEyp6
	 avJvm6juPWZgzxTBoF7qKgTNgebFFjjq0YBqlIBH70K7XUyJkYng6/xzeoKzjm4RsyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FBJQsYY/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B52606A31C;
	Wed, 18 Nov 2026 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBJQsYY/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0204B1F000C4;
	Wed, 18 Nov 2026 15:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017120;
	bh=zNO0hB+WhbYHCaqNm33BBQ9C9Pv3lnd4scs1ezuqHNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBJQsYY/JE19udSaXFTg/FxI7+Ypj6Oes3lOREuO5m4IBpBdD27mHlLRGt/4KMrSB
	 aMG6f+sujKItlNM+xE0QhYE0wguLlS6yJfYEkDeW00bpDSqDiyAOGCQd72sgvi972/
	 jd2z+hU8aAcq0IjLXiylKdi1kucljnFYiePeAzaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0770/2651] iommufd: Fix iommufd_hw_capabilities reference in kernel-doc
Date: Wed, 18 Nov 2026 15:33:30 +0100
Message-ID: <20261118150315.605512456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 63a86354e822f..010f47f7d3d23 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -776,7 +776,7 @@ enum iommufd_hw_info_flags {
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



