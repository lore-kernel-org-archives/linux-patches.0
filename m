Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46FE197545;
	Thu,  6 Jun 2024 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683177; cv=none; b=ev+lBY/dnKAywhrkqQyuEzVt/+kS26vY5UI6xf+TectoMNXRSMXuMXO0hNfDGhHgKGgAqjYT1wIs1mrLo1PUBik5e4uJRMQogCA4ZSC8pjds1qf2M8BHZ3CR5lCS45qBNvu4AWNTDWnprBlgojTuuw5dEXj2WEnIXB3YpYOWW/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683177; c=relaxed/simple;
	bh=/zLB5y/qMA5pnBHdyqTOFoZ2Tw+i6t0enWFvewyFgoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIa4EmUtAHrN2UFNPTqT9I703Kg5HFnCmBADgecpX5GUSegIChYi/mnkliymyI1ixjuzhtxO4t9L2tJk7I3PK62dkvshLPElSKHL6JUdVBbvNm6tSV1x7szC/KUGiuywqW//kzDCcPYLGujvmc8CgLI06W9rAnrJLmlmV6IDhds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f86lWfRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f86lWfRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC88C32781;
	Thu,  6 Jun 2024 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683177;
	bh=/zLB5y/qMA5pnBHdyqTOFoZ2Tw+i6t0enWFvewyFgoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f86lWfRhLnbRv3lDPKTC6LndlldjgpkaXvw4txtw7kVo8Wmb+iHT7mFkWKHptIWd8
	 LTgIHZ1DZK53TtUNwF2IJKYKg/vTgGF1RGbtfh/1v0uWDXG1KPzkNmAidoso8ZKqZW
	 MA3KZ6O2QjCEnSKKo7aYZJZLJDIt0YyNmnNHZ8Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/744] crypto: qat - specify firmware files for 402xx
Date: Thu,  6 Jun 2024 15:56:34 +0200
Message-ID: <20240606131736.325721200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90f5c1ca7b8d8..f6f9e20f74b54 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -463,7 +463,9 @@ module_pci_driver(adf_driver);
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



