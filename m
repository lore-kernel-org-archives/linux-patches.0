Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922B1274B39;
	Sun, 24 May 2026 10:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779620022; cv=none; b=RYX/WtWktoJnJ/0SubiUAnFganEfxdTERTJ6H7dKSOx9GVpsWwf0cEHCPry2lApRlDDQhQaLQu/iB9OvdJdaH6x/ZF4vo6geP6N83Dc1U2dt2rE/pf2G8okQ81DRo4U8tn6HcdwOH8PgYBi3EHXVgDL7p725MtJ9nkRfAedxN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779620022; c=relaxed/simple;
	bh=ENFncFyeXcwIrdxcdDsY13sreIEZseI5yxq9k84jnvY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=l/wWrgxoJEmGDZTbB2anD24hFBNRs2MS0Jh9sMs/iqUhXt0jTpqLNCGe6644F3GD+EohpCfke+UpzFVr1FUZC238MaCSjARsY64AnKhQbXgsCvIf1sDHygZnh8AjdHAIdVDCxldHAoaak7pQYuolsG0mjzX296BjwzABguBxRP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=FqrUiUhi; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="FqrUiUhi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fAWMcU92HgG7+vOjjnyRXeJtYtmkx/dVf7qKqMX7lY8=; b=FqrUiUhiLvJl0UvhE6FrTrJrFS
	WbTDTHFU21MUbDVkDRL2o+kcy0qZ0BziKZDovK/TkEo+wuHDaNYl1UWLYguoJfrbiWoLtq1UUNemX
	My7CcxOi6p95dyBm4pwjtGdsunL6HkzjdBwpWJzAgM0MmF818RwW9molytqCUkBGj1olcxmrvw7BY
	rIIY/Nt91itzorrHowm77yWuUb2uFFU3/n7KHFvv4FpaHFoRsKogocNw/BgFhvKMqttdtUs2XVv65
	SaQ+LYs1HeCLD+5NjxlsmL3RCb4llNcTzDh+mjoZV44/xb4bpDfzrZ3VUPC5g5R+3TspDxj6XW0Kw
	o8V3wzRg==;
