Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062077;
	b=eLGaANvEF/p8Mw1zKrv3qKqr/lr1vC4KbhvIR2J2fxhSeBWfW3rGmI2arwQPT4NRwPvY
	 rYOUgL93gArM9Q68sA/6vXTF6ze1U0nhS6SoDf5xWv9WfgZCN8+03HNvtE5eJwZJ9VuRb
	 zkzMPsjdiBH5DlTUY4q7ZfF1956kNnR9Uod047bdJcT37IC4d7N94QIAapoAkhJ8c5Jb2
	 nGXvybyrX8EPDkholpnKQMg4+S4SzJm0zDdeFUuulJk7yBkr4YZFaC8pOG3vK+MJ7t1s3
	 Gtt1PgmUadJ769e7ZLJ2WEmT0Kvf2a3nuRd0Ul1BZ3VG46lmJX8I0GfIhy0ky6Z5uyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ITCxKpFPFsaq1m7RzM+zZ7zyaKKy2i6e5KgE2Pqoz2U=;
	b=OOnIUsrtREA4CusgrXi1tgI1XuNWjEv9oAbmMT49U+TnrrbTAsp8pRB0qn8HoJ20SjP8
	 bnLiGMXSdpC38Ybul8hg3MB8mF1qJ2JDv8lCRSpXqh0wtleDyXay/hGf31WFLgVY9pOqO
	 9MZDxPZDUytJB0kcsh39WA/NGltSLeIPEja5ps4qFPHdAdn1snEFzb4bpiNNAT8yncU/F
	 dQCWtMonsbdMijCLnu4nvmnmz7XmTcXKAfbdYrwHMl4OTfRNmB560Dsv7PbbOF8rqGh6x
	 6o/U2mL10vh8AZSmJ839UZY5lQqbEOxGPg+l0J58bq5d35OmkBdyzTVZsTYwT3WhoGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd69LSCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36425606A326;
	Thu, 19 Nov 2026 04:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd69LSCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850DB1F000C4;
	Thu, 19 Nov 2026 04:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062077;
	bh=ITCxKpFPFsaq1m7RzM+zZ7zyaKKy2i6e5KgE2Pqoz2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd69LSCLLLhspZzOLFFHIWus4UgqY1VNs1Ch4FdU9P/IMcJj5M7fTKbpIvN7En6B4
	 a7cXKGa9mPJ+VYKc3mhE4vAaMqtKWFr6BwQjwVGEOq8SitT39CK/U0idCWg7jWo5Ad
	 8QwzSX1RYVv1SnO0fbAQ/e6QYJBDy1kUfajeuguc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1774/1848] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:03:32 +0100
Message-ID: <20261118150033.641894129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit a200e12135c96893f7c29bdf97f46868132f695d ]

This field was added 17 years ago by commit de57606c23afd ("ceph:
client types") but it was never used.

This reduces the size of `struct ceph_inode_info` by 8 bytes.

Fixes: de57606c23afd ("ceph: client types")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ef1f253292b2b..aa1dd850b9148 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -380,7 +380,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



