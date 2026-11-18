Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036935;
	b=p+OEgFOsRkxqnw9riyAIhKUWhk2qsEtq8NHxvdr++0CaG78uK0x6RsOJoWZtBA2joZmd
	 YXt94/etEt/cve4NsOlkvc9in1yPPcJkFDJ6Il+vQwSH1NWlZYKxoUaSyRtY1XV7/ddWP
	 gny+/zukDx3t4l/6MQosyTPtpHPq6pzZHT7h8uzsONNJh8U7ZeerrFGdCJdKt+BHPoipf
	 L+vpeOV/DbmX41wSiN8/gvPHH8jFht7nCL4U6KuOLpF3J88dKzjwiWdqFjujAw/ZBsOkm
	 4Jhw/oTvtWXvF7C8FvVANsoA6l6F1Hy+YGoJNNoujErtpXGZ6lxrP/H6q+V/TpiEw7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HEmK/22qlykzJgeZSaURAoATSpEEOkwGiWeaNLxA0mY=;
	b=u2R0PkRDBa+tfdXTBInbDh3tqMEK/PIRosHZDow3d406dmO+g+gXapeOztc5ntrwFk4v
	 +2ZBmgqQxMb63CNec5RTRln++9NWAJ0LGWEDyiTxmp4X1EIxOpMAa0ULu624gQyX34JW+
	 Qe61MKuRcQwaRdsXhO0hd29Gnh4MvWq6WGnaU5LGOrNffxbbAER+Jd44mfWxuXW3Iyapg
	 YQlWQMnMAQ3HYwYL3NJdJKYMlDqBqlf0ANIxqSOqR/CTvTAq5autlNZHC0iSLApYEv94R
	 pTXBn2kIJCZzOX1yEu8Bsx5oRk/JHA4lpdOrQiBoU4u6SLgjH0naUIRBhpaGhZGKdgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzDBVK3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECFC606A31C;
	Wed, 18 Nov 2026 21:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzDBVK3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8BA1F000C4;
	Wed, 18 Nov 2026 21:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036934;
	bh=HEmK/22qlykzJgeZSaURAoATSpEEOkwGiWeaNLxA0mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzDBVK3ldNINR31gw6MME04T2nj6a4XAzbQ+/sUvvHlEX1oV8X+MQ8bVpaEQtipXw
	 C9gbuvS/Wo4tZrvBNt3zZAPz+8tX2MBjWX/D5Wirq9aDDbvJGGxM+kfISZ/qkk10VL
	 MELCr925aa4d9b+4wPOTwrP3BII9HifiRhznG84Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1234/3318] libceph: reject an initial monmap with no monitors
Date: Wed, 18 Nov 2026 15:30:56 +0100
Message-ID: <20261118150357.215786227@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 94dbce2ae4fdb57bdb53ffa3456da777a5cfb981 ]

build_initial_monmap() takes the monitor count straight from
ceph_options::num_mon and builds a monmap with that many entries without
checking that there is at least one. ceph_parse_ips() writes *count only
after it has parsed an address successfully, so a ceph_options that went
through a failed parse still has num_mon == 0 and the resulting monmap
has no monitors in it at all.

The first thing the client does with that monmap is open a session, and
pick_new_mon() asserts the invariant that it is non-empty:

  kernel BUG at net/ceph/mon_client.c:211!
  RIP: 0010:pick_new_mon net/ceph/mon_client.c:211 [inline]
  RIP: 0010:__open_session+0x60f/0x740 net/ceph/mon_client.c:245
  Call Trace:
   ceph_monc_open_session+0x46/0x60 net/ceph/mon_client.c:534
   __ceph_open_session+0x135/0x590 net/ceph/ceph_common.c:798
   ceph_real_mount fs/ceph/super.c:1173 [inline]
   ceph_get_tree+0xd98/0x1fd0 fs/ceph/super.c:1362
   vfs_get_tree+0x92/0x320 fs/super.c:1947
   vfs_cmd_create+0xd7/0x2a0 fs/fsopen.c:231
   __do_sys_fsconfig+0x55a/0xcb0 fs/fsopen.c:463

The reproducer gets there through the new device syntax: an fsconfig()
mon_addr= that does not resolve ("libceph: resolve '127.0.0.' (ret=-3):
failed") leaves fsopt->mon_addr set but num_mon at 0, so the "No monitor
address" check in ceph_get_tree() passes and the mount proceeds with an
empty monmap. The next patch stops that string from being kept, but the
assertion should not be reachable from a mount option in the first place.

Commit 40480eee361e ("libceph: Reject monmaps advertising zero monitors")
made the same BUG_ON() unreachable from the wire by rejecting
num_mon == 0 in ceph_monmap_decode(). Apply the same rule to the initial
monmap, which is the only other way one gets built, and fail the mount
with -EINVAL rather than assert afterwards.

Cc: stable@vger.kernel.org
Fixes: 7b19b4db5add ("ceph: new device mount syntax")
Reported-by: syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1dbed5969931c19d3eb5
Assisted-by: Cursor
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/mon_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 4fd4f2829eac3..68b83a3615a27 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1141,6 +1141,9 @@ static int build_initial_monmap(struct ceph_mon_client *monc)
 	int num_mon = opt->num_mon;
 	int i;
 
+	if (num_mon < 1 || num_mon > CEPH_MAX_MON)
+		return -EINVAL;
+
 	/* build initial monmap */
 	monc->monmap = kzalloc(struct_size(monc->monmap, mon_inst, num_mon),
 			       GFP_KERNEL);
-- 
2.53.0



