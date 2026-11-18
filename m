Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057036;
	b=SGe0PNRbWBMpBS/m+nU3IVFBE1xf1tPncwhip7WUJL8qi1M2gJSx98+P3xhwRF0g8dWS
	 R8ROBaFJ/U67nFs/CxdsSlmnl7C3rJGxAug09dYIrlC2TWhSa6yZ45QdvMsv/4k9EJRnr
	 IXNhMmmHVHahsmWYt70vuR716vx9r3/8vRt17eZgiCO+DWcaRoF+bSwq8STsoXmT2w0Gq
	 lyW4US50xTvQYm/9C8SWImvekckfRpAGc+VVAY4Fcn/cUy79XGpRdkd9v78BQhQ7pYhrz
	 kMUVyJ4E38kZN3jineaX/ydG6zTXscJk3d7RqF6GJ1Gx3FV/m2KS/oWNEQQdhrLuOaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sj1Xlup9lH+e60f0wUXGaEjmNvPtnYNLmHutD4aOMHA=;
	b=ExdZ186B1S75fdGJYS9+iAfSC73Kwz1E7YpI6ZQVqW6pqlvYBEwIN7LRfSzidvC8avB5
	 MaN7GxfnLtkRD0DWmIi3BypqO0cLFasfv5eq5/JhP7GtTb6m1/D6p5I46h6FypFHj69Yd
	 lwZr5kwTf9V6HvV/C3hr417imSm5Y4jcbSPJHQkn4+xYMOuWt9D+c5kNqXYBE6DleiO0A
	 4v+N65AIuGQR1d9QrhTLFq5BaksOJN20IFQ22ruAeL3ZiLMyloQEWD5mFkE9e3nK5wk9s
	 +OBZ51IZLnrDVT8zJ5t3ftz8LTApeQ4qLptrmccbHJSOePSFeHaibn9a7HgMpidv8BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfVyOvgN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4807D606A325;
	Thu, 19 Nov 2026 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfVyOvgN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982981F000C4;
	Thu, 19 Nov 2026 02:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057036;
	bh=sj1Xlup9lH+e60f0wUXGaEjmNvPtnYNLmHutD4aOMHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfVyOvgNVzdk9ddOPF/s77+t/pjIghn9vPTB+shQCRVzQofSFAR5CIPZhUEvzuQ6N
	 bY/HPaDgoP3FoU+P81KyRxJtEl7Z55UWZYikd2hVBbIc6+nggT7OOAVdccvH+hDy2K
	 we3sAzjfvC+Wo0ds/6dyAxFMRKfJZlz+m3L7iNIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Xiaoyan Li <lixiaoyan@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 2200/2214] selftests/net: fix typo in tcp_mmap
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150138.298820716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


