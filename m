Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2931519D8A2
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040041; cv=pass; b=ift+Se4P70gZFMRmwy3JJKGaCxx3N5WH+TVeXofP4U9700QwTFYeCTEZVuBO6bNUPqS+lygWPu8y9sL9joHutkxHtjanThXiDUXbxea23MupGNJ9TFstuMSLeKxNdPidFdUWkBmT9WuQBZMRG80K7XtgT+kKMSdrb+Po2TtE8Qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040041; c=relaxed/simple;
	bh=NnMq6nw/cKkA4GzdBQe19k/LXumuqivNM5KG4SRiMnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NKnlB2I2K+blUxNWd/zms08po4FcBY66YJJptDYq0sqEf4v3y2wkLd/hob6ShjSVlo3NhGNKmNKvPyLM42dd5Sl+RLqt+VyWmblq+bWaXkMCuuATtNZT4pD8MdjU6ZMGQMMxc8NuzaIlGaFFlGGk6znJdpbUGhGZCyCqHazxh1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Lm2VzNFz; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Lm2VzNFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BB7C4CEDD
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Lm2VzNFz"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:33:59 -0700
Resent-Message-ID: <Z_PwZ9CiizyxR_n_@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 10:28:13 +0000
Received: from sea.source.kernel.org ([172.234.252.31])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1ji7-0000000HNV5-3hvH
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 10:28:13 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4F1B49E80;
	Mon,  7 Apr 2025 10:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 43AB0C4CEE7; Mon,  7 Apr 2025 10:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2F3CC4CEDD
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 10:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C2F3CC4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B507582BF2;
	Mon,  7 Apr 2025 05:55:42 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (100-97-44-91.trex-nlb.outbound.svc.cluster.local [100.97.44.91])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 47782829DA;
	Mon,  7 Apr 2025 05:55:42 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005342; a=rsa-sha256;
	cv=none;
	b=D1I0N7Mh6ORqezb3xRckogm9wDvSu2AO6zdepxKTcKTg+6zmpwhTW1zQf9Bf/OuzkyuFBr
	kpB/EFGCJU+Xg0GZgA+/duMZjRpLfto/rNLPxBj7rk14CgYXzJ8+FeAijRck4xZSEtP7ks
	tsuLKjmchoX+AX7+I38X5thnsapM33Cgv9L6UiXZEKG7gadGgBnQNaN6fyPnSHdWx8vAkO
	955XruxRUFwTBYNzcgVU3n2IUrBqD4gS4XgOgdpgqbIH/IUahihx/WMwzOS+XqY18VXqgh
	FgcaYLr39R+Z75DUw4zY+02yX22yd3KKVB7jMoo/x2oaBmVCVqleD9PuPxaYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=2lwJeFwk3g/DZv0WTM1lF/x5y8BnYBSyXNjoJGz5pAc=;
	b=gfH7snTbzM1nDc39nR1FCqtTzT6lm+tG2PCIzLiV2JfEW6/bN4YWUij53pWoVVhWhI1B/f
	NtSQ+x7xz2pzo0ES7y6NS58gFkJz7yNSVwbi/Fl5NAKbUdao4doCAy0dqHchX2kyxASDzW
	O8MO8KSZYksL7oWSnzwxU8jdvYXMYtmH1QU+9po6QoKZ7eZR7WPxesG9nKzBFCKRwIGseO
	tEOKloOjulY9tSk+j5nGOKEavo4ZSb3weeNzFcOG53x4sPckml19frH1UYT2Y2G+HapYE6
	aL4CzrgbMvbIvNSMyZsxF3VCiXTN76Wcx8F00kKG680LmNdRUWDf6J9ZB9/odQ==
