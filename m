Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5FC143748;
	Wed,  9 Apr 2025 20:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230399; cv=none; b=UhCn/q2AotTKXKQdqRJ4DXAH615s5EFtHgxhkya0r/C9ofTYh3T+QbHCdG2oTCkUiy/kzFh/lscKDpopkHPRUxVwvz1e6UKG70C3zF51DB5TEO47LOqIyvTSJX+PLhuqUCigEQsW3g+XyOep9j4hHFEgyCFqp3VoAAQkRgMpQDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230399; c=relaxed/simple;
	bh=WJZb8CIs6oDkFKT7jPcSMeZ3OH2lSmo8VJRB99SoJd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSOU83JaGxxa6tyDT0LuX5J//85um12cAi2AaDCDWULKO0Qww9qGjrc3rEudnnBhF0pG8ZmrIP8wBgNddA7duzCOvp+lBllaDqSN3l8TqS8NBhXVd2rnP2P17TltZkJw9kzo3RGmiZWiJxYuGcRQ5NFgXoJF19xZZZVhp5NHdm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyTKDMuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyTKDMuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42867C4CEE8;
	Wed,  9 Apr 2025 20:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744230399;
	bh=WJZb8CIs6oDkFKT7jPcSMeZ3OH2lSmo8VJRB99SoJd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyTKDMuwHg3fOBYyRroHFg3OTUtkLcZn1aygEAvexfGhx1qKq8Sl1tr3LuTJsaWMT
	 K5nHGj1UAVmmLkVAn1s9rOE9t+mBD7yh+uW8tO8cTVwzZ3JWdqV2UaQLxn9p+sRLRh
	 s9hwkAd1j6WfFPpBnZ7cLi3N70127xTiKtC+vaWE=
Date: Wed, 9 Apr 2025 22:25:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
Message-ID: <2025040918-knapsack-angles-0bb5@gregkh>
References: <20250409115832.610030955@linuxfoundation.org>
 <20250409161034.1244178-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409161034.1244178-1-ojeda@kernel.org>

On Wed, Apr 09, 2025 at 06:10:34PM +0200, Miguel Ojeda wrote:
> On Wed, 09 Apr 2025 14:02:32 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.134 release.
> > There are 205 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 11 Apr 2025 11:58:02 +0000.
> > Anything received after that time might be too late.
> 
> For 6.1.y and 6.6.y, Rust fails to build with:
> 
>      error[E0432]: unresolved import `crate::ffi`
>       --> rust/kernel/print.rs:10:5
>        |
>     10 |     ffi::{c_char, c_void},
>        |     ^^^
>        |     |
>        |     unresolved import
>        |     help: a similar path exists: `core::ffi`
> 
> In 6.1.y, C `char` and `core::ffi::c_char` are both signed. So the only issue is
> the `const` -- we can keep using the `core::ffi::c_char` type.
> 
> In 6.6.y, C `char` changed to unsigned, but `core::ffi::c_char` is signed.
> 
> Either way, for both branches, I would recommend dropping the patch -- it is not
> critical, and we can always send it later.
> 
> Thus, for 6.1.y we could just drop the `rust/kernel/print.rs` changes. And for
> 6.6.y we would need something like:

I've dropped this from both queues now, thanks for checking.  Turns out
I'm not test-building rust in these stable releases, nice catch.

If you want this in 6.6.y, can you resubmit it with the suggested
changes that you had in this email?

thanks,

greg k-h
