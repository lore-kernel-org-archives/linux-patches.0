Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064500;
	b=eS4t1zOMCHOtGc+xHNTVqYg8s+iQ1NlZnQ7XIniWnLGrxl2ZIcr0K71Eg1LU2H7EfWxI
	 eG9tgreP8P9Uz3KKzCqsPkdxsJJXNjWFjQb8PSfHkj9LQvjQiog0Us6PblGUWDlisjXVT
	 fNuFSkzzC20FsP/2MiW+2HoU9b0luk9RRyG8ffzo9+i4Fumr857K80BiEfqci6CJ47FFC
	 G3w5QY3QDiUlS5mxXW+5Bm5jR7DsXkCE/8kT0oA6vq6Ijj6pndNFyvRZkacY6MwaPtYMK
	 b/VWKq5i4xyEOKJsxOrNwVbop+jCU+6Au/M0dVe6zg18zdE2IHQ6byex4gJnm9KL6xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qkj64ZhbrahkNcyQX3Gj7qIiWwASDg/UCWAQahhdUzE=;
	b=NxKojwIUM6zSiNz8c3uL6208DkkX7G7SfEIpqy/ZXuxsFZt1Ygz8DBznVD6le/HwlI1x
	 /b2ZHxNtZvEadChhJDmVnsmiloyy0+Wd8QQFtduomGVrmi2DDeVWHu9N84n9NsF9yMZ9w
	 zbQJ9kHXuLeQbXafEdbZek4LWaHnFGAX6GSZO5tsQvuHmhNX3x8nanxLvNZ8Ckl4VgcNK
	 ZiyyXUBN31cOJLacdF8KBUyxFt6j7fWAVq9CxC8D01RIX66b54HoAZCUBE0ClUh14Sv17
	 tWWvTV7OdBNFEQi4ndiEdAbyGRUfamFLiiUoeCkC0cIbnCLtNvgb4//t0T8Mg3Jp71Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXZq86gI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D44606CE44;
	Sat,  7 Nov 2026 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXZq86gI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73C71F008A1;
	Sat,  7 Nov 2026 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064499;
	bh=Qkj64ZhbrahkNcyQX3Gj7qIiWwASDg/UCWAQahhdUzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXZq86gIRa6f4JtpWz77Li8F5TwSm4g+aWPh8MCdr8HXoJW6Bk2xgD0eWo3Pbeuqk
	 eaIhPQvZohEwupgnwrNj/8kUX1kOL+8Pw9wV1F5k6h/Vnt2XrZcsC2UaXjuPvb2pRb
	 Ac23fxKeMH+5jkyyhKdmqn8kact61G9O0HBD9qiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ZW Tang <tangzw515@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0533/1257] ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Sat,  7 Nov 2026 08:47:09 -0500
Message-ID: <20261107134954.128613648@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 6a3ed6b290513859bd27d9fcb67739347d6315fa ]

A hard readonly mount skips ocfs2_dlm_init(), so the per-osb lock
resources are never initialized and osb->cconn stays NULL.  Before commit
550842cc60987 ("ocfs2: fix freeing uninitialized resource on
ocfs2_dlm_shutdown") ocfs2_dismount_volume() only called
ocfs2_dlm_shutdown() when osb->cconn was set.  It now calls it
unconditionally, so unmounting a hard readonly mount drops the osb locks
and takes the never initialized l_lock in ocfs2_mark_lockres_freeing().
With lockdep enabled this triggers:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

ocfs2_drop_lock() and ocfs2_lock_res_free() already skip lock resources
without OCFS2_LOCK_INITIALIZED.  Add the same check to
ocfs2_mark_lockres_freeing(), which is reachable before them through
ocfs2_simple_drop_lockres(), so an uninitialized lockres is never touched.

Link: https://lore.kernel.org/20260903104744.2164235-1-joseph.qi@linux.alibaba.com
Fixes: 550842cc6098 ("ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: ZW Tang <tangzw515@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 54e8f81119fb1..1a83241b6d41f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3527,6 +3527,10 @@ void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
 	struct ocfs2_mask_waiter mw;
 	unsigned long flags, flags2;
 
+	/* We didn't get anywhere near actually using this lockres. */
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
+		return;
+
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
-- 
2.53.0



