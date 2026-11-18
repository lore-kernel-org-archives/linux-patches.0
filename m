Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024002;
	b=GPf5FZ2WD7mgGaBnbrBFFpq7U5RjKmiV2RNeXcy2jtgU9F4iGPc4AfeKwN7To1286XJW
	 8LnkRRyk1tClaKNPTrAT3N25oPQwdXhZ19VExXhvOUI0TZLFTwBHFqrzkQwfgv48lVxw/
	 HldcL7S/1xG6v6g/Q5PU/sOdWb+FyTV8ZZszT2K7x/jiDIpLGE4e0iX97IpK0PsEx4uXJ
	 Ca4QY8iC0s/OMLaq1vsWnpFQHcxrJVcsphFnx9QQh3o/e44mcnhafReKArdYkjSKgRWcN
	 wvGGR2ZOD1qgoAdoddfZTC7u8GLMJ7JjUWIZQo5F/7js/34AKzg2kwVotg1crv5ojOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=raeB7JnDFjwkzt2i9ojFuCLHcyyoJSOwVUXrDXKny7E=;
	b=MslF+9DiAHgLJAIwJGeEsTXbkznA0Bo6i7NgpCf+ghm22KMJHzMRIRDvtrYgdeOCGmfG
	 KkcckLomqW5FxfO+fBiYx9jVgizQ0qIENrTf40zr0F0kyJBPz9pQLD/9gsczCgxukBZ4c
	 6CQEmRSA+Jkg7DppEY9ycOc8m6lmDUOCrIA9SRnq4HfJTPEGYlbBWobGAwJi475Ik4IDI
	 LhtdJadf4SWhU9wU9YHG7hWYvbT9eGqVZ08ODGmrChRll4eSoLygJ1nd8PxDuwSdyt7mI
	 wRk0uJN1ccdmMhJpBQrAxVI1jBrYayGF3G9p84/LyuhWinSRBdNLvgNBINZjyhCKiRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVLDJoE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F864606A32A;
	Wed, 18 Nov 2026 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVLDJoE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BB91F000C8;
	Wed, 18 Nov 2026 17:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024002;
	bh=raeB7JnDFjwkzt2i9ojFuCLHcyyoJSOwVUXrDXKny7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVLDJoE9mjtjXX4pmjhxHYo7JjSlCBA8/ObQTzhZQFbat+8AYGstInlA70wP9bYMw
	 YB3N3CV5XVI25Z6HFlgBnU0m5Ex9aH9oD/kvs7BIi2gO4f9xLTU1g/jVMYROgF6HZo
	 h9wPqiYU+r0eq77Xb5ISFsbCih10rawTfhL+wQ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2ef75c54d0b2ac5d00ba@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0571/2151] md/raid5: give the io_unit slab caches per-array names
Date: Wed, 18 Nov 2026 15:38:26 +0100
Message-ID: <20261118150142.750008465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 96858e2308431ff5678e0e6fab1a06e19f3d95da ]

Both raid5 log backends create their io_unit slab cache per array but
name it after the struct:

	ppl_conf->io_kc = KMEM_CACHE(ppl_io_unit, 0);
	log->io_kc      = KMEM_CACHE(r5l_io_unit, 0);

KMEM_CACHE() passes the stringified type as the cache name, so every
array that enables PPL or attaches a journal asks for a cache called
"ppl_io_unit" or "r5l_io_unit".  With two such arrays live at the same
time the second one trips kmem_cache_sanity_check():

  kmem_cache of name 'ppl_io_unit' already exists
  WARNING: mm/slab_common.c:112 at __kmem_cache_create_args+0xae/0x460
   ppl_init_log+0x285/0x1310 drivers/md/raid5-ppl.c:1363
   log_init drivers/md/raid5-log.h:138 [inline]
   raid5_change_consistency_policy+0x255/0x740 drivers/md/raid5.c:9141
   consistency_policy_store+0x7f/0x230 drivers/md/md.c:5883
   md_attr_store+0x3b7/0x640 drivers/md/md.c:6158

which is reachable by any user that can write "ppl" to
md/consistency_policy on two arrays, and equally by assembling two
journalled arrays.  The cache is created and destroyed correctly on
every path, so this is a name collision only - duplicate names confuse
slabtop and /proc/slabinfo, which is what the check is there to catch.

Build the name from the array instead, the way grow_stripes() already
does for the stripe_head cache in this driver, and fall back to the
mddev pointer for dm-raid where mdname() is the constant "mdX".  The
buffer is sized like conf->cache_name[] because mdname() can return up
to DISK_NAME_LEN bytes.

The explicit size/align arguments keep what KMEM_CACHE() expanded to,
so object layout does not change.

Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging implementation")
Fixes: f6bed0ef0a80 ("raid5: add basic stripe log")
Reported-by: syzbot+2ef75c54d0b2ac5d00ba@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2ef75c54d0b2ac5d00ba
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260920091533.413-1-yogeshgaur.83@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-cache.c | 12 +++++++++++-
 drivers/md/raid5-ppl.c   | 12 +++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1f7bf680234d0..b3e2582a39d03 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3084,6 +3084,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct r5l_log *log;
 	struct md_thread *thread;
+	char cache_name[48];
 	int ret;
 
 	pr_debug("md/raid:%s: using device %pg as journal\n",
@@ -3123,7 +3124,16 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->flushing_ios);
 	INIT_LIST_HEAD(&log->finished_ios);
 
-	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
+	if (mddev_is_dm(conf->mddev))
+		snprintf(cache_name, sizeof(cache_name), "r5l_io_unit-%p",
+			 conf->mddev);
+	else
+		snprintf(cache_name, sizeof(cache_name), "r5l_io_unit-%s",
+			 mdname(conf->mddev));
+
+	log->io_kc = kmem_cache_create(cache_name, sizeof(struct r5l_io_unit),
+				       __alignof__(struct r5l_io_unit),
+				       0, NULL);
 	if (!log->io_kc)
 		goto io_kc;
 
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 2678e82bfa52d..9a58f0c19a39f 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1318,6 +1318,7 @@ int ppl_init_log(struct r5conf *conf)
 {
 	struct ppl_conf *ppl_conf;
 	struct mddev *mddev = conf->mddev;
+	char cache_name[48];
 	int ret = 0;
 	int max_disks;
 	int i;
@@ -1360,7 +1361,16 @@ int ppl_init_log(struct r5conf *conf)
 
 	ppl_conf->mddev = mddev;
 
-	ppl_conf->io_kc = KMEM_CACHE(ppl_io_unit, 0);
+	if (mddev_is_dm(mddev))
+		snprintf(cache_name, sizeof(cache_name), "ppl_io_unit-%p", mddev);
+	else
+		snprintf(cache_name, sizeof(cache_name), "ppl_io_unit-%s",
+			 mdname(mddev));
+
+	ppl_conf->io_kc = kmem_cache_create(cache_name,
+					    sizeof(struct ppl_io_unit),
+					    __alignof__(struct ppl_io_unit),
+					    0, NULL);
 	if (!ppl_conf->io_kc) {
 		ret = -ENOMEM;
 		goto err;
-- 
2.53.0



