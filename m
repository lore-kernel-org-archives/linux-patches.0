Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D41A3AE18D;
	Fri, 24 Jul 2026 12:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897775; cv=none; b=kSJkxLIn8dZrzDzyQ2ZuJNzzkcqu4c30fQLgCH09IBv+F/D+D4X/YXIGQsBucafA8SRtxFUGPLO980a46UEO8FZYQq0lPh4OaubfAKAMB+7VKwpjGOqpFv1PcSwgT01r23kIbmiq3fqRM2yj+0FTlZ2VvbgEXwnGr7hCdlqZHMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897775; c=relaxed/simple;
	bh=vo5yzZrRdZJOR+FvWsRitydoa0jitoYM15VKZZKuKbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSfZnISBaCSvmNjkXklBKxbjiF9akaUVfVgQ6RRX5DL+dJlVKO7zhNnI4hwS82JDCEhZrd8ZIbmLidaiFp7FN+Uqndv6biS9tGPbvvPvS26OdbbH1dRtBitvnqhhxt4jbaJJ0Dpyx7U+lTGNra5kEh+IKQEwPCG2ogDORT029hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZW8SI+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZW8SI+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A251F000E9;
	Fri, 24 Jul 2026 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784897773;
	bh=i41NWKlDp3HYYXQH1Tmybpdb6jriXN+PKrUMrTlU3pA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mZW8SI+DCwSz4F2vtMKBiHVtcgWDqqf4xI+axYbUs1BZgSaPJj78FNl4oMvAKA5jg
	 7ejJSKtDXJusHjofJb1EH+Lq9JKYjwmVa9y1B7mTq+GuTMUXE/gY8R47JzoqBeKJ6c
	 uNgdsAtEda10GlNLzYvqqEPJdAnk0Q8TTRS5rR+RxR+2YjYa41rLmQePOEAIbqXjk+
	 BjyC0ypX9J63oCofFw9g0Ti4Ysg83L5GRtGtgXfRxy2p2KZEp5dR5nI3iGNVZWfj9e
	 //75tpQy2TU2E2lom+SIuMfbijoNxvCB6gZdH13ljfznQYloSLJ692jvKQ/sHkCTnY
	 t0xQDACp7LSaQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 946AE1AC5AC8; Fri, 24 Jul 2026 13:55:47 +0100 (BST)
Date: Fri, 24 Jul 2026 13:55:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Message-ID: <amNg06YtBLYS5-GT@sirena.co.uk>
References: <20260722142834.868902312@linuxfoundation.org>
 <16237d02-bc2c-4401-a1e5-1d81961a65c9@sirena.org.uk>
 <2026072454-vividly-suitor-3eb5@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026072454-vividly-suitor-3eb5@gregkh>
X-Cookie: Take an astronaut to launch.

On Fri, Jul 24, 2026 at 08:19:25AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Jul 23, 2026 at 04:17:55PM +0100, Mark Brown wrote:

> > Full log:

> >    https://lava.sirena.org.uk/scheduler/job/3014030#L10663

> Odd, and this is not regressing in Linus's tree as well?  Did we miss
> something that is needed here that mainline has?

I schedule this test on a board that's been broken by the serial console
regression I reported yesterday against -next so we don't reach the
test.  I didn't see it stable in v6.18 and v7.1 though, could be luck I
guess?