Received: from dsl-196-116.bl27.telepac.pt ([176.79.196.116] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wR6SX-007Cou-3P; Sun, 24 May 2026 12:53:29 +0200
From: Luis Henriques <luis@igalia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  stable@vger.kernel.org,  patches@lists.linux.dev,  Miklos Szeredi
 <mszeredi@redhat.com>
Subject: Re: [PATCH 6.18 346/957] fuse: new work queue to periodically
 invalidate expired dentries
In-Reply-To: <20260522123641.rc-drop-ab84ad597386@kernel.org> (Sasha Levin's
	message of "Fri, 22 May 2026 09:12:26 -0400")
References: <20260520162134.554764788@linuxfoundation.org>
	<20260520162142.034488466@linuxfoundation.org>
	<CAOssrKcqmVW3kJ131tRF3LCJVQUtdRB31B5HENDfpgrq6r=jEA@mail.gmail.com>
	<20260522123641.rc-drop-ab84ad597386@kernel.org>
Date: Sun, 24 May 2026 11:53:22 +0100
Message-ID: <87se7h6pul.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, May 22 2026, Sasha Levin wrote:

> On Wed, May 20, 2026 at 08:45:09PM +0200, Miklos Szeredi wrote:
>> This is not stable material, and I don't think the dependency is real.
>>
>> Just need to resolve the trivial conflict when applying 5a6baf204610
>> ("fuse: fix uninit-value in fuse_dentry_revalidate()")
>
> Dropped from the 6.18 queue along with the following Stable-dep-of /
> Fixes-of patches that no longer apply without it:
>
>   - dcache: export shrink_dentry_list() and add new helper d_dispose_if_u=
nused()
>   - fuse: fix uninit-value in fuse_dentry_revalidate()
>   - fuse: fix race when disposing stale dentries
>   - fuse: make sure dentry is evicted if stale
>
> If anyone wants to send a backport of 5a6baf204610, we can apply it.

Below is a attempt at the backporting.  I had to enable ->d_init/d_release
operations unconditionally, so that dentries d_time could be initialised.
(Maybe d_release could be left out.) It doesn't look pretty, but I guess
it's the solution closer to upstream.

Cheers,
--=20
Lu=C3=ADs

From 3000e3b879f66afb47d22f360567c546ca9214ad Mon Sep 17 00:00:00 2001
From: Luis Henriques <luis@igalia.com>
Date: Mon, 16 Feb 2026 14:48:30 +0000
Subject: [PATCH] fuse: fix uninit-value in fuse_dentry_revalidate()

commit 5a6baf204610589f8a5b5a1cd69d1fe661d9d3cd upstream.

fuse_dentry_revalidate() may be called with a dentry that didn't had
->d_time initialised.  The issue was found with KMSAN, where lookup_open()
calls __d_alloc(), followed by d_revalidate(), as shown below:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
BUG: KMSAN: uninit-value in fuse_dentry_revalidate+0x150/0x13d0 fs/fuse/dir=
.c:394
 fuse_dentry_revalidate+0x150/0x13d0 fs/fuse/dir.c:394
 d_revalidate fs/namei.c:1030 [inline]
 lookup_open fs/namei.c:4405 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x1614/0x64c0 fs/namei.c:4827
 do_file_open+0x2aa/0x680 fs/namei.c:4859
[...]

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4466 [inline]
 slab_alloc_node mm/slub.c:4788 [inline]
 kmem_cache_alloc_lru_noprof+0x382/0x1280 mm/slub.c:4807
 __d_alloc+0x55/0xa00 fs/dcache.c:1740
 d_alloc_parallel+0x99/0x2740 fs/dcache.c:2604
 lookup_open fs/namei.c:4398 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x135f/0x64c0 fs/namei.c:4827
 do_file_open+0x2aa/0x680 fs/namei.c:4859
[...]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

Reported-by: syzbot+fdebb2dc960aa56c600a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69917e0d.050a0220.340abe.02e2.GAE@googl=
e.com
Fixes: 2396356a945b ("fuse: add more control over cache invalidation behavi=
our")
Signed-off-by: Luis Henriques <luis@igalia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dir.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ecaec0fea3a1..1bc6982b5d6a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -283,21 +283,33 @@ static int fuse_dentry_revalidate(struct inode *dir, =
const struct qstr *name,
 	goto out;
 }
=20
-#if BITS_PER_LONG < 64
 static int fuse_dentry_init(struct dentry *dentry)
 {
+	int ret =3D 0;
+
+	/*
+	 * Initialising d_time (epoch) to '0' ensures the dentry is invalid
+	 * if compared to fc->epoch, which is initialized to '1'.
+	 */
+	dentry->d_time =3D 0;
+
+#if BITS_PER_LONG < 64
 	dentry->d_fsdata =3D kzalloc(sizeof(union fuse_dentry),
 				   GFP_KERNEL_ACCOUNT | __GFP_RECLAIMABLE);
=20
-	return dentry->d_fsdata ? 0 : -ENOMEM;
+	ret =3D dentry->d_fsdata ? 0 : -ENOMEM;
+#endif
+
+	return ret;
 }
 static void fuse_dentry_release(struct dentry *dentry)
 {
+#if BITS_PER_LONG < 64
 	union fuse_dentry *fd =3D dentry->d_fsdata;
=20
 	kfree_rcu(fd, rcu);
-}
 #endif
+}
=20
 static int fuse_dentry_delete(const struct dentry *dentry)
 {
@@ -331,10 +343,8 @@ static struct vfsmount *fuse_dentry_automount(struct p=
ath *path)
 const struct dentry_operations fuse_dentry_operations =3D {
 	.d_revalidate	=3D fuse_dentry_revalidate,
 	.d_delete	=3D fuse_dentry_delete,
-#if BITS_PER_LONG < 64
 	.d_init		=3D fuse_dentry_init,
 	.d_release	=3D fuse_dentry_release,
-#endif
 	.d_automount	=3D fuse_dentry_automount,
 };
=20
