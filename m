Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6AA17BD6;
	Thu, 24 Apr 2025 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745505270; cv=none; b=CRmvvYTgbOAcD0gme15Fsf+5MM2kpruCE61XJgagZho2x5qbtoo9no5gQ6c73wJGJvIrSl4B8uqvpYN17MOEchosP7p+QqSlyiDYqgjQSLHOt4akcfN7hOMC+b2czRoWjxhS6gmAL8bSG+PRuZ4u90qANDVZSJhl3qb6r0Z6amQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745505270; c=relaxed/simple;
	bh=lBY632yHFONY6RYE7IZBlTMj+ZH0jJ67pll7LbVsi50=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QwfYOm5JOT6Gnh0P4FYgMFMQbYN/HlK8VJEDv8gteDWwz4Piz2qiTmRiOF2r16YWXEV49vsU//Z8Gy4vpbMBXdoq+6a67sZwNrufIwwBRssiQuOF+TKcY3jqxM5lFkAUsXwhHk0LeO/0mRrECJB7PfewCopmeNlQDvjK+av6828=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=fcyInJHC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=J1cOdWPH; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="fcyInJHC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="J1cOdWPH"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id E4EAC1140230;
	Thu, 24 Apr 2025 10:34:25 -0400 (EDT)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-05.internal (MEProxy); Thu, 24 Apr 2025 10:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1745505265;
	 x=1745591665; bh=zTkvCEnROr1A65wAUwD/pBdGL1QA1EttebQzh1cAxms=; b=
	fcyInJHC855hzAWTZ2h3AVxngjSc+fFcc6loF5MtVM9qaOJ8prCdjio44QD9CK9Z
	zMo6bJmPFq12CjR1VuSXrd9eKceErfiaxlG6nx9Z7ae4o7FBSAupTULqA4oaTzBi
	VHseiiHlUY3DYaU9iEeeiFN0sUD//cd46MTtY0QsHBQRIQoL1SU58lLjwrVzsE4A
	0naxzbGQQ+THgQA6O8wCmaTaQs6j1l5B9duv7w3CEhDfE4YWon6WVJ7kCg6hDP7C
	eTovsz+eXTyq6p1ex5NUN7QUvL83hA19JJ4ygoXSxvI9UYxU+GV3q4xQUHHkcAXQ
	n74I3uYZO/bsuUkm0O4aYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1745505265; x=
	1745591665; bh=zTkvCEnROr1A65wAUwD/pBdGL1QA1EttebQzh1cAxms=; b=J
	1cOdWPHspr4C/scac8IbOUvSOQvD7e9hdQwop/kh5GV3ew7KZ9gna1X5H4LDUafk
	bMF07kCGYjRO6/eVREigZDQmrZAa/8YYA9RipNYfDARrAMMTzl5sNVl4YXwq0cF8
	yMQ2fMouIDZDqpIf2vMwqpwX5vmGgZ0MB5luG2puRjIeadnYxzhsrUK+uIB2G+cE
	NH5bgY2PzEDF1NUyVxjqH1DP22r1E2sHXZiqjjanV2hdDL3e79rgr8ec3VzSSLxO
	f8J/xt5hufP1MwdiDV6GunboWKjvSbd3JiG/Gn1pu04tvK+O9fBSZe/Kim1qKwUf
	OaK3PxMkaKdOC9gbawmEw==
X-ME-Sender: <xms:8EsKaJNuqCDjxjPu2DaEr7dsZ_7l5s-hCob_4zL0GrheSqjJGNUtxw>
    <xme:8EsKaL9CiezppF3Q0XmZ1flUGkn9nl3Co3i0yHskhUc9UC2_3bFu86TBe9Z6NblJm
    tqHA6SWF7UOn-TIsi0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeeljedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnug
    gsrdguvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeet
    fefggfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohep
    vdejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvvghmsegurghvvghmlh
    hofhhtrdhnvghtpdhrtghpthhtohepphgrvhgvlhesuggvnhigrdguvgdprhgtphhtthho
    pehfrdhfrghinhgvlhhlihesghhmrghilhdrtghomhdprhgtphhtthhopehsuhguihhpmh
    drmhhukhhhvghrjhgvvgesghhmrghilhdrtghomhdprhgtphhtthhopehrfigrrhhsohif
    sehgmhigrdguvgdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopegtohhnohhrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkuhgsrges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgrthhhrghnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:8EsKaIRd3Sl6rsoO-64VW8JMHzPSHZHnQEFXsQgChAQ5zl4caKg0Xw>
    <xmx:8EsKaFvV2KflmPXyAtdb-mxtNoD6jzwtux6j6qlRaEZk9tQXOdCcTg>
    <xmx:8EsKaBdeKh2DeonmkhAqgy2IqsLyOLIKpI9ahv7V0oMJFbIKmdqcIQ>
    <xmx:8EsKaB1WrauUdokUwXNaVmdICfNCsKJYwzgs3ppl8MxOgLlLbqsEcA>
    <xmx:8UsKaLtlJLq9XUVq_FgwPc-FdeQNxlAG4nvOIao8z4kjl0lxY1b-AarP>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CA59F2220075; Thu, 24 Apr 2025 10:34:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: T573a13c25518dc45
Date: Thu, 24 Apr 2025 16:34:04 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Guenter Roeck" <linux@roeck-us.net>, shuah <shuah@kernel.org>,
 patches@kernelci.org, lkft-triage@lists.linaro.org,
 "Pavel Machek" <pavel@denx.de>, "Jon Hunter" <jonathanh@nvidia.com>,
 "Florian Fainelli" <f.fainelli@gmail.com>,
 "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
 "Slade Watkins" <srw@sladewatkins.net>, rwarsow@gmx.de,
 "Conor Dooley" <conor@kernel.org>, hargar@microsoft.com,
 "Mark Brown" <broonie@kernel.org>, Netdev <netdev@vger.kernel.org>,
 clang-built-linux <llvm@lists.linux.dev>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, "Jakub Kicinski" <kuba@kernel.org>
Message-Id: <e77b24ce-e91b-4c90-82d6-0fa91fcce163@app.fastmail.com>
In-Reply-To: <2025042443-ibuprofen-scavenger-c4df@gregkh>
References: <20250423142624.409452181@linuxfoundation.org>
 <CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com>
 <2025042443-ibuprofen-scavenger-c4df@gregkh>
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Apr 24, 2025, at 15:41, Greg Kroah-Hartman wrote:
> On Thu, Apr 24, 2025 at 07:01:02PM +0530, Naresh Kamboju wrote:
>> 
>> ## Build error:
>> net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
>> uninitialized whenever 'if' condition is true
>> [-Werror,-Wsometimes-uninitialized]
>>   265 |         if (unlikely(!(dev->flags & IFF_UP)) ||
>> !netif_carrier_ok(dev)) {
>>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Odd this isn't showing up in newer releases, as this is an old commit
> and nothing has changed in this file since then (it showed up in 6.8.)
>
> Is there some follow-up commit somewhere that I'm missing that resolved
> this issue?

I think the difference is commit 16085e48cb48 ("net/sched: act_mirred:
Create function tcf_mirred_to_dev and improve readability") from 
v6.8, which adds the initialization that 166c2c8a6a4d ("net/sched:
act_mirred: don't override retval if we already lost the skb")
relies on.

      Arnd
