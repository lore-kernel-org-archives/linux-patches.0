Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C60C330B00;
	Fri, 17 Oct 2025 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716455; cv=none; b=sPjP+wh+lfUlt9GBC05z1KLolKJpCukSgZNzg4ddm7cLVS016jN4hycLGDfYa2umO+hDHclhnWY8uM+1wRg24y7fZSm3II7KbZt1sn/Wlvr6bnudId4OitVOVmoFE+HamufB+XsxVD53JbumU1Yvu3DX7DNsg9b4SvCxgkU+Dco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716455; c=relaxed/simple;
	bh=oNSPWQqraW0BYvJ6kB6GYvTPd8Md4ut/OF0bfZIiEp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTiUFtCWMb2A01oJ52DfbSgcQ8Wx++mvUQKLweWZkb3mAqur/wvU8MXR4oSVqNDMngCMLQCmNOLYRTv7azgZ5I7M1wE6aWQ+tzaK8Ec+VhJNKvN5u27ED+uA4eNVLUzdLOzc4lL658GC+llh3/jAOkeCVQrNrd4joV+eo0jDKB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtN7L3Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtN7L3Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9BDC4CEE7;
	Fri, 17 Oct 2025 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716454;
	bh=oNSPWQqraW0BYvJ6kB6GYvTPd8Md4ut/OF0bfZIiEp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtN7L3PnAat0kKWzwe4lsHtbSTtuilKBJBPz14o7fbQVnp9wuOQN9iBsPwZcnOM8Y
	 qfZxj1mISXogMKs2emuazasy1tcI5Y0+ZNafTb7597w1rNAvo7ckhgzu4Dhhdt5xzw
	 +tKCSyk42rkkSPbbTsb0f1GPzo/xqPIRs4i2syHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 179/276] crypto: atmel - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:54:32 +0200
Message-ID: <20251017145149.011250233@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit f5d643156ef62216955c119216d2f3815bd51cb1 upstream.

It seems like everywhere in this file, dd->in_sg is mapped with
DMA_TO_DEVICE and dd->out_sg is mapped with DMA_FROM_DEVICE.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-tdes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -548,7 +548,7 @@ static int atmel_tdes_crypt_start(struct
 
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 	}
 
 	return err;


