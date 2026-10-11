Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94903E5594;
	Sun, 11 Oct 2026 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724224; cv=none; b=uzljj1JIhGr5nUeLMBUTwz3q8fismbtC7XDfd7m4o9ohqHBruG/h3Zcf28gwr2iLuaskeRrOFtHiLtgkOkoFEa5IPBE4sohvPWpTUNRo7NNuqZ1pSs907IRZ4+rfyms7Ocr2//AWAGUSoUPBqXHJWkYgEcBXn3DeZzeSmxS+tVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724224; c=relaxed/simple;
	bh=8vhV/2HZ1ftlHJZLdB47C2Z8Z6/gO/ea8hWSukoTB9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaG4GgMSYTL+CtHgP86blhlyo228P6om+NVnbvC0OAJPpvJ9gQ6uH62JWRVYhSotWs/zSRgsrDUXXZdHlR5Rnt0pxwo5pOvufvIlyaxMJDzkJ6fEB56HP4Z7sb6LXTwQrKU82uAVAGhPztdhabG880st2Vf3DJlphCFtaiXSg2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIkub4Ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIkub4Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9141F0089B;
	Sun, 11 Oct 2026 13:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791724223;
	bh=06YExlWYCYI2hlQoPljJejdL84JiLaFEcetoMG9XiQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dIkub4Ry0SRjcg6tUuorFGY0Kkzyul9x22/bilKGBNQalnJV4n8E8zfegK77hYbX+
	 ToQNXCOzRfiLS7riASX8YZrC2wWKjHpXlq0ByDpiIb/OpGF3vjsHrGWOZScwkQ2TGO
	 zcPXt4Vd4tPW1PGvGRe6niAfz6CSvWVOazcOD60g=
Date: Sun, 11 Oct 2026 15:10:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <christian@brauner.io>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
Message-ID: <2026101124-rethink-craftily-cb25@gregkh>
References: <20261009140946.008206689@linuxfoundation.org>
 <20261011111313.27648-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261011111313.27648-1-ojeda@kernel.org>

On Sun, Oct 11, 2026 at 01:13:12PM +0200, Miguel Ojeda wrote:
> On Fri, 09 Oct 2026 16:05:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 7.2.10 release.
> > There are 428 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 11 Oct 2026 14:08:23 +0000.
> > Anything received after that time might be too late.
> 
> Building Rust Binder breaks with:
> 
>     error[E0061]: this method takes 1 argument but 2 arguments were supplied
>        --> drivers/android/binder/node/wrapper.rs:86:50
>         |
>     86  |                 _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
>         |                                                  ^^^^^^^^^ ----------- unexpected argument #1 of type `&Arc<Process>`
>         |
>     note: method defined here
>        --> drivers/android/binder/process.rs:173:19
>         |
>     173 |     pub(crate) fn push_work(
>         |                   ^^^^^^^^^
>     174 |         &mut self,
>     175 |         work: DLArc<dyn DeliverToRead>,
>         |         ------------------------------
>     help: remove the extra argument
>         |
>     86  -                 _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
>     86  +                 _drop_outside_lock = owner_inner.push_work(node2);
>         |
> 
> (and similarly in `drivers/android/binder/node.rs:74`).
> 
> It is due to upstream commit:
> 
>   dbb17c9ea756 ("rust_binder: move (e)poll wait queue to Process")
> 
> which added a `&Process` parameter to `push_work`.
> 
> 6.8.y breaks similarly.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>

Seems to be broken by "rust_binder: reschedule node refcount update on
thread exit" as removing that fixes the builds which I did.  Any
objection to that?

thanks,

greg k-h
