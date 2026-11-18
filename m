Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032884;
	b=E0QXb9HFxQwgjwpI1jZWd1bycMFsYWgpgg1BT8Sz72ILGuxTIZm9e6OxI505xg7Fc34z
	 L+xmyxVKhpO/YRKxJuovy20kfS8vtPA4siG0RuBicY93uKkPwOmym7KqmQjP2FASutUrz
	 tJguCp9Kqqc5uyF3U3Q/x/pcNgwToxevqgYOy7Y4s/lY8QuElyDdSwj8Ox+X4VOyNjLnn
	 dJMBUBMK3ubtlCIx7LUqONohh/Ld0rzgDj1G3AY7DzG0erUqaUFpIes42U+iNB/8dtoCE
	 9nOlJeAm3w2EFH6+G3JSUsCfEpCQUx0Gd3zufyHFCNQ5Nt4B7IyB0A8kIzYQOZnR1lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=05NCsv0ILN+R8ThnJmc3nr7a1PZ80CW6o763EqedaTw=;
	b=KtvuHKEuYHpnEOFcURnzH+982qwqPwHXsj/ovDpz+l7JqC57ZRZ3j3j+fE8i/7yOkb8r
	 RMxnJO6fFq8sxHDVIMjHm92jPdGm+auc/VgDq6nPHgvjScsbZH1OUdElPQ/L/FA0bbdrS
	 XVP4Ep0xgyMj1OqCnDxolNdi3bje8aoK5RThP+o2MPnIUH4nWcdpIxMrkRNKA9V2AxTCI
	 vRvwvlxh855ycmKs4hACkqruzl7yX0UjjJV+NfETC6tMoouFg7FvKanOmmf+eWqbhEtxv
	 xdzhxTZ+plm4goDZ+ChoF9JMWvMcHjfgaCKVUVsGuPIT6UqkQJj+3HIihVPKS4lEP+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QV4lMOqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DB460A261D;
	Wed, 18 Nov 2026 20:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QV4lMOqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECC81F000C4;
	Wed, 18 Nov 2026 20:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032884;
	bh=05NCsv0ILN+R8ThnJmc3nr7a1PZ80CW6o763EqedaTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QV4lMOqKJf87K33NLOia2WuPH1fhPELHZwfcYNgl1QAZsyme1KDOKnofqXgMBBQGM
	 HE6XmZjClYaoGQVCHD/dVWvpaQa0WbhHDf/7UyYyi9JvEgVsn8awnSZNHhM4fd+N9R
	 z5UheDi5urqAsw1TbLmEG5D7KMJ+lOSb2Cv8YeSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+b0f93e29183ce737@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1571/1756] ceph: fix off-by-one NUL termination in decode_encrypted_symlink()
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150112.282675203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 4da259ea8bf4bd6a91a63f33630a26592d2353f8 ]

decode_encrypted_symlink() allocates enclen + 1 bytes but writes the NUL
terminator at sym[declen + 1] instead of sym[declen].  A malicious MDS can
report symlink_len == 0 for an encrypted inode, and base64_decode() returns
0 for a zero-length input, so the store lands one byte past a kmalloc(1)
allocation.

Terminate at sym[declen], which is always within the allocation.

  BUG: KASAN: slab-out-of-bounds in ceph_fill_inode (fs/ceph/inode.c:996)
  Write of size 1 at addr ffff888020aad361 by task kworker/0:0/9
  Workqueue: ceph-msgr ceph_con_workfn
  Call Trace:
   kasan_report (mm/kasan/report.c:595)
   ceph_fill_inode (fs/ceph/inode.c:996 fs/ceph/inode.c:1277)
   ceph_fill_trace (fs/ceph/inode.c:1716)
   ceph_con_process_message (net/ceph/messenger.c:1424)
   ceph_con_v1_try_read (net/ceph/messenger_v1.c:1430)
   ceph_con_workfn (net/ceph/messenger.c:1576)
   ...
  The buggy address belongs to the object at ffff888020aad360
   which belongs to the cache kmalloc-8 of size 8
  The buggy address is located 0 bytes to the right of
   allocated 1-byte region [ffff888020aad360, ffff888020aad361)

Fixes: 79f2f6ad878c ("ceph: create symlinks with encrypted and base64-encoded targets")
Reported-by: co+b0f93e29183ce737@bugs.sh
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 32f612934f839..933ef43371eb9 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -965,7 +965,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
 		kfree(sym);
 		return -EIO;
 	}
-	sym[declen + 1] = '\0';
+	sym[declen] = '\0';
 	*decsym = sym;
 	return declen;
 }
-- 
2.53.0



