Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585370;
	b=fBvIexOhophQ0aC/RyfpBFeGTev6XSiGu8IXffrhdNYKXcktssC3j9T5518jAq32S2bB
	 mKKwZ0TO6UzBvH+yFp2QbgYaclj47rpvhgv72VGrGLXLFlq7ZAUV0DFcwIlJT0VvkObnY
	 aSc3Ib/RcAcCwKlA8y0oxWI9e6OazouF4y/xklh4p9SL//Cy4yOzxG1Rd4NrQc599Cr7N
	 l+mD8aupte/QGHM5UNUlUg4DIdv7x53W9ZBilBfgJCr8KDvZPP4BxIGMVYJGaJscOBX8L
	 MdIZzvpHo2Znnc5+QtLYJjnodxkAWAyaC1u8s0EwERoE2r75ldz/6L3TsoNQxry9Cjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0JIQPo8Uc845ikZZgMzc5H2dnUbVHE7945pkxiuJ+u4=;
	b=HCOTTdszvEI+bybehQCCQfrSDvJtS2HZkoo1kQmmJhqD7xca/gzyZvdrUhWW53nqIF7l
	 kjF/+I5h4S7t4ngYlwo7IMj6Up5TZvXdAVOLDJxWfbleVnWo1E/MbTRb4yXY7Cxm50EzB
	 zHf7ozGZOJ3m+GA/G0TLvsc5Lbtahj3c5AAnt10/EaNA7VgBM828y4ZwZPXUquNn8o2KR
	 jrjN8m4Biufg5XRgBZlBDEjacIcN8EhagG7NtGyOEZ82csDRKa/6PPYtiS2WG/sFn6m2N
	 IyUPv/2oGvMKvUntLmrulULe4kVWSYD+tVGORkB6WcB7PgsYG9AaXMQz1o5AnNsS39Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXNX6eMx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941C4606AE0E;
	Fri, 13 Nov 2026 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXNX6eMx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8C21F000CC;
	Fri, 13 Nov 2026 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585370;
	bh=0JIQPo8Uc845ikZZgMzc5H2dnUbVHE7945pkxiuJ+u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXNX6eMxU1+nEIMT7uFQAhtOARfh+CeCd3LzyseYLww2p7vICDaNVCnHYE/ZFHYeH
	 8H5CliJkjAaEF+vOvEBej9p5KtCcRhHd2/Pq6as4n0lPao28yljicuqLLU+HgFqmnk
	 N7iw+7oy8pSrCqKzh4/vEjaOv9F3ElRiGD6Y8nac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Qi Zhang <marsy12010123@gmail.com>,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 046/507] net/9p/usbg: clear stale request context after abort
Date: Fri, 13 Nov 2026 10:45:50 -0500
Message-ID: <20261113153755.115896063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit b58943dd690eb9b76c652e735789937a03f3d30c ]

usb9pfs_clear_tx() serializes access to the active TX request with
usb9pfs->lock, but leaves in_req->context pointing at the request after
p9_client_cb() drops the transport reference.  A later teardown path can
therefore retrieve the same request after it has been freed:

  CPU 0 (p9_usbg_close)        CPU 1 (usb9pfs_disable)
  lock(usb9pfs->lock)
  req = in_req->context
  p9_client_cb(client, req)
    p9_req_put(client, req)
  unlock(usb9pfs->lock)
  request reaches zero refs
    kmem_cache_free(req)
                                lock(usb9pfs->lock)
                                req = in_req->context
                                read req->t_err

The lock orders the two callbacks, but cannot protect a pointer that
remains published after its reference has been released.  KASAN reported:

  BUG: KASAN: slab-use-after-free in usb9pfs_clear_tx+0x166/0x1b0
  Read of size 4 at addr ffff88810e7420f4 by task poc/94
  Call Trace:
   usb9pfs_clear_tx+0x166/0x1b0
   usb9pfs_disable+0x1d/0x30
   reset_config+0x9d/0x200
   __composite_disconnect+0xa7/0x140
  Allocated by task 93:
   kmem_cache_alloc_noprof+0x141/0x370
   p9_tag_alloc+0x8f/0x5b0
   p9_client_prepare_req+0xff/0x350
   p9_client_rpc+0x1a5/0xac0
  Freed by task 0:
   slab_free_after_rcu_debug+0xa6/0x1e0
   rcu_core+0x50a/0x1850
  Last potentially related work creation:
   kmem_cache_free+0x1db/0x3d0
   p9_req_put+0x164/0x1f0
   usb9pfs_clear_tx+0x120/0x1b0
   p9_usbg_close+0x7e/0x150

Clear in_req->context after the callback while still holding the lock.
This matches the consume-and-clear pattern in usb9pfs_tx_complete(), so
subsequent teardown calls return without touching the released request.
The existing callback and error ordering remain unchanged.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Qi Zhang <marsy12010123@gmail.com>
Message-ID: <20260802152148.810390-1-marsy12010123@gmail.com>
Acked-by: Michael Grzeschik <mgr@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index 884d6f4af50c0..f2619e8465d23 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -439,6 +439,7 @@ static void usb9pfs_clear_tx(struct f_usb9pfs *usb9pfs)
 		req->t_err = -ECONNRESET;
 
 	p9_client_cb(usb9pfs->client, req, REQ_STATUS_ERROR);
+	usb9pfs->in_req->context = NULL;
 }
 
 static void p9_usbg_close(struct p9_client *client)
-- 
2.53.0



