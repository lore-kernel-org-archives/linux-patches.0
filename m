Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213541;
	b=3CWTMwVKPsIQCl51DjVVE0y34AW6noja3qtb9zLZDdKp6FwgkmYDC8ByWZ6GAkKz0xGm
	 khjxBybJE1M2bwRroMwqt+ysx9vxmmXEKI9tpVqanhvdrIfGi2xwn853uegrslCfFhwjQ
	 0dJMwp5r+E0vSRQmnp+sZDS4J5Y4EC0hgjLoKi52RZXNrYc7bI4N+LPXgnQPGztxFjyZz
	 ubln6AchX1QYZ/4Xf5HnWWnB/b5euce5VR7GT1i7+KqizddeoxSyOlvwNfqRUcq8cDN1Z
	 nGY9d2ReIZZAQGEParHEfCWBLYBDEWq7qMibwi67nacq0nj9jKMcqMQBHyF5WPxL/vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1n4/yyqUVSR+RLPrMtSrtYYveCXVjSo2NhF+W+v7g7E=;
	b=FpKeFfdYs4shDQ6mXR96iwrrMjt8nXovdhzpDzoRp3BkcVkiAR1u8vY6uh37v0YreuTZ
	 K4mFnXDBQLEiR73LtHqxesDeuqXBMuHgPmzBk2PT4NiRHsOsQXW75ki5eyQXW3WLTq0Sf
	 +1GNql796gftkc5KtUp90QK3m9e22fHYO1fr0qkBefLT+KUf4urA9isl72xmk63Rs/xgv
	 Jle9kZ9cYxQhuvtgHjFAjx6TmajDmULqOb29CRoT77ZbTFs3ZgWMwjFXomJEx/C9RvUoT
	 M4IV6ysgAImTCS4sKboPOmvyc/MisaOd3eCAKWsN7vJ3mODuhCPsjzijG70HtsUbM2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZM3W8Coy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AD3606A31D;
	Wed, 28 Oct 2026 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZM3W8Coy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E87F1F031E1;
	Wed, 28 Oct 2026 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213540;
	bh=1n4/yyqUVSR+RLPrMtSrtYYveCXVjSo2NhF+W+v7g7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZM3W8Coy9XzZun3Dp/SbOrpe2PRJQQIw7mOjm5qdEiKwJI/i84vMpG3GO3muA7VvY
	 a9n9p88twGDb8Eeou7Apq52xnNiu4dWgoIGmUBBwfEvFJ6bjumQtEzLMzDpySR9H8/
	 e11D20s4igcYwTWgk9cRLtFk49697HCj3AayCdHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0543/1887] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Wed, 28 Oct 2026 17:43:59 +0100
Message-ID: <20261028170511.714402122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit b0d1022b9bdb1e98aa7fb3244fdd50a58c61766c ]

An immutable inode is never written to so write hints are pointless.
Refuse the hint on an immutable inode the way setattr(), fallocate() and
etxattr() refuse their changes.

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-3-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Moved the check from fcntl_set_rw_hint() to the F_SET_RW_HINT case in the combined fcntl_rw_hint() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 1bde178e4aa2e..13ba6b47877b8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -290,6 +290,9 @@ static long fcntl_rw_hint(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 	case F_SET_RW_HINT:
+		/* nothing is ever written to it */
+		if (IS_IMMUTABLE(inode))
+			return -EPERM;
 		if (copy_from_user(&hint, argp, sizeof(hint)))
 			return -EFAULT;
 		if (!rw_hint_valid(hint))
-- 
2.53.0



