Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831346;
	b=eTba/ZWIG20Z8GgplFSHhndVBsUYhZ6ok5ATJXl5r0u3XYQEkDBv6RVy4Nmb+Y3x5Vj+
	 /hWEob2HhfmSQVZUWQJkBuS283UZfLA9BWlJ3ufhuws2BS4qvYSKQgTbSkkOYnZvttWLG
	 7s4QnHy/Fv2XoIKE2QITIMKV04wmxUfp3+upGbIwKhrEvczhwTTXqz7uZ5s4htiYNz13c
	 w4BzuHeXi66kl16mjSS12WoDI2z2jdy1w7dx4jQyb/a9Vru+fnzpNacJIstVvGWu9wyaF
	 pOCXVtsEWnK4aUJ0f5nUa/nKAzBuQ/sclouqSsirjnCMwOFO9O3sxu7RA/lSB5afbbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b6oLNFvvUDaJt/Z76KKE5SEIhB11pTtYgNNkS3UEdDo=;
	b=KSVnjaxnpsHcOmYQmg7Ga52ZlCLdz2S/zFs7QJr+U8qQtgjwvqKHx3pZ0hmPsYDwk+nT
	 PmYgJKdRRnG31yHCifrk0gq2ffttxsehWYxle5JeWZyhrJF2xO7aFEorZT8gu8FkKGH2R
	 HHiXjA+bCW7ZAwjZDsrCc4dWrU0U4Jy9+barkSLxdtc1K92XUA9nRBoHyP7jqVPogZQvY
	 r0ZeaqWHFxCh5Kdk1Ld6WBmeupnxPova01iBPnww13yJFjWgABAuYqaJnh32Ej1s2mfjK
	 dYRZFe0zv3zg0a8DMmUOXvtCKIGdhOatJ/fv8mQiOGJVXwJGw5NZ4or+cKRmNaE7IPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsyKBrag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84773606D80D;
	Wed,  4 Nov 2026 22:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsyKBrag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48571F00919;
	Wed,  4 Nov 2026 22:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831346;
	bh=b6oLNFvvUDaJt/Z76KKE5SEIhB11pTtYgNNkS3UEdDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsyKBragL/ELNj5V02sEwoVOZhZQpfzQ34AmGdVVJUDI/E05bWDjDZ6b2ImFL8CC8
	 hE2iZbdJmcakWzNdJH/TJ7ND0nYy0VmMdEA399WFkqz74DfSpWnOFuPpsScbaww+zt
	 gANCAnf3rOunyrPXzniSrD0ZdYmbWFufaw8KuMWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0649/1005] ksmbd: return end of file for reads past a named streams data
Date: Wed,  4 Nov 2026 16:06:22 -0500
Message-ID: <20261104211101.905900721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -296,7 +296,7 @@ static int ksmbd_vfs_stream_read(struct
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 


