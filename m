Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050492;
	b=MQUmUBVWM6+0y3ty4h3TP5n5TraW4MFlxjQcHw4v5qD+PNiPB6npTN7buLgQ5jBBFFlX
	 1T4HBlrLBhoyiNR8YoKeC2mvxXqRTaWIatSXVyM/RUAgy0xd9/Tr/1dapwWQQCC+Pa900
	 cU8fy1BQ9T7z7m4zk1Vd02bsKKbehmBoc1lQdgCGo6GHKAoA2+nzIBRCz1pv1hFprHtcu
	 7UkAQyqSotPkNK7V2gNV7Tazgit0di8CsJ5nsRvtCwzVB2KJY3kUK3rHOl3QIttJwinOz
	 sIZ+8TDyx/f8N/69vkNQwwngP1vUFh8fVK0EJB2CArSAknGbUM8WQEyQFe6yrLAwFKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHOznRXdeSvzSvadREF26A4TviPL2H/NM5FTvJmECFc=;
	b=FL79R5LAoHYaH5eIfg+jbn9EA+LAuVyE8MoI9pTYwX797BKBUB4ZkyKkLz9J1Qo/IfSb
	 4z7CX2NNrELbwJgpletLaV8o1jIBe8QIDZEfw9LIf/NYKxiHoLI8c761Ai5k6pXe6Eqxz
	 OiKcw7kc7way+NqwPOsi7WYL73s8lleAXb49iqMyORY66eFrjnEGiX8jKqhb9gj414Uiq
	 r8xs+bChApDlQDRW2Yy8KIQaQMEbFWk8ihPbIls2ZFXudId4Tgmqt8b+XWodXiD/zL7PW
	 jPr3IUSvf8FhRDxUnPRN1s4OA8THiBMqA6INRLbOmBo8EljCs4gF6fMiu3uKQLOOb6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvTnZTmZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF616606A32A;
	Thu, 19 Nov 2026 01:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvTnZTmZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5B31F000C4;
	Thu, 19 Nov 2026 01:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050492;
	bh=GHOznRXdeSvzSvadREF26A4TviPL2H/NM5FTvJmECFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvTnZTmZiEYtBCcnpYxRC5tH8NoyeVkxqmGUFiFawULq05z75R5jyZKOKduAQI5ox
	 tb5T/EvediPE7eNnTQLVRIjRek5UYqg4sIhQxHgjBHQT80h9kp63Rj9RHd7B9Atdli
	 wSagAEl0XiWzvWF/fqe2EWJCE1+v5zWgACT9PZak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2728/2857] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:02:42 +0100
Message-ID: <20261118150339.846269020@linuxfoundation.org>
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
index d2b49620f30c7..864c422180ede 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -405,7 +405,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



