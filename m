Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039729;
	b=miqV7X8D7mHPRIyvOzbY3V7gN3RdS6xQe0z6o7EmA7/Gk3326GAuqeuri66kMYa1DIo5
	 lJEILsa8YTYaRPWxx6cFyWYDLkqk7maIOLclq6rqlRHeetTN3adRE0Cxv8Ixx7MfG+2d1
	 QjpTWdUcS3ydgY4jLXwToMHkTphszRP7qQh0GnCOEWDKawgvGy5n5gD2LCQazlEaoJM04
	 QRt2A7sMLdu9fDcDZF7ct2hBq6iNj7VmtslWlDbI2YJjSUJvwbAhVkQvqmuwsVSOJS5bm
	 tOpj0dVd8SxZeltbRJB+gaf+p4KUWfxv7LDf9BUMfIs1bbo+3b8z3cQtm1lsMjtK9fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M8T4p068WTNTMgZ7PttPKTKSts6A3azeSJdCWVmFKbc=;
	b=po8rsk8XFXWoJPEAyxdKzFiMvOBvaaWJ4XhnpJfx/dChTvT0ECnSYrV1w87FM2v6FLD3
	 RHIVf59V1plsLYvwXUilJEd7MVs07y0Gt7qCWM9mam3sB7BxUSnRiKlZFPN5o6TQgCz8D
	 C9/AuImjU0/+4gqaQWSMQaPuAZaOxzSD/Z2EjokEzTC+5EM7NmIxbhehK9Phg8KmiuhWL
	 jPPDFblHzUywLWi16TId/nGFqBUCA23VCdJ51VJhwx0SxH7nW9dU+xJ/O9UsUACWQfYdZ
	 8UiCgAiD7G45gHfEXqfHgx9lOABJvr/5tKB0l4YR56rjO5/ANPdWSgP4hVpgMgaqNGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVR9EehF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464A5606A320;
	Wed, 18 Nov 2026 22:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVR9EehF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F56D1F000C4;
	Wed, 18 Nov 2026 22:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039729;
	bh=M8T4p068WTNTMgZ7PttPKTKSts6A3azeSJdCWVmFKbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVR9EehFPEORruUot0zaZ3W7PBgu/QPzr+OLIZwQ7E1Ntzfskucz2pVVZ6tSUT7sc
	 YW9TZA1yF/+Co7mILq91G92LaAOgGYHZ6b6H6RbJT2MkqcHbgvGejbyVjGS0AAsWI2
	 UV+tNWdaEpT9Tp2jyrYBJBqK0D4nT2HBr6AlsjC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2204/3318] fs/ntfs3: update ctime only on successful setxattr
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118150428.045689499@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit bfa6296bb6a0e2333796a9507beb4605b92a9fdf ]

ntfs_setxattr() updates ctime and marks the inode dirty even when the
xattr operation fails.

Do that only on success.

Fixes: 2d44667c306e ("fs/ntfs3: Update i_ctime when xattr is added")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 1c18ab072987b..b36ecc7b9f23b 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -957,8 +957,10 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 			  NULL);
 
 out:
-	inode_set_ctime_current(inode);
-	mark_inode_dirty(inode);
+	if (!err) {
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+	}
 
 	return err;
 }
-- 
2.53.0



