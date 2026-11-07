Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062930;
	b=jNVsYeHMErmM5W+yy2FCVW4XDzO1sCzt4K/YohERRCK3yDEV9uOKLRJzzrzsicmeYsRr
	 OQVIw1uuQQhQ3knPyUY/drLR/bZTHn/2/6EmmJRUsnXevqcao1AcBmMF0POkckhUgdoMW
	 zA6bfh11PjbfTelm2Bl6XtP2qJ/HKXkeawdeKP/dMXhhKLRnMkTs5b8Rh6/xc+HSa7DOZ
	 muUlgwkmEKjYeKPLeBRbJYyOMW1crg+5ELfMDYL5X1KE7tYJMr5XuAZ23XUSPiuqTBmjm
	 C2k3Qbkv+04piG/e4eo4EBkZOTaoqdvBfGA4SuruG897gif3yQqZgf1N+f0gZWE/vAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKI5O9Pkm4zYJdzsElCf3/PF6HRFUi7jOA6xG3qVAuw=;
	b=4Fs+iYwYBMD3KQq4AZWtDnFeshqUBhngNG27E1RRvfeRr7U5g4uSLa2Md+dAzt9Adfiq
	 mAnu+ki//tjtUlzaztKSt3xGBTVZyUwJIcnCricpqabp9DwixWJGQ/rewPi/c7ZcLD1mZ
	 XUnOOvHpH6qnZSAM840sLvXtgZE3SDDZZ8BCCuaE2WLwIlsrOhaKrv3VbwMB5KEYmWyLi
	 6kXeSRTM9IBZUA0Xpep+2gnBKg0J41LaorFTwRQIYjbQgjEa58b+Er2gr0vjij/CsBYWI
	 uPgrLCRCAWcN0pWJF5obPMe4qNXdiVeg5N1skeaC8EarpdDhi8V2Oj2QGCSIQUHFdWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4wVaeVL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D6F606A330;
	Sat,  7 Nov 2026 14:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4wVaeVL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F76E1F0089F;
	Sat,  7 Nov 2026 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062929;
	bh=cKI5O9Pkm4zYJdzsElCf3/PF6HRFUi7jOA6xG3qVAuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4wVaeVLI0vANZZL7l8/Z9fWkdlT13Hk0VwtuWwnG1YU8BksbJa+N6H6Z1x4YUS4x
	 c5gqzPcpN7knqOkVAnQKt/ncnyU+FXAIyszLZt819aiHVtBPzVZqEAydOZrtNopEAX
	 siRXB0Fh0JCG/MWHAD3dV5KlNJTrldlblmZtLEBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/869] crypto: qat - fix error source for QAT GEN6 transmit interface faults
Date: Sat,  7 Nov 2026 08:48:03 -0500
Message-ID: <20261107134858.838978631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



