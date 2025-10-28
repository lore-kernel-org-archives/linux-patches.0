Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA59A2EAB6E;
	Tue, 28 Oct 2025 09:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761642353; cv=none; b=r8yoUIiVrF6OZ5Q7Yk1mFwVT1X8+F4PBlzdQXFRl4YCm6nA9Tc984wsDNwDXIUg4emUaQrlpxehImZXPh+cpe50MkalmUFI+vTFdXcpeX1mj2TbZ6NGdNf3QcPIXGIsAqzoSerwLVRDhyA5+2424XiD6sFmSzNJ7vVdttxz4mWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761642353; c=relaxed/simple;
	bh=04SqsjIK5kgoLej5ER8nuZHzewkcdOz9UWXMhHAyFpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9u9/b85sydZZEEfbiUvtFHpBom/I3hWhAD9vHk/vdvKlJayUTsIYLJF5KJSsUBKkn7EkXYSEnaskZcBZJ/J/I6zNhfKMEaQGNP0MSoETJIL5TSNfVT+wyTDEQ9AM1mCXrpwYnbazNKJ4qDuNqHzD6p4mZU5+Rw9p7EfG+tNz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IXextcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IXextcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F29C4CEE7;
	Tue, 28 Oct 2025 09:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761642353;
	bh=04SqsjIK5kgoLej5ER8nuZHzewkcdOz9UWXMhHAyFpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0IXextcbggqHxVeoEEVcanrY8bRkSn5X1ShAJ6yRO3GYqXEtAttQ3DAmROmGmxoAh
	 lQgY5y3/bD8pTsZR4N13RT+rg7/kai+Z5pVaqSZNlDSc/Ck0i/9Lb8einHjXFdi8u/
	 bBJ85446zqBLyt+gsfRD678aWA1jJKWgTIh+bXxo=
Date: Tue, 28 Oct 2025 10:04:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	linux-usb@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: usb: fix formatting
Message-ID: <2025102814-gosling-bobble-dc2e@gregkh>
References: <20251016231350.1418501-1-ojeda@kernel.org>
 <2025101758-mystified-prideful-8016@gregkh>
 <CANiq72nXw4+HesrgNqJjTy6Ji=pVqUMzx7GDO+6U9VYWezTt6Q@mail.gmail.com>
 <CANiq72kn9HZy2kYaGHM9yj2nR+SAQ=J=Oh8k2doPFMDCRy1wBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72kn9HZy2kYaGHM9yj2nR+SAQ=J=Oh8k2doPFMDCRy1wBA@mail.gmail.com>

On Mon, Oct 27, 2025 at 04:03:37PM +0100, Miguel Ojeda wrote:
> On Sun, Oct 19, 2025 at 8:59 PM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> > They landed in mainline, so Linus' tree is again `rustfmt`-clean.
> 
> Pinging about this one so that it is not forgotten. It is the only
> missing thing so that linux-next is clean again like Linus'.

Just now applied, sorry for the delay.

greg k-h
