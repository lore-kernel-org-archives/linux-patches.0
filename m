Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFE415FCFC;
	Mon, 27 May 2024 19:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837822; cv=none; b=uXV5OZyvC2tR1x0w6jGu3VKgKi1oRtmQHreoE2w8Be4rJiFTd2uVkcwAIZ8+Tds9zi4SZ5q5uLJtvyxLimSJIHeU6ahH0BZYFGKI//VmzBPr8psY7QK31aiZpC6EVzOG5YotO9kIKbvdJK81vSEaYeTMn4r3UNuXeDiRNKJ+6+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837822; c=relaxed/simple;
	bh=pivcUogwqgp10B5tsM2u45mj3yALYVrxCGMANPHB3+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lApSpweLRXwWtDSlvMxi9G1e0FFHyyw4ZVjv6akp9cn7ia7Q+StLmHwa+Cmx9S8U0e78YcF0IMiHmDBXgYKAkl12X34vlfORaBlTehEIJz+GC0b0z90uc/Zx6WJ89qRF3QOG1blNGFfV/qb/BEZZel4ESzqnaGqz6Wde/MIiLQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOfZDoMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOfZDoMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6B6C2BBFC;
	Mon, 27 May 2024 19:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837822;
	bh=pivcUogwqgp10B5tsM2u45mj3yALYVrxCGMANPHB3+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOfZDoMF7Rge/OgMdSNKhkQ01NqR9GHWsIzkVMrDv0k9nHq4xswQfm3QOFZucvx0V
	 q8M29S52r9mhNFMAJJfDjbhvAMnOw/0Zmnve+W6gFNV2qkAFPUPaIw6S9TmJ2jo+e2
	 K6eHb4q/a2pavzCRRF1CAV5lRFGky1C9K72MUDGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 157/493] crypto: qat - specify firmware files for 402xx
Date: Mon, 27 May 2024 20:52:39 +0200
Message-ID: <20240527185635.547727038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



