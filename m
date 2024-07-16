Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932261DDCE;
	Tue, 16 Jul 2024 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145737; cv=none; b=bl69sVA6zUi1BV3+VQ//LqDT7L31k9wEGOWOtlneqYXTjrD8ss/QtZnDXwzosAx7o47FVow0HJqgCrD5lPRfuRdRjP0UYf0En0DwIqsxoEGDKjY6yKFlmuo36dDrbrXQWG01WoxWUaeEKOV40cFR3ODS9jTfOQrT7Hs/M/x0gQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145737; c=relaxed/simple;
	bh=79cB9qV7RZAOzVQuE4d7T13IfnyEAyIFIVDC352j/pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihlXBX/YV1ejfBRGQaj4LtCPzrysMo85VOeWM20sWEtmaaFtwUYg3/18lQrUiKHihfB4Zcj/Bg1N79tt0fA8SdYF3T3gcK9QC8/AcF98aAeIx622KK+ME6KXKmxbF7JdA5XZDh9QwN+8Qa670knJpYUmbMNFSwPHoNWv+GJndgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSchz2td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSchz2td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176CBC116B1;
	Tue, 16 Jul 2024 16:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145737;
	bh=79cB9qV7RZAOzVQuE4d7T13IfnyEAyIFIVDC352j/pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSchz2tdsdjforSP+fF6mHkOnB+mVOVwnDccggMc5oWxWLiFLMZjs7qh8W4KIK4yE
	 WcLafL4IGARlkC9h3IDCX2kvJSZr6rc6knXQq4MAflapJj3579Hcdj25qgekYQS2kX
	 KTsleyQsj7P3QaUX/qnci7yVyyiKbxzsDLAIITPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.6 068/121] misc: microchip: pci1xxxx: Fix return value of nvmem callbacks
Date: Tue, 16 Jul 2024 17:32:10 +0200
Message-ID: <20240716152753.943134233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Joy Chakraborty <joychakr@google.com>

commit a6a0f04e7d28378c181f76d32e4f965aa6a8b0a5 upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

Currently pci1xxxx_otp_read()/pci1xxxx_otp_write() and
pci1xxxx_eeprom_read()/pci1xxxx_eeprom_write() return the number of
bytes read/written on success.
Fix to return 0 on success.

Fixes: 9ab5465349c0 ("misc: microchip: pci1xxxx: Add support to read and write into PCI1XXXX EEPROM via NVMEM sysfs")
Fixes: 0969001569e4 ("misc: microchip: pci1xxxx: Add support to read and write into PCI1XXXX OTP via NVMEM sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240612070031.1215558-1-joychakr@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c
@@ -153,7 +153,6 @@ static int pci1xxxx_eeprom_read(void *pr
 
 		buf[byte] = readl(rb + MMAP_EEPROM_OFFSET(EEPROM_DATA_REG));
 	}
-	ret = byte;
 error:
 	release_sys_lock(priv);
 	return ret;
@@ -197,7 +196,6 @@ static int pci1xxxx_eeprom_write(void *p
 			goto error;
 		}
 	}
-	ret = byte;
 error:
 	release_sys_lock(priv);
 	return ret;
@@ -258,7 +256,6 @@ static int pci1xxxx_otp_read(void *priv_
 
 		buf[byte] = readl(rb + MMAP_OTP_OFFSET(OTP_RD_DATA_OFFSET));
 	}
-	ret = byte;
 error:
 	release_sys_lock(priv);
 	return ret;
@@ -315,7 +312,6 @@ static int pci1xxxx_otp_write(void *priv
 			goto error;
 		}
 	}
-	ret = byte;
 error:
 	release_sys_lock(priv);
 	return ret;


