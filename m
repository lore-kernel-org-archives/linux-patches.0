Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625686;
	b=bfTnfaxEnC6Phu2KE/l03EFdqORRhuBLmGouto1TQW2WBXtalVm5geCqieSO/qEqGSWi
	 0rF+fwg47oJ6fPwYyAZSqaiQT1Br01gAoaOi2nda2BcJ3z/h6GbKc/N3Hv1ur6ZT4G5LK
	 jQ7XkH6wRVm87u0vZS9f1NvyWKc1B4hGjzq8jrNSSMFwNVy++HMvSLwTCw/tsV28gylhE
	 ljKTP4UhVlgSB/V/kbmgQOmnPt1VXACU0hIp+LkWHvMsRZvLIO4DfkKh2oXPIJAeqI5RW
	 /e82+QYGhmbWwhiXwjJEQUQSzAkiMHahPhMQj3xsb3YWnvme9n1aZrthFkus5cR4Plw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rPCCroXS0LqukR+pmbET9DfMoHxXDg34M+XTaVMaWU=;
	b=tOa3WHR9SuTUdbVgIasym4jiDPjWtCDQGi60C1FmD12e6Bn/vtme1+0jJ3fwAkwWFqg2
	 alVLW66WwG2F9MAXNTZj8LORpmux55DB9iuPyB+B4PHq/bDOnVVQKSkfWF8c+UPCkr3VX
	 DggIC9aWL7SaZLYa4rAT3kh1ZBN2PKgqpjz83zLoA4VJIETkzxRCsN+WgZQhkYVC0wUNh
	 TWVjaNaSGivsImXTHm/by6ic/co7btuQMp4ni2hm4FCXqicoxP0ZrkJtnT+0Qn2hT526M
	 EjLRvgNe9Lom1NpbnZkRgnD+XXF3Q7L5eppMmo0JHYQrS8+4CmxndNysTuCjfpna7xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xc22vpVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2711F606A329;
	Wed, 25 Nov 2026 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xc22vpVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F641F000C4;
	Wed, 25 Nov 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625685;
	bh=6rPCCroXS0LqukR+pmbET9DfMoHxXDg34M+XTaVMaWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xc22vpVC29W1q0U+PPeMbWuJ8n+0SKO83GGY5QcnzsDiopyz7WQX7BT+Yxrd1OW/i
	 nDK8XzbLhGzlNXpeXQUNSgOIkkkGGrhg77tRfmV4uKHWQq3Zv0WfEdOKOU+feEsK8o
	 e+3MGoT8JTwejkVWKyDwWVEn8ow8bw3jG/OYDq54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <liuwe@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.12 597/816] hv_netvsc: Stop PPI parsing on invalid metadata
Date: Wed, 25 Nov 2026 15:35:45 +0100
Message-ID: <20261125143902.997362688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


