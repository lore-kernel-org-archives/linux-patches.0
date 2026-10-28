Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215310;
	b=dLkwpsQIAM4/gqCxYgB3SYGL0As65c9seRWE3Yp9tqwqvpU3s/WuKQC9YGxDBVH+1aWU
	 iykm4a/ePnTDEmBe5m9HlNzhKi6WI3mTiS+iYuDB9tRWEUOxXUf3tFo1HqSudlRxx5xCN
	 NQNj1RNkoC3JizFxeCZpZa00Vc4wrpWVNqoTnZiPkdptsE76bCGEOwc+GI/4MJr2oR2dr
	 cFZfxWa5cV+WYdZ2roPlGTZO8LJK7iuHV3WlWFZUGiPpL9G8fAW1/RRU5zNvR7oaLq0yX
	 7xP/1Eaq7NQrrJCfpcrTfpS2l4gXhLx6fNFfW2v2pbZ7P+8fAxg+SFE6vn04XTtDE/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TGQH1ij78B7e3phM5uNJpmNzyYa1wzcPTtEsir0BcgQ=;
	b=QcgyVw3XcGn5q5iYa2DrpQUuO++einaUk/Up9zNoiqJssonusjprL99oWdW2ZwkaDZw7
	 91Wh+e1+B1ou/xG+/2bTgigo9Yqi+yO8Q7tHRL7x2AibPoo7QFB5P2ZPKIuViEBYJEIQD
	 Vaz5WsKARqYRPIk5VCQGLVCfHF18b0eavugKbqWvEumyL/Bl46lG7UGK6QFK5T96cMBAo
	 KtBOcqu/H1e5I3SjBbArJ5iPlrUyBxe43mbx3fh/vHDPINp0wyD9HMifzVBf4y8pL1kBh
	 hL6zsVCexLvPy6p9L5SUDDnDqO6ol8UU4WpF/JgyPEKQV5FRK5mtxqLt2+os6EnWWYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHVZaQ9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3726606A31D;
	Wed, 28 Oct 2026 19:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHVZaQ9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E59E1F01828;
	Wed, 28 Oct 2026 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215309;
	bh=TGQH1ij78B7e3phM5uNJpmNzyYa1wzcPTtEsir0BcgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHVZaQ9xsR4yle0Cx/vjdpXtBWbvmbyXkDiZUgwT8Cxf0Zr47fBkiWcUzABgP3HVX
	 sH7tncb9dYqWAcE7bVraJWUWaTfom3SreTdfRcL2Prcsj6HwCakTxug22EfPbNHMyY
	 XLbTLpihBpI2cns2mGf5p68ZkN+sccM4jFyXOKgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1165/1887] media: vivid: fix cleanup bugs in vivid_init()
Date: Wed, 28 Oct 2026 17:54:21 +0100
Message-ID: <20261028170525.914419936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a07c179a92e949172ca52f6d4a13202ea88cd4b7 ]

When platform_device_register() fails in vivid_init(), the embedded
struct device in vivid_pdev has already been initialized by
device_initialize(), but the failure path jumps to free_output_strings
without dropping the device reference for the current platform device:

  vivid_init()
    -> platform_device_register(&vivid_pdev)
       -> device_initialize(&vivid_pdev.dev)
       -> setup_pdev_dma_masks(&vivid_pdev)
       -> platform_device_add(&vivid_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before jumping to the common
cleanup path.

Also, the unreg_driver label incorrectly calls
platform_driver_register() instead of platform_driver_unregister(),
which breaks cleanup when workqueue creation fails after successful
driver registration. Fix that as well.

The reference leak was identified by a static analysis tool I developed
and confirmed by manual review. The incorrect cleanup call was found
during code inspection.

Fixes: f46d740fb0258 ("[media] vivid: turn this into a platform_device")
Fixes: d7c969f37515d ("media: vivid: Add 'Is Connected To' menu controls")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index f28440e6c9f89..c8fe0a6a86cba 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -2163,8 +2163,10 @@ static int __init vivid_init(void)
 	int ret;
 
 	ret = platform_device_register(&vivid_pdev);
-	if (ret)
+	if (ret) {
+		platform_device_put(&vivid_pdev);
 		return ret;
+	}
 
 	ret = platform_driver_register(&vivid_pdrv);
 	if (ret)
-- 
2.53.0



