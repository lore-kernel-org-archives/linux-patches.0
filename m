Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216055;
	b=jVzxhtukWKpBFzfISzUloGVtHhQDMdnwCTa4zJHyHlW39ywBXEczZy6fWJ+D9/CVSc5S
	 bPqkHIAiSLeneu1T9R45Sq+7zO7pswARZmNJjYtXzQzUNyftRDyqxG9+M1ZSlwf7/8z4d
	 vlsuDWzwQVQ3QrTYuV2ZJUbi5AjWWYmnD4vtCGlaXaELDU6uw+FaN7gtbbjszRCBIsegs
	 F7nMmYaVK+rJFCxQooeuOFB9cFddXrfOerLAq0Wpyf9/eVxjbRErQ07GobQm72s2jXrig
	 fbNVlYmxUxc76IrRL3YSC8hVipkx2QseFwyTv+Dft1BbDOVARUWoxmZyXqZsxOQLQyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rn8TR9u4g+HSU+ii36qmT6LQOehMlW7vm4lCqigfQ7A=;
	b=DkNIK0VtIefemEkhvqQs0GxhpM24uW4eTqLSMB7TMKaKuvO4a3RL83q27aZq78bPFXxY
	 ltyipjpjjey4xw09PqrdIu9rZWPi6ntU/jZpkoQv99Y2S3EcTIBnJUl6xTTLqiW9fhaDF
	 ShgsCg3vv5DfZThhsoVYKEhwK5y+lp45kKOWWXtDlMSKcQHtMagLZ0pVfEaLwrjjQWdSC
	 m/FAdlQCW/6FVrUi0u4nGKgZhGMxN/dZMc+ou4AqmUNgERg6KOFWLcjdOSStcd8aNVbWZ
	 qCh1TXb3A/y2VCDIZeoVl4pDHYMYR8RcBpiUYlJ9E1MWPXxfeIVP8CRIAI3LfEbOWBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOrN1r49;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7E606A31C;
	Wed, 28 Oct 2026 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOrN1r49
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650D61F01825;
	Wed, 28 Oct 2026 19:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216054;
	bh=Rn8TR9u4g+HSU+ii36qmT6LQOehMlW7vm4lCqigfQ7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOrN1r49rbHVzCy/Q5FmgFQat4gxpgxrsvS9o1Q6A3eUa83rVNOKR2ywwKlkkl1l3
	 Li6+qwxn4gLSEIcdWrjLpofk9LMdUvMrxVAQcUCtrP/gtIUivHipKHoM2q4qiuuACS
	 Ujol6MbH+gF1CmwczK6xB6z8bGVyMorC48EkWsUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1426/1887] ceph: cap delegated inode count in ceph_parse_deleg_inos()
Date: Wed, 28 Oct 2026 17:58:42 +0100
Message-ID: <20261028170531.909091550@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 4bd3158bd62466d57ed72a3f7bc5f205fedd6919 ]

ceph_parse_deleg_inos() decodes interval sets of delegated inode numbers
from an MDS create-with-delegation reply. For each set it reads a 64-bit
start and a 64-bit len with ceph_decode_64_safe(), which only validates
that the eight bytes are present in the message, not the value, and then
loops over len while inserting entries into s_delegated_inos.

len is fully attacker controlled. A malicious or compromised MDS can send
one huge interval, many intervals in one reply, duplicate intervals, or
repeated replies that accumulate delegated inodes on the same session.
The original code bounded none of these and could spin the insert loop or
grow the xarray without limit.

Bound both dimensions with a single enforcement point. Track the number
of delegated inodes held by each MDS session in an atomic counter and
grow it only in ceph_insert_deleg_ino(), which uses atomic_add_unless()
to refuse to push the count past CEPH_MAX_DELEG_INOS. Because that helper
is the only place the counter grows, the per-session population can never
exceed the cap, so no separate per-session pre-check is needed. The
counter is decremented when async create consumes a delegated inode or
when an insert fails, incremented when a delegated inode is restored,
initialized with the session xarray, and reset when reconnect destroys
the xarray.

A per-session cap alone still lets one reply spin the insert loop on
duplicate ranges without growing the counter, so also cap the aggregate
interval length accepted from a single reply. Together these bound both
the loop trip count per reply and the xarray population across replies.

The cap is a fixed, client-chosen constant rather than a value derived
from the MDS. mds_client_prealloc_inos is a userspace MDS configuration
option; it is never sent to the kernel client on the wire, and a
server-supplied bound could not be trusted for a defensive limit in any
case. The constant is set well above that option's documented default of
1000 (a generous multiple), so legitimate refill behavior is unaffected
while the CPU and xarray memory a malformed delegation stream can consume
stays bounded.

Impact: a malicious or compromised Ceph MDS can no longer make a client
spin through an unbounded delegated-inode interval or grow one session's
delegated-inode xarray without limit.

