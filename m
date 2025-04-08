Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367A619DF6A;
	Tue,  8 Apr 2025 12:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116429; cv=none; b=HeVii9ku04b7Os/wSCk4yToC9ugOMxfTfF9pP6noEbhZTlgcCgkAucsCFh2dJETLf9hWmFtdvO/izLnOjAG6YH6xibmluGEb8ySCH/JhkO45GqRzoPvxPeJF7YwQSZ7LsZ5VGI6a6jo3T7hfHU5cvXYqj/TBnwPBrpSZs0pwUuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116429; c=relaxed/simple;
	bh=swM/9pcyHHgH6r0IzI42yNzmoVrE4WW7BLnSN2yaqz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQk9JwKLSVYBUWt+1jFIzO//N0p8YsndoWkgr6oJ52GsA0r00OnCFy4cKae9I1uIhW+NaWSRts+/FbThoLYxKAeBlDdtnrP/I9K6uye5gDhZd1DP7An0O29hcTnKXX48Zx+9ItJVIv3ov2N91ASnU8nRET7E1cp4f5fD3RUx9Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXvYnYFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXvYnYFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7A3C4CEE5;
	Tue,  8 Apr 2025 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116429;
	bh=swM/9pcyHHgH6r0IzI42yNzmoVrE4WW7BLnSN2yaqz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXvYnYFJ9wnzT+X6RRwhVpsK/AH8JggHEWSNlRtpQvl0oN9RIKKvs4RTpzoXFP6i8
	 zb26DFnJG/jtRypUm+zO0bhq8OUvLqYAHAIqD1lxBpmD2qoHi3WTHxb4m0a2MoXZbN
	 XL5bVoY6zZfnL9eLof6vjH6GMveGdP2l6xMi2Utk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/423] crypto: qat - set parity error mask for qat_420xx
Date: Tue,  8 Apr 2025 12:47:04 +0200
Message-ID: <20250408104848.020119921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

[ Upstream commit f9555d18084985c80a91baa4fdb7d205b401a754 ]

The field parerr_wat_wcp_mask in the structure adf_dev_err_mask enables
the detection and reporting of parity errors for the wireless cipher and
wireless authentication accelerators.

Set the parerr_wat_wcp_mask field, which was inadvertently omitted
during the initial enablement of the qat_420xx driver, to ensure that
parity errors are enabled for those accelerators.

In addition, fix the string used to report such errors that was
inadvertently set to "ath_cph" (authentication and cipher).

Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 1 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 9faef33e54bd3..a17adc4beda2e 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -420,6 +420,7 @@ static void adf_gen4_set_err_mask(struct adf_dev_err_mask *dev_err_mask)
 	dev_err_mask->parerr_cpr_xlt_mask = ADF_420XX_PARITYERRORMASK_CPR_XLT_MASK;
 	dev_err_mask->parerr_dcpr_ucs_mask = ADF_420XX_PARITYERRORMASK_DCPR_UCS_MASK;
 	dev_err_mask->parerr_pke_mask = ADF_420XX_PARITYERRORMASK_PKE_MASK;
+	dev_err_mask->parerr_wat_wcp_mask = ADF_420XX_PARITYERRORMASK_WAT_WCP_MASK;
 	dev_err_mask->ssmfeatren_mask = ADF_420XX_SSMFEATREN_MASK;
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index 2dd3772bf58a6..bf0ea09faa650 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -695,7 +695,7 @@ static bool adf_handle_slice_hang_error(struct adf_accel_dev *accel_dev,
 	if (err_mask->parerr_wat_wcp_mask)
 		adf_poll_slicehang_csr(accel_dev, csr,
 				       ADF_GEN4_SLICEHANGSTATUS_WAT_WCP,
-				       "ath_cph");
+				       "wat_wcp");
 
 	return false;
 }
-- 
2.39.5



