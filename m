Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6CF431E47;
	Sun, 11 Oct 2026 11:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791717300; cv=none; b=cLkuWknKQmv5huM8qie2vjl4ULEPAr/acA9teSySqYi6OyU2AKngoYkkyFDMzmzx1IBCoWLWq5JXM9NThOgfoe7e6LarG0P/FPktMAixVqHR/2nv5soiELESVP0H0O9GTKYtlRDhVbml7HV7lWl3PA16j0r6fen97o2OvHA7GlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791717300; c=relaxed/simple;
	bh=hiKq9ulZAY9+7/4FQpIvyySf1i31AtWMg9oHxZuFyDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtRU4Q2unw++/AWShF3w6HiBwfDs0eA8FXTf8cFQqxS+5U3Pc+ezeLEpmVC3gQMPvVkRcn+uNpSx3GwZxYAL5Jb9YbLTJCrwffeKMPVtYrLF7TL0zYvGIffaq22kmA9tayS2vtgcqPyB8HqkLgybKU/qRb6qnv9ig0tv74y0qOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWLU0JKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWLU0JKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8C71F0089B;
	Sun, 11 Oct 2026 11:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791717298;
	bh=NpBFfTqfu4PyWP7cY77Klo5pQ2XixnLKqSnwH3iAQQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWLU0JKksKfFBFltWGG1fLUvJvH6HWYpTEDYXMr9ncgS4VN8ZctTCcWhPvDZA3lff
	 s7+qOYZmrGTyJ5c3zbJ1Cd4el/fUj+n5PrRcAuDEo1dkJmcPutxJ/3Bha1VnVFHgad
	 GedgHi5vc1Kj80U5XCn7gtC/axnDqwRiJJQrZvf6i6OTg2ApyheScdpBgFV/EEfTzX
	 LkwlhPc0xaEKArWnpoqxY3V2R+l1DPxR1pLaVIjC46ZYMeFHPC2KKKUXWRd1rwY3qt
	 W/PEeDW7Lljtp+81Y6Z1d/ZwUH94KaMbdg/NyfCsQhL9Nyz1OqlcQ4TLNNbMc3xk4m
	 UTky6EgCsVmUg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <christian@brauner.io>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
Date: Sun, 11 Oct 2026 13:14:42 +0200
Message-ID: <20261011111444.27899-1-ojeda@kernel.org>
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 09 Oct 2026 16:06:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Oct 2026 14:08:27 +0000.
> Anything received after that time might be too late.

Building Rust Binder breaks with:

    error[E0061]: this method takes 1 argument but 2 arguments were supplied
       --> drivers/android/binder/node/wrapper.rs:86:50
        |
    86  |                 _drop_outside_lock = owner_inner.push_work(&node.owner, node2);
        |                                                  ^^^^^^^^^ -------------
        |                                                            |
        |                                                            unexpected argument of type `&Arc<Process>`
        |                                                            help: remove the extra argument
        |
    note: method defined here
       --> drivers/android/binder/process.rs:172:19
        |
    172 |     pub(crate) fn push_work(
        |                   ^^^^^^^^^
    173 |         &mut self,
    174 |         work: DLArc<dyn DeliverToRead>,
        |         ------------------------------

(and similarly in `drivers/android/binder/node.rs:740`).

It is due to upstream commit:

  dbb17c9ea756 ("rust_binder: move (e)poll wait queue to Process")

which added a `&Process` parameter to `push_work`.

7.12.y breaks similarly.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>

I hope that helps!

Cheers,
Miguel
