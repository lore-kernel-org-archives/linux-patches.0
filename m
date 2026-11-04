Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829295;
	b=tnduFcc4hPLrGti1b4bEDJCQqtZ0Nmj8qb2s5N7cfhXrweg2as8ydCqW+whAWbaDHwN5
	 4oWo2d6plgiysDQmXkdi4M1GkqClmJ4d0kxQrdcUEdG4s+twieHAlmYgfn3wFNd6BBMMs
	 9VzzqcVCKaz0JdXAxpd1jBIvsRQuwjEfjqngXuGxue/OOWsrMTMlGipQzq5mn6G3lBACW
	 i/4KHwXoCw33+WZLGKeMA4mDGpAlVT7mDeEwwRTzlmGV9v1SWDXUEniK+hEbamU6fZvX4
	 OehCxVf7+pzjuyxgrJkSC9By/6n3FnC+tShGR7WyDm2sjetzfXYuZEdUUhrA22aNnlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYjRym6Tn0TsGb1qNdVtd+/RCn2jNCGmTjGIDsQDEC4=;
	b=UujiFwR+DIfD+TKhz2YllUkQ+0TQYMttJwNjR6HO8kaJVyU+3GwBevFuiNHwWPdG9Ehk
	 c/BQGs9E2ISzyFq46m+NN2obAb7uoB3Jvya3TXEoNxr5iqxl3VlvOfZqQiaiDM3Df8H43
	 QOUdoMFIyTOazOtOjdLqqDMA4YTe0x2oD/ArL9xWdMwq3RH8mRN4hboJArHCLtzE39lDn
	 dLWNO2CWAfCVxfI6fJLoP4ngkH/WUY7+YTRC3Ff8UyJm1TdBdKA2eGkZgZhb6vlfiqiph
	 VMsa50LEJmhrrwwycthaztA5UWBHIveB8x3tEI/U8pN/iFkviIpQHjbUA9ZH2HgQzQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goe7IBgk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401886086604;
	Wed,  4 Nov 2026 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goe7IBgk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF271F00919;
	Wed,  4 Nov 2026 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829295;
	bh=AYjRym6Tn0TsGb1qNdVtd+/RCn2jNCGmTjGIDsQDEC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goe7IBgkypIY6JKKCf2AAPBaOLh5PL3+rKxiXwYGcalD0LJvVXmGR2WSoe4mMQ72q
	 K5LgvL0Qd5uNTxo+Db3gVQoKlPUkg9sb7uCMa+C/bIOFbBd1QQT/FFHuQXCAg2M49W
	 h1zFwcOggWlCGRE/PQkLsyScAkj8pPnxIyG7gRNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0035/1005] spi: qpic-snand: free OOB buffer with ECC context
Date: Wed,  4 Nov 2026 15:56:08 -0500
Message-ID: <20261104211044.552375097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5504e50ffbcf97b3b6ed3740532497922c96a1f1 ]

qcom_spi_ecc_init_ctx_pipelined() allocates qspi->oob_buf as part of the
pipelined ECC context setup. The buffer is then used by the raw and ECC
page I/O paths through the NAND ECC context.

The matching cleanup callback only frees the qpic_ecc structure, and the
init error path also skips the OOB buffer after it has been allocated.
Free qspi->oob_buf on both paths and clear the pointer so the ECC context
teardown owns all resources allocated during init.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260616151129.76060-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 222e4aa7ee488..919e847c061db 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -394,14 +394,19 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	return 0;
 
 err_free_ecc_cfg:
+	kfree(snandc->qspi->oob_buf);
+	snandc->qspi->oob_buf = NULL;
 	kfree(ecc_cfg);
 	return ret;
 }
 
 static void qcom_spi_ecc_cleanup_ctx_pipelined(struct nand_device *nand)
 {
+	struct qcom_nand_controller *snandc = nand_to_qcom_snand(nand);
 	struct qpic_ecc *ecc_cfg = nand_to_ecc_ctx(nand);
 
+	kfree(snandc->qspi->oob_buf);
+	snandc->qspi->oob_buf = NULL;
 	kfree(ecc_cfg);
 }
 
@@ -1660,4 +1665,3 @@ module_platform_driver(qcom_spi_driver);
 MODULE_DESCRIPTION("SPI driver for QPIC QSPI cores");
 MODULE_AUTHOR("Md Sadre Alam <quic_mdalam@quicinc.com>");
 MODULE_LICENSE("GPL");
-
-- 
2.53.0



