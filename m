Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC00225A38;
	Mon, 13 Apr 2026 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097883; cv=none; b=mfRjllqBH9d9k2kSsRV9Dro0dcDU3yZFUMBNIhE23f8OT7UXkVOHp0hRa1OrkIf/pY0tLTUfL1w03V953diucBiLw9iR4yHkKgHqgJgxedQXUFgxcPiovnUxrmjVeG1gHt3ztvNy3co4EdE4WkWOl/hzF28zRqu2K+mFFpUOIt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097883; c=relaxed/simple;
	bh=5BWAwPIIUub5oYzuxeVNSYmEEIYAlZAlNX3XAkEIImA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uFC6LgZfKN7/c1MRn8UabbZBjaqi/iIACqS1MN+QbzJsDoDDxqCvirtx7hD7XacTSLesVeJ4bpIvXkgm0HKnSQcTwZnDpsx9KiBlgiX6ZbSqOfoFQikTsLW8eVLWyuye6PTKJjn6FKx5Yzf3YkOO4f0DI/FxVUzhvl87pA+t70o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZQg0N5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZQg0N5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21697C2BCAF;
	Mon, 13 Apr 2026 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097883;
	bh=5BWAwPIIUub5oYzuxeVNSYmEEIYAlZAlNX3XAkEIImA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZQg0N5a7TswMJU47Hogb2eDNNaL0YB8OHemdb7bp6EF101XMGSOKKDUl76c1V4EL
	 hyryUJ6mza5hugbq7hHDjqFCBOEvfkOX32D8KIY9NBksl7qklGwmRXLcGeqVT3gEhq
	 DoxlhDeK/eYi+nqGjP5Bt0v+KDz+e11A43UjUNeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/570] dma-buf: Include ioctl.h in UAPI header
Date: Mon, 13 Apr 2026 17:57:21 +0200
Message-ID: <20260413155842.110078152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b1523cb8ab307..5e2b1949ffd49 100644
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



