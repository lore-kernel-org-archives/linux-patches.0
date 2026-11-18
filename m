Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050862;
	b=k4TNwDFNk9NOtGW92XieR/GsPwQj2Lxx3AuUcccQJMAMJYsRP6sx68AEuBRDV/MUh+A8
	 gYeG+zOFJI+qDlxEOTuspIjGm6YMNTqZAtChvu0jmS2PFCwf4c4d1WBiFpFbB2H84F2Ki
	 P9H1v92QjngpFIcgW0zBmW1vvsqQbXGAF3qN5fjerNdXM/S8YloDgm/JxslD7sb4MUJcQ
	 OdvyMnch+tKHbMYTuAZ75mnFQIMB1mFn5eeuh+Uzrx3NGDCpBs8fMan+qu+LEOHt1y5Ci
	 UwDdkYB4AHzTkkD/ONIvZdtaBBb4hRPkGqcN8PQUPGl1CORlORbgyVUmdNWdGa6P2Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qy411C92bb1w5EZonK8Nxe2FNkDrSmKOlciE1jh22qc=;
	b=YiSAhLxhrhxLhv3vydEcVtgNb0qXj7YAAMWGe6NKsQ3xlkIufsXX6Aa/1r+O1V5/YTss
	 QvOFNVecgT2NV1la0TNXE20QBbYti5hJ55h24iUP05TqtZe3LrDBqm/YFTWmOfGkpjg7F
	 6HoHoWlQd+w88nzHmlsrYWnmG7k5gt3aWT8qqlXqOcRZcGm0MeVHsq9FImzoipT5JUa+M
	 BwPbl/UGiA0pKrP7NzzH+1tRSasGc0dUPtseD4OT+aOZs/5QDx8b+uIw1pNUCgeTymF3f
	 L5ykCeVWBN8EhBb0Y/GqjWNlAGIT4Ly/3P8yIoZOz2Wf5q6BuDCawaYypUvrMIi9aBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZCbOLc1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F2C606A31C;
	Thu, 19 Nov 2026 01:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZCbOLc1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BFC1F000C4;
	Thu, 19 Nov 2026 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050862;
	bh=qy411C92bb1w5EZonK8Nxe2FNkDrSmKOlciE1jh22qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZCbOLc1xrhHaSV9Qm/2gt+g/QIKnXY8StWi7esMn3CO/B/VvXPpjAt0gJk+L2QqL
	 qrL4PivTX/a6ZJIhTIm2rLn6sFcp2kVd0dp1+O11ZC3/2hFOyeZ67VV/tfUDEpOKf1
	 qfYLgbsSL4ulAPd9L5XhfbqMJHDe58apSgX+u8VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Xiaoyan Li <lixiaoyan@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 2844/2857] selftests/net: fix typo in tcp_mmap
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150343.971650786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 905a9eb5f636f3312964b162362e4d6ca4e37378 upstream.

kernel test robot reported the following warning:

All warnings (new ones prefixed by >>):

   tcp_mmap.c: In function 'child_thread':
>> tcp_mmap.c:211:61: warning: 'lu' may be used uninitialized in this function [-Wmaybe-uninitialized]
     211 |                         zc.length = min(chunk_size, FILE_SZ - lu);

We want to read FILE_SZ bytes, so the correct expression
should be (FILE_SZ - total)

Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304042104.UFIuevBp-lkp@intel.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xiaoyan Li <lixiaoyan@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230405071556.1019623-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tcp_mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -206,7 +206,7 @@ void *child_thread(void *arg)
 
 			memset(&zc, 0, sizeof(zc));
 			zc.address = (__u64)((unsigned long)addr);
-			zc.length = min(chunk_size, FILE_SZ - lu);
+			zc.length = min(chunk_size, FILE_SZ - total);
 
 			res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
 					 &zc, &zc_len);


