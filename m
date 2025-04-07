Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393B31FE452
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040065; cv=pass; b=kUH11lfyNNJMs3Glh3S0RoP7Pg0O35dR0R9icYECYlmJbu7KkLdwO651h8FF6SA1HWKeA4m3n73cxkxBYdjpHg+FG0syEE5Je+PVAouzBU/2MBDklUTMy2dtksgHHShX8Q+SOz6Mw0z2f3Z6TaANNS79cTvY+Um/BNOO52wxX/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040065; c=relaxed/simple;
	bh=PReYsXQnKkzjz+PKktHIlfwQL3JaSTruh4pNBZbN2SM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lvONL0ekm/ELtzBGzHIBYIV1rozHFjJxIRt9CfntfkHgmT3Ugz7uCV3cu9w/u73Cj//fMoRYWZjMz24S9yFnavr2deNgkmUoIvbFI8B6xTWzxY/uwLMc7CWKHfWfYqlEThgd99a32mKX77ZLtYdDUu2FHTmEDGnEm3WUYS4Ly70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=GYZNF46o; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="GYZNF46o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112A7C4CEDD
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="GYZNF46o"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:34:23 -0700
Resent-Message-ID: <Z_Pwf3Z3bNcjjlmF@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 05:55:54 +0000
Received: from sea.source.kernel.org ([2600:3c0a:e001:78e:0:1991:8:25])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1fSb-0000000GVO0-0gkq
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 05:55:54 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6995544879;
	Mon,  7 Apr 2025 05:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 071F7C4CEEA; Mon,  7 Apr 2025 05:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A469CC4CEDD
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 05:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org A469CC4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 896328A39CC;
	Mon,  7 Apr 2025 05:55:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (100-99-235-244.trex-nlb.outbound.svc.cluster.local [100.99.235.244])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3A3298A198E;
	Mon,  7 Apr 2025 05:55:44 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005344; a=rsa-sha256;
	cv=none;
	b=NqzSkSZ7HB4p2ZS58uAKozsJiZ+x6RFs6Uqvftt6g2eBy8Dtrxrmg86MHh695t6TfjY7ZE
	zIVZQ/XBiuBbi7ikketRYo/olA2mJqD6OndCKfHlFGnY+hpQJoXIGyIiEdIDaaPcQTdx6Y
	cwbU8Gmr6VvCvhrdndBvMK8ZwTpGqkroB+nTHojAgzlTeAs1Z95G+s+gETUxJuDcKHqpBn
	IO+ny2mST5o9zQNAdubWlX6v+BSLAO6wiNCaJLrnpHRO/jRUgk6B7E0vOlJjNgGm/FD4b4
	1Dopbcgjq69ezxGlHZ2Zwva99OS3zxh9AbU6uWONwiYCVe8YFUrVjv3aygg8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5q3KUagZRTcHzmRGMW2dyHhgq8n/m3y600hZSisb6w=;
	b=P85cu9OM3Jb0QxXvpE8tudFhC+kdeXmvrp0VazkY0/YaWB3XNYwFB0fFcFfeDw+Y0yuyEz
	vaTwj9Ojo3sl0uitC5Xje24EvdfioIVnRMfv/ykHctIZAmMz1quXnEvRzCEQllVpeQg2Z6
	K973oZ2LyN7Bhv6v/3EdajtSgP7NlYbvU0qWIyhF5DHa4GgztGWLyiZ8q/xA160tKQkhAu
	nxXnruNoc+wfoIjobwreYUR50eKHXkODLAtB7Ps3O8U2QthVIwkV1ymNUHV6so4IW6nWIG
	Nk9CpsxF12atPM0Tbn3tOtAW/CHURIIwoFMQ9lb2oCrr/SBoOW/D/XqRxpOGqA==
ARC-Authentication-Results: i=1;
	rspamd-7dd6dcd7db-nwdnq;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Whistle-Dime: 560127df097f6e1a_1744005344451_2994400659
