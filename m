Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050501;
	b=Ht/Ztjl79wbEgJtoov2fBbXv+508OsjYhGfmU2Sno6WQ0gpY9QxrfIXkZenKJVTVHzJn
	 OghapThTqS2cw9Mt7u0zPo2NSLwRUNVvyd4nIjEblnSMoZsczgdssnH7Lbdjvs02OW45P
	 dw3ec6mqYUJIOlH7nRwgYwJs9WrnbLzXoKVoZeuWfx4wAXMx7+YuiUJDMZc9A5Nd0F/9z
	 0C7ExbWDIxiFF1VTzfP9Dc9RW8QIlJjtIIsYbnOA1v3br2fRVe/gKbmDDgN+O6LvS444f
	 3fCp0ljctUtpbdN9BnjxtMF6hzUDyuUrRc2VAm6Yt4CSCPU18ZIlB8m/GUvTaqOWCkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BKAyhoJavYmxWZ8xVhCztxkENqe9Z/7fsOMb9cLRk5k=;
	b=JPPvK+HElIA0edl3J6WjT7tpjo5mlysbNm1EwJZ4gyPp39q1EFY8RQ5p9jXDujUS92Qu
	 IpUC5c8QYvIEQ0USS9wC1NH7ii4PGaiiqw3LaQ5+xb4lwh0TB26thflZi2+uUG6wGX4qB
	 Bq2RVDiT23fUQaE4RRpRyQgIwji1GRhA+KDDyeRkhfP44VwsfSXUGYi/yF6Dz1cvnMmmp
	 BGamng9J0i8EGCi57a9dPqGtPZxafmc20FnFZzq7waBI7k7Rg8ndK4fNyZu0+5PR6jFE0
	 Lrsz9reEe80QbrLC6RfAMzX06Y8C3hKislTniM+8ODSDY0xajubiOIxx110qBBccy+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5sEVxtb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E5606A320;
	Thu, 19 Nov 2026 01:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5sEVxtb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AAD1F000C4;
	Thu, 19 Nov 2026 01:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050501;
	bh=BKAyhoJavYmxWZ8xVhCztxkENqe9Z/7fsOMb9cLRk5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5sEVxtbxzVSt8TmL9EcBqjoMTo62MReN6et0Tvp7wU/uPDJb+2alYkAq1N6dHzDm
	 73hC0b+tEeIavSWZ8wON5lfLU+3O9/Oh+ZTH1iOaN/mOY1u0ZW9gyC1Jt+W9J/HmWM
	 pn5QdTMMxYr0S8d0whLdDGjGAqsoP3wI/dp4oFEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2730/2857] ceph: dont keep a mon_addr string that failed to parse
Date: Wed, 18 Nov 2026 16:02:44 +0100
Message-ID: <20261118150339.915988014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 6c82bff8561f4c20dc0113f81cb2f6e6e2b4cf70 ]

ceph_parse_mon_addr() stores the string in fsopt->mon_addr before handing
it to ceph_parse_mon_ips(), and then returns that function's error. So
after a mon_addr= that does not parse, fsconfig() reports the failure but
the mount context keeps the rejected string.

That matters because ceph_get_tree() uses fsopt->mon_addr as the "monitor
addresses were supplied" test:

	if (fsopt->new_dev_syntax && !fsopt->mon_addr)
		return invalfc(fc, "No monitor address");

Userspace is free to ignore the error from fsconfig(FSCONFIG_SET_STRING)
and go straight to FSCONFIG_CMD_CREATE. The check then passes on a value
that was rejected, and the mount continues with ceph_options::num_mon
still 0 - which is how syzbot reached the BUG_ON() in pick_new_mon()
fixed by the previous patch.

Parse first and commit only on success. A failed mon_addr= now leaves any
previously accepted value in place instead of replacing it with one that
does not parse.

Fixes: 7b19b4db5add ("ceph: new device mount syntax")
Reported-by: syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1dbed5969931c19d3eb5
Assisted-by: Cursor
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 77bd924228279..e5528d8653aa1 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -391,13 +391,18 @@ static int ceph_parse_mon_addr(struct fs_parameter *param,
 {
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
+	int ret;
+
+	ret = ceph_parse_mon_ips(param->string, strlen(param->string),
+				 pctx->copts, fc->log.log, '/');
+	if (ret)
+		return ret;
 
 	kfree(fsopt->mon_addr);
 	fsopt->mon_addr = param->string;
 	param->string = NULL;
 
-	return ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
-				  pctx->copts, fc->log.log, '/');
+	return 0;
 }
 
 static int ceph_parse_mount_param(struct fs_context *fc,
-- 
2.53.0



