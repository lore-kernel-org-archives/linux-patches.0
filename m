Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B7B26CE2B;
	Tue, 12 Aug 2025 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024365; cv=none; b=Ir1SE6+sbLq5cB6anbLJLfBMOM3Capn2Ze7B/D1Ag9Nlgo6iP19IpVxqEt1oJrq8+8g3d/efI0CG+HI0xLhURoktXKj3epHMwlvE+E1NPspk5pfpzj+aQsF09HSG0bV5Ig+1vAd7US7nNqcm9/lZctMc5nP2iIfxHjBumqCzLf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024365; c=relaxed/simple;
	bh=Vw16C6yEiAwTv0+b2Hyvm4jx1HII21a7SA4XxEroVlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9iFDbjEOS/qpfUIhvwcN/Gv9bBWh0i2ox8GUFeRxGMbv0R1vRtckUStc42//nfB2HPvgmNiutxFQ+3IfMxeFAm67FAFt/gJ1uUXKNeeDF1iHlLGsv97tGHreSD5GF5jYZyR+Ob5YXjW3aPMNUybBZ14j2tf9jfj3sh4AE+b4O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiHghfLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiHghfLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B473BC4CEF0;
	Tue, 12 Aug 2025 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024365;
	bh=Vw16C6yEiAwTv0+b2Hyvm4jx1HII21a7SA4XxEroVlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiHghfLqXK9Rvjhoim/WR82CLUrAeVzO0Inhx855wqmkC4zb6duXdKDSR6Sf5gryQ
	 hCRx2rV9HuUFvXhDAE7B4TBN6zN2x6rPpHoppsFcqH8Z8x0g7IRu3YL23SPzNbl6tS
	 YcVoVFjo2B1uqgjiSFo12/8hv+Xm9uKtcs9sb9yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Michal Witwicki <michal.witwicki@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 309/627] crypto: qat - allow enabling VFs in the absence of IOMMU
Date: Tue, 12 Aug 2025 19:30:04 +0200
Message-ID: <20250812173431.063162780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



