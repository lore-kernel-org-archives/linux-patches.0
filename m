Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621542;
	b=ihhYiPnw9DxJCM/HXHgWGYTAS3ijN1KupEz+tLBXfgJYCQEhl8+ny91lRayH65NH/1K1
	 DHCLkZ+lOy6bDfjGFGewnKebZmzwyS7kdQ//n5QboPevghWdu17xU63ru6IaLnY2WQs8q
	 YFX3oufFugeKWi5CWIdxYjm2Sk+BSgOzaxcaxfPlAm1gfrvBsjFXgo+ixKJka1EeJPOml
	 M2SBL4+2Moiv6zs0WbX7nkJRvnL3GfkDEiDQfhDx8Q/beQCvEMZNDovSmsaxjC2Bw0yEP
	 v15w/dNpZv3IqPlOslAYZ+WX6lKQyaRAToS2AllOnIowOnbMTVC9GpzT+og8A0X3M6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3shThsceBe7Iw8NDFXPehC20EKD/l4UV/l+VQ9ZKMY=;
	b=qUFlSP3hTM2FUc0HVXqNNSsvmJmrs72g9x2D1GnFcEowmdPbbzAHM0GYsikxC8CqvhJB
	 68iwziU4gzxL0NBrcf/i8VGnrhXejFA99sWYD++yMlvXMX0MJwIKzwUOYpWVNAaFPlwjj
	 xRFulWVTBOJW7bdjgzhXel5+LS61Wxwn4TIe5K8lJwdUlIK0tm4JhasQGS9qHWIPNiFM9
	 rITddMlJN57fUvZ1fOg4TjDHjoScoNIp2ypifigLqmeqCsHI/KlZ+NN8kcCML1HmgZvRT
	 K5GTRnwF7TWot0mcspdaL0nxbbhYwtVhvAY4nixB0d1+leoFlUnoWpo7TY6CtABdEsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMVroDzr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E01606A31E;
	Wed, 25 Nov 2026 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMVroDzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF2B1F000C0;
	Wed, 25 Nov 2026 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621541;
	bh=Q3shThsceBe7Iw8NDFXPehC20EKD/l4UV/l+VQ9ZKMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMVroDzrsuAnLrwCB4nqksFW9dG79W+ylTOV8rK+0XAHBa5t4xH1OF8/jmx+T9opf
	 QGmQxLKFxYORq9Epf/zRBduO8psiiklQslF0adRLG8AdKRb+0GMI8ZDlHJTFsFpkt4
	 n/wA0lnsm7k2qTfcAPpF3MtgEn7NKSdBtqFA3mVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/990] block: convert nr_requests to unsigned int
Date: Wed, 25 Nov 2026 15:26:19 +0100
Message-ID: <20261125143827.057095665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 9fc7900b14727d39457bd3724f26e6e3faca3efd ]

This value represents the number of requests for elevator tags, or drivers
tags if elevator is none. The max value for elevator tags is 2048, and
in drivers at most 16 bits is used for tag.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3a9892bca4dd ("blk-mq: reset queue state on scheduler teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0299d62886ed1..5d073a96324aa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -545,7 +545,7 @@ struct request_queue {
 	/*
 	 * queue settings
 	 */
-	unsigned long		nr_requests;	/* Max # of requests */
+	unsigned int		nr_requests;	/* Max # of requests */
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct blk_crypto_profile *crypto_profile;
-- 
2.53.0



