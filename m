Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062301;
	b=OHj13Pw+74oj4DKa2OdDzNHCuu4NIRMe1CPng15ot2C1B7NjpZu0vXEcx68TpRd/7CQL
	 40/xoyY4i6DZUQ4qw/UT+N5rWhJzkKF5npdZfBZVMDGZpd2GJxN6T5HIDDjvMGG3PXUCM
	 a4DaFnO3CnoS3aG0CXHuW2tIhG6cU+Tuqlz3SsUy8zQWQ6P6atcx439VYRqA37Rke3Ybh
	 8MdpV6vIJhYQzTISUdtIQ+Yy84zBXkpnTC5C5AZDaQvhKrXSJb8EPvH2eH+I/ZH8NeJDx
	 PeHcg35oh4npoGs5pWgl4Wl/3uoD9q7nmaF+w3ZrM+coaBTVdakhtwE7EIq+qEIDXyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5q8NN5XiTRstvtd8fdW8oDCL2hjfju98t2HL0uaUUQ=;
	b=V0sqmfGzgetHlyBuSrg/Ttw9e8RlxigsJ74K/bXaYlGpDYHKO0+zDbI3Fz0+fDnEHxlR
	 Uq5+sNVn5Vrq2PrDIecLnvVBN/i+n6X+zU5UP3w4jsvk746JZDwlRnaxgY2r6SUjhAa7U
	 Hn9PVTgijyD0WtHUKbyX04lOMWwzBLwptyE0oSRVwG95m/xF4flcqTPdobtT3miJUyCFE
	 nzJOfeXrBDNSR8Mer5de64JtZ/FMcFXXJrx4E5Q6cAzPZW2fKv0A6yruaZRU6Ud6w7EtD
	 X3iY6jihm+RxnH3QzBIwA22fZ+1Tp8yYrFjouqzs4NIrMBNKBJs3x1+ZpMybMjHBb2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWAc46DB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F7606D818;
	Sat,  7 Nov 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWAc46DB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82B91F0089F;
	Sat,  7 Nov 2026 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062301;
	bh=U5q8NN5XiTRstvtd8fdW8oDCL2hjfju98t2HL0uaUUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWAc46DBPvL/Znm4HnyVKxHe72Zp07tiFwgqPLNbPjEj22n/eoky81Lpzl4ICR75P
	 oNuAeh/fx9uU4zTU6LuD2T/l7FZtxIoB4fqRtW7SZTZkjlavsneGHZiJl9yJry1fxF
	 O9Sgm7BMBbQZuMtynPZc8xUGUYDJvbesTsuic+ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com,
	Yu Kuai <yukuai@fygo.io>,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1199/1536] md: dont hand out the array before md_alloc() has added mddev->kobj
Date: Sat,  7 Nov 2026 08:53:35 -0500
Message-ID: <20261107135031.426135473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit d1472ca2ca5de8ecd2b358411eb14c031404ecf0 ]

md_alloc() publishes the gendisk before it is done setting the mddev up:

	disk->private_data = mddev;
	...
	error = add_disk(disk);
	if (error)
		goto out_put_disk;

	kobject_init(&mddev->kobj, &md_ktype);
	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");

add_disk() makes /dev/mdN openable.  mddev comes from mddev_alloc() and
is zeroed, so anything that gets in between add_disk() and kobject_add()
sees an mddev->kobj that has never been through kobject_init() - no
ktype, no kref, state_initialized clear.

syzbot opens the array in that window and issues ADD_NEW_DISK:

  kobject: '(null)' (ffff8880120640f0): is not initialized, yet
  kobject_get() is being called.
  WARNING: lib/kobject.c:642 at kobject_add_internal+0xea/0xcd0 lib/kobject.c:225
   kobject_add_varg lib/kobject.c:374 [inline]
   kobject_add+0x163/0x240 lib/kobject.c:426
   bind_rdev_to_array+0x80c/0xdd0 drivers/md/md.c:2621
   md_add_new_disk+0xe3b/0x1850 drivers/md/md.c:7684
   md_ioctl+0x200a/0x2610 drivers/md/md.c:8499

bind_rdev_to_array() is not the only way in.  md_run() calls
sysfs_create_group(&mddev->kobj, &md_redundancy_group), and
internal_create_group() has its own WARN_ON(!kobj->sd), so RUN_ARRAY in
the same window warns too.

Every ioctl that can reach mddev->kobj runs under reconfig_mutex, so
hold it across add_disk() and kobject_add().  An ioctl issued in the
window now waits for md_alloc() to finish instead of seeing a
half-built mddev, and opening the array still succeeds.  The ioctls
md_ioctl() serves without the mutex only read array state and return
-ENODEV on an array with no disks.

Hoisting kobject_init() above add_disk() is not an option: commit
ca39f7502425 ("md: fix mddev->kobj lifetime") moved it below add_disk()
so that md_alloc()'s error paths, which free the mddev directly, never
see an initialised kobject.

Fixes: ca39f7502425 ("md: fix mddev->kobj lifetime")
Reported-by: syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6aaf3284.514bccd6.255447.0003.GAE@google.com/
Suggested-by: Yu Kuai <yukuai@fygo.io>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20261006122904.1538-1-yogeshgaur.83@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4c17608e066dd..e54fe6f3319a8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6010,12 +6010,22 @@ struct mddev *md_alloc(dev_t dev, char *name)
 
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
+
+	/*
+	 * add_disk() makes the array openable before mddev->kobj exists.
+	 * Hold reconfig_mutex until kobject_add() is done so that ioctls
+	 * issued in between wait instead of using an uninitialised kobj.
+	 */
+	mddev_lock_nointr(mddev);
 	error = add_disk(disk);
-	if (error)
+	if (error) {
+		mddev_unlock(mddev);
 		goto out_put_disk;
+	}
 
 	kobject_init(&mddev->kobj, &md_ktype);
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
+	mddev_unlock(mddev);
 	if (error) {
 		/*
 		 * The disk is already live at this point.  Clear the hold flag
-- 
2.53.0



