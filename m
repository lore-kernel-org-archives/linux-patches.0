Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16414154A4
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=+IFPX83lPaAOGdnhnP/eIMxERGqSGxvY5B0ikm9lkO0=; b=2w9misJitUSHvle93U8BZqSrbP
	9clMJJvZImdBdayMGB06Nhk5YYHLNh37NSV8kJxI5/4m4bdJEEDvYGgswEAmDo+CxBGxM1ikKG4nk
	kL5u4nSoEpzoMAqI9xLLAz6F/UV4oG0eCDuUPfMdG8vQ9Tn7YTMrP2AxYunh1sTV9QIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qWehb-004OhF-LW; Thu, 17 Aug 2023 17:14:23 +0200
Date: Thu, 17 Aug 2023 17:14:23 +0200
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
Message-ID: <9cb6cb27-bcde-46a1-a7ec-fb251c64fb67@lunn.ch>
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
 <2023081411-apache-tubeless-7bb3@gregkh>
 <0e91e3be-abbb-4bf7-be05-ba75c7522736@lunn.ch>
 <CACETy0=V9B8UOCi+BKfyrX06ca=WvC0Gvo_ouR=DjX=_-jhAwg@mail.gmail.com>
 <e3b4164a-5392-4209-99e5-560bf96df1df@lunn.ch>
 <CACETy0n0217=JOnHUWvxM_npDrdg4U=nzGYKqYbGFsvspjP6gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACETy0n0217=JOnHUWvxM_npDrdg4U=nzGYKqYbGFsvspjP6gg@mail.gmail.com>

> I am wondering whether the `net` subsystem is interested in reviewing, giving
> feedback and eventually accepting code that is currently OOT-only.

netdev, and the linux kernel in general, has no interest in code to
support out of tree modules. It adds maintenance cost for no gain.
 
> Also, it would be interesting if you could provide us any module or
> functionality you are planning to get in-tree which might use this interface;
> it could be useful in order to understand the applicability of these
> abstractions and find a concrete in-kernel use-case.

You need real code which does something useful for the community. Your
problem is, there is little use of sockets inside the kernel. I did
list a few examples in my first reply. Network file systems, logging
kernel messages to a remote server. I thought of one more afterwards,
there is dhcp client code used for NFS root, which could make use of
raw sockets.

However, you have the problem you cannot just rewrite this existing
code in Rust because it is core code and needs to work on all
architectures. And my understanding is, there are currently not Rust
compilers for all architectures.

What you can however do is implement something new, which the kernel
does not have. If it never existed, it is hard to complain it is only
available for a restricted number of architectures. So maybe look
through the RFCs and IETF documents and see if you can find something
which is both useful, and makes sense to be implemented in the kernel.

      Andrew
