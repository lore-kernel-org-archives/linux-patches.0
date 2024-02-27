Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023B01420A0;
	Tue, 27 Feb 2024 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042837; cv=none; b=jrODIgXTPtYWoquaIK2pXqWlb70i8ObbKL4ZCZs6CJbfNG3qRewIXx4W3rXtPyhikJ6ZTlagoLjvAu9s6m694WkKtthAe21HxyB4/PzKfMNM9fjeI1iChg/GqOsmU0ezYqjyFBBQEwz41xkXhUcHMvugbJ91KN0+Abtoxmagzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042837; c=relaxed/simple;
	bh=kZuSCc0vVHxex4N9w0ym1VtNZPF5zV73wq9UUEihInI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1sdHfckSiQxi4V0mpR+n+NuZwYveV+1B7PKJZcJkId5G9uC9aLeUQ6nDjVnZd/yRlLiXjL3sgHZp7wXCWm7tMuVhHtvwf23f6Z12e+KlXiWubl+4GugB1OeiceZcYe90DNE6xky0K4tY0DkZ+Vp80psWcGJ8/ycVZ1Agf3+Ocw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCUHq+J0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCUHq+J0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF53C433C7;
	Tue, 27 Feb 2024 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042836;
	bh=kZuSCc0vVHxex4N9w0ym1VtNZPF5zV73wq9UUEihInI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCUHq+J087ZCfh+JWvXxilt5T7JTP1TdAK0eacjzgs/fnokhwuWBS07aH3yE29ZSn
	 0vLaVhH7iZEDRx3ZheDjqyB2VQCYBkVXFrgERQmKUK5ytyy6sbeQDMK+XAE1+ErAJ2
	 HdYytw/JGxQQ8Uc2q81/ZeZTEuWFCaY2CF1feuRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/245] tools/virtio: fix build
Date: Tue, 27 Feb 2024 14:25:27 +0100
Message-ID: <20240227131619.727190778@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit d650f830f38b19039958f3f4504ceeb2b5922da7 ]

Fix the build caused by the following changes:
- phys_addr_t is now defined in tools/include/linux/types.h
- dev_warn_once() is used in drivers/virtio/virtio_ring.c
- linux/uio.h included by vringh.h use INT_MAX defined in limits.h

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20220705072249.7867-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/linux/kernel.h | 2 +-
 tools/virtio/linux/vringh.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index a4beb719d2174..8b877167933d1 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -30,7 +30,6 @@
 #define READ                    0
 #define WRITE                   1
 
-typedef unsigned long long phys_addr_t;
 typedef unsigned long long dma_addr_t;
 typedef size_t __kernel_size_t;
 typedef unsigned int __wsum;
@@ -137,6 +136,7 @@ static inline void *krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t
 #endif
 #define dev_err(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
 #define dev_warn(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#define dev_warn_once(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
 
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/tools/virtio/linux/vringh.h b/tools/virtio/linux/vringh.h
index 9348957be56e4..e11c6aece7341 100644
--- a/tools/virtio/linux/vringh.h
+++ b/tools/virtio/linux/vringh.h
@@ -1 +1,2 @@
+#include <limits.h>
 #include "../../../include/linux/vringh.h"
-- 
2.43.0



