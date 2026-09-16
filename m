Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578DC367B99;
	Wed, 16 Sep 2026 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523573; cv=none; b=sy6kjwyOkRr/RX/CkbiB/l436fM+r/YAdVyc52OkcQ5EFSW5j3DZyO1CV1UAnmNmX53g4rl920F8xmmze9TH1++qU87tEvWdpWrUrwdN5P+C2F3bf1R1SauJ+8TQ85z3SiryaHtc/p5FSqd/+5onbeKRcmAK6rgSvv4lFn2+WTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523573; c=relaxed/simple;
	bh=FR8I3QcybVNh23QeHn636r2tRiWGu+RwgXT4dQMY4ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwIU4RrFHqxY5tNFsCYAyFxgSKmuIFK1cf8xbfdJCHPgexrzOE5cnSibKKLQgXdcsyGaZcOBElbIDhfgSq+RwYggLGkW0Tb4zk+KhLlkBH6romHTPT6cl25HREAl52mRgJo5fp6A5ajtCwOWlrjcpdRhp0OuJ1mHLqVDfgt2GwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gn7V7tVT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gn7V7tVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC6A1F008A0;
	Wed, 16 Sep 2026 01:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523558;
	bh=MBwSgvxC4e+2C4tf7uicIHIowDdMKsen7ohoo1IJv7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gn7V7tVTjYTM+QF18Tx6a8BE3KhmlVy5cSsoSbQj83+9yXO8E4wAP+NlhfZ5UW7vX
	 z/XZqgA+4H/abPLXypDzCKgrUJC87xunNCgf1/4XzYeIOYzktEjoAi5z7OpBgceOBF
	 vl7H1OMWCUaH/Mdc9KUnjExky+i786SvhLoBUolRNHGW/YYdAiY5iX0OuyfK7mPE9f
	 n+zk7RF+XHlViLfi4rVJTk67X4YomPKJsb3mizZUGIT5JQGmB2qzRFmB4YeFPZSng+
	 4RwzrJ3x0xDZizzEvcKuX3uVafVYaYLHorIFt5GIn2t9v9rKsGkN+nxgf1Bmzy12J1
	 nNcFZni1ZKIPQ==
From: Sasha Levin <sashal@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and release
Date: Tue, 15 Sep 2026 21:52:17 -0400
Message-ID: <daily-reply-20260915-0012-re-l2cap-recv-cb-5-10-revert@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091453-unwary-delete-b272@gregkh>
References: <2026091453-unwary-delete-b272@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Now dropped from 5.10.y and 5.15.y as for some reason this is marked as
> adep of something that is not actually in the queue.

5.15 dropped it, but 5.10 did not: the backport of 89e856e124f9
("bluetooth/l2cap: sync sock recv cb and release") is in v5.10.270. So
the recursive chan->lock deadlock Karl reproduced is live in a released
5.10 kernel. I have queued a revert for 5.10.

f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock") cannot fill the gap on
either tree, since hci_sync.c and hci_sync.h do not exist there.

-- 
Thanks,
Sasha
