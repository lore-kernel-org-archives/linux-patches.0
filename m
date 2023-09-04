Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754533D99;
	Mon,  4 Sep 2023 14:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2FFC433C8;
	Mon,  4 Sep 2023 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693838762;
	bh=029F1XvwKET4UQUq4RcX4JZMFjGbvc0hdM2e/KGwQD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MQzqrnFhWzY62iac3g3ghcAroDs6vyeWLI8nHebRKtq9fSeBuoCL9vWyK3fKZNKB1
	 wsGy/ZZ3pwan/uFrE+K2zZHbaj0rby8X57uCuELHJ9FFoBLtgvn1d2QmqAwPZnV9+c
	 T1VOl3/Qy8x1ldAzGIY7pS0clUGkA+ybcozv2zzs=
Date: Mon, 4 Sep 2023 15:45:59 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	"rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
Message-ID: <2023090425-steep-imperfect-1bd2@gregkh>
References: <CGME20230830170041eucas1p139eda9d21701ab726a9b36751b819ada@eucas1p1.samsung.com>
 <20230830165949.127475-1-ojeda@kernel.org>
 <87ttsatmi6.fsf@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttsatmi6.fsf@samsung.com>

On Mon, Sep 04, 2023 at 07:40:01AM +0000, Andreas Hindborg wrote:
> 
> Miguel Ojeda <ojeda@kernel.org> writes:
> 
> > A few months ago we started a webpage for the Rust subsystem and
> > the overall Rust for Linux project [1].
> >
> > The current `W:` field of the Rust entry points to the GitHub
> > repository, since originally we kept information in a `README.md`
> > file that got rendered by GitHub when visiting that URL.
> >
> > That information was moved into the webpage and got expanded.
> > The webpage is also nowadays the entry point to the project,
> > and we pointed the "Website" GitHub metadata field to it.
> >
> > Thus update the `W:` field to point to the actual webpage.
> >
> > Link: https://protect2.fireeye.com/v1/url?k=f6de0e95-97551ba3-f6df85da-74fe485fffe0-40da65c741bc6c5c&q=1&e=b1890d46-d9fd-4c52-9067-813223d79978&u=https%3A%2F%2Frust-for-linux.com%2F [1]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  MAINTAINERS | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 12601a47c839..7c8088e9a11b 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -18558,7 +18558,7 @@ R:	Andreas Hindborg <a.hindborg@samsung.com>
> >  R:	Alice Ryhl <aliceryhl@google.com>
> >  L:	rust-for-linux@vger.kernel.org
> >  S:	Supported
> > -W:	https://protect2.fireeye.com/v1/url?k=562fa4e0-37a4b1d6-562e2faf-74fe485fffe0-41ef9448fbcb2236&q=1&e=b1890d46-d9fd-4c52-9067-813223d79978&u=https%3A%2F%2Fgithub.com%2FRust-for-Linux%2Flinux
> > +W:	https://protect2.fireeye.com/v1/url?k=9d6f1261-fce40757-9d6e992e-74fe485fffe0-96ce3590ad5e7466&q=1&e=b1890d46-d9fd-4c52-9067-813223d79978&u=https%3A%2F%2Frust-for-linux.com%2F
> >  B:	https://protect2.fireeye.com/v1/url?k=bce0bede-dd6babe8-bce13591-74fe485fffe0-1eb20aae852614aa&q=1&e=b1890d46-d9fd-4c52-9067-813223d79978&u=https%3A%2F%2Fgithub.com%2FRust-for-Linux%2Flinux%2Fissues
> >  C:	zulip://rust-for-linux.zulipchat.com
> >  T: git
> > https://protect2.fireeye.com/v1/url?k=db2bb7f4-baa0a2c2-db2a3cbb-74fe485fffe0-2d91ea432710b07e&q=1&e=b1890d46-d9fd-4c52-9067-813223d79978&u=https%3A%2F%2Fgithub.com%2FRust-for-Linux%2Flinux.git
> > rust-next
> >
> > base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
> 
> I was about to complain about the strange link you put. It took me a few
> seconds to realize what was going on.
> 
> Perhaps we should start signing the patches?

You can do that, many of us do, please use patatt for this.  My
.git/hooks/sendemail-validate file contains just one line:
	patatt sign --hook "${1}"

b4 then checks this when applying patches, so it's good to get in the
habit of using it.

thanks,

greg k-h
