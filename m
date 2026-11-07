Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064123;
	b=bKSLZ9tme9U3rpXrWH4n2cQm+BNEm+cYJ+BsNyW9giC3wRpvb/GY3jvVKeiUPdCw2MNH
	 aEI59Uedl1RnF8Ztx9rhMzJYOIuBb14od0f1795IEWZlLi9dvYGFqgMatKTg7J+JZOq9m
	 J1rk/uthAhguzcFNflVubWquAulGZAPHQWmhD5D2iQniZzRSff3G9d85DPEuRg5uWD6dv
	 326MVahujqAHJCYGA72GmWqMTkrdHkbyxWYg1+4bwB2dRhIPSpTzB4ohDKP1BxmyfyZ3q
	 Maau4jeie65qzTA9Xpi1C4WAKUQelDLjMr3l4v32X3JiQF66K5z8XIB3IBAOW/NMcqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9HW/B6P9/0kTh4HQYOC+ej+0pBF2jIN9mwg6A+r+qM=;
	b=a4DjBPchM6wm8MpELDNsFnFeCaUqSeYuuKQXNN4Wk6FGMTOQwg6T6QppoG5O0yguvMQu
	 YSG3d7HGDrz63f0jstuB4vEKEsBCeAa4W0Q2a5TJV8iRyr7sbt16aMbhvetprGak+oWz8
	 omkThZ9DxlOxxDBwybLl/2GHPklANMz+m2H6hD9uKF2k35QB5z7mHfeO629Cuu/N8csGL
	 v6Q/Gt/QdkgKyUijG4Kw49xhKK+DKFSIDwbWx+iN/EN28zI/t0Lreqb2dTMFQG31EPhR5
	 etDQedsXw0Og+cnEKLnt8nCksVIBgAfSVfL0QB8z9C3bzZPrxbldtXMN5iycqGVoE4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrmEF8TF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B3A606E8CF;
	Sat,  7 Nov 2026 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrmEF8TF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581E91F008A1;
	Sat,  7 Nov 2026 15:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064122;
	bh=U9HW/B6P9/0kTh4HQYOC+ej+0pBF2jIN9mwg6A+r+qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrmEF8TFWkpzc2oVM35k7g3z+DjvtqzCUZtsR9WiotdLkDPb6g6b3dX7fhfFeSvOB
	 shSf7vz1KZcEq/Tbj//Ky4J8ck+TxWT3eQyTm1K57GeUClD3tIfTMccOThQ/DtYSsx
	 FnLXKRfedEPIrvzVVyU4cPMiCGrrqx7m7DWHKNqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0251/1257] crypto: qat - fix error source for QAT GEN6 transmit interface faults
Date: Sat,  7 Nov 2026 08:42:27 -0500
Message-ID: <20261107134946.440486474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>

[ Upstream commit eeaf1ccd4c05d9c6ad67345862b36670e8e4dfc2 ]

TI_CD_PAR_STS faults were being decoded under ERRSOU1, which is
incorrect for QAT GEN6 devices. They are actually raised on ERRSOU3.

Move the handling of TI_CD_PAR_STS faults as part of the ERRSOU3 logic
and split the status bits by their actual source:

 - Bits 0-18 (TI_INT_ERR_DEVHALT) handled when a DEVHALT is signalled
   and are counted once as ADF_RAS_FATAL.
 - Bit 19 (TIMISCSTS) handled separately and counted as ADF_RAS_UNCORR.

Previously, a TI_INT_ERR_DEVHALT fault also incremented ADF_RAS_UNCORR
in addition to ADF_RAS_FATAL. Since a DEVHALT is already fatal, remove
the redundant increment.

Bits 20-25 of TI_CD_PAR_STS are unused/reserved on QAT GEN6. Remove them
from the mask.

Cc: stable@vger.kernel.org
Fixes: 7f3401d0a506 ("crypto: qat - enable RAS support for GEN6 devices")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_common/adf_gen6_ras.c       | 20 +++++++++++++---
 .../intel/qat/qat_common/adf_gen6_ras.h       | 24 ++++++++++---------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
index 967253082a984..902c4b1a23e3b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
@@ -323,14 +323,26 @@ static void adf_handle_ti_cd_par_sts(struct adf_accel_dev *accel_dev, void __iom
 	u32 ti_cd_par_sts;
 
 	ti_cd_par_sts = ADF_CSR_RD(csr, ADF_GEN6_TI_CD_PAR_STS);
-	ti_cd_par_sts &= ADF_GEN6_TI_CD_PAR_STS_MASK;
+	ti_cd_par_sts &= ADF_GEN6_TI_CD_PAR_STS_TI_INT_ERR_DEVHALT_MASK;
 	if (ti_cd_par_sts) {
 		dev_err(&GET_DEV(accel_dev), "TI CD parity error: %#x\n", ti_cd_par_sts);
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN6_TI_CD_PAR_STS, ti_cd_par_sts);
 	}
 }
 
