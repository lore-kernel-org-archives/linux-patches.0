Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065431;
	b=3gHyFmFVXsxAjXYY6OLJuy1qH7MH2uiHam+25WDieQlMvAwFTgNVmDOmd9QpjIZPIFn6
	 ddf60jx0K6bH3DS0VxmCjePrgFhc2loCst41UTbAO1x7kjqRcK79nywP9WGBFitSgmhXE
	 DxX7bA1HKWIZrAM4dm45sXLE28YgI8trLyF8IJIim7H7MzoPXN34BQLl64WQhv+rUCv6T
	 Gcd50cesMWTbpCjogQR8kUrVtvtxDiIU9NyiUM5JQZlAPP4j4SZ3fxwRwEBeveVq+mV0x
	 3/fsxHDyiBLUpZh0tm5VcVJmDm7xADO6V5RzigHcatNmAl7xl5RdZ+o+0M9UAnZdb6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Zr/Hm3oaVewKJBUBXtLCcBc3UDbG/qj/LnY/uRBU6Y=;
	b=gIY5tr6F7bsO+37Hs+xpeLmW2iPkWpxw/2IPnGvsWnwpVvWTMaCSl0nYWLWMeWT/gqVG
	 lT5U3Sc2reaWsL2SRcH1G/S6yrGbkKDHEHvifDctzc6gLugIuBz/u4Q3tieSMrSe5agzp
	 A5KmXct7yB9bDuJnWiqzZ6uxY7yXO6ej/6pIWTKkiyvtL2BotxdWsqR8qLpYRJB98iPC4
	 Sn9tWLVv2rm8sklMZd5p5QuKirKya0bizxAfnjUcH7WGstX7TrRbATXUZdrdmiOvEUF22
	 0Uoi2lozSQXPvuyiSgWnm25P1UaTFdke894Q6CK26mrqwS4PfCA8Kh6WIDVRaN2tkVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXhYVhsV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F3F606D813;
	Sat,  7 Nov 2026 15:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXhYVhsV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E211F0089F;
	Sat,  7 Nov 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065430;
	bh=1Zr/Hm3oaVewKJBUBXtLCcBc3UDbG/qj/LnY/uRBU6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXhYVhsVcbUMYrj6f7OyqWWkLy9FsEy4U2cZwwkCo54w0CJ7ZWX4HmXCpv4O874uu
	 YWNq67VYPTNgTWvt6EbHp0BC+Lpb/1GdnpJbG1jGRngFktswfYNyF++BIecBZ8Y6mc
	 rGT9zCp1iqMV1f4bfVSivpHz6J/GIPxLR1jU7pqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1123/1257] libceph: reject an initial monmap with no monitors
Date: Sat,  7 Nov 2026 08:56:59 -0500
Message-ID: <20261107135010.255373253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 59b304eca2732..2f0181b2566dc 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1141,6 +1141,9 @@ static int build_initial_monmap(struct ceph_mon_client *monc)
 	int num_mon = opt->num_mon;
 	int i;
 
+	if (num_mon < 1 || num_mon > CEPH_MAX_MON)
+		return -EINVAL;
+
 	/* build initial monmap */
 	monc->monmap = kzalloc_flex(*monc->monmap, mon_inst, num_mon);
 	if (!monc->monmap)
-- 
2.53.0



