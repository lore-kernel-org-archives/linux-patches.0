Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037205;
	b=ZXl4Rv09UvAa+uQsdNnJi9F9xnLQDHkKFF32mjBu0uqR4v9l0XljOqQ+uxpYwDYtj5Lx
	 1xKJEjSOtAYGBJHZQPVUh1mbzqs35aCK5B+1Zk2TjMnLaYWvWxaHHoNcd/w6+rwgS7OU0
	 zSqbtUXpeN+3JL/egDdoy6t0tBfM157XynXLEVWLuuNmSvUXVz0anfQGuwY2FKS/2Ena/
	 3dvRsNDVccL4hgO/oIa2zuHYV7LZQUWp8gjeSo+gDHw9PvsDOPOpqdjfHvAaANCrvA1pP
	 a0KotuAXmVPSLK+hxjHwiSxA2LbwY0nIrXaSj+agUs4rdMspkwEfGl1EaJJH9tumHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGVcDxgMpbcjpV5JvIDFCl8mrmRJ63kCf0mlS6jWSyM=;
	b=CD90YfeJU7l6a90boJmcqk49nyVnPoY53Ok540rfJPc40obGqHAho9jQ+D3bqMJuAOel
	 suJLmIqbJ1RT3jnCnaUTup3oYq6G01nCd2SLM8NRHSDcCUMTG+iL1UmBWGZl2zufXVooT
	 jblvLgX1v+hLekqzSL4ox/bQLrOZl+AwkfYrZSCNJED8l5AWGkkFS7PpMrkCsT0bGMUfZ
	 rMAJHu9q+4Uq+SBRq74o63DEzvao/g5qMa9dP27EIV0RRkpbN3g5+YLrpvufKOPdOojLN
	 1zf9aUqD5ANaXDXx9jKKdc6frTsUqLjgtS92QzRxUYbt1bJ1GAZbwfuO67m0V0FVSgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NR5gHsnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F90606A31C;
	Wed, 18 Nov 2026 21:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NR5gHsnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7D91F000C4;
	Wed, 18 Nov 2026 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037204;
	bh=rGVcDxgMpbcjpV5JvIDFCl8mrmRJ63kCf0mlS6jWSyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR5gHsnVa7HpMbtBQ96DxReIemQrMEkjlgvv09oNX/Di8ZS1eN7xEGHFUzjNHxWU1
	 +iPMrWi9RsY4pRSXRj6uRHlhMOCmmemPDOmar2m9RrVdAnBdT1IGn/rkW2mEQGSrHj
	 cxx4HqsKCyVOSGfz/LD4c/i85xjGr8ZkHMCaswJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1292/3318] fs: skip copy_file_range write limits when there is no data
Date: Wed, 18 Nov 2026 15:31:54 +0100
Message-ID: <20261118150359.028000441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 81dfa035891f0502674332ee97db348a16486de0 ]

generic_copy_file_checks() reduces count to zero for a source offset at
or beyond EOF, but still checks the destination write limits. If pos_out
is at RLIMIT_FSIZE, this sends SIGXFSZ and returns -EFBIG even though
there is no data to write.

For example, GNU cat copying a 1024-byte regular file to another regular
file with RLIMIT_FSIZE=1024 copies all bytes and is then killed by its
next copy_file_range() call at EOF. A zero-length request can fail in
the same way.

Check write limits only when count is nonzero, as the ordinary write
checks already do. Keep the other copy validation in place.

Fixes: 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261026015738.46230-1-dennylin0707@gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4771701c896ba..7a9f4106068be 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1453,9 +1453,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	else
 		count = min(count, size_in - (uint64_t)pos_in);
 
-	ret = generic_write_check_limits(file_out, pos_out, &count);
-	if (ret)
-		return ret;
+	if (count) {
+		ret = generic_write_check_limits(file_out, pos_out, &count);
+		if (ret)
+			return ret;
+	}
 
 	/* Don't allow overlapped copying within the same file. */
 	if (inode_in == inode_out &&
-- 
2.53.0



