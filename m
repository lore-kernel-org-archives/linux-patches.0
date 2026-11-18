Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022609;
	b=i0D+SJZnsnGTsuMdlzE9aBYSC6t2iactGeeFBFnicJi93nQ1evgfj8h6LtdlHaIEkruE
	 3upW2BaZcplKBmWVnnm7f7sb30wk4TGMv0V2bG5Yi+b0kSlzKARtNYc3Uuaw5+pMg+KOF
	 z42ovWQKJHZips5tMzpx00tJwxbUpTNj2Ax7pDAy1694WMoCpfWp3Bb1aYRQ6HixzQ/eQ
	 kifn2Rrpw/NUL9M/jH6Am7flqUEzFmnHPiJeCczlP1Xevvql5kYpVhGkpuOFzMytaCss4
	 k0kbR9T33/H3c3JtyMP5jXibu45z+c+74+nhe2ERmRLEhQ7IyZp2v+I4Z/cRKrPaUCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3f3OsMgFsDJPRUxvzrMO6t6jSNArdKYldeH1S/BO7LI=;
	b=2WEN2GUofgQ/yPj8QnTJWBdcsxxR4p8GsvZZD6c+GJobUFLvymqgK/ypDQ1q+/dYX2FG
	 vs13sua1B010C55Zc2xjEJGLtoouSOz2baN6WXwsixYuXgZ/QuSRQOlL4zkFXyr122+qf
	 KdHlTTqLvCXWt3RxeZoqLfek3/mQZhMPYCbktnxSty+EdS/98Dk7zjKMX2Ff0MROmnKAB
	 pTuL4lUXMj8911wYnkcL9HKbX9So/LPck5oXSyVx4wT2Izy5OgYGLQTqduntjOiu63ctP
	 2+63Z6A/4o8zwnct4JSKGZ64LcUNRKB9Kum9Qf91MG2sAtaD9+ixamVIkCYNF5zM4YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgnNAkBN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0F606A32C;
	Wed, 18 Nov 2026 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgnNAkBN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6047A1F000C4;
	Wed, 18 Nov 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022608;
	bh=3f3OsMgFsDJPRUxvzrMO6t6jSNArdKYldeH1S/BO7LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VgnNAkBN9GKMu4lK7Nrywk59YltrkbytoNvEVeyGQEY3j6NDvWtE60cs1KNtUGzT5
	 4bgdwqIPaHZDkos71e+fQys9dRy9hxYGm6M7FypOdvRPi4iA3WXADShRjK5UvUvK4H
	 VWSeYaUj15s7QffHv6ueGM9KlyWw2tN4Mb2CVjEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0074/2151] ksmbd: do not read past the DACL in the access denied debug message
Date: Wed, 18 Nov 2026 15:30:09 +0100
Message-ID: <20261118150124.457767747@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 8296a64df5448548f410fb246c1d88a93609602b ]

When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
the request, its debug message prints the access mask of the ACE that
the second DACL walk stopped at. On that path the walk ran to the end
of the DACL, so the pointer is one past the last ACE. If the DACL is
the last part of the stored security descriptor, the message reads 4
bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
smb_check_perm_dacl().

Print the requested and allowed masks instead. They are what the check
compares.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Adjusted context to preserve the existing permission check with inline implicit permissions because strict mode is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 63f7bccb4d9af..d8c01e775d941 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1650,8 +1650,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 check_access_bits:
 	if (granted &
 	    ~(access_bits | FILE_READ_ATTRIBUTES | READ_CONTROL | WRITE_DAC | DELETE)) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}
-- 
2.53.0



