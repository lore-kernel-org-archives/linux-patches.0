Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063660;
	b=ViNonI4+hUU/n3OGSWWtXmfagMUElEvyXHfTGW37CBQqSVujpHj3FupgrLzKU5LjqRMm
	 +z3JS8WbU0K/m0rictionMwiIqVbMrxf0TkCpIY33n9mxlD0jrDJ8Nj6bHo15Et/HsW0J
	 NeuFTMqdHlBQjAwbbbW8E/pUlRIHt7DsIE9avI+KzuRN+LpyTU1WaMQ3xK5Cod92hXNTW
	 KJtjthlL0E316LLT+Aw3tsfKmpzQnfjnNvjz/8W+uWKUVHWg3GxSsk+uX2VLerFsO2zdf
	 xxX5ImNiJ7pIak/Jvth5AEn3K2PbVrqJJv1GSHmfs09jnSC7HIhoNBCjpXAL0KuNk2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8YLlhBhLV7mDQcs8MXjXo80cwHUjF6DuQqW2wnEj1pc=;
	b=lHrV/EKoCeX3Ah7C8Qqy6GT//nI/mkPgKzjxGTurk3u3wucCLNwmHkTZkujgxt6kaDkH
	 LvRqL1QaZPMdADyIF0hfkQH1+xm5ol8aiuIdOZoYoL40U83M8QpNfsRSVQ082Hqtx/wKW
	 bxiJuifnmo2n3pYeBIsxE5xRckEj1PfdXOzMqvSteUXg6KxIdaNHmADj9QLNfZf9wlcxJ
	 RTgQTd5KQ+hlQNdD8bPASsIKY/5gIRV8/w6+Pzo98RxI9Ja8d14Nr1PHZV8aKbUDfCnMH
	 HhAGIZuhabJgUiSGDWkSMcp+A9yFA3eMFDylRZEXkZifj3zLxXzuKDiogIjkLLvAQ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZrzY+RfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C411606A9E4;
	Sat,  7 Nov 2026 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZrzY+RfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0771F0089F;
	Sat,  7 Nov 2026 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063660;
	bh=8YLlhBhLV7mDQcs8MXjXo80cwHUjF6DuQqW2wnEj1pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrzY+RfOzB7d1ryMZWcTw0THsgzngt5LpRWKeK0wG7AWz8FNz8FwP6MU9LTfTXK3M
	 kW78/kVI0JHRuYSHSZ1lI8SP3L6l0yM4MRQzymnLfnwVLAjQTP6yjBYAeZ1as5k4fO
	 AbZugwC6s7cNflrMIYoFO4hoWC6O/HgD/A4q8Wqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 774/869] libceph: reject an initial monmap with no monitors
Date: Sat,  7 Nov 2026 08:57:36 -0500
Message-ID: <20261107134918.937487196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 614d2bba9fd60..a406fff75ba0d 100644
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



