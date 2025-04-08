Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0AC268FDE;
	Tue,  8 Apr 2025 11:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111216; cv=none; b=VJQtDDEe+9ryrNlEHF8e6kszePJYhpP+DArTr2pfNj6or1aZwinYrBUCXnPV6piqB09JcWaUeZGil+6ob6QLuqLvidJuJ62JJYJD+PsLagbR93xmtlW3JWDwOqFdpparRoALrGDRFmKWEHemCTF/kYG1bxYHa1y4LTNhY/Laa6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111216; c=relaxed/simple;
	bh=CGYh8U50cJr6neeyic83JJgBkPGfwD3au7/T7KRJJsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwskvzTJJmaNtiCI/CL60FPT67+og9xGK+4DOnqCn9d9fMAwZg5OY9vQuk5DnkY2cztok3oviEOja+gro/rlNDXz3638I9iPKtaw1BSK1B8WsbupS5tORjcX9riFF47/VyMeODOcf7JtDrfH+JCXUaQwR+nAflUKhfKIcxYM0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDJHn/qF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDJHn/qF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A2EC4CEE5;
	Tue,  8 Apr 2025 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111216;
	bh=CGYh8U50cJr6neeyic83JJgBkPGfwD3au7/T7KRJJsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDJHn/qF6SDkqAWnqCcDWI6qVu8dD+3WmyosjnIWyKg9xcssix+mH/az1uSC5zQpe
	 MzuuW15kd2IsnNUrFf8ECV3Yc12LSU9PmayaggIW21B3+p3Nnb2V3M1ud1/pkpH/jW
	 JDRiB51Xd4LMV1CDPr6eoYYFWlRAIBhoGpUWdu8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 352/731] crypto: qat - set parity error mask for qat_420xx
Date: Tue,  8 Apr 2025 12:44:09 +0200
Message-ID: <20250408104922.461417231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



