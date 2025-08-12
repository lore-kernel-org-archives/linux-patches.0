Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21B82CA9;
	Tue, 12 Aug 2025 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024544; cv=none; b=KeC2pLJ0gOcA0/bAyzaGWekerp52ip1/wYn0pdkswSGlCRGYFNbon0y3DNaFN/YhyGOccDmWcB44rGw0375QUmuuVDmwEp2Zimc3KIz4PeiF61YHUrxZ3KK2BfvnSqEmULRCNYRGCyIUEgihoLMvutC8qUzSurYucFZMxPxHZFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024544; c=relaxed/simple;
	bh=GgQNcsmabYjAO9Eot5ualmtGdZ5gAX39wQKvZbH7Bfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlcXDxvnqCHrVvW54x6wDVxS/UiQlKJCf3SGYNyIl3MYzIeVNJyQ25/zkcRwEml4Y2ku1JF4DA3xtFNqdvMTMVRGOGwyTof53iBGlDxQmkwMF2T8CwL1XZYEFVcaEPpVe55oN2s+smWNmRb85DWr6D6es2AdFE2AOQNhFUyzws0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oD0bsJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oD0bsJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50309C4CEF0;
	Tue, 12 Aug 2025 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024543;
	bh=GgQNcsmabYjAO9Eot5ualmtGdZ5gAX39wQKvZbH7Bfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oD0bsJw0qfzhE13R+TKF+ol1hx0j0wWg1fsSBcZriAD+kI5ZxcAEK+Akdn3uYIM5
	 x//8+SHDirVq4rfTGyrd61ku/utA1LHril5+SGeUXklVpYFrdUItv2oBN0J+4UDWWG
	 s82KxCazlrp+FR0b9xxmwB1Nm1SrgMVDHK1Eqaqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 404/627] crypto: qat - disable ZUC-256 capability for QAT GEN5
Date: Tue, 12 Aug 2025 19:31:39 +0200
Message-ID: <20250812173434.661478686@linuxfoundation.org>
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

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

[ Upstream commit d956692c7dd523b331d4556ee03def8dd02609dc ]

The ZUC-256 EEA (encryption) and EIA (integrity) algorithms are not
supported on QAT GEN5 devices, as their current implementation does not
align with the NIST specification. Earlier versions of the ZUC-256
specification used a different initialization scheme, which has since
been revised to comply with the 5G specification.

Due to this misalignment with the updated specification, remove support
for ZUC-256 EEA and EIA for QAT GEN5 by masking out the ZUC-256
capability.

Fixes: fcf60f4bcf549 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 7c3c0f561c95..8340b5e8a947 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -191,7 +191,6 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 			  ICP_ACCEL_CAPABILITIES_SM4 |
 			  ICP_ACCEL_CAPABILITIES_AES_V2 |
 			  ICP_ACCEL_CAPABILITIES_ZUC |
-			  ICP_ACCEL_CAPABILITIES_ZUC_256 |
 			  ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT |
 			  ICP_ACCEL_CAPABILITIES_EXT_ALGCHAIN;
 
@@ -223,17 +222,11 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 	if (fusectl1 & ICP_ACCEL_GEN4_MASK_WCP_WAT_SLICE) {
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT;
 	}
 
-	if (fusectl1 & ICP_ACCEL_GEN4_MASK_EIA3_SLICE) {
+	if (fusectl1 & ICP_ACCEL_GEN4_MASK_EIA3_SLICE)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
-	}
-
-	if (fusectl1 & ICP_ACCEL_GEN4_MASK_ZUC_256_SLICE)
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
 
 	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			  ICP_ACCEL_CAPABILITIES_SM2 |
-- 
2.39.5



