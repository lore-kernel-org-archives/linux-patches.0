Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214533;
	b=n8q4DgDFnApm8YSbxjhmEt42UFCwcgNcdVzY3LzTDAFRxCxiAa4RCE7lBPd5NnCxwdeR
	 XFqlJfZXtHHwY8hA/cuV3qQhCa1BTqRzAnsLUKQj5MLJzBOXjUO0efM0OXFe5LvMXTvKp
	 oQu/HHNAlT23IhR3AegGVzTLuN8/sTTbPyzlHk+SI8vHYXJoUNCZFC4FRHgr3TQo5uBxJ
	 j5Am4jXlsQoMsZ2rTeUDpG/oa/kMUMoZ3xV3yG74LrubOsO0cFoS90nY9A6ht2AifSPcG
	 ZlubTlQpjTbb87JcnRbxThwCmd1qrJm3K2XZfmEOrTHKpdsyQc25C59pCc1tdGcy68Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xH41hfHfPjjK2ASV21Xnf3gV6fdtJwfGP7ioRIWyqe4=;
	b=2eborRe1MGJgYIVHOjEWXYSwFe4cr7jAhfU518grByE+70FCbyZ2h9cIghCirp/uPgR3
	 VSMYiqCK4N1LyJtaAqE8BeTAigzY609BcG7lf1mnbcpuoxUL3/idUi/zhaCR/eeNzrsy8
	 v1G1F7xs0vmXnIzem63DO/V8fQt8rgVjil5gWOPIOe7BfNYTsH4LuPICyx8DXVeldGNMh
	 gL3UG7e70hqn2HjunJc8yFG4HWNZm/2reNcbJ2+RBu77dkGuT9BsQdzHTkR6DciP4l+d/
	 kTz1ZOLpA82vvWxhIkXu5sJqP+Bceox9eUslYcp2QHciUh6U/d+j+s6VueTJNRKwOXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1TbXyS/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06A5606BFB4;
	Wed, 28 Oct 2026 19:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TbXyS/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7EC1F01829;
	Wed, 28 Oct 2026 19:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214532;
	bh=xH41hfHfPjjK2ASV21Xnf3gV6fdtJwfGP7ioRIWyqe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TbXyS/zwya14tut71IpxtWl41bwm5Cbp/5cXWjLuW/soy6zcWCx9hYrdzAmVLju6
	 +7DLcQ4iJec4xrTMMQl+Iq9pyi6cLUPQSo/aKHZtQEDPP7gQPHvbWO8Sc4ftRCTopb
	 wTw1mHZb1GR7nCFNXPyRtgcdq7lZoqDilzYuSvGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0891/1887] cifs: fix memory leak in smb3_fs_context_parse_param error path
Date: Wed, 28 Oct 2026 17:49:47 +0100
Message-ID: <20261028170519.694924777@linuxfoundation.org>
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

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit 7e4d9120cfa413dd34f4f434befc5dbe6c38b2e5 ]

Add proper cleanup of ctx->source and fc->source to the
cifs_parse_mount_err error handler. This ensures that memory allocated
for the source strings is correctly freed on all error paths, matching
the cleanup already performed in the success path by
smb3_cleanup_fs_context_contents().
Pointers are also set to NULL after freeing to prevent potential
double-free issues.

This change fixes a memory leak originally detected by syzbot. The
leak occurred when processing Opt_source mount options if an error
happened after ctx->source and fc->source were successfully
allocated but before the function completed.

The specific leak sequence was:
1. ctx->source = smb3_fs_context_fullpath(ctx, '/') allocates memory
2. fc->source = kstrdup(ctx->source, GFP_KERNEL) allocates more memory
3. A subsequent error jumps to cifs_parse_mount_err
4. The old error handler freed passwords but not the source strings,
causing the memory to leak.

This issue was not addressed by commit e8c73eb7db0a ("cifs: client:
fix memory leak in smb3_fs_context_parse_param"), which only fixed
leaks from repeated fsconfig() calls but not this error path.

Patch updated with minor change suggested by kernel test robot

Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index abd4f8587fd0f..bd19aab1f3c6b 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1511,6 +1511,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
  cifs_parse_mount_err:
 	kfree_sensitive(ctx->password);
 	ctx->password = NULL;
+	kfree(ctx->source);
+	ctx->source = NULL;
+	kfree(fc->source);
+	fc->source = NULL;
 	return -EINVAL;
 }
 
-- 
2.53.0



