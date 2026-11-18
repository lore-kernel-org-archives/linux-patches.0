Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021751;
	b=ZnI4OrdyD/P/+GFfuD5S5RWdUF4JXt4pwg7cZjE2T/Av39fSfKI40kz7G9nPTVIivSm5
	 d/3JQQtO3jWJdGPRTMIKfxBTOs4kkUyOtBol/uJdhkgGu5Yrmqg62DOdEpEiOwxPZ5alh
	 Wm6Qmv2Vt3PpzYzV7hcAe0msat1/VBRZttiteyieULjgswNcJj8Ip19L6r+AKZEzWllDi
	 ywZqUzE3LebqvGr5t2yWXxQocerYYXw+0YZ0vgUC7F/L+eNcBvYm/wiuBBpVyLi+3HqbS
	 lsTzcjOqwYGyaWzDkl5srf9rjDo78d2jtXAtdOpt5V9vEiPFrjOecwQtwDXT/R/IH8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lj+AoV2PYgA6EdDxzCGRminVjP9J4xACi/7HTY2gA+4=;
	b=Ev17xOOvdVwmtV3sw49qV4YbZvN/ZInCwKy4qVmbrefHnWnDJgZrtIAVVfCqNpQlSr+V
	 Rf46viVxsmR4isUax9a6byNXfiY18mEL9TjzgECJ/iHy3ZHnhpJpRUZ1DfZK6Nw5D9w0H
	 I9crBB1lI6hMKCgQjYwJimcRU5+3hAjmW2RoZCA6aEchk83JiwdbpsGnkTwTTKXYBGkpo
	 oGPDMyD/yhHyYhb93R5/O3smTIdbLi4hIRjz5i29kdFwcWPXdnyaa/kMoLf80/EYqzslI
	 g7GerlBdR8g0uWzctOupptz9w2pL8ORcpfyGZKmw5mNepJW+CtSqqe0g/B55yid1ugQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B56Y3j7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAC660A3804;
	Wed, 18 Nov 2026 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B56Y3j7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCBF1F000C6;
	Wed, 18 Nov 2026 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021751;
	bh=lj+AoV2PYgA6EdDxzCGRminVjP9J4xACi/7HTY2gA+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B56Y3j7Qjzs9Magvc5pjC4hckBxM9akbsc0talOY2Tg5OxNXcMhl1BGZQr4V2oRqZ
	 +IiGAJXsIfF2l4k/lU/bdh5t41OyI/mHW29Sj7rDCH1HnKOst1TLdYg2YMV/rzk3n+
	 FeMJmnkH8Q8raRAT/+lkBl8Mx9aJJCLVYUJy/zV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+b0f93e29183ce737@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2419/2651] ceph: fix off-by-one NUL termination in decode_encrypted_symlink()
Date: Wed, 18 Nov 2026 16:00:59 +0100
Message-ID: <20261118150412.346318302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index d52e2b389e0b6..79c4409f183ea 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -993,7 +993,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
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



