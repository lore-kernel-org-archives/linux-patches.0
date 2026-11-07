Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061495;
	b=mIqhTR2Q+SnUuhdcA62nx42LWmfP1eSVaZsEr4610xoAsi21p3dT7zTwiC2Xb95PJX2B
	 k9OUjADV2VTojtHJeVVQo41GAL7Fez9O5NxAuId/HQtqKaMLbUVxGNrGzQxcQN9i55sMh
	 n+RBLzZ4s4MSpMTFsJzxY9tErehu/7k4GYcght98vFvifVmhsdc6c01BzXmGQL1C5+oxf
	 WXYti9dnu8GVolFE1PvgK8nslzHQu30LT8x93ZKwdzPUoKkjQKYRJePzHmJDjfHgHbevE
	 J+rcp+NTzu1A/nWdILzdXCSyELbH3ISF0kNqBfRcSweT22o6rFEjNfoAtFMrbwbJuEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pAlKWXTqmX7llaOd9x7e9LMcRcYFBk7Mkox6k3Aj3f0=;
	b=AqnM20BMajEYcM4fNjA+QrAvqnZ9T5O84qk7Hagz5ML15zLy+b8US2YR9iFJFBxNmpZO
	 DweJqbLtyiPhP1hR+0x2uk0ubnyyvQRXb9dlRiDdBazH07a0vBWogt0Q5sV/yjQWfEjnp
	 Fk/St+QVfA8q+OyOz556hkP3QwefgXvnue4hLir4yDzGnfJVvx+X0oKjuZfFkorud3bz/
	 vdWZ6+A9mghlz2nF6KzkGbrmvNFTDp8lmZ5peiKdIyLD6XJZ6R8RaYbXLU8fVEAZgvMNk
	 +d4etF4fpR9TnxkKRyHHI7Mo0/Mq6vCFZAgJP9R0f2d5L9logrZbTa3o988GSO+fmPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mh8UKPIX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2607B606A331;
	Sat,  7 Nov 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mh8UKPIX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0E41F0089F;
	Sat,  7 Nov 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061495;
	bh=pAlKWXTqmX7llaOd9x7e9LMcRcYFBk7Mkox6k3Aj3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mh8UKPIX9UEtUUPWu9PHCTqw8IjGGkhqhLDoWeXkC8bw1+uniTlKktuPKXpVJSiOq
	 HW6gbk9mwsa9m8usHhrxoYIUoc24tng26VDMGkhs2S4ari5bA8+bxVKFYW95njy42o
	 cyKph/a5qqw1fq3UkbQ+VJz1qIQrmVb0pBYS+0ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0591/1536] ksmbd: return end of file for reads past a named streams data
Date: Sat,  7 Nov 2026 08:43:27 -0500
Message-ID: <20261107135014.132585102@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit 626611dc22a3b63b3264a7a797d9dbc530234fcd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -299,7 +299,7 @@ static int ksmbd_vfs_stream_read(struct
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 


