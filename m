Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF17F33120E;
	Tue, 31 Mar 2026 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975757; cv=none; b=RgteK8Otxk1EZwRz9+Ci1bZo+uElTl8/RrkgiYLLCwJq7+5Exmnh5iXuZU3URJ2AZYYkl3hGm+JL+3lUiYkyxQCB7gPxIiKM5QA1TMr3vAcwbd7Ouqp2v/N5q4bebQ/JzAAiecb9nziPsDu0NwIV6ma3e/llTrkwWn53QzwFteA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975757; c=relaxed/simple;
	bh=NUXTR2GRk9hxI1lZaYa4e85lO/Yb25g43j/fLunu17E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfAHPvKQQnP6xVd9Rj7sWXV7mFaKz4+MIQDSP0QO6kSaqskOUThLH9mctZZbLdhfdOgTGCjbyREL+r2tMIAsWzBzLIroNCQmh/SIfnloKY6jyrbbR67fPA33Bwcd+wXGXYxoXDlN13q7DaScmyTnn8+XZkUggpGAjC4bsLjdtOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQGhnUla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQGhnUla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345E8C19423;
	Tue, 31 Mar 2026 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975756;
	bh=NUXTR2GRk9hxI1lZaYa4e85lO/Yb25g43j/fLunu17E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQGhnUla3zkf2BbH5oLSuPLdi6MOARjJFMyOUkNrAyx0ksflACRjcWtbZyckl41PB
	 QvLm1wrvkY0XBMioFbQyakQd+KpExHEjvwcJ9HLnrtCpPF8jifmF1TytwjuKdI0TrR
	 ECb+5EaM0G4SjKwciJjkSHekg+duoI3A2eq8dqmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/244] dma-buf: Include ioctl.h in UAPI header
Date: Tue, 31 Mar 2026 18:19:41 +0200
Message-ID: <20260331161742.851760519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



