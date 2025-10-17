Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D667241663;
	Fri, 17 Oct 2025 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713180; cv=none; b=P67OYhh8ai8c9+pqu4PX019duhirsFMZmj5PqlMojiZmUJyoVYoRdfweIykd0HHlHVqdXTwCp4G6pOyB5FU1CNe3+zlbymsUrxZU3hdKTdCZZNbwZRNfXwRdgOhkSW6Um7RynI5kyHvjoGlkNej7HyGbYH3K8SFW10JTLAHLpSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713180; c=relaxed/simple;
	bh=P9TDXo4S5F4Ya9tQTTkxLtD+PE5l63nYm1LJUy3l9Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taDBIqjao4Y2H5XzRY/Yghwpiy91x61bDvuCY5BJzKVlSErXslTJHSiqohU2LdZmfDHT7Ri2J5HvBsnAFgl6xBhxmp62HMch7KKakTb8wyX3kwa/IwOaum0yDnIzFZOrvSBvmDJALEZiizLyNaJipPpl+g0xiBKGF0Gm1g5jc2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MklOybAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MklOybAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAC3C4CEE7;
	Fri, 17 Oct 2025 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713179;
	bh=P9TDXo4S5F4Ya9tQTTkxLtD+PE5l63nYm1LJUy3l9Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MklOybAWVHQB9fjnunewoHryGoDZnkA3yJIY1WhvofqcY/BBBiQhD5z6exeYM8zOx
	 R1ADwVM7nRzo3yvoHQu4qUC/21PSq4bRj/P34xDGQXlbBJSv4oVS2D9lLEewGy8v+S
	 YIpLJhp/M7MNJS/uDXY57EBQjYu+o5PlzSLi7xwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 075/168] crypto: atmel - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:52:34 +0200
Message-ID: <20251017145131.791101591@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


