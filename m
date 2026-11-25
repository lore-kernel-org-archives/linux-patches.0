Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625946;
	b=QclNrigVcgK+A3aZxbbQUiymRSNpGq7Y9NBZUNYnp+bXEMC8eqsgWjrzKNbuDYzg/6dT
	 NdUWBEbDOarnh7FloIH249zziyXpBrZrLWKkxZAtFRhw0mIqXRRy1uHQd7VIJWGQoxi/y
	 +VmJN0sJ9yCPtDdGTXy/x/Fe9Ck5oA8Nm+ihfvw+vCjRTVSUHv33O0w5DSeAw7vTeZelm
	 rU2AknwURJSvLdGsBpDJLONUjCSsMU+4cI75LscyK0IXuMmWhz4aENpalBjmkOYnUk+OW
	 qzOJmWj1ld1yLLmDh383vhW4q0da7QTVgIP0ih67sAkp0qO3hKbBydtVbYgmza5dTiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0tkzWcexSbdszt+jZdm+TM0NW13/QUH4FIGFx0fyMo=;
	b=unmSJX2Qemlrycn0sz655BsXfHTX2DHKc85grLV8OgUEMlBaL9AbXnbw4KKiP3SVlayN
	 1SanF05dszGiNEJ8vRmcwaal0D6IUeXtf87Zmfqj+XOT1TTp6+qp7r8Z/E19wlLH2Wz9q
	 6U8O475UjOe4W74QuD8jf+FrW8D8+FQKL2espY9qbzwVLDocTXDBR/ndw+ej5UdoJ8d3Z
	 04NYFdt3EENdo9QPrluZE6Ai2KnXSvUif4h4b8S4K5wJ/ATxqHd5hWbDbTXST2037wadJ
	 jvjXm/wKZvZcbJ3FI3wmIA+ctfqC5mUZReRnr+KHy3la4K/5xov/Mrqbgx/FC3+FHCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rywuEXFX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C25606A332;
	Wed, 25 Nov 2026 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rywuEXFX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE911F0093E;
	Wed, 25 Nov 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625946;
	bh=L0tkzWcexSbdszt+jZdm+TM0NW13/QUH4FIGFx0fyMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rywuEXFX77ohW0vLzw3RAOGgqAAVOWdHXNGOVM1Qk/9zHDkoSydpkiy78RKZkWjuE
	 yjeO0czP6/H+BgaYLfKp+quEIIFAw4zORcxBqKb2NqRvlQQvEyi9CTQqu3a2CCQUwL
	 gdRcL7FC0H39HMm9U7cke8qVLWguSiJGWBLJNmTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 681/816] smb: client: bound invalid NTLMSSP signature diagnostic
Date: Wed, 25 Nov 2026 15:37:09 +0100
Message-ID: <20261125143904.944712163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

commit 0584b02669c3e76188097174b4f25ed13723e94c upstream.

The NTLMSSP Signature field is an eight-byte binary value and need not be
NUL-terminated. decode_ntlmssp_challenge() prints it with %s on the
signature-mismatch path, so the diagnostic can continue beyond the received
blob until it encounters a zero byte.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in string
  Read of size 1
  string
  vsnprintf
  _printk
  decode_ntlmssp_challenge

Print the fixed-width field with the bounded hexadecimal format.

The patched kernel reaches the invalid-signature path and returns -EINVAL
without a KASAN report.

Fixes: 0b3cc858003b ("[CIFS] NTLMSSP reenabled after move from connect.c to sess.c")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -961,8 +961,8 @@ int decode_ntlmssp_challenge(char *bcc_p
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cifs_dbg(VFS, "blob signature incorrect %s\n",
-			 pblob->Signature);
+		cifs_dbg(VFS, "%s: blob signature incorrect: %8phN\n",
+			 __func__, pblob->Signature);
 		return -EINVAL;
 	}
 	if (pblob->MessageType != NtLmChallenge) {


