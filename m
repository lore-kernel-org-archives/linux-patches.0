Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7942CAB
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 19:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736711973; cv=none; b=TzcxjOQw+LIEefv9V53ThUvUUe/PY7Hox0cVwuk2DVcv/HUdlyW87b9hydyAhhAVUSWMidh9+eFwhgGe2KmvxLY4p2esttd9inYygk0CtXP9+6E6CNrDFhooCT2imTqETkvF6fPsHpv144gjcPPRShUJ/VrMMObOCta/w3jJCAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736711973; c=relaxed/simple;
	bh=EmT0/6rZlSTB8HmFsJzaPuZE6y1Mg8+/N0f492LhROI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tVC2o0VgA6gpXX/me6fpJj2e6jVMZ2hXbfdAgYxBK8Nc7NiJW7QSubho1BAGzmIWmxsl3nC43RVO7p6tEPpY+jKqQtOFfkR6rJG2YeB+nuWoIuLVEiM8JUDbYRe4RqqormcyRvdopmvEPJJs862oz6wMjVO2U4k7OhLBPcyMx3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=WxN8BMU9; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="WxN8BMU9"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net BBF6840409
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1736711964; bh=LrsNTitHGd3IPIBGiv7yoGBBn65iWAffM97G3kOIwk4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WxN8BMU9zthrAmn5OE3O/OMUyBe+ND8c/yMLYQb00M5c6nQIqOhYK9dewNw+P9rZ6
	 pUZ15D2rf5/oa+HFWkMapXgEZR6e37ow6HQhkkUQx9gMLtgVbbAWu38IvooZj6zr3c
	 SF63OTujrItn8O3LqjHv+T6wJdovWYrsN73U9Z46nCuY/f+bMmhK4DAiNiAifE7OFi
	 5x7i04IgkYQSVbAlofUqogjwKbdRvGqW4y/Ex+aC7m5q4w4z3wybmG9NkwwEVF50sf
	 6HBuae0v87iqswoJSbgGz8wN2UjpfelIdf0qIPjXpRLEo3cRvuEVSjYeeDyMdO699L
	 2LEJBAlNo04Lw==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id BBF6840409;
	Sun, 12 Jan 2025 19:59:24 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Neal Gompa <neal@gompa.dev>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, Masahiro
 Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 tech-board@groups.linuxfoundation.org, Steven Rostedt
 <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference
 between Acked-by and Reviewed-by
In-Reply-To: <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
 <CANiq72kQOrvi5=1RUScEpov79RNzA3vna9KW6MoYmj8XJZhpQQ@mail.gmail.com>
 <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com>
Date: Sun, 12 Jan 2025 12:59:23 -0700
Message-ID: <878qrfdcro.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Neal Gompa <neal@gompa.dev> writes:

> I've had my Reviewed-by tags silently ignored or deliberately stripped
> because even though I've done a technical review, the maintainer does
> not believe that I did. Therefore, what I am saying is that
> maintainers seem to speciously decide whether an Acked-by or
> Reviewed-by tag is appropriate or not *after* someone has sent it.
>
> This is the fundamental problem I have right now. This decision is not
> the maintainer's to make, it is the submitter's.

There *are* people who seem to make a game of getting as many such tags
into the repository as possible.  I think a bit of maintainer discretion
is important here; I don't believe that there is a fundamental right to
inject a tag into somebody else's patch...?

jon
