Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B820FABA
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 10:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737543407; cv=none; b=GZKDrhdRYQDF8t+6I9DII5kSmepKjD8avcyijdZQB7XHKEsrec0RbGkYTzN9vnlok3xDTDwBeBbpztm2IvhPS484B1Ih8l+8KlswdHxGhnrvJil1GplvfkOcV8IYBwKxiwd9Q6ZAqskJGK4vIIeMCDTs9sotbBCzL64tJcEokog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737543407; c=relaxed/simple;
	bh=AnzI3OIDtlwopPeC+exjSijeqvuf4PQUZbKrW9OGbek=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=J7rQhIxYTBKyRBWqSYBaTO+SaY3RBwcRO0z6s9QsD09bAwYm1nBWR7KEjDqEMeqWrpeWIsY8KavIzLduIsHKrKa9ibgDEoda+mkLri8vHe13Y1WH7XTlTlwUr4GYToKQGBDF5MBiUGcYsS4nbfXdT5WmKxyMgANUp4MnjFUEWMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=vmV5jOq0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=h4gargiU; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="vmV5jOq0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="h4gargiU"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6B70E1140089;
	Wed, 22 Jan 2025 05:56:44 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 22 Jan 2025 05:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1737543404;
	 x=1737629804; bh=IOqEecwDXajVgLyiPNj2jrdlv5N8/BMqYGepKTfgfYQ=; b=
	vmV5jOq0QoUxt+M8oXcw9dcyh8Axrp/BWtr1xqVRtSFwtubObZMpMwAlON0IaYYo
	BlpNK2qvQQ91mRpsd8uu32PjgcNlC93qFryDLWoJ4KjwNzT9R2VpGcgFpgNWb5qW
	ieTQJ84KlTCn6ahVNiKpme5Q2rfd7Zc6CWxke1/pUUSF0pL4S+h1KAQoDL++RGpA
	y6avmlDAqnsYDzkaG3LOk4b4Z72nPDIGz4GiS/oHbTmLLM06XM1i3gt5mwpLJdFO
	G9k6e4iI92/31DURFSmpLzC8lYyBGA7NcWgeMc1s8MLBOuWJqDvOlBdA+OJhssY0
	Y2KcgCCr+6GjYT6OXXoKtw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737543404; x=
	1737629804; bh=IOqEecwDXajVgLyiPNj2jrdlv5N8/BMqYGepKTfgfYQ=; b=h
	4gargiUPH03fHwpc/1zwxQ4Y5WFJXhOio/xbKWYwXaMHssJ4emGeVN6MAX7XFsT9
	QLZmX896+o9i+pZK55HuRnihDSk4C4qdp1uVmmAt74bgFwg0CApH1l3akJkkB6oq
	KdrJ7ecklO8DjqZS4Fp+fPwBtb0gcvfs1hZp2gIo9+Jh2jsmFkWURpCtDdn6SKDf
	2h9yn3iqm2y1xFf1yJyilfWMBpcgc/fesuqVYjRzM6DNJL2nYGMnX8ukkOmJJP34
	3VMGIcPl16ncXBXHMfdwH31yLsi/EbvE2IR9qJDl3ppA9lZApk4Or63UMHEEj//+
	/2ZS+ni2sev2hpBO/VvdA==
X-ME-Sender: <xms:686QZ1JltolmzfLuK05dRrvCa44_v0ZJgUc3BoC2I5_ue3eIQ-80Qw>
    <xme:686QZxLsPk2MtbLlrJKyWqBIhkoKKM7uhgCBLgmL52bX5rVyOMpmBr7jIlOwi9ise
    y4fXfquYceJdLv9FHE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgudegkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteef
    gffgvedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopedv
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphgrvhgvlhesuggvnhigrdguvg
    dprhgtphhtthhopehfrdhfrghinhgvlhhlihesghhmrghilhdrtghomhdprhgtphhtthho
    pehsuhguihhpmhdrmhhukhhhvghrjhgvvgesghhmrghilhdrtghomhdprhgtphhtthhope
    hrfigrrhhsohifsehgmhigrdguvgdprhgtphhtthhopehpvghtvghriiesihhnfhhrrggu
    vggrugdrohhrghdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopegtohhnohhrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehshhhurghh
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghssehkvghrnhgvlhgtih
    drohhrgh
X-ME-Proxy: <xmx:686QZ9sH258KPIY71xIqdac19FC09bu11zuKQJqMFZ7ZVW26SFzJPA>
    <xmx:686QZ2aGGEaQwW_Z3IiIb1VnBqE0NoKl-ZjoBbDBudniBsM81kElzA>
    <xmx:686QZ8ahfHdKNp4uYY12DehmsQvYy7RZCPbquTZX6S3vsW8DrRkiwA>
    <xmx:686QZ6Bh1zC9krzG8SEHNUFlIoIHsgF2iMPNBvQzND15Wwox-TeJgA>
    <xmx:7M6QZwpNlZzS4WXgXvkXd5lrQYBhEsO3GQ88re5KxP1wGmvpB6tJwA3G>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A6A302220072; Wed, 22 Jan 2025 05:56:43 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 22 Jan 2025 11:56:13 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Guenter Roeck" <linux@roeck-us.net>, shuah <shuah@kernel.org>,
 patches@kernelci.org, lkft-triage@lists.linaro.org,
 "Pavel Machek" <pavel@denx.de>, "Jon Hunter" <jonathanh@nvidia.com>,
 "Florian Fainelli" <f.fainelli@gmail.com>,
 "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
 rwarsow@gmx.de, "Conor Dooley" <conor@kernel.org>, hargar@microsoft.com,
 "Mark Brown" <broonie@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Dan Carpenter" <dan.carpenter@linaro.org>
Message-Id: <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
References: <20250121174532.991109301@linuxfoundation.org>
 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Jan 22, 2025, at 11:04, Naresh Kamboju wrote:
> On Tue, 21 Jan 2025 at 23:28, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:

> 0000000000000000
> <4>[  160.712071] Call trace:
> <4>[ 160.712597] place_entity (kernel/sched/fair.c:5250 (discriminator 1))
> <4>[ 160.713221] reweight_entity (kernel/sched/fair.c:3813)
> <4>[ 160.713802] update_cfs_group (kernel/sched/fair.c:3975 (discriminator 1))
> <4>[ 160.714277] dequeue_entities (kernel/sched/fair.c:7091)
> <4>[ 160.714903] dequeue_task_fair (kernel/sched/fair.c:7144 (discriminator 1))
> <4>[ 160.716502] move_queued_task.isra.0 (kernel/sched/core.c:2437
> (discriminator 1))

I don't see anything that immediately sticks out as causing this,
but I do see five scheduler patches backported in stable-rc
on top of v6.12.8, these are the original commits:

66951e4860d3 ("sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE")
30dd3b13f9de ("sched_ext: keep running prev when prev->scx.slice != 0")
a2a3374c47c4 ("sched_ext: idle: Refresh idle masks during idle-to-idle transitions")
68e449d849fd ("sched_ext: switch class when preempted by higher priority scheduler")
6268d5bc1035 ("sched_ext: Replace rq_lock() to raw_spin_rq_lock() in scx_ops_bypass()")

      Arnd
