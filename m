Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B432D0ED;
	Mon, 27 Oct 2025 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590682; cv=none; b=QNOvvXjAUXESk2SUI1X1adKRs06moYtI1Ixb3csYlbeJ25jEWtmOf9D6jl8azgpDUioO5M8jMX1e5uWS4MkXz55fNU5bYQgWJjcwE/hutXwZSCNhNfu/ybCqL7f2R+ZVRx84IRchuV2hHHH1eZ5ilYrE6QZ/Swx9ivOoXQ+nsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590682; c=relaxed/simple;
	bh=E0KhFf9tzt5VNUXAK4fM2PRBZiTMLwPfRt6vXgnOrX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZBSTmCJfw++p7Kfa5DQAz/k1lUYCh1WQLW4t0UKalUpWsFooUjjwB/mAKhi7JKMwpl/NhK7+cIyRByvTLsGKkHniX0K5eXaYlVsS1s6pipSsFdY4CCknPUiEmWYCqIPWkYar2Fay1tb+tru2LEQQntumWB2IbLV/+m8XvQTG9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4/inw83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4/inw83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A1CC4CEFD;
	Mon, 27 Oct 2025 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590682;
	bh=E0KhFf9tzt5VNUXAK4fM2PRBZiTMLwPfRt6vXgnOrX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4/inw83eqdVNFW8xrHwY0cubQi9HudWXTaCzw+dFXM32HZZ6y/xDuT+cHYrUwnwr
	 7rU+WFuZ+oA1e07sVjCWqGBiwLfV5TLsqB8ovduDVPexYDmY23n7ce/6W068eKelDv
	 1hXeeuUPWZVR985jtKEf24GnlJDPmRtB3Br0tauk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 108/224] crypto: atmel - Fix dma_unmap_sg() direction
Date: Mon, 27 Oct 2025 19:34:14 +0100
Message-ID: <20251027183511.885153877@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -565,7 +565,7 @@ static int atmel_tdes_crypt_start(struct
 
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 	}
 
 	return err;


