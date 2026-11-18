Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030017;
	b=37gacHRCmY8h0ExIyMlJ2kBmNzE8dOCNUDicK9ShxFNYwdXQ5ilMZ+t66BQKRE+aHcKT
	 Ofgc7q1+LVXB/DpEHiriEq66Nj+FOKKl3EYCAfDvaIoTataz/x+ijBCy84nhstOhvZ5IX
	 cuPH0DI2e3ghBmSSAAF+QRWj/cbSXezMX0gD5RtWTP+oD5cLaOnzH7ake+fSPoFjWZcUl
	 ODZPw00ZGcuA2Z9zsf+VyArnne4jel3d7qV9zcxPvVYWS32y/ZSWO1OEagTj6VcgUNoLi
	 FSsGSmW6Amg2s46srxqZGrxOIhbJofNg00DkDaVhUx6QbRK+FXcs/h6qEgaMKa73zlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lX7cyGbSD5n1f/tgBFWKSWq1q7R5jQLtY86kOZGoJiY=;
	b=ocnpQfbm/6cozdf6i+oNK3gwNbLK7CGOSmV4IOVGKL9M33lwAyhYjyhjEYHYDxVI7Fwk
	 1gr4nFAThsk+S1som8ZB5bfQUM8WvbmVTaIWqZi1g4jd9SMM8jegt0S9yzVbgl4H4H6b1
	 f9CVz5Q3nS9qa8OfgRbalDiiWvwQlNZpkdBzXNJ0sg0hanE1HAIU4P2bQXpozyWkjnaR3
	 1sbDadKBLrqj/P+5hrY19UAhxuetozIaWa20TdQzT/M+rmJv6LXGbgeNE73gWHK824zZX
	 fkbhg32Ruggy0DWFTruE9SAQR2P/zcUBHn2bOTkKR7o45eCpsaYXv73VoKiiSnbl5NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IySkAVRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC298606A31C;
	Wed, 18 Nov 2026 19:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IySkAVRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E041F000C5;
	Wed, 18 Nov 2026 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030017;
	bh=lX7cyGbSD5n1f/tgBFWKSWq1q7R5jQLtY86kOZGoJiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IySkAVRce/ZwbekrY5Otv5LlwXUXp9PK+3WKLaIkjIPb3mnK0JlE/C+VZpKb6BFwr
	 Xr4vqX2iv9HHoUGoXUjfwZOFEXDuHOcHA1sZCjvFAEbd79h7aWK12s9nVoyP3+TBWR
	 +kpqsIuyWo5VBTv0DhEqjYESi6ZNkKmcS7SbI0TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0553/1756] iommufd: Fix iommufd_hw_capabilities reference in kernel-doc
Date: Wed, 18 Nov 2026 15:44:40 +0100
Message-ID: <20261118150031.127784839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index e245fa295662a..e0533364ba340 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -529,7 +529,7 @@ enum iommufd_hw_capabilities {
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



