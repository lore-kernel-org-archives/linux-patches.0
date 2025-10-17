Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE3A33710B;
	Fri, 17 Oct 2025 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713787; cv=none; b=XB3FtCwN3mDdlArp4Mwo9hFE2RvfXc2nZ2LWprCORlmde2A5/Nx7yugOFdU1K/wrvOaeTdn6ug1mm5K6K4f1haj5wQy5SzKaaIfuNQH7vgl6v+iGU/euNDOynSqPOpcS1Z3zY396Yi8j9A/zohPyf61mzdhPs1Z1KjAz+CmXgFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713787; c=relaxed/simple;
	bh=DWblO0Ifg/L0NdwEUrjIIb5GZlOymE+5Xt9z9Evbq7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwnOsnXLvbXqkm0pPPpxaExoAB50JBfyhUuQj4pFFTNH3HdrezEvxogMQQGaW3Eb11UgDpBArCV36XSuGFe5NWIwZFuJHTqWvYPkhOdwdcn+M+4TKq/EIQW6v/+nTX+6M+ZrMUJtCrdZq5hRF6nxOXHLshep8Z/SidjF7g+8eEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy1vdLoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy1vdLoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A038C4CEE7;
	Fri, 17 Oct 2025 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713786;
	bh=DWblO0Ifg/L0NdwEUrjIIb5GZlOymE+5Xt9z9Evbq7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy1vdLoqcmU0it2U5+1kmBN5Pd6nBVRt2AL+jooDJBEWDYbi1KqB12hNFnDnK6uWu
	 oNqZYIw1VlRy+0yafddCc8YrMDdp8o4M805kZYiRUV+cvVyDQMH2xZF6A9w5Qq5Z/G
	 4zBWMITeIHmArxm+NJLZVA4bIEKaDQ6eW9ZZo43E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 086/201] crypto: aspeed - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:52:27 +0200
Message-ID: <20251017145137.915503321@linuxfoundation.org>
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

commit 838d2d51513e6d2504a678e906823cfd2ecaaa22 upstream.

It seems like everywhere in this file, when the request is not
bidirectionala, req->src is mapped with DMA_TO_DEVICE and req->dst is
mapped with DMA_FROM_DEVICE.

Fixes: 62f58b1637b7 ("crypto: aspeed - add HACE crypto driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/aspeed/aspeed-hace-crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -346,7 +346,7 @@ free_req:
 
 	} else {
 		dma_unmap_sg(hace_dev->dev, req->dst, rctx->dst_nents,
-			     DMA_TO_DEVICE);
+			     DMA_FROM_DEVICE);
 		dma_unmap_sg(hace_dev->dev, req->src, rctx->src_nents,
 			     DMA_TO_DEVICE);
 	}


