Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623009;
	b=o4G37eejpsld8G6DEi1PsXZp1OtsWCCSZMDlKlpJyAHT3X8BRZ5KJF1imSz5JMWD0TK+
	 3awoaVW9L44AlqcbWGeOOyQbE27XX9ixi1FeVF9cLymSZ0oH4+GwrXG8EOlopmmNAxIs2
	 8VzMXUSfV9BR4bxgOHwnu3mUWVoTT1sAdwtnacvQrpsT2tJpZR0mDsiKMjNKHVua0wxI2
	 bQHxJ0guxsbxntTqi1PQ+oWLiAYgc2NHDVuUEYa44snVJ6OTYJ+3lOoIcvTo24qrWRlCf
	 7od9q8tF26nbzCWSxkJlm7WVYx5y4pBiEDxBo7Snlq2Vx60WUwklFAYt05Smyoduotg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sP9UwEJRpzlJfyEIkRI3MWbebCeZmk2iNE50x3E99TM=;
	b=aG+9OcOM7roJJY+Dbysbubgyt1O0XRSVIfQhoWnv0WItyM6J3tC/+Gsar2nKsK7l6tVa
	 xv1pDE1pRhReeVb0UGGGXmzebSJ9afpt+xLcJuHwxyY104wNRgf/rXxAHDVOkicKa5Vp0
	 LlNslGPuTn9bfys3y34sMkmKtQBRSBc6iH9SduzVQgcB7YUr3eG1+yyyPUEoJfBiAa3OR
	 D8AJd8rkESNRyLTcYlLlo7QsGbvSonwshrMb67rbbM0LnbWi1uHa2gWGcaXj4Qj1GqAh7
	 lMaii2UH2kUr1RyVLSDKVXEErZErswyIuuuBBTJ7hdtLU5QGLTWaBguOVmgDEDIu2pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0hgud/7A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793B9606A31E;
	Wed, 25 Nov 2026 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hgud/7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DD31F000C0;
	Wed, 25 Nov 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623009;
	bh=sP9UwEJRpzlJfyEIkRI3MWbebCeZmk2iNE50x3E99TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hgud/7AkIEw2a+wpqem3puYLHW45rYrpgKIg5C5ejTS5beDp1o9DC40YIa0fXZDt
	 DL3PpIqiWDfvIbifejxM3BsblWpKAq8AC5Q4f7PYCNDbGz/0iJXDNTla0SUC9K7s0l
	 apLUBinDSSSDTirHyEZ6YR7jHpwuxNSdgQ0nCXLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <liuwe@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.18 719/990] hv_netvsc: Stop PPI parsing on invalid metadata
Date: Wed, 25 Nov 2026 15:34:46 +0100
Message-ID: <20261125143838.922451716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


