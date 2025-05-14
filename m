Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2829321A43D;
	Wed, 14 May 2025 19:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250072; cv=none; b=SeIpfhiZG/Swmcls27KythF1T8SoTR6qhohDHkXkStkpqKn91xMSSC49ox4G0oME1Mpeht/6ExFac0U4sVKDKAMvc6UWS2+fJm6MS/mFVrrFA6VzwNPeEyWhJLXu75To0l8gq1i7RpeJeiRlF2VuWQId18PJrdBKowrNWXgN2ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250072; c=relaxed/simple;
	bh=lOa0LK4b8qZWlQ7JnonxWFPgOHkWrQ9weNETFEnVwo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaoIuPR4P8cz9BzQWL1KHtluaW3ePYRu+rpk8EcKw7IlinB55CZTrzPjZfYIzLcU12PGHS5pmDzfTC/6smgFqVX9YGis/jSq4uNuWubiqzAtoJbg3yuNTC6+n3gkMO0AbZ9Qu2CnWBqLuNDTh6a7dwIMt/wDThYuWcoG3iDtwRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5gwmOzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5gwmOzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81568C4CEE3;
	Wed, 14 May 2025 19:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747250070;
	bh=lOa0LK4b8qZWlQ7JnonxWFPgOHkWrQ9weNETFEnVwo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R5gwmOzOVsYI8gjDNNv0WY9HKizp9D1CBX90KWUjAeSeruXtRb+UkvQ8cY6VVViYg
	 6UlaTcqXAKCtiOE4fmk/fDDRHpQn1XXhD/u42yvkIvmE3EaT8SLzITvHRnDzum4QHY
	 /PCvkTDQX8R2pFZdlpnjCn6ib/DEmk/wxGLlup2yETyGUv5A/IbET5W3VjVD6jRhek
	 i+HwV2TRWG8LhGqjhKIn0hTqnn9sNjDNLJHMB8ZAM5fzPkR6dtIpmc2A9DtWYGzssH
	 s5aP00EN1EKYor2uGoPQ3ah8YnNBEsrgtv+iUwhNZfjir16U5N0EungQOwlhMwwoRU
	 ki6yLUIVoZmGA==
Date: Wed, 14 May 2025 12:14:27 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Timur Tabi <ttabi@nvidia.com>, "ojeda@kernel.org" <ojeda@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, "dakr@kernel.org" <dakr@kernel.org>, 
	"a.hindborg@kernel.org" <a.hindborg@kernel.org>, "boqun.feng@gmail.com" <boqun.feng@gmail.com>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "tmgross@umich.edu" <tmgross@umich.edu>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "alex.gaynor@gmail.com" <alex.gaynor@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "benno.lossin@proton.me" <benno.lossin@proton.me>, 
	"rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>, "bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "aliceryhl@google.com" <aliceryhl@google.com>, 
	Alexandre Courbot <acourbot@nvidia.com>, "gary@garyguo.net" <gary@garyguo.net>, 
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Message-ID: <grdfkevm4nnovdefhn7thydixjtdt2w2aybuvnrtot2jolyte3@pmvcv3vbmmll>
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox>
 <20250513215833.GA1353208@joelnvbox>
 <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
 <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
 <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>

On Wed, May 14, 2025 at 10:52:17AM -0400, Joel Fernandes wrote:
> On 5/13/2025 8:43 PM, Timur Tabi wrote:
> > On Tue, 2025-05-13 at 17:22 -0700, John Hubbard wrote:
> >> On 5/13/25 2:58 PM, Joel Fernandes wrote:
> >>> On Tue, May 13, 2025 at 02:07:57PM -0400, Joel Fernandes wrote:
> >>>> On Fri, May 02, 2025 at 04:02:33PM +0200, Miguel Ojeda wrote:
> >>>>> Starting with Rust 1.87.0 (expected 2025-05-15), `objtool` may report:
> >> ...
> >>> Btw, Danilo mentioned to me the latest Rust compiler (1.86?) does not give
> >>> this warning for that patch.
> >>
> >> I'm sorry to burst this happy bubble, but I just upgraded to rustc 1.86 and did
> >> a clean build, and I *am* setting these warnings:
> > 
> > I see these warnings with .c code also:
> > 
> >   CHK     kernel/kheaders_data.tar.xz
> > drivers/media/pci/solo6x10/solo6x10-tw28.o: error: objtool: tw28_set_ctrl_val() falls through to
> > next function tw28_get_ctrl_val()
> > make[9]: *** [scripts/Makefile.build:203: drivers/media/pci/solo6x10/solo6x10-tw28.o] Error 1
> > 
> > I think it's an objtool bug and not a rustc bug.
> 
> Thanks John and Timur.
> And sigh, fwiw I pulled the latest rust nightly build and I see the warning as well:
> 
> rustc --version
> rustc 1.89.0-nightly (414482f6a 2025-05-13)
> 
> I am leaning more towards Timur's opinion that this is more than likely an
> objtool issue.

The above warning is in completely different code from the Rust one, so
they're likely unrelated.

The fallthrough warnings are typically caused by either Clang undefined
behavior (usually potential divide by zero or negative shift), or a call
to an unannotated noreturn function.

Timur, can you share your .config and compiler version?

-- 
Josh
