Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0551E4A9;
	Wed,  3 Jul 2024 12:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011137; cv=none; b=FyIooK1J14hUbpv91OquDxJiCVJsUdO+pWg+iQJDdg/SCSvEiITXuifWeUYjNVkhbMFAKYefddO4y6r3Q7gJBpvfyGnRQSgvDrekde/I4lJTZFA7rSaPzvyiSJNb9I55Wk8MD8ah3AlMJccEhP+8tbFI3IR0P0GGT3+1mxXDKL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011137; c=relaxed/simple;
	bh=nNNUZm664y5+aNHN4KM1zSbOCRzvw78F77j06vmhomo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hje5e6UDC6Kd7DJVgMWsqnlsGd+2tyLZz/3GOEE8mx9jb/+3fBeF34u4eRls8VGMKdEXmK4R4RdlIUCQr1eP0HmCkLYO2o/epf61z8a8NMaDqlj/uBrzQtbhZR0frWwLjPoYbt9XubQ4TjEi1Mk93b2o4BzrEIqhApf5VK6j4X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kty/ro7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kty/ro7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51E5C2BD10;
	Wed,  3 Jul 2024 12:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720011137;
	bh=nNNUZm664y5+aNHN4KM1zSbOCRzvw78F77j06vmhomo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kty/ro7yN0MVcaiFs/RgccK6ns6GLON2tUIMFvzFvwSv6b0ey8XcpVI6MCS3ch1wl
	 0CNLWswpyQ7hiWG7p9J2pEgiNFva+pKmpU2a2AzZ5pd6Tnuby6s46LqGSJsrm6UX88
	 FRiva05RaMVzlStoV5iBynIFgYMohnpfOiqjqtZU=
Date: Wed, 3 Jul 2024 14:52:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 067/356] selftests/mm: log a consistent test name
 for check_compaction
Message-ID: <2024070349-convent-quiver-dc57@gregkh>
References: <20240703102913.093882413@linuxfoundation.org>
 <20240703102915.636328702@linuxfoundation.org>
 <416ea8e5-f3e0-47b3-93c2-34a67c474d8f@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <416ea8e5-f3e0-47b3-93c2-34a67c474d8f@sirena.org.uk>

On Wed, Jul 03, 2024 at 01:02:18PM +0100, Mark Brown wrote:
> On Wed, Jul 03, 2024 at 12:36:43PM +0200, Greg Kroah-Hartman wrote:
> 
> > Every test result report in the compaction test prints a distinct log
> > messae, and some of the reports print a name that varies at runtime.  This
> > causes problems for automation since a lot of automation software uses the
> > printed string as the name of the test, if the name varies from run to run
> > and from pass to fail then the automation software can't identify that a
> > test changed result or that the same tests are being run.
> > 
> > Refactor the logging to use a consistent name when printing the result of
> > the test, printing the existing messages as diagnostic information instead
> > so they are still available for people trying to interpret the results.
> 
> I'm not convinced that this is a good stable candidate, it will change
> the output people are seeing in their test environment which might be an
> undesirable change.

Did it change the output in a breaking way in the other stable trees and
normal releases that happened with this commit in it?

thanks,

greg k-h
