Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CB51AE86C;
	Thu, 29 Aug 2024 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724939231; cv=none; b=hE3NT1omVyg51WTEgZYiyyaaGCStzSLmNa6ho5IVHNrYa+8z4zl1Ui2MzMIUko1QocdOuaqESBd1k6fY7eIzvAfFBqyD/1FryHq2pPBGiaWFQwBpPywsLlMGAtlC7p8eMVmEgqDM0k7GN/W90xQrogMlQY/yadxurCuu+SA0Q2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724939231; c=relaxed/simple;
	bh=5prqHuey4cnxotk8J/OPRkleI+Nv7YerIbInSFCxGDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlGtqVHmS1mqzV333qawoLs5iWGu7u/kNn7qw6GenxeP76vPcn9xLDZTaU6NtY5MISpA8Imk8NuMwq+UOdtAoIIJdBoGCEjxHZ6Ll4b6cWq4JTxA1SH7xFeuVQWjP+qSb1l2BxGG7q3BPPWufFNTTAWBfgnEIXBXUhqTgizSXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXP2NqvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXP2NqvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4974EC4CEC1;
	Thu, 29 Aug 2024 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724939230;
	bh=5prqHuey4cnxotk8J/OPRkleI+Nv7YerIbInSFCxGDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HXP2NqvTqxl5kOhvt0ahADCD9lXWTKaSXFuy9Tc9W45UHc7XRmUZQTmM0+ih5echt
	 1mSeRtrlszhRIRFL+EJzbg2q2PICKtJmmiASqiDDUFxIc8aFUpdpqmvu90TYuqFgGD
	 1SWZ6cLgoaNh9oaJxkr2COsefP/sdBCUBjrJIDAw=
Date: Thu, 29 Aug 2024 15:47:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	kuba@kernel.org, linan122@huawei.com, dsterba@suse.com,
	song@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
	christian.brauner@ubuntu.com, keescook@chromium.org
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <2024082937-grandpa-sliceable-40ce@gregkh>
References: <20240827143838.192435816@linuxfoundation.org>
 <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>

On Thu, Aug 29, 2024 at 01:37:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.107 release.
> > There are 321 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I believe these have problems:
> 
> > Jakub Kicinski <kuba@kernel.org>
> >     net: don't dump stack on queue timeout
> 
> This does not fix bug and will cause surprises for people parsing
> logs, as changelog explains

And as the changelog explains, this fixes one of the most reported
syzbot issues around, and as such, qualifies for a stable tree
inclusion.  Please be more through in your reviews.  Same goes for the
others "reported" here.

greg k-h
