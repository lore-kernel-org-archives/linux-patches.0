Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543D117DFE7;
	Thu,  2 Apr 2026 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137093; cv=none; b=Un0OGrvF6x0sdHrQtXrbnMqLrb1FUMdthlKCYgJyL9KIY2GYJ9EeDobu8py2wGqsEJdnjoxrhF8vDG5LilQdbyy66JullFiB2O8rEh8LhhSBXP9weaUFc/tylvDCwTdVSKniR2+62zp6ACWJtSJnSoJYq/uqJ1WBveFEnUgT/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137093; c=relaxed/simple;
	bh=Td3icuELWGGH1yowg86doR00XdlTWwQNfYSLOJ4dNIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ty+y7hQJzJ5g3CPhqcjq4qvMX6jsYaIzb0PnaVv8334lSHNg5jSQ1S4bTpWzpOaL90Chqaawd86a099iqxlZdP4EI56HHmRwJ9GXjkT9vtlOMVS4KL2K1e8D4b43kA34f4ybmj8Ko1/M9Gwvcu1omcio4QQ3Hn+fcPTZ4C9pI5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+k+oG10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+k+oG10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AD1C116C6;
	Thu,  2 Apr 2026 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775137093;
	bh=Td3icuELWGGH1yowg86doR00XdlTWwQNfYSLOJ4dNIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=y+k+oG108+OiylRehuyrynpOsaprc8BZLqXtR3U4nShVEF9DeJp8RjRw74tNRdSZ0
	 xIgw3Kw/Jv3uBRheElktp6a/les9zm01JEqaFZ23UFW15IgSEWQSt2dN5AbUWDmL8P
	 5o22/scL7UvjYOoaLmPqm91YWLI5dFWSHrhJRit0=
Date: Thu, 2 Apr 2026 15:38:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org, Benno Lossin <lossin@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
Message-ID: <2026040254-spoiled-refinance-5b48@gregkh>
References: <20260331161741.651718120@linuxfoundation.org>
 <20260402132540.124376-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402132540.124376-1-ojeda@kernel.org>

On Thu, Apr 02, 2026 at 03:25:40PM +0200, Miguel Ojeda wrote:
> On Tue, 31 Mar 2026 18:19:10 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.80 release.
> > There are 244 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> > Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> There are a bunch of `CLIPPY=1` warnings (errors with `CONFIG_WERROR`)
> like this one on the pin-init change:
> 
>     warning: unsafe block missing a safety comment
>         --> rust/kernel/init/macros.rs:1015:25
>          |
>     1015 |                         unsafe { ::core::pin::Pin::new_unchecked(slot) }
>          |                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>          |
>         ::: rust/kernel/block/mq/tag_set.rs:27:1
>          |
>     27   | #[pin_data(PinnedDrop)]
>          | ----------------------- in this procedural macro expansion
>          |
>          = help: consider adding a safety comment on the preceding line
>          = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#undocumented_unsafe_blocks
>          = note: requested on the command line with `-W clippy::undocumented-unsafe-blocks`
>          = note: this warning originates in the macro `$crate::__pin_data` which comes from the expansion of the attribute macro `pin_data` (in Nightly builds, run with -Z macro-backtrace for more info)
> 
> It is not a huge deal, since they are just `CLIPPY=1` warnings, but we
> nevertheless try to keep them clean.
> 
> Apart from that, the rest looks OK.
> 
> Cc: Benno Lossin <lossin@kernel.org>
> Cc: Gary Guo <gary@garyguo.net>

Ok, I can live with clippy warnings, but will gladly take a fix-up patch
to resolve them :)

thanks,

greg k-h
