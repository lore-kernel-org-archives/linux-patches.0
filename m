Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035024;
	b=VLcs/tiDg5N+ToecyoVN/za6lE2FPBPJznS8KuJi8yjxPjHY3i1yReFH2CVh9G8sza3x
	 AsMjboAF6jJoXeFUXWJbnOE+ziIA/Xhi9jwCXyHub2oT1rbNzl0W1yRy+9mBTYf6h1oyX
	 lkRYSlLIZpL/dnAkmD9YbolVstqXaAVyW6wkVdBG8hQFXdYMQ9BQuNat0cIJM7ZAR2cIC
	 gcPwx++9TMaJNuy1Zd6BZftzPdiBdZquiQ79BYUqLBO9tkgWbx23I7vJjsLeagOwINMce
	 O800DOYbgX4py6dF3ZstUzdJm5TK/lIlF/aBjgHikRkUlEVlte1/U72m0cmcjSB8dVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1mBcn3SxUAHMxHAu36Rdr4U+sPgyRCLQ43/zYWkzC3A=;
	b=Cfr+leSPzQELROxEJyZ7DAF6wAkVWVMvxUgXKLdnLO01R/Q0z0J08/8lpFUueoaml29O
	 dz66Mk4cKvh7x5js9lVx5Flu9z+GdLEucMqv8t9vQlv30qqfuHcZ2cflmSPS66FUXaYmj
	 UOa8HFZo416kANGCaH7Ii3yQ+J0zLuB31tFTyaMLb5kz37ixuABgdAyLCJ36Rmwqcwvk/
	 FIEeII47IgUEGqTYWc+v3OxWdF9WIGga/oirJFnDslyglneG0IvBZM12BfAIUGFJJDpsV
	 FCqXnunxP8yuSX+NUTddGwNnQXdfb5mo6tnDQSJhnB1VLVgElombhcQ9AstFVMkdA/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJdq5eOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B91606A31C;
	Wed, 18 Nov 2026 20:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJdq5eOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB721F000C4;
	Wed, 18 Nov 2026 20:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035023;
	bh=1mBcn3SxUAHMxHAu36Rdr4U+sPgyRCLQ43/zYWkzC3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJdq5eOv7P73PTYutce8ubsATGxt1YAVp0izEcat/M7OggkYrhjNlzmCSh1kR5llg
	 P6pcqBrOQPG7kSDtRNhwDJ6ynwg19Agn6Z6lRkjBdUojGa4yeSTB69dJArOW+AmvuW
	 jZ2vFVGZzyJkpJTCXvUlX2u4n6gcX1OFBIcC/7Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0576/3318] ksmbd: return end of file for reads past a named streams data
Date: Wed, 18 Nov 2026 15:19:58 +0100
Message-ID: <20261118150334.768803493@linuxfoundation.org>
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
@@ -300,7 +300,7 @@ static int ksmbd_vfs_stream_read(struct
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 