+static void adf_handle_ti_misc_cd_par_sts(struct adf_accel_dev *accel_dev, void __iomem *csr)
+{
+	u32 ti_misc_cd_par_sts;
+
+	ti_misc_cd_par_sts = ADF_CSR_RD(csr, ADF_GEN6_TI_CD_PAR_STS);
+	ti_misc_cd_par_sts &= ADF_GEN6_TI_CD_PAR_STS_TI_MISC_MASK;
+	if (ti_misc_cd_par_sts) {
+		dev_err(&GET_DEV(accel_dev), "TI MISC CD parity error: %#x\n", ti_misc_cd_par_sts);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+		ADF_CSR_WR(csr, ADF_GEN6_TI_CD_PAR_STS, ti_misc_cd_par_sts);
+	}
+}
+
 static void adf_handle_ti_trnsb_par_sts(struct adf_accel_dev *accel_dev, void __iomem *csr)
 {
 	u32 ti_trnsb_par_sts;
@@ -367,7 +379,6 @@ static void adf_handle_ti_err(struct adf_accel_dev *accel_dev, void __iomem *csr
 	adf_handle_ti_ci_par_sts(accel_dev, csr);
 	adf_handle_ti_pullfub_par_sts(accel_dev, csr);
 	adf_handle_ti_pushfub_par_sts(accel_dev, csr);
-	adf_handle_ti_cd_par_sts(accel_dev, csr);
 	adf_handle_ti_trnsb_par_sts(accel_dev, csr);
 	adf_handle_iosfp_cmd_parerr(accel_dev, csr);
 }
@@ -591,6 +602,8 @@ static void adf_handle_timiscsts(struct adf_accel_dev *accel_dev, void __iomem *
 	if (!(errsou & ADF_GEN6_ERRSOU3_TIMISCSTS_BIT))
 		return;
 
+	adf_handle_ti_misc_cd_par_sts(accel_dev, csr);
+
 	timiscsts = ADF_CSR_RD(csr, ADF_GEN6_TIMISCSTS);
 	if (timiscsts) {
 		dev_err(&GET_DEV(accel_dev), "Fatal error in transmit interface: %#x\n",
@@ -730,6 +743,7 @@ static void adf_handle_ti_int_err_devhalt(struct adf_accel_dev *accel_dev, void
 	if (!(errsou & ADF_GEN6_ERRSOU3_TI_INT_ERR_DEVHALT_BIT))
 		return;
 
+	adf_handle_ti_cd_par_sts(accel_dev, csr);
 	dev_err(&GET_DEV(accel_dev), "DEVHALT due to a TI internal memory error\n");
 	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
index 66ced271d1733..11f7b2986f567 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
@@ -170,23 +170,25 @@ struct adf_ras_ops;
 #define ADF_GEN6_TI_CD_PAR_ERR_MASK			0x500638
 
 /*
- * TI CD parity status mask
+ * TI CD parity status mask - TI_INT_ERR_DEVHALT bits
  * BIT(0) - BIT(15) - CtxMdRam[0:15]_sts parity status
  * BIT(16) - Leaf2ClusterRam_sts parity status
  * BIT(17) - BIT(18) - Ring2LeafRam[0:1]_sts parity status
- * BIT(19) - VirtualQ_sts parity status
- * BIT(20) - DtRdQ_sts parity status
- * BIT(21) - DtWrQ_sts parity status
- * BIT(22) - RiCmdQ_sts parity status
- * BIT(23) - BypassQ_sts parity status
- * BIT(24) - DtRdQ_sc_sts parity status
- * BIT(25) - DtWrQ_sc_sts parity status
  */
-#define ADF_GEN6_TI_CD_PAR_STS_MASK \
+#define ADF_GEN6_TI_CD_PAR_STS_TI_INT_ERR_DEVHALT_MASK \
 	(BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5) | BIT(6) | \
 	 BIT(7) | BIT(8) | BIT(9) | BIT(10) | BIT(11) | BIT(12) | BIT(13) | \
-	 BIT(14) | BIT(15) | BIT(16) | BIT(17) | BIT(18) | BIT(19) | BIT(20) | \
-	 BIT(21) | BIT(22) | BIT(23) | BIT(24) | BIT(25))
+	 BIT(14) | BIT(15) | BIT(16) | BIT(17) | BIT(18))
+
+/*
+ * TI CD parity status mask - TIMISCSTS bit
+ * BIT(19) - VirtualQ_sts parity status
+ */
+#define ADF_GEN6_TI_CD_PAR_STS_TI_MISC_MASK		BIT(19)
+
+#define ADF_GEN6_TI_CD_PAR_STS_MASK \
+	(ADF_GEN6_TI_CD_PAR_STS_TI_INT_ERR_DEVHALT_MASK | \
+	 ADF_GEN6_TI_CD_PAR_STS_TI_MISC_MASK)
 
 /* TI TRNSB parity status */
 #define ADF_GEN6_TI_TRNSB_PAR_STS			0x500648
-- 
2.53.0



