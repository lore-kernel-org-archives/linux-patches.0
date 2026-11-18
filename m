Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045799;
	b=LCWI9OI4vo481g8rPN83uiFP0RNYTTnZdvse0g8AMMxO8hTNoUBaIbvv4S8ov20sRLB2
	 o83jztfXkhH8j7UEbRNAD6QtqK7BRHfuRy59LwIeZCmUpoyMWNpGTAu7CpUtW+2N6GG4O
	 9XKozrPkXwv/sSdKSAfjcN8xoA9taWASk4TRiq7asMQwi/QzpTporgCFes3eR/N1UzinE
	 pr966+MGT3C6Ertlh0ydpNPau1GIzbHI2CaPdJ1UoUKoP2d0pu9a0Ts7yWvRNrqbR1oTy
	 YIOshwd5dMUOvQQw5t4wa4ZAgx+YtXNQy6Vgs7nwtV4xv9X6x2Uxj4GFDzPoq4fR61A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3utdxx372rhk2k8MmuXyxkAfojSbuGmN5cuWnayeDI=;
	b=gHtayw5Ysrlg4LomH+R2hk4Q43zwszHf0br9Y2jCi+lsDxKG/DWicB0GOCuj/FoNV/6i
	 Vk0AC/MFGBjQrC3sjSsTrzJrxxYBcNCVCcpKXYCIIHuV9o7UmU2Xp2/1kIMH3nkCOdlaF
	 kGQYMBbVea1ASPMI+OOQTUzsvYMg/cR4Sn9KyqRw0R9j/4mo6//alO0T8qcEcd1qOUrzA
	 Tc2/Ny4y+RuwFKBtTkegj4WBBh748qm+Bsm/mwWA63YxLb5e2k/nBj8cDc+FNvHJo7Jln
	 x/fT14iNVtHODyNRlla0qK8YGIXctPWQdgWivK5QXkYK8nuFFBXT+HEZolMPfW8jdDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxYETiJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C055606A325;
	Wed, 18 Nov 2026 23:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxYETiJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593551F000C4;
	Wed, 18 Nov 2026 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045798;
	bh=p3utdxx372rhk2k8MmuXyxkAfojSbuGmN5cuWnayeDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxYETiJ3IFLUHMOQ30HHQNYvWw11M81gir8wRX6InWzgf3qSiYbY1YUF33jIBkO/Z
	 KV846nbmyD2KzrVxz3/6voMLMpzV87EkLH1sN3eYOnzk8sd3LMOORoOh9layr/pE0Y
	 YG8XmBWks+07frpimbkMm0Umr8pvO//7bkaJSXL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1052/2857] libceph: reject an initial monmap with no monitors
Date: Wed, 18 Nov 2026 15:34:46 +0100
Message-ID: <20261118150239.470793340@linuxfoundation.org>
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
index 88d76ebfff4c5..a53a320045f6e 100644
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



