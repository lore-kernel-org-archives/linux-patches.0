Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAE515FCE0;
	Mon, 27 May 2024 19:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836526; cv=none; b=V614oGQt6QEV8YzM1eAvWgVHjs3BS6RMPXLkhFO2uOG7qsJs6/u4GgC6lh1MjCzQdLI+bfa451FGizGxA83dub3lkmyNv5qHJXJbzYPrcSDJ2S6FhD9WH0wFhZ8OsYJj7LAHLX+zAswXgtVcNIAYqrpJc3jXQik5FD4mqup/aPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836526; c=relaxed/simple;
	bh=iwMue27QdhVv3EnLvsJ+Te/Ts0fnsRwRPFUsCWFOTp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avshFvCN64FN4NQVw62ORmCCQsLmORNLTimTKn16ii8H1vwTXv5m7UH4gJ2syphVt5RztKRzYkzbjWyhjp2wUmxS2Sl8i7MwuclHz5m599T9uf4ee9zAsfhvNBbGHh5+64K4skupWQz7zNfqZ0R++OfPGu7i2R9+6Fqx5eEGQPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPQzCcrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPQzCcrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3634C2BBFC;
	Mon, 27 May 2024 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836526;
	bh=iwMue27QdhVv3EnLvsJ+Te/Ts0fnsRwRPFUsCWFOTp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPQzCcrnw/mWiutnwe+kAmZqboIbJSJb4m3Vi3ZlROsS8rr/ySYS9J/gixvTs0VKI
	 M9WGD/B04Vj+wXrp0G0VDMDbmcpwIlIfyLItlk8CF/p/nAbRvulu/cwkZEXOISRTw6
	 lQ+H4WMQhJqrPzhmF+obCcvg115K/iQD0bOzs5MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 086/427] crypto: qat - specify firmware files for 402xx
Date: Mon, 27 May 2024 20:52:13 +0200
Message-ID: <20240527185609.786773961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit a3dc1f2b6b932a13f139d3be3c765155542c1070 ]

The 4xxx driver can probe 4xxx and 402xx devices. However, the driver
only specifies the firmware images required for 4xxx.
This might result in external tools missing these binaries, if required,
in the initramfs.

Specify the firmware image used by 402xx with the MODULE_FIRMWARE()
macros in the 4xxx driver.

Fixes: a3e8c919b993 ("crypto: qat - add support for 402xx devices")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 9762f2bf7727f..d26564cebdec4 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -197,7 +197,9 @@ module_pci_driver(adf_driver);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_4XXX_FW);
+MODULE_FIRMWARE(ADF_402XX_FW);
 MODULE_FIRMWARE(ADF_4XXX_MMP);
+MODULE_FIRMWARE(ADF_402XX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_SOFTDEP("pre: crypto-intel_qat");
-- 
2.43.0



