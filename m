Received: from wfhigh6-smtp.messagingengine.com (wfhigh6-smtp.messagingengine.com [64.147.123.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9A38DE4
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 07:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712042383; cv=none; b=W5JgBKcxSx8ftkIFTb1SXIIELaSuZJZ1XFOIl4GICNwl43TR9UuDablIC+3i+B4U72mVpyRScLZKCj2lvmonWH5C3zZf/DWo/q5BJOjWbHzmA4ZeaA9acVa0biddOxoR7TCcY673+Wtc+fuzT4WDv3eIgI3F/ri7OHnIMAvIeOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712042383; c=relaxed/simple;
	bh=t3+dbsfIPQbeWr+q9uViuQaTIjBdHTYZlXXnXSbWL8Y=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=CnLoHrgDZwNhkRm8j6TF2R8HcdRJgmzwqvmCqWOc/zprEZMjjvd0zB34QqfJRv9bKN7ta7qi3TavBJC07h6HoXpr7xHhK9zH+XBBUOdZ4GDA9FNbM+W/FYKtxWWHWA5pU9pg2godcW+2ph6cMLxh/zDbOrGWc/WAQ5qDFS3pdzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=bszLAKDj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=q2xTIGu+; arc=none smtp.client-ip=64.147.123.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="bszLAKDj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="q2xTIGu+"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 1B9221800083;
	Tue,  2 Apr 2024 03:19:40 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 02 Apr 2024 03:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1712042379; x=1712128779; bh=oa7kRr3e8B
	3txZcQabphYPUectsNgHIIATUahJ1A5rw=; b=bszLAKDj5LEPuTvHOj52mL5WZq
	vvpWCNli2adlBnon9dc4SFGYwKLWycmGqOC0rJbdHW4CjCSTlAxQKbvKTWZgAEXE
	K6TzcvUdV0xuL4zShdQW8+zAJGQJBdkSi6njZ+uf4L73VGZsJXAsp+Wcc/q3Z4al
	kkRNxkfw2n4BYNbrIcGXdhnoWSNSdNLf47sN/VrNhNovsUeZj7DOLsajR2Nh4NXx
	cD5q68p8ZakyLgesQQK94HaiobYBLeD52qpW0z+yVlZYqANPNqldkM0zE308tM6Z
	Ctf5OHkxw3zCuCzTI7CTSuBZrQlxUqYp71xg8ONhxjFoAAOhmo05VHltin7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1712042379; x=1712128779; bh=oa7kRr3e8B3txZcQabphYPUectsN
	gHIIATUahJ1A5rw=; b=q2xTIGu+1UjJmJHHOAJJLn2b0N8sskvyVBEUcv/IhTk0
	BU1Vu2HOSrGBiPBc+4KcAt+AIe4dxyoaJyHvRMAIFp0EcOnscMakNIw35eVHcDqS
	unaCHKcl0Yq3CTM2IPDI/BIHgJE8/4wOHCotCy8WNe1ME2UMoA/dL05i26OtlCVH
	e1p9NYb4ecVkwyksqMh0ysJc2VG/nGbq72ZDbDplQa6OOQUwXC16jof8fdkwDxj7
	8SfeGU2kgarGZhpFtRyPR/B1OxHIjHo2K9ddTo6mFOIuNCMtIKPGR/UxsQt5UgnQ
	l5+y5qK3BUlHBR/ZsDln0Soxfu7Yaki08hGDHQi8Lw==
X-ME-Sender: <xms:i7ELZtXO-ISc2wGaCvIE99R5doTTm0EMqs9iZ5PLnXKTj8b58ejR0Q>
    <xme:i7ELZtmKFdJ0T18i-tv3McxJpRqpKb8xhnFDkVN6l2JpqeBhoYqGdiZFibc1siCvd
    cWHdyWN6uJr2LgFgOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefuddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:i7ELZpZsV_PIZ8N7ejmazo-Bj_zfjgGWSdcySafZ_1GaJR4KpQtOwQ>
    <xmx:i7ELZgVs85q325RzUvX6bFJBTby34AUFs1VbtCpirl-NeWpdUVLmHg>
    <xmx:i7ELZnlAkdP3BQTXbv4a8E_iagD6v5r-OTjyDg-Hxr0HZCtOTYPIWw>
    <xmx:i7ELZtfFN3N0ZYDwcGxBgJguMiQj_OKLReGS8DlXz4AcJmDnsLRqXw>
    <xmx:i7ELZgiY_y0IrzydCVh5QrSFZTlk0TaOuHkODM7KcUbNK3KzoQLqyh3D>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 14674B6008D; Tue,  2 Apr 2024 03:19:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-333-gbfea15422e-fm-20240327.001-gbfea1542
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <44381e5a-cab6-4abb-b928-ebea7ce3d65b@app.fastmail.com>
In-Reply-To: <20240401152556.751891519@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152556.751891519@linuxfoundation.org>
Date: Tue, 02 Apr 2024 09:19:17 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Linus Walleij" <linus.walleij@linaro.org>,
 "Nicolas Pitre" <nico@fluxnic.net>, "Jisheng Zhang" <jszhang@kernel.org>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.8 254/399] ARM: 9352/1: iwmmxt: Remove support for PJ4/PJ4B cores
Content-Type: text/plain

On Mon, Apr 1, 2024, at 17:43, Greg Kroah-Hartman wrote:
> 6.8-stable review patch.  If anyone has any objections, please let me know.

I think we should not backport the feature removal, this was
intentionally done separately from the bugfix in 303d6da167dc
("ARM: iwmmxt: Use undef hook to enable coprocessor for task")
that is indeed needed in stable kernels.

It still makes sense for everyone to just turn iwmmxt support
off on pj4.

     Arnd
