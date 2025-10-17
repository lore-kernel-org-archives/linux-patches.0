Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22082F12D0;
	Fri, 17 Oct 2025 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714392; cv=none; b=d4nmwuOvQ0AHO46yxcpu5HV+7xLw6+DLCsg+eWVpPkMcN1mmcHgUkPKz8M4n8ngZ2mD8Nnot3fuih0u12mcrgzIDzH57Gbc1Ima4bG6oJ/dn/gMpFg1TC0IFZeIewCKk8ZCu4Pdbfpofo1OdROm9xkkTnae633bL3ELE3/N7dgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714392; c=relaxed/simple;
	bh=nLY3efeGIhLj+aGRzrzsixXrncuFqa/wpBe259jJoR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mX45ZRMs4JZjheLFLrWy9DcG02wbUL046TORSXQv1RuPRQ6Rn+uAez02iVoFQqcS8CS1QqrYNeWceYsAiPx7oOIb4bwUfr81un0CK0F638fSV1gpKIfha2GjBPtJSDD4KdJgE8kKcnSprMeU4F2weKtaXYzIzvAUrwBHRzfN5dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNMf7zND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNMf7zND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56951C4CEE7;
	Fri, 17 Oct 2025 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714392;
	bh=nLY3efeGIhLj+aGRzrzsixXrncuFqa/wpBe259jJoR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNMf7zNDV4Evw3R/dPqAMXIgczIVxkJEpRcJzqm6EUhYlfZ81kVcyCcn1Rft+hBpw
	 2hbCu5dAjY3/DyHQSianTHwzMGJtnaGfGnFqb+Bi0UUNRsmQLNqffuol46H3/y3YQY
	 2HvsjAXhHV8oWGydPBZmVpE+sTeHR8cnzYZGGWP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 128/277] crypto: atmel - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:52:15 +0200
Message-ID: <20251017145151.801056331@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -512,7 +512,7 @@ static int atmel_tdes_crypt_start(struct
 
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 	}
 
 	return err;