Cc: stable@vger.kernel.org
Fixes: d48464878708 ("ceph: decode interval_sets for delegated inos")
Suggested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 56 +++++++++++++++++++++++++++++++++++++++-----
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.h      |  9 +++++++
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 63c30ee31763e..77bb4f7ba937d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -430,9 +430,33 @@ static int parse_reply_info_filelock(void **p, void *end,
 
 #define DELEGATED_INO_AVAILABLE		xa_mk_value(1)
 
+static int ceph_insert_deleg_ino(struct ceph_mds_session *s, u64 ino)
+{
+	int err;
+
+	/*
+	 * Cap how many delegated inodes a single session may hold. This is
+	 * the only place that grows the count, so atomic_add_unless() bounds
+	 * it at exactly CEPH_MAX_DELEG_INOS; s_num_deleg_inos can never exceed
+	 * that.
+	 */
+	if (!atomic_add_unless(&s->s_num_deleg_inos, 1, CEPH_MAX_DELEG_INOS)) {
+		pr_warn_ratelimited("ceph: MDS session already holds %d delegated inodes\n",
+				    CEPH_MAX_DELEG_INOS);
+		return -EOVERFLOW;
+	}
+
+	err = xa_insert(&s->s_delegated_inos, ino, DELEGATED_INO_AVAILABLE,
+			GFP_KERNEL);
+	if (err)
+		atomic_dec(&s->s_num_deleg_inos);
+	return err;
+}
+
 static int ceph_parse_deleg_inos(void **p, void *end,
 				 struct ceph_mds_session *s)
 {
+	u64 msg_deleg_inos = 0;
 	u32 sets;
 
 	ceph_decode_32_safe(p, end, sets, bad);
@@ -449,16 +473,33 @@ static int ceph_parse_deleg_inos(void **p, void *end,
 					start, len);
 			continue;
 		}
+
+		/*
+		 * Bound the number of inodes one reply may delegate.
+		 * ceph_insert_deleg_ino() separately caps the per-session
+		 * population, so this only has to stop one reply from spinning
+		 * the insert loop under an attacker-controlled len.
+		 */
+		if (len > (u64)CEPH_MAX_DELEG_INOS ||
+		    msg_deleg_inos > (u64)CEPH_MAX_DELEG_INOS - len) {
+			pr_warn_ratelimited("ceph: MDS reply delegates too many inodes (have %llu, +%llu, max %d)\n",
+					    msg_deleg_inos, len, CEPH_MAX_DELEG_INOS);
+			return -EIO;
+		}
+		msg_deleg_inos += len;
+
 		while (len--) {
-			int err = xa_insert(&s->s_delegated_inos, start++,
-					    DELEGATED_INO_AVAILABLE,
-					    GFP_KERNEL);
+			int err = ceph_insert_deleg_ino(s, start++);
+
 			if (!err) {
 				dout("added delegated inode 0x%llx\n",
 				     start - 1);
 			} else if (err == -EBUSY) {
 				pr_warn("MDS delegated inode 0x%llx more than once.\n",
 					start - 1);
+			} else if (err == -EOVERFLOW) {
+				/* ceph_insert_deleg_ino() already warned. */
+				return -EIO;
 			} else {
 				return err;
 			}
@@ -476,16 +517,17 @@ u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
 
 	xa_for_each(&s->s_delegated_inos, ino, val) {
 		val = xa_erase(&s->s_delegated_inos, ino);
-		if (val == DELEGATED_INO_AVAILABLE)
+		if (val == DELEGATED_INO_AVAILABLE) {
+			atomic_dec(&s->s_num_deleg_inos);
 			return ino;
+		}
 	}
 	return 0;
 }
 
 int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
 {
-	return xa_insert(&s->s_delegated_inos, ino, DELEGATED_INO_AVAILABLE,
-			 GFP_KERNEL);
+	return ceph_insert_deleg_ino(s, ino);
 }
 #else /* BITS_PER_LONG == 64 */
 /*
@@ -852,6 +894,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	INIT_LIST_HEAD(&s->s_waiting);
 	INIT_LIST_HEAD(&s->s_unsafe);
 	xa_init(&s->s_delegated_inos);
+	atomic_set(&s->s_num_deleg_inos, 0);
 	INIT_LIST_HEAD(&s->s_cap_releases);
 	INIT_WORK(&s->s_cap_release_work, ceph_cap_release_work);
 
@@ -4220,6 +4263,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 		goto fail_nomsg;
 
 	xa_destroy(&session->s_delegated_inos);
+	atomic_set(&session->s_num_deleg_inos, 0);
 
 	mutex_lock(&session->s_mutex);
 	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index e7b0194724d78..428f4fd6cec2a 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -219,6 +219,7 @@ struct ceph_mds_session {
 	struct list_head  s_waiting;  /* waiting requests */
 	struct list_head  s_unsafe;   /* unsafe requests */
 	struct xarray	  s_delegated_inos;
+	atomic_t	  s_num_deleg_inos;
 };
 
 /*
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 62a691065292d..d2b49620f30c7 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -572,6 +572,15 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
 #define CEPH_MDS_INO_LOG_OFFSET		(2 * CEPH_MAX_MDS)
 #define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
 
+/*
+ * Upper bound on the number of delegated inodes a single MDS session may
+ * hold. The MDS normally hands out a small preallocation window (the
+ * userspace mds_client_prealloc_inos option defaults to 1000) and refills
+ * it as the client consumes entries. This leaves generous headroom while
+ * bounding the CPU and memory a malformed delegation interval can consume.
+ */
+#define CEPH_MAX_DELEG_INOS		8192
+
 static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
 {
 	if (vino.ino >= CEPH_INO_SYSTEM_BASE ||
-- 
2.53.0



