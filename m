Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A71281E
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720184396; cv=none; b=rrxNEaHphgoSfj0fh3f5dzBM9hIO5S40kRzsuxOztQQbDEKglIuY58u5WloIrLd2kIhLwL8B8ZMfiqjpaUgkWBLlhAq+bdtKHXA3XUvdDmA5KefVckb8qqacsiWx2IweZN1aVYwsw75KkeP0By8kvhhXJ9yR2WhDQ3W5yeLxaWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720184396; c=relaxed/simple;
	bh=VzS+ic2YFjoOYqTywkuQAT9X6IwIbcB7ZS625NxgHdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RErdgzOUnYDpvuU4HQ2FetfzPJqCdMbdh1isEl66PRtLWrU2eSMqV7BgktYABEq+ZjBWot98br28m7P34ab6hFc03SawG8yYRpWFW5DHCxMdG9KsX7neaY/xAe31/8quaHQXyNtY2gWMBR+Dhz74cUf1uWQ14cbBn2fU/+S+ToE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBP/j4vf; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBP/j4vf"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58f9874aeb4so957757a12.0
        for <patches@lists.linux.dev>; Fri, 05 Jul 2024 05:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720184393; x=1720789193; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pPHWBuGWsy1zU9N/El+E2fV7OQ1j1Ymj+M4e88iwJ7M=;
        b=nBP/j4vfZsJYQzwFPCl06oNaP8SR53kaoxhwLNcYxiV8c7SJKjaWMClaTVPHj9evjl
         0tEmlxbk1S9/hb0653pPRMbzt5GhtDz39X2sLq4QhyZGD30GxuqrF8CtVN2MtjwarR9Z
         QYy5jckqWopAk30bOt3aht9jV9M779q03XSH0OQHd2pGxmobhKIP8WXbamdMn58zXP+C
         ZAhvoaVPHbz3ZcrR2SyoZS2tGIofX5ofvjAzMVJ3L3K9EVUq9V/F5PSLEEUkr960R+Rc
         QAIfPXXxBRBGMdd0J6JNqXR5tq7zxYryQ8aQ6UFag2SjoHXhcufkoF4QLpPg3qOdOpDl
         NEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720184393; x=1720789193;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pPHWBuGWsy1zU9N/El+E2fV7OQ1j1Ymj+M4e88iwJ7M=;
        b=NMweUvR3JmeBkRbux94t6EJrqm/I/jDbGbGvTB+WkABViZx+YxBp1+HJ4xivJqXvXy
         Ebjn6G+kHzIslvUL3hxiBIq15ixN4rJEP0BSsvbMz9kx+ighyvfs1hSeP4OWUPKOUGZi
         4KnH2MKvPPcC3oLKGzMpUSLgacZ8AVkUi8sh6OzBtYV/nKdemlTbmySyIh+IaO7rfVIw
         qSgG9ne/BWSIiWJ9Zg/v0+koNONDM8d71BAYsBZ9yJe9kGjVDraARkmbOR1cnp0suw0L
         +mW0It0NYvB6Qr0a5QLh9vxXub+P9eMdaJmmI/ckfbZIj6RHTs320pziuijvP/oZV9H2
         Pg2w==
X-Forwarded-Encrypted: i=1; AJvYcCWjje+pBzRfyAAblHcjtkWzNW+TtEjEMAonbwGwp+rhWLG4SDVFJTwsIz8w/UxEgMX4ueGSFA5TkJO1KExu+NHJjXoDKM0M5w==
X-Gm-Message-State: AOJu0YzKkh+nED06sTDFQTtyig2YGyUnNIZsq/F8WPsctRHU3r17Aw8r
	vOyGcccQ7BEP2hxiN+9JGOpIH6C8SAJUnFvOXky+gJ+pnsryUa4=
X-Google-Smtp-Source: AGHT+IHTV/cG8LJsYeKSwuY3SkyzUVcP52RZ3SV5iUZUNO9nF749TRMCoTZI++I2KrI84E1vVOKnoA==
X-Received: by 2002:a17:906:48d8:b0:a77:da14:840a with SMTP id a640c23a62f3a-a77da1485b8mr64341966b.69.1720184392690;
        Fri, 05 Jul 2024 05:59:52 -0700 (PDT)
Received: from localhost (host-79-17-25-43.retail.telecomitalia.it. [79.17.25.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7525fb8387sm454063966b.94.2024.07.05.05.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 05:59:52 -0700 (PDT)
Date: Fri, 5 Jul 2024 14:59:51 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Jan Alexander Steffens <heftig@archlinux.org>,
	Johannes =?iso-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>,
	Fabian =?iso-8859-1?Q?Gr=FCnbichler?= <debian@fabian.gruenbichler.email>,
	Josh Stone <jistone@redhat.com>,
	Randy Barlow <randy@electronsweatshop.com>,
	Anna Figueiredo Gomes <navi@vlhl.dev>,
	Matoro Mahri <matoro_gentoo@matoro.tk>,
	Ryan Scheel <ryan.havvy@gmail.com>, figsoda <figsoda@pm.me>,
	=?iso-8859-1?Q?J=F6rg?= Thalheim <joerg@thalheim.io>,
	Theodore Ni <43ngvg@masqt.com>, Winter <nixos@winter.cafe>,
	William Brown <wbrown@suse.de>,
	Xiaoguang Wang <xiaoguang.wang@suse.com>,
	Zixing Liu <zixing.liu@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 13/13] docs: rust: quick-start: add section on Linux
 distributions
Message-ID: <ZofuRz4LCJD8A4fk@gpd>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-14-ojeda@kernel.org>
 <ZoeQVYda-AZN6PYy@gpd>
 <CANiq72==+YBoQDBwEVuncY+ygeTkQPEbK00yBCPN3YWVk1L9XA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72==+YBoQDBwEVuncY+ygeTkQPEbK00yBCPN3YWVk1L9XA@mail.gmail.com>

On Fri, Jul 05, 2024 at 12:50:35PM +0200, Miguel Ojeda wrote:
> On Fri, Jul 5, 2024 at 8:19 AM Andrea Righi <righi.andrea@gmail.com> wrote:
> >
> > This implicitly covers Ubuntu, since packages are sync'ed with Debian.
> 
> Do you mean the names (i.e. command) is the same, or that the newer
> versions from e.g. Sid can be used in Ubuntu? If the latter, that
> would be definitely worth adding, yeah -- is that supported / expected
> to work?

Command and package names are the same. We may also have different
(newer) versions than Sid, but this is up to foundations team.

Zixing, what do you think?

> 
> > In addition to that Ubuntu also provides versioned packages (such as
> > rustc-1.74, bindgen-0.65, etc.), so in case of special requirements
> > (e.g., older kernels) users should be able to install the required
> > version(s) using the packages provided by the distro.
> >
> > Maybe it's worth mentioning as a little note, so that users are aware of
> > these extra packages.
> 
> I thought about adding a section for Ubuntu to mention those -- so far
> I only added the distributions/commands that were likely to work with
> the versions supported by the kernel, with the idea of expand later as
> time passes. So I didn't add the versioned ones since the latest is
> 1.76, so it wouldn't work for the current kernel.
> 
> But it may be useful to state it nevertheless, since some people may
> only look at the latest docs. (Or perhaps Ubuntu can add Rust 1.79? :)

Actually, considering that this doc will go in newer kernels, probably
it's not worth to mention the *old* packages.

About Rust 1.79, calling out Zixing again... :) He may have newer Rust
packages in his ppa at some point, but I don't know how much we can
consider that ppa "official".

-Andrea
