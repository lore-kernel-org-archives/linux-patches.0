Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062579;
	b=nA7v3olc63iuploRa1gSKhpgbi0OMrs6s8TLpittbaJFYr0NIR3sOc1RXr7w0H/iWDoO
	 C04gQFUt5JUqwLdhPPEx6cL1UWO/WWFyf2gvCwHV1uC5E2ZCNYLOGtXqaPofamNF3oLTE
	 2gzfhL2VuU0+xvBTPthldH1RewcK+H8hJxmS/D1Cfgb77Yb6+cfL280thAdtsdaBqDUxy
	 a1Nxnrr6vVgRSGDw/d2tJwGPFsGva95e5+48PS1aP2bi9FXacRwolCvj6I/SFsAMOU8Pp
	 PQW390UnlaZ+8b+1oIBLe52617LbrLmzv4D36GT03OE105J/crTQvTo11l/1eEtMdtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrWXbxtMuxaU4kkmFabHEbkspIU6Kr+GrPkrc9yJTTo=;
	b=j9BoiMB6h4l6IRtxcJFHM60ZvVHqAIG5H1LAvJhSwoJsi2N70nE+WeI629AApsIWqmFM
	 qlqucwXjI6VOChycfXNAFp8L9LlhxhUXJm8XRYtOhIxTlDV4C1UBQNlodd7xChAD5No/M
	 r7OV72zVeMrMT6Q50uJ+Svd804hN+AMpcnap2c8h53SsjB8DAwBDIYNLRoNa84fCfF1hx
	 WZhQgBMDpd7O1rC5rzSnN/x34umTqDh5kVNXWmfrKDgSp+mbLIAwbPCE/qrAGukP4885p
	 3zcG+JxTLM970pUSAsJR/ihrLsa9dozLDeDWgJ10Wl7sSXGRWC+iNkt/t1JdJyi5rWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dc4J5Vv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EF4606A66B;
	Sat,  7 Nov 2026 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dc4J5Vv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB151F008A1;
	Sat,  7 Nov 2026 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062578;
	bh=vrWXbxtMuxaU4kkmFabHEbkspIU6Kr+GrPkrc9yJTTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dc4J5Vv7gMKdsqmxPYPX6gc72d9ewafW7rn9OHb6HTQH40H26X/TuB6HFYTAVVG/1
	 8s56ulvjzeeDk9Sun327SZ71PMC5EvfPzIlUVuNQTuRX5EmroQVim+IVVQ0de5+Bq3
	 eO02MMcdOueaEeBe5F956YkCRC6O/kl6QPY49X74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1460/1536] libceph: reject mismatched CRUSH weight-set sizes
Date: Sat,  7 Nov 2026 08:57:56 -0500
Message-ID: <20261107135038.846589952@linuxfoundation.org>
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

From: Felix Hoffmann <f3lix.dev@gmx.de>

[ Upstream commit d8fc89b5bfe4cb3aebe4c8a818247d11291b841c ]

A CEPH_MSG_OSD_MAP message can contain CRUSH choose args with replacement
weight vectors for straw2 buckets.  decode_choose_args() validates the
optional IDs vector against the referenced bucket, but does not validate
the size of any replacement-weight vector.

The CRUSH mapper assumes that each replacement vector has exactly as many
entries as the bucket.  A zero-length vector for a nonempty bucket makes
bucket_straw2_choose() dereference NULL, while a shorter nonzero vector
causes an out-of-bounds read.  An authenticated monitor or OSD can deliver
such a map and crash a kernel client when it performs placement for an
ordinary request.

Reject a nonempty collection of weight sets for an absent bucket and
require every replacement-weight vector to match its bucket size.

Cc: stable@vger.kernel.org
Fixes: 5cf9c4a9959b ("libceph, crush: per-pool crush_choose_arg_map for crush_do_rule()")
Assisted-by: Codex:gpt-5
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 68bd45852fc37..e812b30778d57 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -378,7 +378,9 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 		ceph_decode_32_safe(p, end, num_buckets, e_inval);
 		while (num_buckets--) {
 			struct crush_choose_arg *arg;
+			struct crush_bucket *bucket;
 			u32 bucket_index;
+			u32 i;
 
 			ceph_decode_32_safe(p, end, bucket_index, e_inval);
 			if (bucket_index >= arg_map->size)
@@ -389,10 +391,18 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 			if (ret)
 				goto fail;
 
+			bucket = c->buckets[bucket_index];
 			if (arg->ids_size &&
-			    (!c->buckets[bucket_index] ||
-			     arg->ids_size != c->buckets[bucket_index]->size))
+			    (!bucket || arg->ids_size != bucket->size))
 				goto e_inval;
+
+			if (arg->weight_set_size && !bucket)
+				goto e_inval;
+
+			for (i = 0; i < arg->weight_set_size; i++) {
+				if (arg->weight_set[i].size != bucket->size)
+					goto e_inval;
+			}
 		}
 
 		if (!__insert_choose_arg_map(&c->choose_args, arg_map)) {
-- 
2.53.0



