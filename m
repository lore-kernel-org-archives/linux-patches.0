Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400553D47A5;
	Wed,  8 Apr 2026 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671727; cv=none; b=s/wpnG0n8+ZZAdLTz90NUB2Jbv3Rhng+CN8PxjKTq1AiUM3mIfO4TYwDAiU0w6glScXL6b1gRhC8K47Cbb+sqtuRwgJH6qV7w5NwRPev5JZWLSCPuyUzSOMFUkigLmERjrBYpFuBiP5V6JY1qZ+7jBvkLnqjTb0+ljUkrk0RTRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671727; c=relaxed/simple;
	bh=cOj3HOIhVtSkZrKg3nRCWxkUp0cFBbwlbhU+kKj2OXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSce6+ogbO9aItPovNVvVXy/N0D+YLVBCWnq54NicqssQRm6YL8B3xJJYzxOWc+X8wNr208kc2Zxq+amaxjac3DpBJw+WlpTikkdgJtPsWPj9DM1X2JN7KTMyRbc0LK2nm0IMozmugo3oDxhuwQw3o7XkiL7ry8cxciLmij84Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWmlRc+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWmlRc+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C943AC19421;
	Wed,  8 Apr 2026 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671727;
	bh=cOj3HOIhVtSkZrKg3nRCWxkUp0cFBbwlbhU+kKj2OXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWmlRc+ol7ClU3H8p1k0Rp3XY8o984gPimrDZjS1ixDfE1bL6zy6ejwHMqrOyg9hz
	 2pdWOH5Td33cm5VZIMN9FSL6Ta7Ea+Wrphgm08vY+fUWukLsAQJtDvQFIkOsETOFmo
	 CStD5YYVrReMrW2L35N2jO/+AGlDAXvEHex7/fgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/312] dma-buf: Include ioctl.h in UAPI header
Date: Wed,  8 Apr 2026 19:58:54 +0200
Message-ID: <20260408175934.374791285@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



