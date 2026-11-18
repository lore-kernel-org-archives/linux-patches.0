Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021378;
	b=oKD41zxOiNjW6vVtDlJZsEVxeuzJDy9BPjkzdu7aL/z4vgomxgLYI7k3a/29cQbQ/4+Z
	 gz2X+KbCvroxFJr/2dXZ5MMeffVcpWuCaQgrnPhQfL9AfNVM7TH18NGq4VR7FuptwERS1
	 1Slv9rQZQSm6TrGLTvV8yDTXxFPSwuPIoTKOAx1qgu8NUn8b9+qr9qNkzKtlJbzgMNqup
	 rMwXfG2+ZrKtiYGUyN9K9+X+m5a2lkAT0JmCR8/E7BdC0aiy52gniFh5iAkejH9oey/cl
	 N3uJFV5T49t1qBFWXrYzktnwFICR2hYhYNz9MjmVRGF5NP/e6q7e+gfUYK+8695Hg/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/fV3KNYpvunAWsBPA8O34g47qfngXP1dIU67EWkF/QU=;
	b=4ZqckCZc7++2GUwLfYY3zf/acUm43zrC5N7Zx6AZg7rQpZ9iFJcvcN0CAfXzSOfWhVzY
	 yjpoNs9uAilqVTHKNfl191oA/OsvGBhyhQyp+FHYteifTn9cE65EpQucUop53nIJQYyy1
	 /lbsG4nlxakY/VPJPBFLu4ziR2nlxjrKuf9ZwhUdFVRs4de04nLjHInUnBVYeDd7tyDlU
	 Y9D2dw9X4uQKFpMJKJ5u0T2ap2fACmmLkeZBcS0SvI4rO0dVQpMClDm5uPUmeFre5LQ7O
	 PvW7vCVGWwJMEjJaNeR9ulobW2VqJVoSct4Q3mPo9ZZY/MgSaDUNJRpz5XiPjxKSg6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/h7LQ/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD4A606A33A;
	Wed, 18 Nov 2026 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/h7LQ/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BA51F000C5;
	Wed, 18 Nov 2026 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021378;
	bh=/fV3KNYpvunAWsBPA8O34g47qfngXP1dIU67EWkF/QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/h7LQ/aV5eFVIn1v9u9oL4OWGaOcBVgD5+jxkgGFbY821l5Vx7oxGGMxx3Kcn+CP
	 rTGDg2nEX3NPWiKYrWjOmYA7MhpBaN7bZ1A4C8WRh0VZaZfGFjsKTGHYBZr+pRr8vk
	 CsIH6UA1K6ZJHseTVWJ3FFED3By9QM40t0qDT4g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2287/2651] ksmbd: fix AFP_AfpInfo header fields in synthesized xattr
Date: Wed, 18 Nov 2026 15:58:47 +0100
Message-ID: <20261118150407.622284388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit d3ef5ae55a16d4b31859e7feadbb50a0cd38dfcc ]

smb2_set_stream_name_xattr() synthesizes a 60-byte AFP_AfpInfo xattr
when a client opens a nonexistent one on a Time Machine share, so the
probe is answered instead of failing with -EBADF. Its header does not
match what clients write: ksmbd uses 0x00051607 and 0x00020000 for the
first two fields and leaves the third zero.

The user.DosStream.AFP_AfpInfo:$DATA xattr a macOS client writes
begins:

  00000000: 4146 5000 0000 0100 0000 0000 0000 0080  AFP.............

Write those sixteen bytes: the signature, the version at offset 4 and
the backup time at offset 12. The 60-byte length is already correct and
the rest stays zeroed: a zero type and creator lets the client use the
file extension for icon and type detection.

Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first probe")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dc53b1d3e5931..4f6cf8df4ae9f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3468,8 +3468,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 			 * AAPL there too.
 			 */
 			static const u8 afpinfo_empty[60] = {
-				0x00, 0x05, 0x16, 0x07, /* magic  0x00051607 BE */
-				0x00, 0x02, 0x00, 0x00, /* version 0x00020000 BE */
+				'A', 'F', 'P', 0x00,	/* signature */
+				0x00, 0x00, 0x01, 0x00,	/* version */
+				[15] = 0x80,		/* backup time */
 			};
 			rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name,
 						(void *)afpinfo_empty,
-- 
2.53.0



