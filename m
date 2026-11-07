Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062586;
	b=U1VhDfWQ2tFgt3gHkfp7rG1DObEL6Uw+VfLNPb5n8TGaAhnoMLzZNfTjZir3BElveqmA
	 QifM9iFdcDSHpNAwZurAHwAMFfBHZOapJoO/juEMt1Ww1nIL9mhQv+6oyWDLhkp5nHpUy
	 Ejs/KNbB4NdZUOu61UeN773rbps+0yzuK+N44RqAE28htQg5RuWihJWA8oQNXDhIlk07Q
	 tIbqPQfw5pqBo2WZ3oS650mQ2ay56meNnDg0RLzu/JILfoLbjd+fO5PzHvfKgicChvp88
	 8d3004Nd7vcJY1Fd8RvksHlNOg3QYoPnmI2xrZhDfKDomCg9vS7KNMupP+zy752tcrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I/Gemz3Z8AhAQaywv394xu7SdVYwHfpVQFoGlLypyco=;
	b=IXEYxxBCldcBVogBkV+2uQMJodNq3g+4RPI1WUh/l+5pV0C+fDCQiFwL+fq9IwpcWoM/
	 9Ni68UqqVLfinBdvuY70rHnOyMulnTYHZ3JfHLaCwleHBzQAi0o8xxThhgTe0HeiNAywR
	 SFlyaYg3Xuy/oZJgqAL/mOzq7p/RbG7epBf29/VMGu3IZgVBCW7SfZre46v4VZLpyh+D1
	 QOz29t0Ctwmon1WwDAFWdyRpFnqEtCZ+26j9139dNGPtw2718+hvQpZgxP3DBbCATSNNu
	 U8slnqrB50bj3TP9tTw61YaRXG1TSbZsuIs9ynm3Nk5mIBLxBfM/nBb2TIqkxlzybrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=La4Xpfnx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22BA606A337;
	Sat,  7 Nov 2026 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=La4Xpfnx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E141F008A1;
	Sat,  7 Nov 2026 14:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062585;
	bh=I/Gemz3Z8AhAQaywv394xu7SdVYwHfpVQFoGlLypyco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=La4XpfnxtmgIDAlAgn66OjJp0ihIGd5Mc+e9GHHkAkFpZCbRGwWJRinxjNZTmEVxg
	 NFDs/ZaFNQN8in0Q3bx/HpFuFlxk3Lc7vAZmo1FjCqyOzQN6yEvoSpdSTRrwMnBnL9
	 zCxG5wA6CGAo0CjE8pJhrfGe4E/UlbYr7yjRn4S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1465/1536] ceph: fix 32-bit overflow in readdir reply count check
Date: Sat,  7 Nov 2026 08:58:01 -0500
Message-ID: <20261107135038.988925980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 52913831ba56efceaafd80b501d68fa00f79bde6 ]

parse_reply_info_readdir() checks how many entries are in a readdir
reply by computing the end pointer of the decoded array. That pointer
addition can wrap on 32-bit kernels and let an oversized count pass the
check. For example, a count of 0x40000000 with 156-byte entries wraps
to a zero offset, so the decoder can write past the preallocated buffer.

Check the count against the number of entries that fit in the allocation
before publishing dir_nr. Reject oversized replies through the existing
error path.

Cc: stable@vger.kernel.org
Fixes: 54008399dc0c ("ceph: preallocate buffer for readdir reply")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a2870baa8ec8d..1e7c6d317f6fa 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -436,10 +436,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 		goto done;
 
 	BUG_ON(!info->dir_entries);
-	if ((unsigned long)(info->dir_entries + num) >
-	    (unsigned long)info->dir_entries + info->dir_buf_size) {
+	if (num > info->dir_buf_size / sizeof(*info->dir_entries)) {
 		pr_err_client(cl, "dir contents are larger than expected\n");
-		WARN_ON(1);
 		goto bad;
 	}
 
-- 
2.53.0



