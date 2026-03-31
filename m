Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A933EF0A2;
	Tue, 31 Mar 2026 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974284; cv=none; b=Lbs58RgShH3/rZTWB9O3hyAZP+x8TsvAE7KzPbmr9/vXM8EVRiHCE3GVX0XZsB63SLG+NxiEqcIEGWEQxY8C6MDprrkBjHXS6Vd6MTLyCDc54ktUnBNYAM+nBK31XgFfueL7z8pE4XcQhcDLqNetM1Z/d7mXZOYRHYvzvHO7Gro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974284; c=relaxed/simple;
	bh=3g+1v8sLiSAftfdSCzvvqYLZGEg//1Gno9uBVgfLgdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=biuPIcOz/n68jbTgskV95rRrsolMzlLsEwXh6kFl3zFwetzopd/07QxHTqqHZWDe+IRyG8itW9DxODUXG8FhKRDMY4E13HN5D+Zfi+2ysqRVd2/jm4BoUWDAU2a0dZ8NZ4ub/ORScefIXCSh5avMdqSCcSUQY+poLPFpqxtJO8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwZ/PZ3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwZ/PZ3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3979C19423;
	Tue, 31 Mar 2026 16:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974284;
	bh=3g+1v8sLiSAftfdSCzvvqYLZGEg//1Gno9uBVgfLgdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwZ/PZ3JoKb/q/gkytakRi6j19nY9E3gEYXBol6f7bj9SrlR5Ru6bZRqqxI7OKeg0
	 2rpxP+DqGm9nD33vAfP5nbH3ukp0nc0V8Y31LL2T73ARv+nENJJK3CkRqK9Xm2GMRu
	 kxB/mqx8gb+78lRsNuTtldVxYa14aAAv1nUGZtyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/175] dma-buf: Include ioctl.h in UAPI header
Date: Tue, 31 Mar 2026 18:20:09 +0200
Message-ID: <20260331161730.707201170@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a6fda66d9adf..e827c9d20c5d3 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -20,6 +20,7 @@
 #ifndef _DMA_BUF_UAPI_H_
 #define _DMA_BUF_UAPI_H_
 
+#include <linux/ioctl.h>
 #include <linux/types.h>
 
 /**
-- 
2.51.0



