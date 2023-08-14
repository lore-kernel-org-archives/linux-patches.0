Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0D4C154;
	Mon, 14 Aug 2023 15:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E6C433C7;
	Mon, 14 Aug 2023 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692026751;
	bh=FO5zCQ9Aaqj1NS7OYkS2u8nCHSNUw8PdooF5SOw4v+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i4tkYcxc+OPe6SWSa8P9ZhQtHCLm7sboRNJ7foxlBmZ2WcwsyPwVLCnH3nqGkLkDW
	 B9c7nzOJBnW7q6t/ZV+WHiKHW3n6VC2hAXBHlPbuYkqrR0fEakVFpAzDBjLHeD9NTJ
	 AiXUSkUOjkEuD6zI/fhLPaQg37APlAaOqcbvux4I=
Date: Mon, 14 Aug 2023 17:25:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Michele Dalle Rive <dallerivemichele@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
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
Message-ID: <2023081411-apache-tubeless-7bb3@gregkh>
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230814092302.1903203-1-dallerivemichele@gmail.com>

On Mon, Aug 14, 2023 at 11:22:55AM +0200, Michele Dalle Rive wrote:
> This patch series is intended to create Rust abstractions for Sockets
> and other fundamental network entities. 
> 
> Specifically, it was added:
> - Ip address and Socket address wrappers (for `in_addr`, `in6_addr`,
>   `sockaddr_in`, `sockaddr_in6`, `sockaddr_storage`).
> - Socket wrapper.
> - Socket flags and options enums.
> - TCP and UDP specific abstractions over the Rust Socket structure.
> 
> This series is a RFC because I would appreciate some feedback about:
> - The structure of the module: is the division of the files and modules
>   appropriate or should it be more or less fine-grained?
>   Also, should the `net` module export all the structures of its
>   submodules? I noticed that it is done in the standard library.
> - Whether the documentation is comprehensive enough.
> - A few other specific questions, written in the individual patches.
> 
> I would greatly appreciate any kind of feedback or opinion. 
> I am pretty new to the patch/mailing list world, so please point out any
> mistake I might make.

The best feedback is "who will use these new interfaces?"  Without that,
it's really hard to review a patchset as it's difficult to see how the
bindings will be used, right?

thanks,

greg k-h
