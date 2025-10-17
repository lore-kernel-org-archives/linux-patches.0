Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538093370FB;
	Fri, 17 Oct 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713789; cv=none; b=CZz4wEXFhAo7af+nxrDGr1HunXj2FnouZBIMW8eN2MABmiPDKTad5/jyUzJ7yvBFVaNInMmcGHM/TJGUvB+kQi4oVe7/rhZCMCJl5mGzWKA6aYV1ZRa+foWE11IBpa7w/anAx81Hd/WctJPjdQlbXmaMkpB5CHr0YxI7o2oRg7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713789; c=relaxed/simple;
	bh=o8PWin9pbMfYgueoFJxAdqsZ/9DN8J6PQBCB8BHtVS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzOqvYZRGG8eIcGkg0yMlN/T/a8x2CkVM2YhQPm5gIprp9ekXWoe9Qn3sndI4C+vJr/hl7lbl3pzzG0+MhIGg7MIz765qqYiBZd+HLVf7f6ZgATBulmE1q0HhrqagL3LEsRDFPvjuja4xTc0bH17BW6PLh8P0dQl6zqeotDqN68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbX8Sa4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbX8Sa4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38EFC4CEE7;
	Fri, 17 Oct 2025 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713789;
	bh=o8PWin9pbMfYgueoFJxAdqsZ/9DN8J6PQBCB8BHtVS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbX8Sa4UY9LRAlspzqzvDJM1jkHWG8dY8BV2TyTLHvNwb7MwALZhdHq40ZVrKO5Ck
	 wyarL4Koez+Fbp2TWw2aGXcT/p0c8RO1Qt52JKIfvp8Mgf/zoDBxkI+Lu7Kfpv+dW5
	 YIiCn7r6nrwAvKKVo0jKi6HabcTTTLvRQgMeu56g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 087/201] crypto: atmel - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:52:28 +0200
Message-ID: <20251017145137.951636771@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


