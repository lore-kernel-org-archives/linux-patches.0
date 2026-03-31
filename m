Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370983E3C5C;
	Tue, 31 Mar 2026 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974861; cv=none; b=e6r+0Tqx3eI3mFxKi2mP6/an+/qm1htv1RnIxYzKXVFookZyTT9D8Zn1iP01IK/qaZsqOLapIgYtI5aIyNQqhqrXquub/Iu/EypZeL96v9Bfhkhe2cW0HCB612l0fLTO/b+1/PwiuYLJff7s0De2NgigIJICndaqsp1upBNfg0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974861; c=relaxed/simple;
	bh=SGOZ94CZaZfuxX9Klcna6RHE0JA5fhyKi9+6mkfVAVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lBce2sUHlqjn8PrSJUc489hgE+FaJaNbY68d0g1bWo8nF9x50Dv0MdpHHwJhiHtfwV5emWqVUP7hNRgfXqa4bQmBni1LdoNPJFvKdBOILkvQN+LIjQqyGucG4dLOfCdx4GDXgpq+xN1o4dQiu7A63VCoW1xWQB6fZa+UhBgtGTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOU3uMzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOU3uMzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CEFC19423;
	Tue, 31 Mar 2026 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974861;
	bh=SGOZ94CZaZfuxX9Klcna6RHE0JA5fhyKi9+6mkfVAVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOU3uMzHbX49zOuDGP87n/azXor99MjcT5wmuUKhYOHmIp9aVA9bGDNrxyycqMNmF
	 mKklqpFjd6w2nBkMOwpS/xAP9P777h6rKfHWyeeUa/DcXjaaUgEPwwbdlmsCas7UnZ
	 3cOD5UcT0Qy4sQBygnLvzlr5ni0hAv2ea3jj08hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 055/342] dma-buf: Include ioctl.h in UAPI header
Date: Tue, 31 Mar 2026 18:18:08 +0200
Message-ID: <20260331161800.923097161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



