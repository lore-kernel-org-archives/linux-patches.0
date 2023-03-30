Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943EE79C6
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 15:20:01 +0000 (UTC)
Date: Thu, 30 Mar 2023 15:19:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680189597; x=1680448797;
	bh=Z3JCbWaaWUMZEyUU5ytYZUzOcZ8CnK3JDGgkqkS7+eI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=EWfJX+CKcZmbhRYtFful5fvUIEi+TDwouuLODz7hj1r1918HfMDyWmRZFA7CEdBGa
	 MFSu1v9YXcYEHVMI5dI7lkiMhcjF3LTeMNPQRxUIOHo17qwuyX1Twuza49DxD4U+i7
	 JjL/CScn6HFXql4n8Cj5Vozl9xDbIulns4ebrZVUpSD7po9J9WmoHeJ1TKlXL/ZCmz
	 js4+NtwWITHIShFuzwi1eZ0e9c/WfErbn4klebzYePWA61DNiUL3TNT4KHrtMC8eEr
	 YYicgA9rE6pVOKM5FOa27XbxXKsM9hAtPIcPT52BTt8gGo1ItxzZWaD+07p8CYqnTW
	 57va7nW5NWcSQ==
To: Alice Ryhl <alice@ryhl.io>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH v3 08/13] rust: init: add `stack_pin_init!` macro
Message-ID: <4b048bfc-e4fe-8c2f-ebfe-9b6a410cd8b8@protonmail.com>
In-Reply-To: <ada8307d-5177-2094-683f-bce619f1ea44@ryhl.io>
References: <20230329223239.138757-1-y86-dev@protonmail.com> <20230329223239.138757-9-y86-dev@protonmail.com> <ada8307d-5177-2094-683f-bce619f1ea44@ryhl.io>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30.03.23 17:00, Alice Ryhl wrote:
> On 3/30/23 00:33, y86-dev@protonmail.com wrote:
>> From: Benno Lossin <y86-dev@protonmail.com>
>>
>> The `stack_pin_init!` macro allows pin-initializing a value on the
>> stack. It accepts a `impl PinInit<T, E>` to initialize a `T`. It allows
>> propagating any errors via `?` or handling it normally via `match`.
>>
>> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
>> ---
>> +#[macro_export]
>> +macro_rules! stack_pin_init {
>> +    (let $var:ident $(: $t:ty)? =3D $val:expr) =3D> {
>> +        let mut $var =3D $crate::init::__internal::StackInit$(::<$t>)?:=
:uninit();
>> +        let mut $var =3D {
>> +            let val =3D $val;
>> +            unsafe { $crate::init::__internal::StackInit::init(&mut $va=
r, val) }
>> +        };
>> +    };
>> +    (let $var:ident $(: $t:ty)? =3D? $val:expr) =3D> {
>> +        let mut $var =3D $crate::init::__internal::StackInit$(::<$t>)?:=
:uninit();
>> +        let mut $var =3D {
>> +            let val =3D $val;
>> +            unsafe { $crate::init::__internal::StackInit::init(&mut $va=
r, val)? }
>> +        };
>> +    };
>> +}
>
> This will be inconvenient to use if the initializer is infallible and is
> used inside an infallible function. However, I'm not sure what a better
> alternative would be. Perhaps we should have three variants?

That could be an option, any ideas for the syntax though? Or should it
be a different macro like `stack_pin_init!` and `try_stack_pin_init!`?

> Also, maybe a `<-` rather than `=3D` would be more consistent?

That is sadly not possible, since `<-` is not allowed after `ty` fragments.

> Anyway, I don't think this should block the PR. We can revisit it later
> if it becomes a problem.

Sure.

--
Cheers,
Benno


