Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042532;
	b=NWWAkAhOZb9gAPU1U2vCGl26nfM96JI0SYGE0MbcGlX1QbCEbe65iCHVRjECg5kKR9Bn
	 7IhJ7aslnV/tQB/k4vwQApCxjGJY+avNInv4qYPCcTHYc9gtDFxm1j9Lkw49KAUsT8gdn
	 HZooQV1uJA4P6v2UBZUAkYGSJymi+rk89B4MmavlxNqJ5uGQ4ynLHGfazYWldpG8NzSnO
	 gi38jWvpZtgS0IxTR9TNVK8QxEsQDuoDhY/iFQUyXrcDsBRaTvkU7nEOW07BSQxdfhXYO
	 S+mKyM4Y4EBPg7p5oPOwCp1OVu1aItHFc9B7IQhOBobyl9W31kGe4PyP9usY6o6b7Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0foL3EkMbJoJ12hawrDvthu39kvRNKG+L8pvFmcruxs=;
	b=rn6PR83GLRGbGdEX8CHRjOEhORp6vS1Ju+wQOSxKZTtywkTi2EnFw34qDjikw+taIHaH
	 5Ch4okCMg2awwkNfvZpiaAVVR96niunrScMyU2vaOkH/YW5VcsUEWDpShm8evb3fQuxhy
	 IMfMwTJTOkX/QH1IFob3vziVcEzZ5vB6NLLI0sxYnDiocPjC1bsf/1lzC+9bGe+1Qctkq
	 57DCaveF1QE7ZOcDNPNh/l+hbGwDXzNk2KYp9WxbrZu8fTlBKQHxzUW1A7RQDskYyU1PA
	 1XtYOG004+DyOZjhrjvVboA8CBSbHTd4HgfeBy8bTewW1oU87Idd9OCIfGjed1ZAhAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/wA64q3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B784606A325;
	Wed, 18 Nov 2026 22:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/wA64q3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE5F1F000C4;
	Wed, 18 Nov 2026 22:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042532;
	bh=0foL3EkMbJoJ12hawrDvthu39kvRNKG+L8pvFmcruxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/wA64q35hGhbpGN3MAPDqJlJVUxM4Uc38UCKp8DlRlYUO06SFiS9lX6NLoU2iX+6
	 bKKQ6NKglf2GVGxIBJt/bui5EynrHCCAvFFpAqRNrvho+SSUBiA8bPn/Qku6hpMy39
	 aSz2S6iKO2Wjr18ueqPT84Z+tUXCcUGhENygZvlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3164/3318] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:03:06 +0100
Message-ID: <20261118150454.764296015@linuxfoundation.org>
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
index c921ffcb93bd8..0cd9230217735 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -411,7 +411,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



