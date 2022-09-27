Received: from hop.stappers.nl (hop.stappers.nl [141.105.120.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631FDA5D
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 14:05:12 +0000 (UTC)
Received: from gpm.stappers.nl (gpm.stappers.nl [IPv6:2a02:a46d:659e:1::696e:626f])
	by hop.stappers.nl (Postfix) with ESMTP id A807C2000F;
	Tue, 27 Sep 2022 13:59:40 +0000 (UTC)
Received: by gpm.stappers.nl (Postfix, from userid 1000)
	id 4F074304049; Tue, 27 Sep 2022 15:59:40 +0200 (CEST)
Date: Tue, 27 Sep 2022 15:59:39 +0200
From: Geert Stappers <stappers@stappers.nl>
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Adam Bratschi-Kaye <ark.email@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Sumera Priyadarsini <sylphrenadin@gmail.com>,
	Gary Guo <gary@garyguo.net>, Matthew Bakhtiari <dev@mtbk.me>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH v10 10/27] rust: add `macros` crate  
Message-ID: <20220927135939.mf6oowsceaaen25b@gpm.stappers.nl>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-11-ojeda@kernel.org>
 <YzL/FfwKoL5eBiWS@yadro.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzL/FfwKoL5eBiWS@yadro.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Tue, Sep 27, 2022 at 04:48:05PM +0300, Konstantin Shelekhin wrote:
> On Tue, Sep 27, 2022 at 03:14:41PM +0200, Miguel Ojeda wrote:
> [...]
> > For instance, the `module!` macro that is used by Rust modules
> > is implemented here. It allows to easily declare the equivalent
> > information to the `MODULE_*` macros in C modules, e.g.:
> > 
> >     module! {
> >         type: RustMinimal,
> >         name: b"rust_minimal",
> >         author: b"Rust for Linux Contributors",
> >         description: b"Rust minimal sample",
> >         license: b"GPL",
> >     }
> [...]
> 
> I remember that there was a switch from &u8 to &str on master branch a
> while ago. Why this patch was reverted? Strings are really better here.

ASCII versus UTF8


Groeten
Geert Stappers
-- 
Silence is hard to parse
