Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C946C377567;
	Wed, 23 Sep 2026 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172935; cv=none; b=hVSZGe2CjSTet5yk4cY3FKRogTpiwEnWXlQm/zUy5ZyZDEXceoaDYsRT8uYAljfdwQ89HZCkeoUEUYqu9gtcPguobeFXiG5ggcbI90BOvgFxUqdBIPLqAnL9DNdW4iVGxs4x/JXY6PQqbxCepYMnRUeKbDnayKTU39cRtJl9ha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172935; c=relaxed/simple;
	bh=jHbVnmUPFQfacpJVKY5LIcfNadmhp3Nqy3vAJ3LI7s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tI49pZlinSKJix7vFeFcE0zBP7oIrtRPRSlSGWKqiE414bo4GZJ6X/mnoNSED705XBmsVLuKqmQcTZfsWO8CfTF/qMIfglvMtAmodLLwcWsmwk89lzIrlCWSq1OVUNVcKRftO6bsxOLZGVEcJBrnNY+DIC1j49At04QWXLhZnts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2pkBUid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2pkBUid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246381F000FF;
	Wed, 23 Sep 2026 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172934;
	bh=PWZSAgGBZgr6IlxAhDiIaEoTmI2E/ncS3rLtDb+BuRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2pkBUido1QTvKjjUXki4+YdPufA07fO/B3W9vKIsvluUcI4oKQMrILYzwYxAp1uF
	 Sg/q2Qi+lFhtIRAJIn3kAyTnRpDedJhzY2Ag3eqhmPQLl4J/LAHPSL/GfDwJvWICJ+
	 xOlS/Ytx/0ukFi06P9Jc74wZlEeW9Lc5l2VaOEMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 104/438] dma-buf: Make DMABUF_DEBUG default to y on DEBUG_KERNEL kernels
Date: Wed, 23 Sep 2026 16:02:05 +0200
Message-ID: <20260923140647.476063815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 143755bdabaa96776c24f878014608e9cb44f930 ]

Commit 646013f513f3 ("dma-buf: enable DMABUF_DEBUG by default on DEBUG
kernels") changed the default of DMABUF_DEBUG to "y if DEBUG", but no
Kconfig symbol DEBUG exists, so the option has had no default since.

Use DEBUG_KERNEL, the Kconfig symbol for a debug kernel.

Fixes: 646013f513f3 ("dma-buf: enable DMABUF_DEBUG by default on DEBUG kernels")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260907020015.24719-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 7efc0f0d07126..e4f078a326a41 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -43,7 +43,7 @@ config UDMABUF
 config DMABUF_DEBUG
 	bool "DMA-BUF debug checks"
 	depends on DMA_SHARED_BUFFER
-	default y if DEBUG
+	default y if DEBUG_KERNEL
 	help
 	  This option enables additional checks for DMA-BUF importers and
 	  exporters. Specifically it validates that importers do not peek at the
-- 
2.53.0



