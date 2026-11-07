Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060794;
	b=j2kj95RzlCkHpDmlMVaOtGOblhaTSZGNGkT5R3uW9a7eVkzJBMtNuG52Ffi+dBgqGh4n
	 GO/2+zO7gP4JhKMQ/V2r4kdYkoUjVr7F9RdX4nU0xnGEmKSWrBUBWjIT3u/4zwCgbismJ
	 ASIQtYjq+jTdIyWp39/WiwCr/suWLusuNWtlxP6Qfp8/6SEof3qJYjDJNHdU8xgMGJFlr
	 UhjuJisPXsTeP13f/4nGM6IYoMeWPDWwi7D4DTyKa/ffIlq+r1/Ow0Kze90n6I0H9pTw0
	 mo/Fmm1qPJ+ZoQN3u2cSyscIBymLiC9bXUL9BLK/Yo0E1g1OqrHAEKByreo6WPjkBPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JCQhZtj0cLI3v+bK2xBu01QHmZbgm9eiOpH9oiJpt4=;
	b=i8Bwa9ZbwcnJZVhrYjziGIOWFHUNMHeN+8Zr2+yYU0sZZTU2AmdKJPTNPGCWzQ4wpvBM
	 hRUhc3ebXsB2bIPKLOGeQRp5lMQx5jDb++Ubt5DkJRmkP49oYrDU6N1diEDl+chw1FLFD
	 9B5xCaKk5airKtWRyQC8Jf0yQDxuWFDVRXd/AzZKqeNkIVpAMArYl0vKeq6tEbqEMWBnp
	 dlAw0A6kedw2C8RLSbUgnaFa+aDjfDYDleXFd818D6lIZgW1thbLl9yNWsAEcbVv1ASY0
	 WfvRH7enXcf0aHofPFmrrahQ1IbZAcNU/CsO7HlKOkH2tFdw+MiJtRH0cbwsH8gBfzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ARUKEuRJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A7606A332;
	Sat,  7 Nov 2026 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ARUKEuRJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C079A1F0089F;
	Sat,  7 Nov 2026 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060794;
	bh=6JCQhZtj0cLI3v+bK2xBu01QHmZbgm9eiOpH9oiJpt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARUKEuRJn7NBrkgl95q/76YDGwdWwLw1yfCLz0jef/aJ/qvk0YbAGfTv4dS1jK1iN
	 Or902XqBYfSDUcs2Mzdc12wdJTqZG7DXnfoeUQaD8ALn6ZDLiL5oL3Jv4c8Qo1Iodx
	 O2tjr2hL3EU12YWSLfdlPcvufaXQtyrEtQJNBCmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0196/1536] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Sat,  7 Nov 2026 08:36:52 -0500
Message-ID: <20261107135003.167139460@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 705a3fd3bac167f1dabe3d3bba46cd484c5528dd ]

ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
false and the function returns NULL, which callers such as
ext4_block_do_zero_range() treat as "nothing to do" and return success.
This can mask real failures during zero-range, truncate, or punch-hole
operations, potentially exposing stale data if the block was not
actually a hole and needed zeroing. So propagate the error to the
callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1701dadf5fc65..dea85cff89457 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3715,7 +3715,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	}
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
+		err = ext4_get_block(inode, iblock, bh, 0);
+		if (err < 0)
+			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
-- 
2.53.0



