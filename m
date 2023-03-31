Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE0F1FB1
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 07:09:45 +0000 (UTC)
Date: Fri, 31 Mar 2023 07:09:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680246578; x=1680505778;
	bh=yc7pszNaS5MbnHhdKhl5ZeYs5tmQLP8mPSrXEB1Pfk4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=P77Mw4qMdqZYI2RdWmjZNTsGKTQyZ77FieQWyPBpdBBmiAqwn7bM0hYslj+c7jbPc
	 4/UkSxuVIWihc8PVv+QsXkBOkSiQhk9IDPczy8+kO/AYbK3ZG1ZEFCB9qkr5iMgixU
	 jrW4bSSBPQwEc1Ck3bTBS9YAk/qI9HTraRRN9o0vSsOnbhAQGQARKE6r8OuMmKCiAh
	 afZlEO2dX17N/zaQKYEbO+XfQ65sfB6FswvnGw/6da6+cgIgsn5u/SDPSX4QYDPwQR
	 xlaQm3ZYPwI7ItkJ0SUqanHEc7cxGns7nzWfu13woHHx9sKmh2MGBlKCmtaWOh6TMJ
	 A8BIO+WjxIqkw==
To: Alice Ryhl <alice@ryhl.io>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 09/13] rust: init: add `Zeroable` trait and `init::zeroed` function
Message-ID: <06e72e1f-af49-d952-7dd5-c80b9e3f27ee@protonmail.com>
In-Reply-To: <19db6213-297b-a33d-7331-3c1a5b72fad9@ryhl.io>
References: <20230329223239.138757-10-y86-dev@protonmail.com> <19db6213-297b-a33d-7331-3c1a5b72fad9@ryhl.io>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 31.03.23 00:40, Alice Ryhl wrote:
> On 3/30/23 00:33, y86-dev@protonmail.com wrote:
>> From: Benno Lossin <y86-dev@protonmail.com>
>>
>> Add the `Zeroable` trait which marks types that can be initialized by
>> writing `0x00` to every byte of the type. Also add the `init::zeroed`
>> function that creates an initializer for a `Zeroable` type that writes
>> `0x00` to every byte.
>>
>> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
>> ---
>> +// SAFETY: `null` pointer is valid.
>> +unsafe impl<T: ?Sized> Zeroable for *mut T {}
>> +unsafe impl<T: ?Sized> Zeroable for *const T {}
>
> Actually, I just realized that this is not ok for unsized types. When T
> is unsized, the raw pointer is a fat pointer with a vtable, and the
> vtable part is not necessarily zeroable.
>
> However, it would be ok to do it for `*const [T]` since the fat part of
> the pointer is just the length in this case, and a length of zero is fine=
.
>
> See more here:
> https://github.com/Lokathor/bytemuck/blob/8391afa876ba2e99dffb0c991cc7fa7=
75287d106/src/zeroable.rs#L56-L65

Wow I forgot about fat pointers completely! Good catch!

--
Cheers,
Benno


