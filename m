Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052005;
	b=me9a0TTLJP95CuW3QG6pn6OjB9VOzRMt54FoHHqiTHc8H47B5H9jFBaPf8kLd0DDiddI
	 gcepVZwnUu1mzrgCao0ZdAh3SrJ5mwGn/Rk5BuuvZlC/cMAT67ZCkvGLO2cAPfmhJobWZ
	 B/wNZxbUzWvOXJ43W8Xj/B2YY6hWXvKaSzauGwhS7gh2TYhe1ZLSgB+XLLOhVNqdtygI4
	 RBQ3ExDLJLUUEwSix6WTal2gJnVNV8OnDAiRtJawXc3Hz1VXKQIN+md7l/G3OCvaQm2Bv
	 H5Vne/Rc267EvUDUKjj6EQ2RwuQ03vk7PMVJyC5mBl4sm3tQDzrGIQNKFw7geNGQ6jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2UKAPxHdWxUc6+iFYSYzeI4WquuGn3Mvjfdmxs4OANQ=;
	b=sabUcKZxLN/LTfGX+IElGgS3Pd7EV1OXI8F9Dd9/jmu/FGsuaFSq8pNC6bpHRdM5o40W
	 gGXA2Vg5xdCFNhxNAsBD1gU3iKT6LWJW9MWXUI1O0hygodOT+80qEQqDXGjDRViVmCipm
	 OZzQ/1GsXbIs/GlQX8SHjHcmvqDuOFfi/zMiYeZLrxnqIBMXviJcvCeutx7Qmd0U6J68W
	 BIoCv7NU4apgXQO4Rv1LkJ6xh3YWwo7va9BX9kBoeaJwlvtwXNl93KgdKkwT6MJYhLlBx
	 LyhvaU5NAKTYVDjntoioYj12YOWZvKWYIbsNumImoeZT/WDQ70QEsGfUzI88kFRS2tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EDlMv7LT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE18606A325;
	Thu, 19 Nov 2026 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EDlMv7LT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A01F000C4;
	Thu, 19 Nov 2026 01:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052005;
	bh=2UKAPxHdWxUc6+iFYSYzeI4WquuGn3Mvjfdmxs4OANQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EDlMv7LTv+yiPJLo73Vh5wF/1G+axSJssdXZ7qCzefQKPgYwI7+ZTujY0cQP0niKM
	 7XsMbZSGSTmVH2Aep6Izy9pcfJuLPmBz0/FxQWVavKVtbqJ0/CaPLSU4LOQ0a259ZY
	 xZE/CS/DLrRlAw3BkrjDuHBXON9vCvTP1PBZoNKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0408/2214] ksmbd: return end of file for reads past a named streams data
Date: Wed, 18 Nov 2026 15:34:44 +0100
Message-ID: <20261118150027.089310810@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 626611dc22a3b63b3264a7a797d9dbc530234fcd ]

A READ on a non-empty named stream at or beyond its end fails with
STATUS_INVALID_PARAMETER. ksmbd_vfs_stream_read() returns -EINVAL when
the offset is not below the stream length, and smb2_read() maps -EINVAL
to that status.

smb2_read() already turns a zero-byte read into STATUS_END_OF_FILE, the
status a regular file returns at its end, and an empty stream already
takes that path. Return 0 instead of -EINVAL so that non-empty streams
do the same. Clients that read a stream until end of file otherwise get
an error once they have read all of its data.

The buffered copychunk path converts a zero-byte source read to -EIO,
as it does for a regular file that shrinks during copying.

Fixes: 2ae1a6cc4302 ("cifsd: fix potential read overflow in ksmbd_vfs_stream_read()")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index a063d7a006ecb..92159a82c232d 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -299,7 +299,7 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 
-- 
2.53.0



