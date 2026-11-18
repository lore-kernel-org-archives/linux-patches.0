Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022603;
	b=v7dfjbTi9y5PoMCmj+Rp8vBi3nSV4ur/RXZXUX8PT/zCeu4tTE7dTaaUpSJIy+S1e/B/
	 B+PxF/OkDAIfLBNXikrnZfc13xmPeqoEpYBLJ3j1GhMRR/nT9G5jsoDCtDjCtFWqcTtET
	 JaUGSBG8LcgsXdit1xoFfU5dKk+8TrLWXFuvQyxGbdPT78BbaqhMby1fE736ItOvhIloz
	 h/2ljjWFVaj9S5aaUc6wJ9DunWtywEEiV6mwVrShn8eVbTO3lzXFQ/OePAIbi2N5w8zg6
	 6upuM/4VTMGre5nmkQK8Kem6MmhLXvh4iZB/xaIKoaHFJPouaPeKGu4WKAjKln0AK8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=phUzpTK/7EUfD2CeZQNhSScTdk6dMD8uAuF3dw7ZEyM=;
	b=oHABWyCDrLCmHZoeERugMZ2bhFHe1d/OFkSjn0TWVtwxYgilVNNdH2CYUeVBVdqYd1Pp
	 IYnUEHegR8XfbFYwCNSDSl4xGXQIK9Br1VgWy0Tm4XrU3g2t9EkQrYHbj0HSZN9pEn3hG
	 8e5WkhUd30bWGv0U4EN8S4JzCLYKnq+MdHIADk5+vHThbete4KsTZpU9qyRJQbsNla86+
	 cRP80bBjVPUpZ/wxPl0M9QSLQzlWkKLRRnc3/I6oPy5uLhYeHz+w19sUrH5Ee8UuYs8Kj
	 hYI0EmBYpudWg8GIZfHgQc9v9m3lNWESY0zYmG6xvIm2pwEDC7lToUJD4sS0aT3DbYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIRBAONQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F494606A32A;
	Wed, 18 Nov 2026 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIRBAONQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6391F000C4;
	Wed, 18 Nov 2026 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022603;
	bh=phUzpTK/7EUfD2CeZQNhSScTdk6dMD8uAuF3dw7ZEyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIRBAONQ1SojbO6ub9GvD7Uo6n8AjMwNHtQjn1u+S9YLx4NohFHVaUvujkvE8LpPd
	 kYBJwiO5wmO/8DjedBhGlz8xFAuj8Fq8FgLxeU8jUN2cB/WbHVY6FJn1dApBAVYQ1g
	 8izVJtAnjk4x6VpxczFx6TMPbI/FqUAHr1znQnNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0072/2151] ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
Date: Wed, 18 Nov 2026 15:30:07 +0100
Message-ID: <20261118150124.385749657@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 41a5e8777093f7946fade3737363ef045303b8dc ]

In 'ocfs2_ioctl_move_extents()', add extra check whether only actually
supported flags are passed via 'ioctl(..., OCFS2_IOC_MOVE_EXT, ...)',
and reject anything beyond OCFS2_MOVE_EXT_FL_AUTO_DEFRAG and
OCFS2_MOVE_EXT_FL_PART_DEFRAG with -EINVAL. In particular,
OCFS2_MOVE_EXT_FL_COMPLETE may be set by the kernel only and
should never be passed from userspace.

Link: https://lkml.kernel.org/r/20251009102349.181126-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 84db6619cb70 ("ocfs2: validate move extents against a stable EOF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/move_extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 831c6c648f04f..f599978cbb9b1 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -1044,6 +1044,12 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 	if (range.me_threshold > i_size_read(inode))
 		range.me_threshold = i_size_read(inode);
 
+	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
+			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
+		status = -EINVAL;
+		goto out_free;
+	}
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
 
-- 
2.53.0



