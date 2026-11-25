Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619613;
	b=4Uo8ol/R9suwsH4chHdirXRkanl2wIAUfBVtL66iCnr74a2b/tOznhxy2bXo63ESsyAn
	 mZAURZBjSKllUWJI2mduPqm9NZCx9Vpno4J9zO9VlQ1QQIrXZzujvCciyhAmouIftHagI
	 C+iJ6Vv5UiU2nT49yRPa7n5eo0Q2+5pvA2DYb7r0tEQza/GM9JdW6mq7MEo50rEDLUnn1
	 2FjAZ7napLy94/m7EfffRGKMnN9MM/sqkZFzS8e1fDKEi3h/7RzKN3d+b6QSTMLhJkSK7
	 2XGFC6jofRPGGLMscNBq8CkAz6mgzqSs1mVbqWEYSkfTXF0eUnrd/m3ODmA+4/heUug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxYwFZLiwl3dWzA8W3a/O8b4cLCkoyq+0vAptiNfP2E=;
	b=Zqrt0tdm9ZbgVKTyHMyoxbaw6sip1YG88e6knDJx/Pl2DwBUp5pEaRPlxNfU4SLkZhgE
	 +kCnqq2gg9TEBWE7hq8AHieZoTYzghMajenogjHNuf9uwYdl620g6DuM0YKKaIZ1TYEC4
	 U9AUDgxEfJroWchv+oQn8k/2DUxJfZqF2X9RAARurVR0q4/KA+RoDEZB6si2u1/CnAHca
	 4t3wkM3zlKNuXS0vjPkQU8bap1eF6lyssUWxfNQxDPtt7o2rhlRNvpArI4un2nMF70R5l
	 mCqUyJhrAqgB+VbXwYTjX674BFSu6QI7cgT2XtCsLW3jZ2JBRhuC1KK8zh1jg3z5Kag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfEnwfs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E98A606A32E;
	Wed, 25 Nov 2026 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfEnwfs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E03B1F000C0;
	Wed, 25 Nov 2026 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619613;
	bh=wxYwFZLiwl3dWzA8W3a/O8b4cLCkoyq+0vAptiNfP2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfEnwfs33ezUF+aocr5ybS+TEsiQ5UKh5bkfzFV2HJnQNaXU/7q02MDSL3i30fjN8
	 rUxQZJpaXjLsaXBMN1CUJtu5zIMR6CvbfxT9RxUinOlNb2extBk5knbQsdtq32CQF3
	 Au3WiSzAqzL6nvm8KOVaP2oAMIdRs2z5AP6yvxOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <liuwe@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 7.3 0654/1005] hv_netvsc: Stop PPI parsing on invalid metadata
Date: Wed, 25 Nov 2026 15:33:12 +0100
Message-ID: <20261125143837.070076871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

commit 19a227903e65c7a9c179156485660a4e017575fe upstream.

rndis_get_ppi() uses continue when a per-packet information entry has an
invalid size or offset, or cannot hold the requested metadata. However,
the remaining length and entry pointer are only updated at the bottom
of the loop. Each error path therefore retries the same invalid entry
indefinitely, repeatedly logging the error and preventing receive
processing from completing.

Return NULL on these validation failures instead of continuing. This
terminates the lookup when malformed metadata is encountered while
preserving the existing behavior for valid entries.

The issue was reported through an internal bug-tracking system and
confirmed by manual code inspection. The pre-fix hang has not been
reproduced locally.

Fixes: 44144185951a ("hv_netvsc: Add validation for untrusted Hyper-V values")
Cc: stable@vger.kernel.org
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Wei Liu <liuwe@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/rndis_filter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -401,12 +401,12 @@ static inline void *rndis_get_ppi(struct
 		/* Validate ppi_offset and ppi_size */
 		if (ppi->size > len) {
 			netdev_err(ndev, "Invalid ppi size: %u\n", ppi->size);
-			continue;
+			return NULL;
 		}
 
 		if (ppi->ppi_offset >= ppi->size) {
 			netdev_err(ndev, "Invalid ppi_offset: %u\n", ppi->ppi_offset);
-			continue;
+			return NULL;
 		}
 
 		if (ppi->type == type && ppi->internal == internal) {
@@ -414,7 +414,7 @@ static inline void *rndis_get_ppi(struct
 			if (ppi->size - ppi->ppi_offset < ppi_size) {
 				netdev_err(ndev, "Invalid ppi: size %u ppi_offset %u\n",
 					   ppi->size, ppi->ppi_offset);
-				continue;
+				return NULL;
 			}
 			return (void *)((ulong)ppi + ppi->ppi_offset);
 		}


