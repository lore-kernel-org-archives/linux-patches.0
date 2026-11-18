Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026935;
	b=s1L1+tviWdab3R9kiQ6MDUw1wujhsrCifW7FR7nolO/5gLqOS1oLuQoUmWsA+GdkwJ2V
	 pLJPK4gW2gFYwjFYTaQwGEoQqQGmPTXpZsdzFmUVobLNRX1bXTAZybhWqQKEg9JFBXUs3
	 JwWOB5PDk36wXMBlH0WiWXRNXvX9Yro2AMAlD1UvhfZmYrkCUzDAoFfifI36TSghSpgHL
	 /J4lT0fo7AUAQNqrNjg8zqhVrN1wrW7jLlO9QTtiylqgTnSUhlgi7KHT4heHXBsMVT7Iy
	 M7ATZRZLc2yQ8pYBqRl3jz3jJ+gY9TMPntLzS0oBGt7nFrWN95eBCTpy4Nu95IUelgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oM/SJGEZ96kcGE90hpdSEKLoQ9UYKc0QzGfo7ekWumo=;
	b=JO5oGynqM/b0p9+TcJVG+T6oh678l3lXvixJK/k92qOswRwJ7nWM5kDyKKuyNFotKCAd
	 4ZOhjBN/GIH68RQ0YP8DtjnMAOAVVKKO5jfzyf9OCQ9+PfCBzBxBf5B6y+FiJKFkZnEe1
	 w60gIAO6HM2KNxwNUh1XUOAczpStMj436wj+g/Detzs0ocKgyxyP+2thZ9MF/WyP7XMG0
	 +qNc1ZbHdRyflJt1ULiD14MH8bmZLya4lKNEruKN2d6Cg614JSmWgXvQVHeLPV2QSsEdO
	 yeDmv+/UDug4JRmIlIYoJN1ZlPSmhOALLbuYnmy2w/t+In46bQXHBuwolnPRwF0eL6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I940hv4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE6606A320;
	Wed, 18 Nov 2026 18:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I940hv4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C51F000CA;
	Wed, 18 Nov 2026 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026935;
	bh=oM/SJGEZ96kcGE90hpdSEKLoQ9UYKc0QzGfo7ekWumo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I940hv4Zag4lJet0wg5KaOlDss+0U97Fr0/VncMbLzzTxL2FqouSSB+1g86+iy9kT
	 pyLHMWkmw+wm4V1FJ1wiipXuxiiLMKTornRXZwzwZqDo/sNMrrVg/uknh0lWUun1cP
	 TRV9B2aAJnhxhxWLsKN8qIWRH72CKlnEcjZ0Okzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1612/2151] selftests/bpf: Accept unnamed dma-bufs in the dmabuf_iter default test
Date: Wed, 18 Nov 2026 15:55:47 +0100
Message-ID: <20261118150220.592365381@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 653b8f14fdda385bd7c5b786f8dfdcc3e5599e27 ]

The dmabuf_collector iterator prints the inode, size, name and exporter
of every dma-buf in the system on separate lines, with an empty name for
the buffers that have none. The default_iter subtest parses that output
and looks for the two buffers it created.

It requires a name for every buffer, and sscanf() finds none on the
empty line of an unnamed one. On a system that has such a buffer, like
one exported by udmabuf without a name, the subtest fails before it
gets to its own buffers.

Take an empty name for a buffer without one.

Fixes: ae5d2c59ecd7 ("selftests/bpf: Add test for dmabuf_iter")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Link: https://lore.kernel.org/bpf/20261009-selftests-bpf-dmabuf-iter-unnamed-v1-1-962ee94f7a5e@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c b/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c
index 6c2b0c3dbcd86..354421e3c5c42 100644
--- a/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/dmabuf_iter.c
@@ -188,8 +188,9 @@ static void subtest_dmabuf_iter_check_default_iter(struct dmabuf_iter *skel)
 			ASSERT_EQ(sscanf(line, "%ld", &bufinfo.size), 1,
 				  "read size");
 		} else if (f % FIELD_COUNT == NAME) {
-			ASSERT_EQ(sscanf(line, "%s", bufinfo.name), 1,
-				  "read name");
+			/* Keep an empty name for a buffer without one */
+			if (sscanf(line, "%s", bufinfo.name) != 1)
+				bufinfo.name[0] = '\0';
 		} else if (f % FIELD_COUNT == EXPORTER) {
 			ASSERT_EQ(sscanf(line, "%31s", bufinfo.exporter), 1,
 				  "read exporter");
-- 
2.53.0



