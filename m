Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0911F1EB1B5;
	Sun,  2 Mar 2025 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740940302; cv=none; b=VQ+YiIi6brud4yaNeOUwSj7vok6EIK25iA9zcw0zZysZYN16xNT+iM0bmdFa1Joc2I34MOgEwKUfF6oVZGjwuIqyPc7UcLROy7d7h8+wdWlBKxHZi6Tf8xY3whVdDYR4cVUVMu0bh1uEbByLhED0AJaO41Myshb3znuIWqgHTO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740940302; c=relaxed/simple;
	bh=H+9GBlmiL0+MASzOfUf3x/aekpIE+MtJngbHKKTuS68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsQtbLSfKbypnKbaQmpxrzL6A7P13xru7hU5GohyvVhCOvZX1PtiMUqpowDO8idpj1PUC6XCeVKlEeTCZGNtSUvZ8H6613zUz5+HPMRWnboK4/ccSgdBsuw2RvgxYlaMGMIbozhuHnliqcYMlpoQTDc1zoRhRYnG7qTio2SCQOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giu50hYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giu50hYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DDAC4CED6;
	Sun,  2 Mar 2025 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740940301;
	bh=H+9GBlmiL0+MASzOfUf3x/aekpIE+MtJngbHKKTuS68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=giu50hYMzAquWhRQTt+DEWKLYK09d3blK2S4KxfrV3hPDm7/js6yPRC/uSOLa6LKu
	 ncFW/g/18rGLG7ahTo05Sn6p2wCREYtxEx7CF6Zdw4qBGmRF+fw91RYR6KN+gTZUH3
	 dKr9Cixl8NG971N5W594RAcWp9dtp2opo+WsNp5y4lGn5APqbJe4mjuvCxboYOWZwo
	 gl1L0pUoLZ1fWjWWUDr3A74KIr+MjXObxUmuNW4ZcK89PcvJCMU/2yf8BEyan02esZ
	 HTaEjqIBFj6wrw0L9jpdzMXzbykFI1lu79kJxmGAztXThb4E3wD99Zpj4Oh/2PO0cC
	 0Dcuoo2XGi2WA==
Date: Sun, 2 Mar 2025 20:31:36 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jocelyn Falempe <jfalempe@redhat.com>,
	Thomas =?iso-8859-1?Q?B=F6hler?= <witcher@wiredspace.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in
 documentation
Message-ID: <Z8SkCA5HD2WxR_W0@kernel.org>
References: <20250301231602.917580-1-ojeda@kernel.org>
 <20250301231602.917580-2-ojeda@kernel.org>
 <CANiq72=69XAOapYBurbwsQOEaw2uamZ6ta=DT6cC-om9XK3dvA@mail.gmail.com>
 <Z8SMTiWzTDjIwGfO@kernel.org>
 <CANiq72nQNFSa0quEwLYMUVw-2CH3FwrV695k-rWfoQn5r0Mo0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nQNFSa0quEwLYMUVw-2CH3FwrV695k-rWfoQn5r0Mo0Q@mail.gmail.com>

On Sun, Mar 02, 2025 at 06:45:13PM +0100, Miguel Ojeda wrote:
> On Sun, Mar 2, 2025 at 5:50 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > (cosmetic) Nit:
> >
> > I think you could just:
> >
> > Cc: stable@vger.kernel.org # v6.12+
> 
> Thanks Jarkko -- I did something similar in the past, but sometimes
> patches got backported too much because they could be applied.
> 
> Normally they don't hurt, but I try to be more explicit nowadays so
> that the stable team can decide, and thus I copy-paste that line for
> changes that are related to new compiler cleanups and similar.

Ah, ok, I guessed that you might have some backing idea on what you put
:-) Thanks for the explanation.

> 
> Cheers,
> Miguel
> 

BR, Jarkko
