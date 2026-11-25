Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624599;
	b=vqMltHWKtaElRXzIkkMKzGmOER91lRzvfphUNG2YPt9CmmsoOzJphT62t2BNaWu/+ajJ
	 PzHrJ3Tv1WUh1604npvXtHEyggcLARQ6EUVwry4Ctg5aYFz1DUkafxKiF3GY2UB9ygDLq
	 V8uE840d5Z1gdb2d4ZN9e86o1lLE9eG3WoGwDmhIGe6pNJAoRcFUEHKWk746C0+MOses6
	 m60T1VMtE4ECfZ2EcOFZTumeTSyETnIv0KHjf2yxEzN+5oYARR7Cm7KzhlsNT9CbwkDlg
	 3Q2l7vW59QsCvIUeSiQOYQ0uaPOVoTdWlEc/FMml3wTLYTYsQ0+nuobsaQ6w3IKn9dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YCg5pdys6a0oOdu81islD7yILICT0GWnexVsle0He6g=;
	b=qCX0b2UTrphbUwlHkYZETd+VyD/+wp3VhRfs5J7ikppm0b50YSfLhPBCxZlysdmZufAF
	 DvWA8oZKGiTjYm5DBDQPTYddqM/c9GICMwdnJ/aiZnDXDm3XBpbGLjHBsg5i9tN/xzRBn
	 IxtJ++1J/9hd3IyUJ84IvZBRWFM6YBxcS1tQH2gLQcP2/7V/WmMTs1TrS4WbjxB71neIN
	 wXri7d3sAoU+i7Pbsh3HlWHBaYURtRAovteLPD8CUZkZV++JyQQupXRxOMXNrY3eaRdzw
	 0JZNBCzjDm/z/MkP/7hrazaGdoc+QdZOt3AMEk7IxGLQ39GcpPSvZh7gxl5UpnJPkQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/pdDHfS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28658606A339;
	Wed, 25 Nov 2026 16:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/pdDHfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1431F000C6;
	Wed, 25 Nov 2026 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624598;
	bh=YCg5pdys6a0oOdu81islD7yILICT0GWnexVsle0He6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/pdDHfSYlDlRtcPcj6QLUXvrbT66JsBYuv5exhNKYagr/KsD0WUToQf1353FWkGU
	 ONFKtCIcQRLDdc0+dWoJbcuLVBf+8dZQROsSCE+ekQApfi6SbUGYf0jg50aLG1dFch
	 7Em2HCKXi/zM6hZm1GvTwxkebxTx6f9dNWSWrunA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/816] iov_iter: take an unsigned long segment count in import_iovec()
Date: Wed, 25 Nov 2026 15:29:53 +0100
Message-ID: <20261125143854.882015675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 965e5e451146a19f69523fbcbc73d07e401a3775 ]

readv(), writev() and their positional variants, process_vm_readv(),
process_vm_writev(), vmsplice(), process_madvise(), vectored aio and
the btrfs encoded I/O ioctls all take a full-width segment count, and
all of them hand it to import_iovec() or __import_iovec().  Those take
an unsigned int count, so on 64-bit kernels the upper 32 bits are
dropped before iovec_from_user() checks the count against UIO_MAXIOV.

A count of 0x100000001 is therefore imported as one segment: writev()
on a pipe writes a byte and readv() reads it back, instead of both
failing with EINVAL.  A count of 0x100000000 returns 0 as an empty
vector.

import_iovec() was added with an unsigned int count, but the helper it
wrapped, rw_copy_check_uvector(), took an unsigned long, as does
iovec_from_user() today.  Until v4.1, readv(), writev(), preadv(),
pwritev(), process_vm_readv(), process_vm_writev() and vectored aio
therefore failed these counts with EINVAL, as did vmsplice() until
v4.18.

Widen nr_segs in both import helpers so the UIO_MAXIOV check sees the
count the caller passed.  Callers with 32-bit counts are unaffected.

AI assistance was used to find the bug, develop the fix, and run the
reproducers.

Fixes: bc917be81059 ("saner iov_iter initialization primitives")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20261026180619.4147910-1-parri.andrea@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uio.h | 8 ++++----
 lib/iov_iter.c      | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 853f9de5aa05a..227b726cb557f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -355,11 +355,11 @@ struct iovec *iovec_from_user(const struct iovec __user *uvector,
 		unsigned long nr_segs, unsigned long fast_segs,
 		struct iovec *fast_iov, bool compat);
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i);
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i);
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat);
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat);
 int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter *i);
 
 static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direction,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 6f2f83c0358f1..5944e2721231c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1444,8 +1444,8 @@ static ssize_t __import_iovec_ubuf(int type, const struct iovec __user *uvec,
 }
 
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat)
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat)
 {
 	ssize_t total_len = 0;
 	unsigned long seg;
@@ -1516,7 +1516,7 @@ ssize_t __import_iovec(int type, const struct iovec __user *uvec,
  * Return: Negative error code on error, bytes imported on success
  */
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs,
+		 unsigned long nr_segs, unsigned int fast_segs,
 		 struct iovec **iovp, struct iov_iter *i)
 {
 	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i,
-- 
2.53.0



