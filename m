Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045384;
	b=FXY4hFkYb4oK6F/yVOQR/2Bkkm/ECF6GaECtpvM14mPVal0vO1f+XTjUfySlG8Ubs6nQ
	 cwhxzgoLVwxF6+ip4sLmfQtt8kU7vxVW3woMtR1bofRKzIRJDV4q4NbFOwUyqEn9ppS14
	 t4CmOwhLI4e53IeVYNwss6gpU6ibn2C3UM6ETvc0Wa/fQ5zGBkrtxor3oeqWDGok0Om/c
	 /OGXKCmBpem0uBQtoQHGvf9g2wIqPSosobru65u0cKTfTwpRmjNFKWTA2bgwZQ/dgcyC7
	 b+64QxGeX1hO3YQcBeKmh6v1s40wJZA0CaAeItbWGmv507xGGGGH3hcF69kE/8k0fGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9qRShj3sxy6NLepRSIGiGJmdVIsS2X47ckacVDXWN00=;
	b=TpbaE40H60yWZ1tmWnPL83ip0NbTlQ5OfvIlUwN6eMT+HV0bIb1nVaWHEPRmOknngLNu
	 c12ES0R5lwFxyaGKBIuZHbXKQ0elaQWvxaDUqVOVmgn8atcL0H3hiFraxLQF/BVGB/0Ei
	 mUgM49comm3L41G24u6+Szf6FVfGKtHi1iIl6R8lioPASoSCeRKxFGwQ8XvW2neq7YWiA
	 HXnsQSXHJPY3ulBn9o6C6f6cPtWahSyEZL0CRnyBGxilX02h4dSEFumAQCRseKK2QXY7E
	 TBPKqit3Fvr2wBuKz5kyaL4mtzUhRoOXFHyqtlu0cYEYdIIahMJIX4HiYMMz15JgJ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7L0jBRL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D25A606A32C;
	Wed, 18 Nov 2026 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7L0jBRL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765FA1F000C4;
	Wed, 18 Nov 2026 23:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045384;
	bh=9qRShj3sxy6NLepRSIGiGJmdVIsS2X47ckacVDXWN00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7L0jBRLI0vzvxETK/uZnuMADAuXsHjF69kufkXBavh0KYcHFNWFukXU4xfg8UZty
	 TViyvVmQjErwV0oyqTDmeydK46/ftkHTyNpjxMv5q8MBWYJDqOLpUaPQ2qcWn+A801
	 2ystlZnh15HV6Gc49RNAlJKu1XGShs5XWPQ5jQnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com,
	Yu Kuai <yukuai@fygo.io>,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0905/2857] md: dont hand out the array before md_alloc() has added mddev->kobj
Date: Wed, 18 Nov 2026 15:32:19 +0100
Message-ID: <20261118150234.152137294@linuxfoundation.org>
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
index b60321f1e808f..9aa635e289c3a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5766,12 +5766,22 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	blk_queue_write_cache(mddev->queue, true, true);
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



