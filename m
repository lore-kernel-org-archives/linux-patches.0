Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023673;
	b=hp47z4FAG+M7l75PpqLdig1en+fdKbAshkeD2BMSF4E/gmD4T3gUAf43H9Jm7dXHvWBq
	 0iK1vcMExXiGaOCfCdsJwr0a333hSqnkBFLI7MVLZOFnz0fLKMtHGKGzMWKxYrNOMNKTp
	 AOQt0Zit97dkIB4RjRI1pjrR6fC781d99e7GiAjzh7KYqfhprZhQiGKglG3CxlXllM9I1
	 II+plABnRZuS0vbvsMiwKtkmnlxvLFmO/UeNuS/hFLmZlESx9cY5aSwLZmAFtK9Nv/4p2
	 WQrNvkQzoNVARgglAaJaHS9kkaTQAzpAp32lbZlHU4oefuLH81JhMacuujFg+iXvrLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=maeVynRrN8pSLIzPbNJ9Q6/EK8trBTKQyI7pDXo1ICc=;
	b=hxhpvyvwLToAUXZT15X5k3Pukf7GnYF4Yjo5w2XhRt4GwB+d8sZ5X8xD4nS7sgRHkMp+
	 KPKy576zoRKdP8vGj7CWJDz2TEPTLm6ODqvStuqyHY73OXL9ONnBXZhAtwXUA4kqNJhst
	 VgRpNkTlqxsbjsTGNctjeQxOVtIYa4o8Vw1mPU/e8ESrSc+L/LzGAHTfykOuIMM/xvqkK
	 +AyuGaPci0wEeaVhb8ogTu3qcUQ0CKuResRp7Z0p5F3O0pRLxLuUS0CkMj8ze34Vl6F74
	 5fbwspR5sxBaUQazfhkFI4+/9dP7gFL2XTYJSkd6sT0v0SwNSFnQkVguvjyQWmoNWBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCpR1Rvt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B0F606A320;
	Wed, 18 Nov 2026 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCpR1Rvt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB8B1F000C7;
	Wed, 18 Nov 2026 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023673;
	bh=maeVynRrN8pSLIzPbNJ9Q6/EK8trBTKQyI7pDXo1ICc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCpR1RvtpMbOLD31lcSn6rrHLl8sgPJI58hyCYpM4KRBq0qEmZ9wqWLS4lVdezpGp
	 cZNE32bVNUI16WUapTE4xfMm5EGed1v5Tpc+B+5YL/IEXYuMpje9L++ckHMGlcVzoG
	 e8jtgqV+HJ8V5MUCTaE28Mm60I4VmDG6pLpKIMj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0453/2151] block: Fix the thaw_bdev reference in bdev_freeze() kernel-doc
Date: Wed, 18 Nov 2026 15:36:28 +0100
Message-ID: <20261118150138.531018948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit e14c3379be86854c203de1e0fdfdeaa0b45509df ]

The kernel-doc comment of bdev_freeze() refers to thaw_bdev, which was
renamed to bdev_thaw by commit 982c3b305843 ("bdev: rename freeze and
thaw helpers"). Say bdev_thaw.

Fixes: 982c3b305843 ("bdev: rename freeze and thaw helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260911233415.31271-1-kmehltretter@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 00345746e34f8..3acf3e9d33739 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -277,7 +277,7 @@ EXPORT_SYMBOL(sync_blockdev_range);
  * The reference counter (bd_fsfreeze_count) guarantees that only the last
  * unfreeze process can unfreeze the frozen filesystem actually when multiple
  * freeze requests arrive simultaneously. It counts up in bdev_freeze() and
- * count down in bdev_thaw(). When it becomes 0, thaw_bdev() will unfreeze
+ * count down in bdev_thaw(). When it becomes 0, bdev_thaw() will unfreeze
  * actually.
  *
  * Return: On success zero is returned, negative error code on failure.
-- 
2.53.0



