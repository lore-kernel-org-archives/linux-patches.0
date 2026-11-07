Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065080;
	b=tj+MPv/0v+QG/VpjXbeY9/NelmWDeXIDszEGt3i5/mGlNKsdvaP+qH6R6vJ4XiqAbWYi
	 6hbrdt8RCmluLEha+zI9YBKF9HyW7vENix9GzGpVSdyxWRZInIkrR7eGQNRSXLAanjVib
	 VlMGQk7nHxkgWAcRmWHS0tvjuc/tNLg7zbWZqqNoOEew5vOtzXm/SFADaTzh3bGNo6IS4
	 Tj6R0bQnKXyZm22qrZB3+5cJFfpp/7wbrnQxEgz+YwaJHDrd1O/imoP87Fz6SKfb1xr61
	 Ho0S6FuTeaBqTAFyZVF9GnHRL+8R/EgHokrJ01tS4+3pZb5w2XuDwZWArTc08F6PFmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PiiqmkI3mKROP0grBt2aRysLU2KYZFp7BQWvmATFND4=;
	b=QDGpogyIkLnipXdwudRgoiuLQdt3uHu4BnY1xbGlM4BDuCrkjMAckymI6bh6pzc6e9Wu
	 9LDCmE1RkMfuWZox4Cqy1piq4Sk+X0KPZO310d+kxMDlKBPqagCORBbygxgSmQOW76/tX
	 nbiSL7n6Ma/XzwRemO07w1hoem4+rYZVsXkLdhT8Q0+A6c0plYEoTTdr+zzbh/WvwgAzw
	 3M9T13G1I3hmqBCNrAaNFe8U4tLHAOZgFQbK3Qy6BtZQOSkqUSrJC6TnoIv0K1LfVlj6R
	 S+ICeImwmtAOtOSaQ+4wwMbUXHUYmawO4822KVLSufh2Qt4oOUHIJ0cK6268qwAhhPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ql0W4v7J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC92606A326;
	Sat,  7 Nov 2026 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ql0W4v7J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F201D1F0089F;
	Sat,  7 Nov 2026 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065080;
	bh=PiiqmkI3mKROP0grBt2aRysLU2KYZFp7BQWvmATFND4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ql0W4v7JMleifH24whY09Yr2YJ4EbgCtyNYBgeuP8RNNmJXiHafb8XqfMGw2ZCPvW
	 WSJBMq/D6p4kKf/wSNN8ZKUGehTTgL4O4MQ193WLCN7173iYjQOmuzB0g6CjCoHtnC
	 KDnllYOvgeTuALB8U+QhFhiCku6aGu55730GP0Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0916/1257] ntfs: use fatal_signal_pending() for fallocate interruption checks
Date: Sat,  7 Nov 2026 08:53:32 -0500
Message-ID: <20261107135004.647373573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 338abaf0dc9230a6627de1a532b7fea5f13623eb ]

The fallocate implementation uses signal checks to let a long allocation
loop abort early.  However, signal_pending() also returns true for
TIF_NOTIFY_SIGNAL, which io_uring uses to deliver task_work completions
to the submitting task.

generic/616 is an io_uring fsx soak test that issues fsx-style
read/write requests through io_uring and calls fallocate() directly in
between.  A pending io_uring task_work notification can therefore make
signal_pending() true inside ntfs_attr_fallocate() even though no real
signal was delivered.

That caused the previous signal-interruption patch to return -EINTR for
an io_uring notification, which fsx treats as a fatal failure.  Switch
both checks to fatal_signal_pending() so only fatal signals interrupt
the allocation loop.  A real fatal signal still returns -EINTR, and any
other error still takes precedence.

Fixes: 4dc8f4ee2d46 ("ntfs: handle signal interruption in fallocate")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index c949ff7650759..c7c09a751c6a4 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5855,7 +5855,7 @@ int ntfs_attr_fallocate(struct ntfs_inode *ni, loff_t start, loff_t byte_len, bo
 						goto out;
 				}
 
-				if (signal_pending(current))
+				if (fatal_signal_pending(current))
 					goto signal_out;
 
 				vcn += alloc_cnt;
@@ -5876,7 +5876,7 @@ int ntfs_attr_fallocate(struct ntfs_inode *ni, loff_t start, loff_t byte_len, bo
 					    try_alloc_cnt, &balloc, false, false);
 		up_write(&ni->runlist.lock);
 		mutex_unlock(&ni->mrec_lock);
-		if (err || signal_pending(current))
+		if (err || fatal_signal_pending(current))
 			goto signal_out;
 
 		vcn += alloc_cnt;
-- 
2.53.0



