Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534461FE452
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040057; cv=pass; b=YODl4zSlS7OpDDG8SYbYFdzIUdm7ye1nZBSoSYPKVEAsRRYStFXvqe22K5h7U7po3n1mjSfFVW1IHYoGuvReT7k6MeYjOaqFAariKKXzaanM7Jvs3kY0qsFo3W2VVHOHDDcMLV1EdinOO7CF/tL3n7h4J8DMew/J+Euzi2Whk3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040057; c=relaxed/simple;
	bh=iuZCbwZx0C6XAZzPoTKiS7D1eM/iJkU5j8K/5ddz+CM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i7MN4WrnAxgElITFtSdRyInxUoEu/bmNJM4KUGgMW2gaNHbNgr2R+rBd3TMUbTkxxqxQrAwXUPyIHsXm2HRKOrtkJfwF2/eH25kAAgyURfLJ80zGnsduCKYQj4jjTqb6du/DDjE939uYkjtdGWsh250faFx9/a/GXJn446UdP/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Ov02pp9v; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Ov02pp9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA45C4CEE7
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Ov02pp9v"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:34:15 -0700
Resent-Message-ID: <Z_Pwd7MlL2YgjFG_@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 05:55:55 +0000
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1fSc-0000000GVOj-0ojv
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 05:55:55 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id F135E5C588B;
	Mon,  7 Apr 2025 05:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id C0F29C4CEEB; Mon,  7 Apr 2025 05:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9B71C4CEE8
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 05:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org A9B71C4CEE8
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 253C4164BDA;
	Mon,  7 Apr 2025 05:55:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (trex-5.trex.outbound.svc.cluster.local [100.107.20.214])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 7EAFD1625ED;
	Mon,  7 Apr 2025 05:55:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005343; a=rsa-sha256;
	cv=none;
	b=bw1nUdFIFDm/ZQSESyUpYsSZ1X4R/dFpBKsQ8U/a7uahS6cAzWnKYO8YBpOUjUFYnSWvgP
	Ip8lpeRKrIsFPozVzSbOWOsFvE7ysnPN4FQtW+ZIty/HtA/KvM9Yr8L5Dli8nkUs2wrYtC
	qwU7wWXsGcZkdiGMAqrVAoX6nC3txIOHjdXVCOegi58MV49REQs/pJcU8TGevlN6472emG
	M6GO98EnjvzZIaxtKKQ+tmPLoEqdYnSfzsfRzcVunhlVcwEphVVY0KDW+RHhFMp4VDP+fy
	N+ZFmwMc2w8IaTyu97wsT2ndVhX9ObWDpjw1hUOriD2j4vp/qulAHO/PhwTx1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n55SsjDipGFvh6fmwNss0hln0pwwfO57bV4W3x/8M8Y=;
	b=dEqaRZHnUK0T9ObzuCW0jK4+4WumcVLBWmtJPQ2DtBxLW9TmtwM3BWpT9JSjLTglJYBnqw
	vt/Lkx3lPnY3TQj8wOccpPSiYgKHvldtoptpjF77Un1EligezWuBWxSi0qMYMV78AKqU72
	EkNqfNoNcTxMHV/DtgXtfl05tG55CD4/Q7TPZ6kE+dAzb9a7zSTLnabQiB6CcT4FYuCeF4
	pIAq6iuRzHGv5twuoJ6j9FkfGDLGenI6YAcNN0t4PMnEeiaWNLx8dvFy01TbJbdBstTiNu
	tZZs8wRBDX9cAIIlw3XgPb7MGmYyIHCFtpIB6zMnK2/nvxjfsOs8XdUydGwBpA==
ARC-Authentication-Results: i=1;
	rspamd-7dd6dcd7db-nwdnq;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Fumbling-Hook: 425548d106db0357_1744005343890_1510509024
X-MC-Loop-Signature: 1744005343890:575294298
X-MC-Ingress-Time: 1744005343890
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.107.20.214 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:43 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNH1B80zdP;
	Sun,  6 Apr 2025 22:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005343;
	bh=n55SsjDipGFvh6fmwNss0hln0pwwfO57bV4W3x/8M8Y=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=Ov02pp9v0bwWBUiIjsMscNxjbx8V0IHUs87SwnsQShqMw1Z4FihOTBJfiTiXVl4Ou
	 cJ7HmfIavgZ3qEg6zAEY1WfKFrA+gQ572L+EnQUL5DqyxWP248vlW/zfvmG4fTl4Do
	 1ZCqHISu7A2t9cmK5uG/y1GEr2Hvm5pZXgmtfIvmh07Ol1bYkXhHAAWROu7Fx1i4H9
	 qrscdu5YL4wJTQIw06AerzdXS2JKFm2zhtIqB1lHYU4/SNJk0Pl9TwG9iAXICv9dum
	 XdgUpQwlC8vYX/g8mg4E3Gf/aLXA1ZIUZnLs0xPxD+u7u2cs7SuP8NijEzs9Uppneq
	 bTy1/+fjqWkXQ==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 3/6] fs/ocfs2: use sleeping version of __find_get_block()
Date: Sun,  6 Apr 2025 22:54:52 -0700
Message-Id: <20250407055455.785065-4-dave@stgolabs.net>
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
X-CRM114-CacheID: sfid-20250406_225554_343714_21B8E2CF 
X-CRM114-Status: GOOD (  11.16  )
X-Spam-Score: -2.1 (--)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  This is a path that allows for blocking as it does IO. Convert
    to the new nonatomic flavor to benefit from potential performance benefits
    and adapt in the future vs migration such that semantics are k [...] 
 
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

This is a path that allows for blocking as it does IO. Convert
to the new nonatomic flavor to benefit from potential performance
benefits and adapt in the future vs migration such that semantics
are kept.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f1b4b3e611cb..c7a9729dc9d0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1249,7 +1249,7 @@ static int ocfs2_force_read_journal(struct inode *inode)
 		}
 
 		for (i = 0; i < p_blocks; i++, p_blkno++) {
-			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
+			bh = __find_get_block_nonatomic(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
 			if (!bh)
-- 
2.39.5

