Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FED63BFAD4;
	Sun, 11 Oct 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791728254; cv=none; b=Mxkd3H6jzYCpNr80bc9geRaidBO6KX0Jmy0gpEmP+oqy2QaJ9RoH3jFC9CwUbvZ20bCN8+ly2llT7EBTOOWIW4bDUyHUai2vWcRjD1Qv7qLnUAKBUgZVePZwB72byQshJQKgsRwvV5trTr48duEAcmeTKJbtBEa6Xm6///q7iPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791728254; c=relaxed/simple;
	bh=12ZnFheN+hu1enEV+dyHAf0EKJnyEcQyXbBOdfYtQmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZ757saqQsl2AoVYeZ1muv+CwGbzIbGOlZojTXyHYQ+K8buXwtkb5aHItTvX12Vylai6v9geDcjtTxKJmwBsVq0DDtyr4zVEkd1CE/1/YRJ0ThR5cj7YbczhtS1fI512z4ZceLX+xS8hv/KFb+ikltLW9CV7PA2dzc8BAC+S/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvKpRzp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvKpRzp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEA61F0089B;
	Sun, 11 Oct 2026 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791728252;
	bh=bt+drmw8aO5BZ2dZpTNYiHti4w1yhUKQ87080rKd1CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bvKpRzp/CZKa4emgvL2K8YowuBTaGmj+knZDJwBrinHTq+vIcXKkkfySZWmQeytLu
	 ZbtbCfT/NXA2Oy6/6t7yCULUA8ULJeYEnLYvZ57CVT13yLxMz2bDWLssUQDMB7TwNn
	 CxDJnWsFsmhgyh5qU1Uh04C7Gj5A9ORu3cJLlbPY=
Date: Sun, 11 Oct 2026 16:17:30 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <christian@brauner.io>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
Message-ID: <2026101103-fling-stipulate-084f@gregkh>
References: <20261009140946.008206689@linuxfoundation.org>
 <20261011111313.27648-1-ojeda@kernel.org>
 <2026101124-rethink-craftily-cb25@gregkh>
 <CANiq72ndhLush3bugar1YGPnsein8min1k3_NucBxzFwCWe9Ug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72ndhLush3bugar1YGPnsein8min1k3_NucBxzFwCWe9Ug@mail.gmail.com>

On Sun, Oct 11, 2026 at 04:11:48PM +0200, Miguel Ojeda wrote:
> On Sun, Oct 11, 2026 at 3:10 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Seems to be broken by "rust_binder: reschedule node refcount update on
> > thread exit" as removing that fixes the builds which I did.  Any
> > objection to that?
> 
> Yeah, it is that one.
> 
> In case it helps, I am re-running my CI with the extra parameter
> manually removed in those two calls (instead of dropping that commit),
> to see if the rest builds and runs fine after that issue, and it looks
> OK in all the builds that completed so far.

If that works, can you, or someone else, send an updated version of that
commit for the next round of stable releases as I dropped it for this
one.

thanks,

greg k-h
