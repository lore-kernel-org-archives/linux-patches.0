Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705440;
	b=xVRJeMl+0i2UFWOeL9kDTRnce9IvgHA+Bvn9yXuoxLhfknwM9z8zLvTJVKEUweBxZjaz
	 LDSuKappqbnpGZCDF1GNnSK6aT8iWd2pAgm/t6kMMuFW289y8sYxV+0PGWKM2qFZ3PYgi
	 /rIP2YzGHh3/KkjuNvBI2HurKWalGwTG/wIrehtpkyhY/MaN8PdPgvbfBzIIuIC2eaJ0n
	 /BqRSdkUAKdyhh6exTb0UuzjJZgyufMpnuO5cEk/kknalLfLJ8kSceuflFj0L+2lHIsEr
	 6pweM79sL+ou4vXMXXDwlC/WZuoXiM+MyWyuk0iH+Sn4UQ6bLOOHEF3fpU0dOKdB6Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i4xceH+qRnGHcBatBi9cNcSzmeEk2q91U3LfHkp/p9U=;
	b=yYBKuAlpue3/dsvy/PtqnfKM+EpySoy1PKmA+fJpsmfk9YniDgeOhbK+g404NY5Ofm65
	 KrgyoclkGRkeFD2RvxXsvqrbptSC5NZAMiQosw5Id/OuFMQUL32D662FmYXeTlXyANGB6
	 Bh8DK0KS0IesIGnpTWelXh9M+L7gqMJAM2O3drn4rr0P1f6OJwLJI5yoWRg/hnZ/AJWn+
	 FKUb56yDAVTIny97oNUrixpZivZfF80QDWoAnFssJ0fxg9f6+xwR8rLPNW3GTG4h9YqHo
	 TV+57Pr7OayTr3q56AbE4oxsXsqwD3BILzIh6EYPUqkDTtR7jdgig/lw2VZWLplNz2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qckl9aWd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FCD606A321;
	Thu, 26 Nov 2026 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qckl9aWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E371F000EB;
	Thu, 26 Nov 2026 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705439;
	bh=i4xceH+qRnGHcBatBi9cNcSzmeEk2q91U3LfHkp/p9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qckl9aWd3B0LgE7mG3GHHWHnwZN7tWFoE4PptrIpCGeBTRO8vgrpGK+e8ekWWpvK2
	 frT0cwje9vnwBr/HRr0hMtWppBAj6NeYPs3NO59h2aJCrvNa2jw/JOQ7263JW6W0+c
	 GusfOQyAxi+huhaSjeRktwEa0tPcqv6kRuCzUxwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <liuwe@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.15 199/319] hv_netvsc: Stop PPI parsing on invalid metadata
Date: Thu, 26 Nov 2026 15:39:27 +0100
Message-ID: <20261126144011.236762216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -411,12 +411,12 @@ static inline void *rndis_get_ppi(struct
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
@@ -424,7 +424,7 @@ static inline void *rndis_get_ppi(struct
 			if (ppi->size - ppi->ppi_offset < ppi_size) {
 				netdev_err(ndev, "Invalid ppi: size %u ppi_offset %u\n",
 					   ppi->size, ppi->ppi_offset);
-				continue;
+				return NULL;
 			}
 			return (void *)((ulong)ppi + ppi->ppi_offset);
 		}


