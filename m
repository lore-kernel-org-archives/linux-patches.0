Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9381FB3;
	Sun,  9 Mar 2025 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741537636; cv=none; b=cJ1ITeHzNgvpUTDnH5VtlvsidC0w3Mvu1oOhYAQUtgRP6g967fMIbBBKJTqXnrzo0CWi+uPsUhhYPwIki8RUMBmx3QST+/3t83BdL9y83ugo82wBeuZHn6qOTfRSzc4xrMvy4jhGzlixPdpSqUXmAmJBFDmYVQZIPjVOUh8egEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741537636; c=relaxed/simple;
	bh=CxpI5xmN0yqi/hQcPV31Gk/Nx7XU1co1kADCpP7BSVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrc4l9pX6OgI45xa5A4Qeu7YUwLEolazvfPZ/PzTVd2VJeb63sBQcKBR+rzDefDx5TLH/wGXCvT6M2wWxrClmGP48JXY4lOQ4DBgednqhCMEpD80v8Q1TDfzH3P1os0Sw1Qi8UBsFU5zDYbxL2m1KRQWEzdT8hoPk0C1xzWkXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBWO+KoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBWO+KoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D37C4CEE3;
	Sun,  9 Mar 2025 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741537634;
	bh=CxpI5xmN0yqi/hQcPV31Gk/Nx7XU1co1kADCpP7BSVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VBWO+KoRByyxWU3fon5q2W99YWahUynkrU4L9EfX+iMOLlgcft1yq/Me/G55GxlQh
	 bOaQPfVTAJJ/mR4XTecpccnsfbrRVTSEJccQnPflI4DaTSAtabFPbCrdWKkaeDBSIb
	 zQhikXe/DepcpPWLZyY1Nl3AWTEn9TOH98n7Hj4I=
Date: Sun, 9 Mar 2025 17:27:10 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Ilya K <me@0upti.me>, Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev
Subject: Re: [PATCH 6.12.y 00/60] `alloc`, `#[expect]` and "Custom FFI"
Message-ID: <2025030955-kindness-designing-246c@gregkh>
References: <20250307225008.779961-1-ojeda@kernel.org>
 <33f6c73c-4a2d-42b3-b033-921d2e1eaeac@0upti.me>
 <CANiq72nu71ETyLpu=GwbzpnMJg3jetL5zSSh3AE+DoQDMgHAwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nu71ETyLpu=GwbzpnMJg3jetL5zSSh3AE+DoQDMgHAwA@mail.gmail.com>

On Sun, Mar 09, 2025 at 03:20:56PM +0100, Miguel Ojeda wrote:
> On Sun, Mar 9, 2025 at 1:42 PM Ilya K <me@0upti.me> wrote:
> >
> > Hi, I think this is missing one final change, specifically 27c7518e,
> > or rather, the only line of it that applies:
> >
> >  pub unsafe extern "C" fn drm_panic_qr_generate(
> > -    url: *const i8,
> > +    url: *const kernel::ffi::c_char,
> >
> > Without it, the build fails on Rust 1.85 / aarch64.
> 
> Bah, sorry, my bad, that is embarrassing... It is not just that one --
> the actual remap is not there. Let me re-send...
> 
> Greg: no changes except for the 2 extra on top you will see.
> 
> It still holds that the x86_64 build still builds commit-by-commit,
> and I double-checked that hash builds for x86_64, arm64 and riscv64
> with the min and max compilers.
> 
> Let me also run a test for loongarch64 with the unrelated fix applied.

Please just send additional ones, not the whole series, otherwise I'm
going to get confused :)

thanks,

greg k-h
