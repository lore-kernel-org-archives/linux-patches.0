Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB6D2222CC;
	Tue, 24 Jun 2025 10:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759497; cv=none; b=pTR3T2Go9zx7dOI3HJBEjUxApikM7pX9BnJ0sLrAyi5sl9/c0Hg4WXXt9f85HI0lA2FeRBoaTNIOirH7ElGhMuh/KlqYgjSivGOCYbI4p+Q6PhzoT4YbZ1tEOm/IlMTuILpsesXHCXw4fjWyR9z9X8Co/zU0a+9ngTMwRKpZZ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759497; c=relaxed/simple;
	bh=3idfn73F/+sFVNQMs0qZ8sSOCpvmYqg2IlJ59BiVbI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M2+gzks7Uqz1hynsVxUdqsFqG7XmR0INLcGk+Y/k0DOETcArk4e9gfWoJKSHA/9No5hG0rZYX29mkBdXDLe840b3leQyHzBKzmqOvokwBkuLgA5hb0udu3c5Lc1vLKIC3iGM57tgn3m/ws5BXpZwpF/G4mDD93Ugh2JWm9+O644=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiQGSidh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiQGSidh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B6FC4CEE3;
	Tue, 24 Jun 2025 10:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750759496;
	bh=3idfn73F/+sFVNQMs0qZ8sSOCpvmYqg2IlJ59BiVbI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BiQGSidhaRT+nhHpJzUdSzfO9f9qdOyOT7qvmQOLK9+WCD+1Wm1OhHlMPjmVwrrYW
	 mpRxSz2EBJGjqEttIJ8bpms0yzbYDqMSfXiR3Jzpn+yo+dxDK/N2IoZRiMAQ4/3JBy
	 DE8a1tkAY+cuoP2qV5WQIwWoy3hS7Uhv+e70dgF4=
Date: Tue, 24 Jun 2025 11:04:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christian Heusel <christian@heusel.eu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
Message-ID: <2025062442-ablaze-blouse-9327@gregkh>
References: <20250623130700.210182694@linuxfoundation.org>
 <a0ebb389-f088-417b-9fd4-ac8c100d206f@heusel.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0ebb389-f088-417b-9fd4-ac8c100d206f@heusel.eu>

On Mon, Jun 23, 2025 at 03:50:45PM +0200, Christian Heusel wrote:
> On 25/06/23 02:59PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.4 release.
> > There are 592 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Jun 2025 13:05:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hey Greg,
> 
> this stable release candidate does not build for me as-is on x86:
> 
> error[E0432]: unresolved import `crate::sync::Completion`
>   --> rust/kernel/devres.rs:16:22
>    |
> 16 |     sync::{rcu, Arc, Completion},
>    |                      ^^^^^^^^^^ no `Completion` in `sync`
> 
> error[E0412]: cannot find type `Bound` in this scope
>    --> rust/kernel/devres.rs:226:49
>     |
> 226 |     pub fn access<'a>(&'a self, dev: &'a Device<Bound>) -> Result<&'a T> {
>     |                                                 ^^^^^ not found in this scope
>     |
> help: consider importing this enum
>     |
> 8   + use core::range::Bound;
>     |
> 
> error[E0107]: struct takes 0 generic arguments but 1 generic argument was supplied
>    --> rust/kernel/devres.rs:226:42
>     |
> 226 |     pub fn access<'a>(&'a self, dev: &'a Device<Bound>) -> Result<&'a T> {
>     |                                          ^^^^^^------- help: remove the unnecessary generics
>     |                                          |
>     |                                          expected 0 generic arguments
>     |
> note: struct defined here, with 0 generic parameters
>    --> rust/kernel/device.rs:45:12
>     |
> 45  | pub struct Device(Opaque<bindings::device>);
>     |            ^^^^^^
> 
> error[E0600]: cannot apply unary operator `!` to type `()`
>    --> rust/kernel/devres.rs:172:12
>     |
> 172 |         if !inner.data.revoke() {
>     |            ^^^^^^^^^^^^^^^^^^^^ cannot apply unary operator `!`
> 
> error[E0599]: no method named `access` found for struct `Revocable` in the current scope
>    --> rust/kernel/devres.rs:234:33
>     |
> 234 |         Ok(unsafe { self.0.data.access() })
>     |                                 ^^^^^^
>     |
>    ::: rust/kernel/revocable.rs:64:1
>     |
> 64  | #[pin_data(PinnedDrop)]
>     | ----------------------- method `access` not found for this struct
>     |
> help: there is a method `try_access` with a similar name
>     |
> 234 |         Ok(unsafe { self.0.data.try_access() })
>     |                                 ++++
> 
> error[E0599]: no method named `try_access_with` found for struct `Revocable` in the current scope
>    --> rust/kernel/devres.rs:244:21
>     |
> 244 |         self.0.data.try_access_with(f)
>     |                     ^^^^^^^^^^^^^^^
>     |
>    ::: rust/kernel/revocable.rs:64:1
>     |
> 64  | #[pin_data(PinnedDrop)]
>     | ----------------------- method `try_access_with` not found for this struct
>     |
> help: there is a method `try_access` with a similar name, but with different arguments
>    --> rust/kernel/revocable.rs:97:5
>     |
> 97  |     pub fn try_access(&self) -> Option<RevocableGuard<'_, T>> {
>     |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> error[E0308]: mismatched types
>    --> rust/kernel/devres.rs:257:21
>     |
> 257 |         if unsafe { self.0.data.revoke_nosync() } {
>     |                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected `bool`, found `()`
> 
> error: aborting due to 7 previous errors
> 
> Some errors have detailed explanations: E0107, E0308, E0412, E0432, E0599, E0600.
> For more information about an error, try `rustc --explain E0107`.
> make[2]: *** [rust/Makefile:536: rust/kernel.o] Error 1
> make[1]: *** [/build/linux/src/linux-6.15.3/Makefile:1280: prepare] Error 2
> make: *** [Makefile:248: __sub-make] Error 2

Thanks for the report, now fixed.

greg k-h
