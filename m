Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0C22F2F;
	Thu, 15 May 2025 22:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747347376; cv=none; b=er4zNkoWjlIBPsNl92krAEC+Ligi5RRi1SlzYybdhl/O4CZb3FjkzTf+4fBHiXzb5q81fgqknd0O3ro7hy2EErqu5teQ6rYnnHV1L3UulAtRPuMxzdEOSamOgkDaChjiUFC5bPg20VhlqvYKXWzf3a8Zi+NnPKGdTYXzX7kSdVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747347376; c=relaxed/simple;
	bh=dTJqCmfcwYRLr/DgjdtG3mRSyp7XhGxLyWrkppntvV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJr6aNHZEuhBea8idrFNy20JAxF5Jd7gOqPWuQzjnR1UrYuyeGW3g9yHBQWAhk1565Wq4RT9QlTFXeOObw1KF51NK0pLq4afKsEV+SkqOdtDXXtm2u/bRUj5/Eignkj+QhZpa4d6UyTSgkbM4YDNWugVCtoXcncpazV5abdbN8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQBgwCaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQBgwCaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF891C4CEE7;
	Thu, 15 May 2025 22:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747347374;
	bh=dTJqCmfcwYRLr/DgjdtG3mRSyp7XhGxLyWrkppntvV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQBgwCaf+PKaRfYwvgPcmir6P94WwVb4sJsINFR//0FkJjcsUwLaJGx46viZBbf3E
	 LMn1UcIiqyptjLQiqeMK/GWuQzDzsa7XGo4RqZCDT/0cAUNE0Fw1DnfCuMZ7YECZAc
	 nLTBF81rfkZXgpnq0vOY3ZWsNcSTte2Imw+9Y3C5ZxcHW+mrBJe49PxI+KplitRSFh
	 z+IpM5C/UE4amE+YHP1dIDAbnlTJ3IGjIPOic7LKRL1PwaSX18L/gu1Wwl/JCUB1Ce
	 MkbS+kHw+TlKfP7VG/LABU0rueKmheu7tJ635LQWuKJub4DGR1yWKVhbN5h+ZmiH1b
	 Ix3cgJ/3Z9Lbw==
Date: Thu, 15 May 2025 15:16:11 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Timur Tabi <ttabi@nvidia.com>
Cc: "dakr@kernel.org" <dakr@kernel.org>, 
	"a.hindborg@kernel.org" <a.hindborg@kernel.org>, "ojeda@kernel.org" <ojeda@kernel.org>, 
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "tmgross@umich.edu" <tmgross@umich.edu>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "alex.gaynor@gmail.com" <alex.gaynor@gmail.com>, 
	"benno.lossin@proton.me" <benno.lossin@proton.me>, John Hubbard <jhubbard@nvidia.com>, 
	"rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>, "bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	"aliceryhl@google.com" <aliceryhl@google.com>, "gary@garyguo.net" <gary@garyguo.net>, 
	Alexandre Courbot <acourbot@nvidia.com>, Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Message-ID: <i7he6uxzzna7abu46xl3la5ix5t7psodns7k44bllgcq6lusty@wlcjvp7rhoo3>
References: <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox>
 <20250513215833.GA1353208@joelnvbox>
 <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
 <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
 <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>
 <grdfkevm4nnovdefhn7thydixjtdt2w2aybuvnrtot2jolyte3@pmvcv3vbmmll>
 <554965650ac2aaa210028d495b06e1ede6aab74d.camel@nvidia.com>
 <devk5empq6e3fy4vp5mhxaznzrxfso6d4bqqzpzachlwy5w567@32tvtoddkn6p>
 <097a4926cebc9030469d42cc7a3392b39dfd703d.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <097a4926cebc9030469d42cc7a3392b39dfd703d.camel@nvidia.com>

On Thu, May 15, 2025 at 07:06:10PM +0000, Timur Tabi wrote:
> On Thu, 2025-05-15 at 09:18 -0700, Josh Poimboeuf wrote:
> > > Since I build with LLVM=1, I'm assuming the answer is 18.1.3
> > 
> > I'm not able to recreate, can you run with OBJTOOL_VERBOSE=1 and paste
> > the output?
> 
> You probably can't repro because it includes code that hasn't been merged upstream yet.  Try this:
> 
> https://github.com/ttabi/linux/commits/alex
> 
>   CHK     kernel/kheaders_data.tar.xz
> drivers/gpu/nova-core/nova_core.o: warning: objtool:
> _RNvXsa_NtCs8S3917Wilyo_9nova_core5vbiosNtB5_14PciAtBiosImageINtNtCsgK88DPai1lC_4core7convert7TryFro

I'm not yet qualified to look at the rust warning, I was actually
wondering about the C one you reported:

  drivers/media/pci/solo6x10/solo6x10-tw28.o: error: objtool: tw28_set_ctrl_val() falls through to next function tw28_get_ctrl_val()

-- 
Josh
