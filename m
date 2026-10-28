Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214496;
	b=kIcHMvsUgIsE71D+x+Y0LEsocOoTGWFfj4oI7+nD7xuIL/4PU7LIkCs1nn+zj07wLS+M
	 ftKCqgT0n8ILxCIVqxdcFI1IDH3XSFm8eklB3Go7xE0BzvHjP0oZmVLs9OjXGsk2wHXyM
	 +UF3+zaObg23ZGdlJxEo8myD4dMQ3SrV72PXIv1TYWFIMidYmkw3hbEkusmUIl0lh1ZGy
	 rHMQ0AXTHEL77+9Ddr1hOIkvXn4bnoUm/E9C0niea3wlk79jnh5wH2Ne5d/A1jWBtrkr7
	 bHJMFNMyQdKvCzXeRymFygs89gS6ZeAizGeCt7yApKZBRLUjX5EJmrPBS/I+7o/tgPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kpw+6fm0DF83l95XuUoDt/lCfzXD7WYlAPyhCqy16IY=;
	b=ZE2Ptbk6Kf3jaWmyzIlbCUmSiYy/27Sif0puhW/nXRQvarGQO7a5th8ZgRRAH7lgi1mq
	 1BCetBmEvpBKvWH52wCufkRauSO7SXuK+rlOdKe4uZ3N73obtex+be5RI7XYT91frK/T5
	 GxYO8h45ZDJoxRxAqWAgddl85QWOagHFa6kLKh1BPESPhvW+9MP4FBi3lQX9SV1Lxq8E2
	 Oh7V7n8kynVGBDrLcl1vFWOkg8Aw3OZLRUxyxQiG0sNwUZuR7sap6tbca7BSCHAFJPi+d
	 30qcQe+MF7zTWo6fXBpOVzRVogDnGYjWpQ9jrmP2DEKNaet5mC2y7hrVd5s/ohish6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AguuxJ8I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC5606B7FA;
	Wed, 28 Oct 2026 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AguuxJ8I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2211F031E0;
	Wed, 28 Oct 2026 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214495;
	bh=kpw+6fm0DF83l95XuUoDt/lCfzXD7WYlAPyhCqy16IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AguuxJ8IzP8xNg4K7csHRE4Hr5bG63eKK8wllq4zl0/Y3mLRDEk2kXxUAr7zxA8v7
	 YC6ZrPMPZX5bJlwlbe58gq0kBcRerfrI+BcWTJOGjE0NX6XsW+2HTBbNAev+6aVMr/
	 s5xbjl12E0N1ba8anU5VoxfZ7hy/HoWmkYX8jops=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0879/1887] cifs: client: fix memory leak in smb3_fs_context_parse_param
Date: Wed, 28 Oct 2026 17:49:35 +0100
Message-ID: <20261028170519.420525981@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit e8c73eb7db0a498cd4b22d2819e6ab1a6f506bd6 ]

The user calls fsconfig twice, but when the program exits, free() only
frees ctx->source for the second fsconfig, not the first.
Regarding fc->source, there is no code in the fs context related to its
memory reclamation.

To fix this memory leak, release the source memory corresponding to ctx
or fc before each parsing.

syzbot reported:
BUG: memory leak
unreferenced object 0xffff888128afa360 (size 96):
  backtrace (crc 79c9c7ba):
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444

BUG: memory leak
unreferenced object 0xffff888112c7d900 (size 96):
  backtrace (crc 79c9c7ba):
    smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
    smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438

Reported-by: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72afd4c236e6bc3f4bac
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 35f2c94aafd14..abd4f8587fd0f 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1167,11 +1167,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "Unknown error parsing devname\n");
 			goto cifs_parse_mount_err;
 		}
+		kfree(ctx->source);
 		ctx->source = kstrdup(param->string, GFP_KERNEL);
 		if (ctx->source == NULL) {
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
+		kfree(fc->source);
 		fc->source = kstrdup(param->string, GFP_KERNEL);
 		if (fc->source == NULL) {
 			cifs_errorf(fc, "OOM when copying UNC string\n");
-- 
2.53.0



