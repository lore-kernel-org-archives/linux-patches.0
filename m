Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B0F32F767;
	Mon, 27 Oct 2025 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591286; cv=none; b=Q4ODtOJ9pEPZkFsdV/xFPwMIRTQBLqCHKMp+Fkx2tO1ofVVZvcbaerEko0k/NXeTzMTP8CCANkUefVK711hfLIfJNfJL0xiQ5LgBFSiCrghzyyyzxTYANXjeMTAofKZ+e5XRJP38J/ukVRdOMmomSUc3qAJmCeQ83PS421ci00M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591286; c=relaxed/simple;
	bh=aOedaltG88AXF0h+kCmf0cu5QdqAmdS3A2NJgBsszJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdHgakblN4yv5H+gSsfN5lPtdSXlBh+uQN5wBlMoBn9+HRscpm4XCF1jeGb+2DzvuyuvgODjuAu1f47STQ+Q6SnhI/Kn2lZOsrgjZKo+tBY00rIg3U+Qcir3isIqdpgGvTjQem87SjJOorBjGGNlwnp0Bens75w9YqIgnm+KKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8lKSPUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8lKSPUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179F5C4CEF1;
	Mon, 27 Oct 2025 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591286;
	bh=aOedaltG88AXF0h+kCmf0cu5QdqAmdS3A2NJgBsszJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8lKSPUNung0Z/jt2UtKu7f7eVk6BLIIxYpR39KCB/rC2FZrujBz5bknXGwerxW/s
	 OKlDO0QSkWCFLvXnpCM7oafF0tiJgnOD+FjyCqFr2MqVMYtKTBqRyozpp6RdmR9wep
	 953ffInK2Z+s/rzzQCU7nCJwZ7+0+aTbAD58jyGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 138/332] crypto: atmel - Fix dma_unmap_sg() direction
Date: Mon, 27 Oct 2025 19:33:11 +0100
Message-ID: <20251027183528.278426245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -558,7 +558,7 @@ static int atmel_tdes_crypt_start(struct
 
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 	}
 
 	return err;