ARC-Authentication-Results: i=1;
	rspamd-6c88b8f79f-spgr6;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Bad
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Illustrious-Trouble: 1bc161b22720aa21_1744005342519_845135743
X-MC-Loop-Signature: 1744005342519:3360865361
X-MC-Ingress-Time: 1744005342518
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.44.91 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:42 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNF3Z2KzMN;
	Sun,  6 Apr 2025 22:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005342;
	bh=2lwJeFwk3g/DZv0WTM1lF/x5y8BnYBSyXNjoJGz5pAc=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=Lm2VzNFzWMSlPNzJToT1xatZZmCIZqBpzihYPOrI8GZD0FRflqICujjHilQZOQPtE
	 3C1xaQh4cXNnQdTuopKG1tAZfN2bqpDjSB4ZFZeaajf/0rmiveMBzKOS/YOjDf4gmn
	 M39eHUrCq5aI5CQc+Fg8U+Jb0MKENsJW6gOaeORKUM5aaJti95qwNY6DvMUbdr3+UM
	 bjgjW0EVbiImsv04s06hRkiYUbSacxOJgUd8in/i5G5Rh9BRML+Sj3rY7FoR9TH8jO
	 HOwNCeU1FlC4A7qDPpKIXGflifwmrGx/ZdLLs8oLCuXdYg4AlMLiAPouRM+D7dRhr6
	 KR9LKdSMHQvbw==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 0/6] fs/buffer: split pagecache lookups into atomic or blocking
Date: Sun,  6 Apr 2025 22:54:49 -0700
Message-Id: <20250407055455.785065-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20250407_032812_079928_460219A0 
X-CRM114-Status: UNSURE (   5.78  )
X-CRM114-Notice: Please train this message.
X-Spam-Score: -2.0 (--)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  Latest version. Davidlohr Bueso (6): fs/buffer: try to use
    folio lock for pagecache lookups fs/buffer: introduce __find_get_block_nonatomic()
    fs/ocfs2: use sleeping version of __find_get_block() fs/jbd2: use sleeping
    [...] 
 
 Content analysis details:   (-2.0 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.0 SPF_HELO_NONE          SPF: HELO does not publish an SPF Record
 -0.0 SPF_PASS               SPF: sender matches SPF record
 -0.1 DKIM_VALID             Message has at least one valid DKIM or DK signature
  0.0 ARC_SIGNED             Message has a ARC signature
  0.1 DKIM_SIGNED            Message has a DKIM or DK signature, not necessarily valid
  0.0 ARC_VALID              Message has a valid ARC signature
 -0.1 DKIM_VALID_AU          Message has a valid DKIM or DK signature from author's
                             domain
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level mail
                             domains are different
  0.0 RCVD_IN_VALIDITY_CERTIFIED_BLOCKED RBL: ADMINISTRATOR NOTICE: The
                             query to Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                         [172.234.252.31 listed in sa-trusted.bondedsender.org]
  0.0 RCVD_IN_VALIDITY_SAFE_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                             [172.234.252.31 listed in sa-accredit.habeas.com]
  0.0 RCVD_IN_VALIDITY_RPBL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                            [172.234.252.31 listed in bl.score.senderscore.com]

Latest version.

Davidlohr Bueso (6):
  fs/buffer: try to use folio lock for pagecache lookups
  fs/buffer: introduce __find_get_block_nonatomic()
  fs/ocfs2: use sleeping version of __find_get_block()
  fs/jbd2: use sleeping version of __find_get_block()
  fs/ext4: use sleeping version of __find_get_block()
  mm/migrate: fix sleep in atomic for large folios and bh

 fs/buffer.c                 | 76 +++++++++++++++++++++++++++----------
 fs/ext4/ialloc.c            |  3 +-
 fs/ext4/inode.c             |  2 +
 fs/ext4/mballoc.c           |  3 +-
 fs/jbd2/revoke.c            | 15 +++++---
 fs/ocfs2/journal.c          |  2 +-
 include/linux/buffer_head.h |  9 +++++
 mm/migrate.c                |  6 ++-
 8 files changed, 86 insertions(+), 30 deletions(-)

-- 
2.39.5

