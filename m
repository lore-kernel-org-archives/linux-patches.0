Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032979;
	b=EV6JmRSDGmwBLkcGPrdS2s8PjpZkt2CxdzSDbv6arhL5oKGeAzb/EeBC0Ho36eFtQ+Og
	 ruWJmftBkRHmx67JXdMENlXeVW5ghMZUsVATgM+kWLKqVES+iitMGhQVBMUasnOvsxTJj
	 y0hbN4rSOCcqtg2LD4wKfahk0/rc9wh0qYxmWmeTHmK8KmKGtkD7PTsw+nTn1n8xKBwFr
	 7Fl/W/RSRAv9mRqI6pLVDBaxkptZoAIK8FCCmJ1vjM9VTpfL1X6O+BoVBfeaTfAjrEJc8
	 cWaxuMU/jg39i1xVaYcj/8WFJ9YRxx4eyTMVduus1eeTi/dzu0FhFmgMKpsZHJXixHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LKnoYGfbt3QWUMf6RtutTefj80OE/ZzyAnjG6EYHRx0=;
	b=X5JEzCYpNwYUs0W5zyTdjCfmi3sp0+uDPYW8rGpOgv8YmH82ZWHPLBSmW1j/U7iuXg1+
	 8jpRhQUD6QtRuUru6WrdJLkzeT6ugtzLa3LamHp0nHa+qK+vU2ZMFSbbfVfjZJVk2en+U
	 A6MgGSLv+WWcEdl5JxvM65TqUqsJERBlxNrigJNyjBrH13OO2sT/BGIyhbjwjH7cBqcFq
	 VBjQ84EGQVq2BrNKYxvXV/2BLNsNqc+Fg6EKcsArYf8fGEDq7ZT10MILibJt6Kybd/Xo0
	 l+9TVRlbdKdP2t6q40gHRSQO11svo/VYc3olWggoO/MCHCe/oVMABeaGN9iTWxsn65Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4twKxk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F04C606A31C;
	Wed, 18 Nov 2026 20:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4twKxk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7855F1F000C4;
	Wed, 18 Nov 2026 20:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032979;
	bh=LKnoYGfbt3QWUMf6RtutTefj80OE/ZzyAnjG6EYHRx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4twKxk7vwImW1qhb8IKNZr6SurCDuKINJGHlz4SdK2JCjxolT+OujEpm8WZ6rQbF
	 s1p5Qfcv7bl9c7ir62ThNGAAb0OCrffQ8bQNdi3Jp62Taz5+LJqOR23jHk5TdVBNOD
	 8xjOOcvHorJis/HO/xWFRb8QHOi02nv80coKQIGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1563/1756] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150111.708453915@linuxfoundation.org>
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
index 83ddd61e16475..e5c22c833b8ef 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -438,7 +438,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



