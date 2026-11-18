Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062283;
	b=pjj6rgxTZlWp3uiinStQcXJoJsE9o+WQOsemHOQWkR6YIEmtDHC5fQ5+4sDZSfkM3Yn0
	 W820DxC32QURcV30GP3IxraGYTv2rou4lqEiDOC1GcgksZvhWxt2QNV3DawAVaID6T1u6
	 rOcaNL8fVaVUnrlPYm71GFYk/rFblDdBbzZD16Qq5wK33DGfTBsqr4Q8GohvkVhs0s8pr
	 LWpF8/pGa5nnX+v8JcFiB3vVnIXC/TC2IErnOQSuBZkFD27ohycty2leUvv9M+UseXyZy
	 2cYqjk2zmokUAm6/v2sDs5Tth0GS7BLINhtNo0dhBPOBxfgLQfu+CONQSSbr64d/IQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u22ASmKEcm9dxyjMpucqboOa7T4zxjPfA7wEy1paBdw=;
	b=s7P5CG3rksqKJxWdOQKGva76WaO2jpoH/HODqruhCeQd5jIA52IxT27hx53U8X1Qp+yj
	 21IuK/wxpSYuJqvcu7+ZTW4pjit2Z0Y5NOrZHzS0qfCM8W567tYxcHX0ptIZZBIKO0bnU
	 nrK1HVQ0yya/Qf62WynKFif3W00UzJw/98+DFw06IqY66LqNz8pbtCS7K1m9LIjmThjGj
	 VPKvd2nzqRuLDMO8c0vzCwSb4YZKxshO9z2WuhEHnZr6dPuPx3ZBig6xFcmzyRYQr2TwU
	 gsca6A/JaAHg+y7s2OuRXmAL6bp5CU+BoK3x3ohApSidvy0kR87IisHxy83Dm03uQvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIR4bHlf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FE7606A325;
	Thu, 19 Nov 2026 04:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIR4bHlf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3091F000C4;
	Thu, 19 Nov 2026 04:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062282;
	bh=u22ASmKEcm9dxyjMpucqboOa7T4zxjPfA7wEy1paBdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIR4bHlfuRKrQ2VpqEYVq4WN3O3XNNOqOAbxSt6lvwNKXpR+kBUbimcSSUsTpQCdf
	 XCtcBLdIiRZweJiMsK+FiJCiq62oy2HEwpmKU2ZilCyBMA7wTq5QtrnZweRCulxke3
	 se5lzuPEazBtv8beIMV4GsIUIFtzYnLniqiHJ1BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Xiaoyan Li <lixiaoyan@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 1826/1848] selftests/net: fix typo in tcp_mmap
Date: Wed, 18 Nov 2026 16:04:24 +0100
Message-ID: <20261118150036.111931853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


