Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027987;
	b=UBiEchkqXruet3/S/9TZuunwfkrXt6IC/UuhRnqS9SAE54tYKQkZnkeGdlgz5HjD4Jgs
	 MRfiKecJdQQ92gXQcKqohnxH8+yyFOT0kXlRSPjxZeyX0WZp4KWbB1zOnbp9O0armXj4e
	 w/01v7iII9UJgEL7PcZC1Tpc0n9OnkjlJGkllEYdJE9PUD9GWSyMJUvhxfhEGqZ3FDsCY
	 l3ECF9J1DU00buNsSx+ZQu+Hee15uW+RuS0BX/SGv3ByYRzXQF9xwP4QIx1/StXf2x36z
	 /Rrxz3Yi7omQIY9KxAaB4aAFfMgLJUV6ej2GXEA8cKSPjQ+8y5cu3TR0j74sIg2xZ1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+BiHG3myHzgcILDceKNzirVLtdKco5oP8Rzmcz70hic=;
	b=xmuDV1bnyAqaFUeepywxBHEz9PA7OnqZk6kp9YzhXRbTfWO7mSmb6n2B7NAWWYyEtURQ
	 SSQMDfaG6+rEkk62eNaqsZ8lL6vaQza5+LCWizlRF8VDMZTiJmjvfqhix7ZjqFu3Iqkwn
	 hMUqu328lrxfNLuCbYbEKu1mOCkKVGgMOKWcqfXX65o/26nrA4/JtCeC17UMbryVPnfF3
	 DjGL1yvN9cjGPs1p1ptE6pqdVrP7DTfOjrA7FD4M21uSmo/ryPSHR12BNqPFRku2mesKP
	 Qc/ZuK+jUowWeNsJe9WcJd/h9/B2gVhCU/gmK1Vawl0+9NOXEErkz3201wTgUN1my4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTNDIM+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB39B606A32A;
	Wed, 18 Nov 2026 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTNDIM+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AB71F000C4;
	Wed, 18 Nov 2026 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027986;
	bh=+BiHG3myHzgcILDceKNzirVLtdKco5oP8Rzmcz70hic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTNDIM+C1lDUMpIIs6Gvi/EkSrVvFrAM3XXQORsyI/y5SLuiWep2qTj7UtYqmKWes
	 WqSjm4IQR6LBH13nYoXz6aJU0jQsfu5bgDjaUrA5nplYIGnB1Gx24C+7fo1spZJZUK
	 XgiotfouLsSAnma7utBzLneYfifjKHGB14STlVx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+b0f93e29183ce737@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1957/2151] ceph: fix off-by-one NUL termination in decode_encrypted_symlink()
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150233.050927102@linuxfoundation.org>
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
index fddeeb9527fb3..ee072825c3800 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -966,7 +966,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
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