X-MC-Loop-Signature: 1744005344451:1065055193
X-MC-Ingress-Time: 1744005344451
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.235.244 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:44 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNH6D4JzMN;
	Sun,  6 Apr 2025 22:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005344;
	bh=a5q3KUagZRTcHzmRGMW2dyHhgq8n/m3y600hZSisb6w=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=GYZNF46oKUlMlmUtEZhBBk2YtM09iA6B6cMxZ+/9Ehypwa0R1uAch7b8IDEHKajP2
	 Ksoi66j4PAnpndm5Otj9I//i103kJ++fZtJ1tRVq206JJzlOOTabdH6egZIQPcU7PP
	 bdxLa+psZWm/wcSBzxFkYqVJ4kLwLpQaun2KYST4IMwPGrWpdkE50/bR4aOb0TRKFG
	 ZnSldseiq20w2F51laYIHWXHE/aVDQviXJXxHagFKjQvUMakniG63otH6fcfWdJJh6
	 N+jQFN5xKx70j59RBfgKNaGNy2lO5NxwujQJlqMMYnjbqEwRp1ZGYdJ1mREo461qnb
	 JP87HnjKK+CBw==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 5/6] fs/ext4: use sleeping version of __find_get_block()
Date: Sun,  6 Apr 2025 22:54:54 -0700
Message-Id: <20250407055455.785065-6-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250407055455.785065-1-dave@stgolabs.net>
References: <20250407055455.785065-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20250406_225553_396466_D694DD6F 
X-CRM114-Status: GOOD (  11.52  )
X-Spam-Score: -2.1 (--)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  Trivially introduce the wrapper and enable ext4_free_blocks()
    to use it, which has a cond_resched to begin with. Convert to the new nonatomic
    flavor to benefit from potential performance benefits and [...] 
 
 Content analysis details:   (-2.1 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.0 SPF_HELO_NONE          SPF: HELO does not publish an SPF Record
 -0.0 SPF_PASS               SPF: sender matches SPF record
  0.0 ARC_SIGNED             Message has a ARC signature
  0.1 DKIM_SIGNED            Message has a DKIM or DK signature, not necessarily valid
 -0.1 DKIM_VALID_AU          Message has a valid DKIM or DK signature from author's
                             domain
 -0.1 DKIM_VALID             Message has at least one valid DKIM or DK signature
 -0.1 ARC_VALID              Message has a valid ARC signature
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level mail
                             domains are different

Trivially introduce the wrapper and enable ext4_free_blocks() to use
it, which has a cond_resched to begin with. Convert to the new nonatomic
flavor to benefit from potential performance benefits and adapt in the
future vs migration such that semantics are kept.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/ext4/inode.c             | 2 ++
 fs/ext4/mballoc.c           | 3 ++-
 include/linux/buffer_head.h | 6 ++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1dc09ed5d403..b7acb5d3adcb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -860,6 +860,8 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 		return sb_find_get_block(inode->i_sb, map.m_pblk);
 
 	/*
+	 * Potential TODO: use sb_find_get_block_nonatomic() instead.
+	 *
 	 * Since bh could introduce extra ref count such as referred by
 	 * journal_head etc. Try to avoid using __GFP_MOVABLE here
 	 * as it may fail the migration when journal_head remains.
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0d523e9fb3d5..6f4265b21e19 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6644,7 +6644,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		for (i = 0; i < count; i++) {
 			cond_resched();
 			if (is_metadata)
-				bh = sb_find_get_block(inode->i_sb, block + i);
+				bh = sb_find_get_block_nonatomic(inode->i_sb,
+								 block + i);
 			ext4_forget(handle, is_metadata, inode, bh, block + i);
 		}
 	}
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 2b5458517def..8db10ca288fc 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -399,6 +399,12 @@ sb_find_get_block(struct super_block *sb, sector_t block)
 	return __find_get_block(sb->s_bdev, block, sb->s_blocksize);
 }
 
+static inline struct buffer_head *
+sb_find_get_block_nonatomic(struct super_block *sb, sector_t block)
+{
+	return __find_get_block_nonatomic(sb->s_bdev, block, sb->s_blocksize);
+}
+
 static inline void
 map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
 {
-- 
2.39.5

