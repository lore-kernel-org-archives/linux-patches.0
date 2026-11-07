Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064184;
	b=qHREocyOIEOvCU6nkNNqNrc9C31evqQjuybgsjfNSA8JjG86RM1GHLFXgIVB7cs2weEr
	 nCMpecMOXiRDCiwbVELxtOZkT5wa/3Yk6OXKhMnqztzC7w9Zkqtnfv+FRJZrqgvMEa30k
	 Cc2y1ZSBiyA760mq+Q9iy/aU3PXjrMG6c2TH72uEyoaafOgocp4ZqrS+d9x3prPDsq5+7
	 coN7iYMZ8YAONEA5dbHwkSEKQQa9dNE3Jb8eBVE/kU62HmLDFgNXtcAdTXRM84c3by88z
	 JqRbGUTWd/KRFmQzJOrCqZ5lvvJHyECL14CWMGAfB6slp9/mNnFRcxaEEEYwGFBaqJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=skY7d+K2EqNEHU6r2YdGP1p/lqHXj7qkmRZrZ5WV9Ts=;
	b=D9sv5Lnu8uvmDFNnFrxHOt7tyPnsQFU6VggCFNxzdTvwI+RupXk5T2VBTJcL7gN+SGAU
	 j9shcpidFR0cPHfb2XY0xK5MMxv4EIdvISadZhXWYsCmkft1nXlq8MwL3vlRu4ZXFq+MU
	 tYMZZrZQ3s5I++ZE5btOdPfc6/lKR3HQU+WEv+sFQUlosJMTMxgvi3fwiK4bqItvyCsEi
	 g4Rvb3ZvTOGh7UVKqDZM3S46a2X44lmHeqgj/MLrlRmDpD0ssFYmlVBnhN8zhaxXZA8jq
	 cEw7xukzdcD2Iv4GC1FPALAJKDbIffuX7jQAJ2++eiAhjXbEH/u7dq2l5JjoxBk3JkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMTKdz1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BFA606D809;
	Sat,  7 Nov 2026 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMTKdz1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32361F008A1;
	Sat,  7 Nov 2026 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064184;
	bh=skY7d+K2EqNEHU6r2YdGP1p/lqHXj7qkmRZrZ5WV9Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMTKdz1n6C+QNMoWsyq2d3IsMmx/Zsghg/BZtVhxC/6YckAEDvHIFJQFZTtSVYPBQ
	 gR1JEeszG41BwmaIz2+Ny/pFTz96jKYDCtwJmr/+F3koQa2xQcVhExlJfsd4C7z856
	 tb5vruZq2Nz/EGdjOkHSooCEUT/IdhwCrMhAqkw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0326/1257] fuse: fix GCC 8 build with CONFIG_PROFILE_ALL_BRANCHES
Date: Sat,  7 Nov 2026 08:43:42 -0500
Message-ID: <20261107134948.427917576@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6e887377a63f670d79f3d8a107f29e745e9ddf43 ]

Commit 25307ca50b815 ("fuse: simplify logic in fuse_notify_store() and
fuse_retrieve()") introduced a loff_t cursor and used it in place of
outarg's offset field. In the min() expression this changed the second
operand from unsigned to signed.

With CONFIG_PROFILE_ALL_BRANCHES, GCC 8 does not propagate the range
established by the preceding MAX_LFS_FILESIZE check through the branch
profiling code. Consequently, min() cannot prove that the signed operand
is nonnegative and rejects the mixed-signedness comparison:

  min(outarg.size, ((loff_t)((long long)(~0ULL >> 1))) - pos)
  signedness error

This happens with GCC 8.1 on x86-64 and GCC 8.5 on arm and s390.
GCC 8.1 remains the minimum supported compiler.

Use umin(), which is intended for comparing an unsigned value with a
signed value that is known to be nonnegative. The preceding bounds check
guarantees that MAX_LFS_FILESIZE - pos is nonnegative, and outarg.size
bounds the result to unsigned int.

Fixes: 25307ca50b815 ("fuse: simplify logic in fuse_notify_store() and fuse_retrieve()")
Cc: stable@vger.kernel.org # v7.1
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/notify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
index 1ba763705d911..fff059f8ad859 100644
--- a/fs/fuse/notify.c
+++ b/fs/fuse/notify.c
@@ -155,7 +155,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 
 	nodeid = outarg.nodeid;
 	pos = outarg.offset;
-	num = min(outarg.size, MAX_LFS_FILESIZE - pos);
+	num = umin(outarg.size, MAX_LFS_FILESIZE - pos);
 
 	down_read(&fc->killsb);
 
-- 
2.53.0



