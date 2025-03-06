Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6FE2066FF
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741261019; cv=none; b=RCBym5i3qjnRX6qZ1Bf6q0xfVj3L2QlrWFCmYG7hJUZHGQvEBuwD1G9d6zMcFh+B6ZAb382Wbns65ulm8u3JEi6Cqx9reaslJQsd/BFatzbIWKGpzNJygnoEC8GW4yBD0P1VUIeE6WmfMjfWhPXOANxQnAcAdmAxZhjqpGzAawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741261019; c=relaxed/simple;
	bh=J7YyaxuyjzZE9rRVT+aVgEUuE6f/mN7Q1m2L/2ehXpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EwJoY7n0P2y13ZwqxQoZ/1RITVq4FmrW3r3aRCPxeqbkd1EDUS/hVusakGNgNM0c1MWEl/aP4ynllXUUA+oCMinabMzK02l5nYF07CyMztHxFC11KmyyAhJy7O9N3QFvRrP9+z43cRdmC/1Pl1C0zaUURpH4wTysK/ufqUjXHhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKzo6U20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKzo6U20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F404C4CEEF
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 11:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741261019;
	bh=J7YyaxuyjzZE9rRVT+aVgEUuE6f/mN7Q1m2L/2ehXpc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oKzo6U209sNppYHc6sLdNcpyjyK6SqEQnFg0sdVpTiwIlDzaWElb4aACfqV07f0DS
	 MP4IxKYG4uxqb7HfH1z15wrpRANN/sxA7rUdePL+JwAVM7XQ5K3QvRApdWyaT+2q6h
	 K6sV0pGTnNDhbeOkYMwcmGe95/alky+/VV50Nxnb45VIpTWuPR09Fbrb+yYLHCZTub
	 ZZRP1eKkDZClNJKz0R0RpKyHRr2PQPe/1tEGP6/bvykyEcjtv6P+Ig+X8LsJ7e+83t
	 Uo4J2oR3eE6j/Jf4QaqjExxhBk/n5qzzau0wKGyP3bL5jw+4rHiaK9ot+YOJfUjiWc
	 nugrFRR0MnXSA==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54954fa61c8so654401e87.1
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 03:36:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWntMjd1ezIztA0Z8qm9DWzgO84ZoKLDNaNMrtqtZ8nCGOSJKITP0qzpQx49xNfqlcy9JX3t2lG@lists.linux.dev
X-Gm-Message-State: AOJu0YzmB1td6WQkiYkanSMAsJzdhA3vL42VDU3gloR0rItUZPSXr4hK
	0yrISIcGMSYe0xCexDWlBq6lUUkwJi2mlc4k9l9QtV/I8SNy8pn5I8VW3qtYhj1DunU9bVREL9Z
	ZXJJvmhGyRjAXht6sNlZxJsDC/P0=
X-Google-Smtp-Source: AGHT+IFzAyFRwVte8Hotabo7FMYBd05dZcaElxdlKllY9eUVFhjtPLRMD29Y6HH4VN6rZ8EcX8AQhANlE5QfwByaun0=
X-Received: by 2002:a05:6512:3ca2:b0:549:4ab7:7221 with SMTP id
 2adb3069b0e04-5497d382feemr3061824e87.50.1741261018116; Thu, 06 Mar 2025
 03:36:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210164245.282886-1-ojeda@kernel.org> <CAK7LNAQBFX5q6yyKBJoxMoD5d9SwdKm0c23J4+LpjwA1eh=bZw@mail.gmail.com>
 <CANiq72n=95jgJs17NFAkit5uzxqtO9xij9Um3ybd_RiMCpFrDQ@mail.gmail.com>
In-Reply-To: <CANiq72n=95jgJs17NFAkit5uzxqtO9xij9Um3ybd_RiMCpFrDQ@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 6 Mar 2025 20:36:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQC5Q5EQjuvMEWS5NAs-pixj3b--rkCHZ=xGQDTHqBBFQ@mail.gmail.com>
X-Gm-Features: AQ5f1JreRF_M4JISf0E2-xc60a7758UzryRd2z_zSk0dC77hJQoqe1lml4uhHqY
Message-ID: <CAK7LNAQC5Q5EQjuvMEWS5NAs-pixj3b--rkCHZ=xGQDTHqBBFQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add rustc-min-version support function
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2025 at 3:48=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Fri, Feb 14, 2025 at 2:39=E2=80=AFAM Masahiro Yamada <masahiroy@kernel=
.org> wrote:
> >
> > Do you want me to pick it up to kbuild tree,
> > or will you take it with my Ack?
> >
> > If you go with the latter,
> > Acked-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Thanks a lot Masahiro -- happy to take it on my side if that means
> less work for you.
>
> Cheers,
> Miguel
>

This has not been picked up by any one in linux-next.

I applied this to linux-kbuild now. Thanks.




--
Best Regards
Masahiro Yamada
