Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051861;
	b=VeVqP8W3WpVCm11uENqfwbOtT5wrGWqmNNuoOweBfzKYQ5SWYW0PDoUfMvDE6Ob4FYlY
	 h5ib0Jvg5h3iu7JOYWbYiuajKSM55sVdpJvye5rT1J2qtcRoGD6fwP4U4MuktyzpMZMlF
	 eDqWbIkLtUi3DoJekIfwAommIOFXMNNE0PoNOtr/hQo7RqXuVXLulCvXVxJY55OFSqTDx
	 Fb3VsXAxYVoEy85jOyuQbW/anXFZHVRMtwmQBX5bmHjXFQeQob2VG9SRFsP19qJc0YQd6
	 4cESU7dnBcoiJUSjEPJTl47+uudiXtUw2UxQlG76y36nq8z2jdWD0J6xnu+fZXEJgIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6dA7PKerXvX70vnLyyldLPwtHUl1cyopKGSa7ctKQU=;
	b=z0EFUhNZiZUP+Cb4HI74tk9478/+EUpH6fP4K0xr91sXz7gKTZphYOA2YWYJe8fRngmD
	 tMde0z6tzY6vSWSVeX1I0Wp3uYFR1ZggCLaNsmeEjVe+kEIoJ/0dy8RXi/gKqdBsn+uGA
	 93uwKj17WOC3WWSm6Ls8Fndnhq86gFxKZwA7eImAjs4aWDSpxtYPwgz8e4kHRZQptfVAt
	 JDk7Lct5WnMjCMq7Dtugb49BdBP1XLSyrgO2baVb1vXocv7DwUHmPCwfiXN/u0UQpBJgl
	 T86zJ6YX61lGEc5tH5492bO7aCQbgeuql9Zm02b1TJyUICq8mLNhJQXvUHGbdks4Xxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmkSjEFG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4C2606A320;
	Thu, 19 Nov 2026 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmkSjEFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59FF1F000C4;
	Thu, 19 Nov 2026 01:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051861;
	bh=K6dA7PKerXvX70vnLyyldLPwtHUl1cyopKGSa7ctKQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmkSjEFG/twQByCLGrsCp18B7qWtSK5fEJH6Tn0WNyGMLdlg9ibdMTeucv7glooPf
	 c+ZZM2Dy4a52PHiQNk66TsmdS6HvLxLv6oC9npnKIeILlwp9bTTPqt+gQttfekFURr
	 0eItsyTQHyun5oRwZt8DSQZ79h2KODoWMk6Ae5Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0357/2214] nfsd: propagate SETXATTR value decode errors
Date: Wed, 18 Nov 2026 15:33:53 +0100
Message-ID: <20261118150024.981984777@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit cfcfe0b38a66bbc4122c78a2b75e1b97b3534761 upstream.

nfsd4_decode_setxattr() stores the status returned while assembling a
non-empty attribute value, but then unconditionally returns nfs_ok. An
allocation failure can therefore leave a NULL value buffer paired with a
non-zero length and allow compound processing to continue.

Return the decoder status so that the operation stops on the original
error.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915125636.2849626-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2251,7 +2251,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


