Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3751318EC1;
	Mon, 13 Apr 2026 16:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099209; cv=none; b=evhySr84FnSBkm55rOTM6vv0MCVI/24Soh8629Yer9Gc5WuwHzjWaURdi5HPr1bwFWyNMhkUCTvAtHRYIJZ92xt7hhqSTemClKsHgMKgnT1WwH8u09ipyw1kf8V+y9m1uf5w/SNKWmcAqGd8s0W4y187B3cs0JsyRjvBOqegcPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099209; c=relaxed/simple;
	bh=haD43vye1OtTwXzTHhi1nJ+JO5dVJL9bwyDPOISza6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrhdqmOqkCzNFhVYI4PBRq6NVSiN1hOIASUzTlkDZ+k/IGGgi/WfS6UPPnrC7XAhwYLnW469zweicuktGQmUxnn8IBV2fAROmE+L8x8Dp11kesD1csqMLBdw4RerR3sK8pxogDD94hq54wgVOhXruWtPada+klPB3iEzCcANXt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoMadhP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoMadhP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6089FC2BCAF;
	Mon, 13 Apr 2026 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099209;
	bh=haD43vye1OtTwXzTHhi1nJ+JO5dVJL9bwyDPOISza6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoMadhP9uu05YUy43zBigaMIuxsKrUWigY24khl0i7+yAy6p/Eqo1XWh69hXRvArc
	 XbmTLoOPQkWo4a8Jcn+kKqKyunmqHUMEZO1pJiLa5ufanLH/qPogLzygidQzhZbe/R
	 92RGK6/P4lzhDlAIchZq+4MWh+4tL4WFSvDQOIko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/491] dma-buf: Include ioctl.h in UAPI header
Date: Mon, 13 Apr 2026 17:58:10 +0200
Message-ID: <20260413155828.229183867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac J. Manjarres <isaacmanjarres@google.com>

[ Upstream commit a116bac87118903925108e57781bbfc7a7eea27b ]

include/uapi/linux/dma-buf.h uses several macros from ioctl.h to define
its ioctl commands. However, it does not include ioctl.h itself. So,
if userspace source code tries to include the dma-buf.h file without
including ioctl.h, it can result in build failures.

Therefore, include ioctl.h in the dma-buf UAPI header.

Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260303002309.1401849-1-isaacmanjarres@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/dma-buf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index f76d11725c6c6..dd9fa80184f3e 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -20,6 +20,7 @@
 #ifndef _DMA_BUF_UAPI_H_
 #define _DMA_BUF_UAPI_H_
 
+#include <linux/ioctl.h>
 #include <linux/types.h>
 
 /* begin/end dma-buf functions used for userspace mmap. */
-- 
2.51.0



