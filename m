Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4698F4A
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 16:19:04 +0000 (UTC)
Date: Wed, 22 Mar 2023 16:18:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1679501942; x=1679761142;
	bh=5ALAy5pala/Uch3PDmDpaH5urLbdFuosVmerjiirmy4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FcblW/U6YDpSVX88KRGptcsTah8DZLGUshKfFv4z/KKtKVfaQW6aKiAfGdkD4DoDU
	 bHKMeNW5mrNgC15uJuuT3jWxDx62jemwO+5dpLMi+119jFMkmw+CkRlxRj86bTHykv
	 BuKVpvE7bqgA6L8L31gPB0zQlhOm4p9wMEq8XahVGKTv3ycg8ItoOHl6s3Gk6m7REO
	 pofN8WNJwETtJMO6Cp0BYYHs9tb74E/cVp+7sHpsbbXKKOTF/rT6qTP1YRl6xwmHMg
	 N5WQ8bEP+xukdqbN8nzl7U6godJQd8uR+RlfQrJkRhAAUKMvEOZHFou6xGk6Ye8AUt
	 MkcgMtkWhbMmA==
To: Boqun Feng <boqun.feng@gmail.com>, Benno Lossin <y86-dev@protonmail.com>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 4/5] rust: init: add common init-helper functions for `Opaque`
Message-ID: <7f2af153-0537-ab64-81c3-a15714d8afd7@proton.me>
In-Reply-To: <ZBoONi8oMO4X7DWy@boqun-archlinux>
References: <20230321194934.908891-1-y86-dev@protonmail.com> <20230321194934.908891-5-y86-dev@protonmail.com> <ZBoONi8oMO4X7DWy@boqun-archlinux>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 21.03.23 21:06, Boqun Feng wrote:
> I wonder whether it's better to make these as methods of Opaque<T>, i.e.
>
> =09impl<T> Opaque<T> {
> =09    pub unsafe fn ffi_init(...) -> impl PinInit<Self> {
> =09    =09...
> =09    }
> =09    ...
> =09}
>
> then it's a little more obvious to users that these methods are for
> Opaque type pin init.
>
> Thoughts?

That would work, will add it to v3.

Cheers,
Benno

