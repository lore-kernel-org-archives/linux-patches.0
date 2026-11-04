Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830869;
	b=FDqybavwMwp19Sqa3nWjS98faY5zNzorkzmUARJG2GHo/Y+8I7mh4H+/ALpMFI904vla
	 EYqEEn3FpTmDuBicphka3zAan3bcIrR/Ij7Rj/DoQcNaB2mIfXKBaTymyWOfPkpBskTxQ
	 wRawxatYLHolVxzYxoG4O0EPEVZZBC3K3jMapbVCg4m4YiyeIr6LUwPOcw4eCAS1LBUCz
	 DUm+zc+8jOhaQOukqsUFdX4fMQG0C+jPs7cWFjcDSZsKH6lU74tIbc18uf6TfjBW9OGsF
	 T5M8D4e8rYR3PmphzKrq1P7D3TQ0a0y1g6Cj1nrZGUSxBgGl/eUJmqlqusiW+5YzPDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22znB58S3Yq9ScNZa5TWOxJLpAz1jhIndb+eyvvYylY=;
	b=uQSpdxKJ00SYjFzDHtl8bTdYI+nOwnYDKS58q96gIgQql9KNnfcykfCpUccdqN90+Jwn
	 CgjLytFAavp5us2WH6mrH0ozaBKN2P3ONZ7hwqZvsDCpkfvRGAj2b9X26Uo9zZdDnnJxp
	 URWObEN95XnmJO+Xyqmqtmlk+H/GppxOW5QV9GeiLFtSO6/4Zk3Jk2N2kWjKLAwF4if9W
	 SrfMg+QTlEHJOAYHGCKVJnRvuRexUmhqFRBaIjfwCldwUppcN2MfGofWErsKYvk2qxIxh
	 0y3wAHo4yqCtzgqv3B08P9ZB5hkTUaLX7LJFj9ouIutCuE7oDDviUc+Odb+7LZeIRBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asfu347h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64C7606E80E;
	Wed,  4 Nov 2026 22:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asfu347h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8338C1F0093A;
	Wed,  4 Nov 2026 22:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830868;
	bh=22znB58S3Yq9ScNZa5TWOxJLpAz1jhIndb+eyvvYylY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asfu347hjIZqSixSyXCanNaJa4D+AtRXJeWWv3mBKgCCOnb+EonQEY+tSnmnZprTI
	 Fyg0NQj0f7+wGeGBrBf+UoUMLQF0TFQBL+y9C8B1QtyxMyADD7vhyaycw7wbSXfISS
	 S8hxx0MG3osdxm/6hDqgv4ScbiML2j31bJ+NgO8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0370/1005] iommu/vt-d: Fix CACHE_TAG_NESTING_DEVTLB polluting shared variables in flush loop
Date: Wed,  4 Nov 2026 16:01:43 -0500
Message-ID: <20261104211054.451540599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 3846e469c1ba1407260066070bff5c88ee39a4c7 ]

In cache_tag_flush_range(), the CACHE_TAG_NESTING_DEVTLB case modifies the
shared local variables 'addr' and 'mask' before falling through to
CACHE_TAG_DEVTLB. This causes all subsequent CACHE_TAG_DEVTLB entries in
the same loop iteration to incorrectly use the full-range flush parameters
(addr=0, mask=MAX_AGAW_PFN_WIDTH) instead of the precisely calculated PSI
range. This is not the intended behavior, as regular DEVTLB entries should
always perform targeted range-based invalidation.

Fix this by having CACHE_TAG_NESTING_DEVTLB directly call
cache_tag_flush_devtlb_psi() with the full-range constants and break,
instead of modifying shared variables and falling through. This ensures
CACHE_TAG_DEVTLB always uses the original calculated addr and mask for
precise range flush.

This change slightly affects trace_cache_tag_flush_range() behavior.
Previously, after addr/mask were overwritten, the tracepoint could record
a full-range flush even when the caller requested a narrower range.

The tracepoint should reflect caller intent. Although this helper may
widen the actual hardware invalidation range for implementation reasons,
that does not change what the caller requested, so logging the requested
range is the correct behavior.

If the actual invalidation range sent to hardware is needed, it is already
visible via the qi_submit trace event, which records the invalidation
descriptors emitted by the driver.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 385ae5cfb30d4..e6bc730fac3b0 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -468,9 +468,8 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 			 * affected by a change in S2. So just flush the entire
 			 * device cache.
 			 */
-			addr = 0;
-			mask = MAX_AGAW_PFN_WIDTH;
-			fallthrough;
+			cache_tag_flush_devtlb_psi(domain, tag, 0, MAX_AGAW_PFN_WIDTH);
+			break;
 		case CACHE_TAG_DEVTLB:
 			cache_tag_flush_devtlb_psi(domain, tag, addr, mask);
 			break;
-- 
2.53.0



