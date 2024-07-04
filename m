Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76BD1A4F10;
	Thu,  4 Jul 2024 09:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085326; cv=none; b=I8HNCBkcEUf9YVna2XhaGrKxdAxRxafzsIWaDV8qxe7e3XCxS9hQEwCTXBAgWosgU9T6Xio4ZlDhhgh11zRMyVvitLGsEmD+nSQoriQSwKR+8nHMcjl/hx8xWODAo+gepNNEu3HX7Btd5JKS+lt4F7HxlOpYuqZjBmjlYIxhfo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085326; c=relaxed/simple;
	bh=7zv/O2MpoRy7DlREmUQ/K/GkYVYtPc2lFm7970aI0XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNmUr/QjVTC2OIVoZZTRw8mdvQARV7V8bOR+5cH+SwKX4tCXIe/YgfX33dSgxsWi6tNofDmcaAr0ehkOjL62D2RY++A2OfxesLI3zIKCLDxvv+4AcPm07iV4LAD+Zlkrw2dpVG5hPqJmg2OQbBq13DjqbW9LCUhLBrqmy+7mkiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQG6SLcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQG6SLcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F560C3277B;
	Thu,  4 Jul 2024 09:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720085325;
	bh=7zv/O2MpoRy7DlREmUQ/K/GkYVYtPc2lFm7970aI0XE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aQG6SLcZbN2pylLNZ0aph6P9kV8Wj95EZtxrEEK6EKjWuo3LMZZRJ9Jx6ROh1FHgH
	 6ySMBvdZ+4NkX6ANQEHA5zvMNq1VTVJuVqKBVBAVOWUhPRncrlhuCBvNxVCK/J9E75
	 CV/HFvo4DdDczTe+8kQgF7KR0SMBSuGW63oGvy+U=
Date: Thu, 4 Jul 2024 11:15:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 067/356] selftests/mm: log a consistent test name
 for check_compaction
Message-ID: <2024070406-reformer-panning-20f2@gregkh>
References: <20240703102913.093882413@linuxfoundation.org>
 <20240703102915.636328702@linuxfoundation.org>
 <416ea8e5-f3e0-47b3-93c2-34a67c474d8f@sirena.org.uk>
 <2024070349-convent-quiver-dc57@gregkh>
 <2a39df32-73ea-43fe-84ba-e840ba3dc835@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a39df32-73ea-43fe-84ba-e840ba3dc835@sirena.org.uk>

On Wed, Jul 03, 2024 at 02:36:56PM +0100, Mark Brown wrote:
> On Wed, Jul 03, 2024 at 02:52:14PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jul 03, 2024 at 01:02:18PM +0100, Mark Brown wrote:
> > > On Wed, Jul 03, 2024 at 12:36:43PM +0200, Greg Kroah-Hartman wrote:
> 
> > > > Refactor the logging to use a consistent name when printing the result of
> > > > the test, printing the existing messages as diagnostic information instead
> > > > so they are still available for people trying to interpret the results.
> 
> > > I'm not convinced that this is a good stable candidate, it will change
> > > the output people are seeing in their test environment which might be an
> > > undesirable change.
> 
> > Did it change the output in a breaking way in the other stable trees and
> > normal releases that happened with this commit in it?
> 
> Yes, it'd affect other releases - I didn't notice it going into other
> stables (I tend to review the AUTOSEL stuff a lot more carefully than
> things you send out since you normally only pick things that are Cc
> stable but AUTOSEL has some wild stuff).  The output tended to be stable
> for a given test setup so it's likely that if you're just looking for
> the same test results in a stable release you'd see these tests getting
> renamed on you.

This is here as a dependency of another change, let me see if I can
remove it and get the dependant patch still working...
