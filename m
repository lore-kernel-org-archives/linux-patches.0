Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912CBDF64
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 21:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=HrxOsLNMinh0XT55HWMr9WeUCVus6jXn08caJP+Pw+Q=; b=h21GG1K/7J7XB2gv3AgKdeVbYB
	m2PXkhRcOaWWou8fBstYy5jFxyzOVlQakI3bzSt0rX1CKkXK0SBeLmT6C5AtIpzMD84eUJjoQ2Myc
	8OaNgPPwugQrP3T9LU0M1S9R8QCZepcXJsNIWGCVBfkWA4F/9KltrwblRxKf9uo41XT0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qVfEz-0045qo-Qk; Mon, 14 Aug 2023 23:36:45 +0200
Date: Mon, 14 Aug 2023 23:36:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Michele Dalle Rive <dallerivemichele@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Davide Rovelli <davide.rovelli@usi.ch>,
	rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC PATCH 0/7] Rust Socket abstractions
Message-ID: <e3b4164a-5392-4209-99e5-560bf96df1df@lunn.ch>
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
 <2023081411-apache-tubeless-7bb3@gregkh>
 <0e91e3be-abbb-4bf7-be05-ba75c7522736@lunn.ch>
 <CACETy0=V9B8UOCi+BKfyrX06ca=WvC0Gvo_ouR=DjX=_-jhAwg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACETy0=V9B8UOCi+BKfyrX06ca=WvC0Gvo_ouR=DjX=_-jhAwg@mail.gmail.com>

> > There is a long standing tradition in Linux, you don't get a new API
> > merged without a user.
> 
> Sorry for not being clear on that.
> 
> These abstractions are meant to be used by modules: having them, modules
> can start using the kernel network functionalities through a first, high level
> interface.
> 
> Since there is currently no network support in Rust, this patch series
> represents a first step to provide access to networking to modules.
> Sockets are just the highest layer of the network stack: the goal would be
> to port structures deeper in the network stack, to give modules more
> access to the network api. However, you need to start somewhere.
> 
> >
> > There is not too much use of in kernel sockets. Network file systems
> > like NFS, and SMB are one. These need to be careful with memory usage,
> > you could be busy writing blocks out because the system is low on
> > memory and trying to free some up, and asking for more memory might
> > not work.  Sending kernel log messages to a server. But that needs
> > care because of the different contexts it can be used in. Without
> > knowing what it will be used for, it is hard for us the point the
> > special considerations which need to be made.
> >
> > So please also let us see the code using this API.
> >
> >         Andrew
> 
> The lack of these abstractions was noticed in the context of a research
> of the usability of Rust for the development of consensus algorithms using UDP.

O.K, so what are the use cases for consensus algorithms using UDP
within the kernel? Where is this code? Ideally you should post it for
merging alongside the rust API to sockets its needs. We can then
review both together, just as we would if somebody were submitting a
new API in C along with its user.

    Andrew
