Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2F20B3E;
	Tue, 23 Apr 2024 21:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908488; cv=none; b=jdXkJ0LzuN+fCWwmG50s8K2UPoaVIxuK2kDnbMHrZsVmj8nre7fy0Rq9orVOXkngwf+Y8T3/ruShVqMzzg+k3e+BW6miXDl5piv2tBhZ2WsOJOz7cN7A2bKyFqzJRpE2n977NXbrjIaPBLRr1xxfX7X1byL1AUvxZU6wndeLxUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908488; c=relaxed/simple;
	bh=tRikLRhXC6175zRBhXqULWPV/8fdp0phynfcTrjUpf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQfWZIdy96PDqPqV+7yyJ3IvmvH6cMSEt8nyCboxMoYaFcoPuP7K6rBBRLY+QHIJprAFdPrNBYIBLlkLmo91iM6HhINCDcZQI3CMHhWL8OpdbnDEIgv3JYi6Nnyz48oeGdn5DljMVnipc4n8QarqI7ccIOpyX/MivHBqXUx+GB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYHohzfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYHohzfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DCBC32782;
	Tue, 23 Apr 2024 21:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908488;
	bh=tRikLRhXC6175zRBhXqULWPV/8fdp0phynfcTrjUpf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYHohzfqUzyHvI84PBMsT+ahEnr0+APHHGZbyQWSrw9H73pWd9knOVRTcH30c9X3Z
	 AEhkeUPuZ3iH2s6PyHTCSHaWmnGZTmgKd0I8Tsbn0Vatwx2zsQo32lDPhk/Z8dizPa
	 EWEXFcu7G4ihWLLGj24z6S4PBLsQcihC+aBTZV5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 062/158] iommufd: Add missing IOMMUFD_DRIVER kconfig for the selftest
Date: Tue, 23 Apr 2024 14:38:04 -0700
Message-ID: <20240423213857.976896332@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8541323285994528ad5be2c1bdc759e6c83b936e ]

Some kconfigs don't automatically include this symbol which results in sub
functions for some of the dirty tracking related things that are
non-functional. Thus the test suite will fail. select IOMMUFD_DRIVER in
the IOMMUFD_TEST kconfig to fix it.

Fixes: a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
Link: https://lore.kernel.org/r/20240327182050.GA1363414@ziepe.ca
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 99d4b075df49e..76656fe0470d7 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -37,6 +37,7 @@ config IOMMUFD_TEST
 	depends on DEBUG_KERNEL
 	depends on FAULT_INJECTION
 	depends on RUNTIME_TESTING_MENU
+	select IOMMUFD_DRIVER
 	default n
 	help
 	  This is dangerous, do not enable unless running
-- 
2.43.0



