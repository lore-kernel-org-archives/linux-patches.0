Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8E81EF0AD
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743780970; cv=pass; b=a7tJr87LotYkfk224fxbynWZ5wPej+ksCpduBwaeaiHxo8Mj3n/Nyf6CRetlP4g9PY1aMQjxT1I/TO5QGQJ+mJS0qq1HuqF/SAyiayCvVIbbMK+yw4YXzbL4Uqy/yryUMGts6LoMMjvOgNkjs9WLPGvHCc+XSJ3VEISfye7z8hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743780970; c=relaxed/simple;
	bh=RJA1P3ofskqZiKn1W63P0/0DLW4aztE+wVWouTGZpoI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LJ8b6cQUGvIVWpdVXv+OBxiAUoXF9tpP6Tj2oG9EPHBcGgGnVApbrj/G3V78zWhEZzSf2AmTx4U0jekDXMhofdozNdqekImiqELd4sEGSnCTfoIEND1Zpsh4WnZiHV7eWyGv/uU0AyDBO1b3hNbVa+gShMTzGBlMvQpXF+fU+RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=mdoDQUSv; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="mdoDQUSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D241C4CEDD
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="mdoDQUSv"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Fri, 4 Apr 2025 08:36:09 -0700
Resent-Message-ID: <Z-_8aR10WIY_8rVx@bombadil.infradead.org>
Resent-To: patches@lists.linux.dev
Envelope-to: mcgrof@infradead.org
Delivery-date: Fri, 04 Apr 2025 08:26:24 +0000
Received: from tor.source.kernel.org ([2600:3c04:e001:324:0:1991:8:25])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0cNc-0000000B8JV-1mOh
	for mcgrof@infradead.org;
	Fri, 04 Apr 2025 08:26:24 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2EEA6113B;
	Fri,  4 Apr 2025 08:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id A2576C4CEE5; Fri,  4 Apr 2025 08:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75D5CC4CEDD
	for <mcgrof@kernel.org>; Fri,  4 Apr 2025 08:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 75D5CC4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EDA5C1A55EA;
	Fri,  4 Apr 2025 08:26:05 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (100-101-70-132.trex-nlb.outbound.svc.cluster.local [100.101.70.132])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6F7321A4717;
	Fri,  4 Apr 2025 08:26:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1743755165; a=rsa-sha256;
	cv=none;
	b=X8hfHfAEext8nXCKynx0HaO4gtFF+njxaYT62S5jdtnlpwM1XZK7OlRB8iFsPJYVGT0DDJ
	0wYyWNkwNFFmJbF6g8YehwKgSLqWE0MA78AMhdTgjO98r8l8M24O+TIHGgJw8swnlbXZcF
	MHHpVO5AbKTQ8sGk3+wFaoLvojABKohSMTDYH09Tpy0iFdTufjg+9n+q1WHTi3fELBb/4D
	5+z54TZ6tq/EPEMu/ncK6Td14id0knG1hpA/spJSs2CvC7m8RUFcxem1ioE5cmT8cXVTV1
	DIKylQDeZMRNZc3rYnwTFxzzvxe/q64SN54CINAWMQfh9bdHUMMZexJrpYNBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1743755165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=tu4JNVZRcMAXqFnFVnrGyb0kKIZDjN64WZm36uSX3EY=;
	b=lLBEoc1pDeP2rtxc259zNcOLwxDRFqS3GCRL6Juzjgxvl4WWH6QKXbBnX0ZNPV3SXFB7sI
	sqqPQSUFw6pDqBZkQRcTeIgMT9b1+cww1GDH67Ctb+GQinpyrQkmaGh+KYNeswcwthLVsc
	GzEWiugI4vF6XZCYyrQ3i62+cWmefzwxbj4lgFHsNN3QnaroM03400Sc/5a9xLP1xZuFEP
	d+xI+FCtntzzLG24R42rhBMMEc8KiPFol+5T9A8fnyzfAmrCfWNOgykUKWn0KGEhL0x+FL
	U8uV/BTtVKdwHRJThtSONMN1RWJIYxJTO7qWYjXr/k0dp+tbiKT0TyDI63hlhg==
ARC-Authentication-Results: i=1;
	rspamd-77c6b75dd6-rq7h4;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Broad-Whistle: 0d0f7383787de79d_1743755165671_3040980200
X-MC-Loop-Signature: 1743755165671:1864974805
X-MC-Ingress-Time: 1743755165670
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.101.70.132 (trex/7.0.3);
	Fri, 04 Apr 2025 08:26:05 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4ZTWs86fH3z6W;
	Fri,  4 Apr 2025 01:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1743755165;
	bh=tu4JNVZRcMAXqFnFVnrGyb0kKIZDjN64WZm36uSX3EY=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=mdoDQUSvstodbUUiz6CKDfV7ShwFzgPG9VSjWH7ZJgcao+v9X79y3olllIwWXIem5
	 oztKeiiui9l3JOpsWGVRBVCai6g74v31H57h9X5ntyGxFX8fYrg+KBkbX9F+urRxwU
	 NAuQzw84275tr39LSw5bujp5wIm4CjOLgmnzl4dzT1qVmBGtTYOrY5f/OW2E16gygV
	 u7A/KbUHrEPB83y8OdSruAosFgRRmlmJDJUC0PdApO9ww6KYbgVCfX6HjsvyPGgisX
	 ePTzWuTwpdud+QgflCK5r4eJ1i2KMb28q12gqp91XqCGDGxaaVzhgpfsvbLXyiv+a7
	 ef6QzaupTf8Dw==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 0/3] how about this?
Date: Fri,  4 Apr 2025 01:25:17 -0700
Message-Id: <20250404082520.723838-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is combines basically the folio approach to serialize
along with doing that hack idea in the comment for the __find_get_block() shit.
Then by adding the flag we can come up with a nifty locking scheme that
satisfies both these issues as well as potential performance improvement
by avoiding the i_private_lock.

What do you think?

Compile tested only :D

Davidlohr Bueso (3):
  fs/buffer: rely on the folio lock for lookups when possible
  mm/migrate: fix blocking in atomic for large folios and bh
  fs/buffer: introduce __find_get_block_nonatomic()

 fs/buffer.c                 | 76 +++++++++++++++++++++++++++----------
 fs/jbd2/revoke.c            |  8 ++--
 fs/ocfs2/journal.c          |  2 +-
 include/linux/buffer_head.h |  3 ++
 mm/migrate.c                |  8 +++-
 5 files changed, 71 insertions(+), 26 deletions(-)

-- 
2.39.5

