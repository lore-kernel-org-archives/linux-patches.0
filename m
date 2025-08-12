Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968D72DE1E2;
	Tue, 12 Aug 2025 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022449; cv=none; b=OeBilPJuBG4p8VSVlNjOhBonqDuIXjETaUy1Na8v2eEJ6NuDkbW8eB9R/qvLD820/IUKk0liLjAz5P3RK2/T2CLZGUY7bZYBOY06kW6t/CADvuCbXnitNJ8WKp+24p88qkPxdZ22shV47nUD2ZmDV3i3uCPp66ogdZx0yXG6IuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022449; c=relaxed/simple;
	bh=rBohJIqUeOOCJkFQYtXHSi0/RGS7t02/M6GHlOxw2Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECBe3VlXOxEg23oISeZ07rAbFEv4tNbTzvIXXNGeUFOlJ1VvncbQww92DsL+H5GIqd8JoF3immg4R7rHrv27iNut9olTEBXAgIKFRkZNV/UgCB7tEuUe5dnp2JIKlStHj1/z3mLNenjYvXVOFG39QLHdu3nukSsFbRRjp09jSg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEElUVpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEElUVpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E070BC4CEF0;
	Tue, 12 Aug 2025 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022449;
	bh=rBohJIqUeOOCJkFQYtXHSi0/RGS7t02/M6GHlOxw2Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEElUVpzllggI3++g5S4P5xIxcO4vHLimtV0WvqtVUpaL8oTVm2DHHk4tyydWrskc
	 toiSYIjnt48vAWyWT0gS10vaaD2MU+qw4SPHy+Zo6zfAVj+JK0vdYmookCWaikrrlW
	 Z8VNjsC516ZwfNEPQds6zOGTe3+gM7HGD9SdVWAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Michal Witwicki <michal.witwicki@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/369] crypto: qat - allow enabling VFs in the absence of IOMMU
Date: Tue, 12 Aug 2025 19:27:35 +0200
Message-ID: <20250812173020.712132324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 53669ff591d4deb2d80eed4c07593ad0c0b45899 ]

The commit ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
introduced an unnecessary change that prevented enabling SR-IOV when
IOMMU is disabled. In certain scenarios, it is desirable to enable
SR-IOV even in the absence of IOMMU. Thus, restoring the previous
functionality to allow VFs to be enumerated in the absence of IOMMU.

Fixes: ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Michal Witwicki <michal.witwicki@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_sriov.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index c75d0b6cb0ad..31d1ef0cb1f5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -155,7 +155,6 @@ static int adf_do_enable_sriov(struct adf_accel_dev *accel_dev)
 	if (!device_iommu_mapped(&GET_DEV(accel_dev))) {
 		dev_warn(&GET_DEV(accel_dev),
 			 "IOMMU should be enabled for SR-IOV to work correctly\n");
-		return -EINVAL;
 	}
 
 	if (adf_dev_started(accel_dev)) {
-- 
2.39.5



