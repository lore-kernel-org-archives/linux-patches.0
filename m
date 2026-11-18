Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042426;
	b=Ow2r6DLXx6pny2Ar5edMgNQJNANLgVcmSCjS5GEf4X+5itnCKBY9SfXiQt/sQGaRGepZ
	 4sI5QT0mHoup/rK9IymotQYerdxMDIN6EWGJhveYeYe3qG7pRMGiDCJUKocON2xSAiJhQ
	 L+aUaBFTU7Kv2/rofLi4wP39Jd0GdMlR0oz21ObtdZKsNczmfOoEpA14UAnn7TRTvbnwq
	 ZCX4F9FVBWb8r93yMjIw81ZLNMjHM53tdI0iMHvDT4+++Iti0m+GM4M7fA6hqqW/RBnII
	 VkuTUkRtYooBml1QGlexzq50Y0Ilk1L6BiO8w8Alp0oG+ufHxaCmhXenFfQJqDdaD8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y8VQ6UMjs2JfTWG1DMbMmVvHHxsyY7ilqCUTqUZgH3g=;
	b=i61C7Uo8tn5ZOL5buQY4qN9L8UEoObMmzQTw5YZ19e2fo2XEwV3xcR3vsjX0NbtijHtk
	 KR7Kq431BPygAXI23UWE73O88Iym+zWSGI54Y/td5T/TqWHWRVGgtnCwOiqJ1C+K38DWt
	 mZXCLB4RJYY8frBetRs91Ae3ybg899wlhrfqlSS/FsK5kVxl2hEU8YZKlExiskOTHgFmT
	 yp70KFUDOwEixTwP8qKwa6lU9hgN6ihR9M8rlPpULBx9TKKUO2layJJ8TtKvrgntFvtu/
	 M8o7EMhecxETb2ErgJ+co8iEZ1z1EYOAJOm/EtofFIrxZ+0X5+i2ABITZXyOEVGPLtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18nlnxss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B8606A31C;
	Wed, 18 Nov 2026 22:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18nlnxss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB681F000C4;
	Wed, 18 Nov 2026 22:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042426;
	bh=Y8VQ6UMjs2JfTWG1DMbMmVvHHxsyY7ilqCUTqUZgH3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18nlnxsstHcTQa4FyZxHlMKylHSOAmyKludbM8GedruZzfm++x1lBqs6p/ZVrmLET
	 sRE988NnyFo/97dfgKsAI2FVVK/6M6WODf411NMmqvWnxwzEfK6wvKa/DAWK5sbZCg
	 Elx2ylK65z1kOy4U5aP3BFEU/lZAQDTK+Jyz/cjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+b0f93e29183ce737@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3167/3318] ceph: fix off-by-one NUL termination in decode_encrypted_symlink()
Date: Wed, 18 Nov 2026 16:03:09 +0100
Message-ID: <20261118150454.850561926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 940ab16f7cfc8..4555fccfc4c9d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -913,7 +913,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
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



