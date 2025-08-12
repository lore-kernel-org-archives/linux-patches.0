Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716A5260583;
	Tue, 12 Aug 2025 19:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026076; cv=none; b=s+EGvLaoaBKMwjHNXdV/q1me0CIiJyJQ62WhP5L1xIlQx0K1GKBTDPfmfmbUW9ogtUGz8GuXKMPgjGVCdY0zktVZkCzuXcwun3r+aTfNodlfQO74345k2YXoMuXoNpzutpHIaRQ188uMvZjfOXZ4DZkVtXNFGE633w+Qy32WPDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026076; c=relaxed/simple;
	bh=puj9MNdhnAigFLjdAGz3q71nsABNLUol5LgyEtAFF9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyMfW0tDZ6sOtl2eXEI6Eb/lnYNynhYCFrTIpIMFun4YbtSJPCRX0LhuJpBfdvUtwvLgvalHAi83OGJpilQ673HZyxgKtsf8nEa8x5jyCvzBxj6hxpc6w3I0snZEA+GrKq1CC61U6uoptQLWNu4XgptFnT4TAYbnKcbWPs95Wd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtDt9UrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtDt9UrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D352BC4CEF0;
	Tue, 12 Aug 2025 19:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026076;
	bh=puj9MNdhnAigFLjdAGz3q71nsABNLUol5LgyEtAFF9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtDt9UrDUt/ae2ML35aPsueFcd1wyxRz12qYRTBwjPJ+hlgaUhB15vciNqkMJZPn3
	 j6em1wKtxQmRQyqdYxNwMieZS6wkEQeVitl6PAG7VUQ6iAtlHh/VNYlcuPi0NKeDZD
	 ixGrHmMfBWHeQxkvBz4aJqzzTSTYBf9+RAECkHbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Michal Witwicki <michal.witwicki@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 230/480] crypto: qat - allow enabling VFs in the absence of IOMMU
Date: Tue, 12 Aug 2025 19:47:18 +0200
Message-ID: <20250812174406.932851185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



