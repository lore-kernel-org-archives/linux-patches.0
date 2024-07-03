Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907C14778E
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031366; cv=none; b=J1Hjd7GRaPjrik4Z64fWfHpKKL7yR84RACl5GNbU1vOA33L2SnCKFI0aB8cp+TvhzTGsa53XGDiRJbHNtdUZeJn6jyeBGzN4y+3br7edQhQ53wxumdwdLbo/z9zr91/wJHZhAB1dpoc9ZTXoUZHCGI9ODC1g9gEFUTBR90vg+DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031366; c=relaxed/simple;
	bh=L3NcVxEzp5nQ+zMdZm1I8lzij8qXeXyjjQ5F2gqLdxo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgKfCnEw9u/Xm8x5iKF8IEi/goq/ObRosQHIDBBjwvrtUynY4BAqSU7My6JAjQUajx0Eukfe7DhQng8YLf9Mvbt20+i5paXiUk17TpraJhNl72X1U/FPPhjviAZpI1H7kH0iy+78Y7hBP5BJToD7TRrheyGt3ZAUqmDkws5cA9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=metaspace.dk; spf=pass smtp.mailfrom=metaspace.dk; dkim=pass (2048-bit key) header.d=metaspace.dk header.i=@metaspace.dk header.b=hZqOvw4C; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=metaspace.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metaspace.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metaspace.dk header.i=@metaspace.dk header.b="hZqOvw4C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=metaspace.dk;
	s=protonmail; t=1720031346; x=1720290546;
	bh=L3NcVxEzp5nQ+zMdZm1I8lzij8qXeXyjjQ5F2gqLdxo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=hZqOvw4CIHvkRdDkrAH9bxLznrjrViPUamKEtIiq+lresBwXhY5AQ1qoU1+PJ+Ai1
	 qF5Th2gj6114phfrjYL1mRmWtGlPJw8ZXAobejJaQiuM5aRLH1w7tRy++vs/xG4Z+X
	 CaROtuntJqF6ztjpGWXjwW8S/MBsrFK9Uud0/RBJfYA6vNJ3424gJq1yFq3kvUy1Sd
	 5UiB7bjR2/P2vpCqSTiCeYFojAvnWkSQm3p6wckFYpohZjUiCQA3lNoMu4uY9EIxJ6
	 DarSTn1bf/QW/itvAlTogVg+QjLXSMnOnJrZGMwYOv0xJofMdT+LAzRPm9o7RA1cmt
	 6wyy6H0VZcxxA==
Date: Wed, 03 Jul 2024 18:29:02 +0000
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
From: Andreas Hindborg <nmi@metaspace.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 00/13] Support several Rust toolchain versions
Message-ID: <875xtm8h3s.fsf@metaspace.dk>
In-Reply-To: <CANiq72nPyZJL7TA5wXT__wKp3z5Eoue=RB_Yphh+NCe_AkRpGA@mail.gmail.com>
References: <87a5iy8jlm.fsf@metaspace.dk> <CANiq72nPyZJL7TA5wXT__wKp3z5Eoue=RB_Yphh+NCe_AkRpGA@mail.gmail.com>
Feedback-ID: 113830118:user:proton
X-Pm-Message-ID: cc9662937d5efc6765c4103eeebf592912e06793
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Wed, Jul 3, 2024 at 7:35=E2=80=AFPM Andreas Hindborg <nmi@metaspace.dk=
> wrote:
>>
>> Maybe because I am on v6.9?
>
> Yeah, you need https://lore.kernel.org/rust-for-linux/20240401212303.5373=
55-4-ojeda@kernel.org/
> -- please see the "## LLVM's data layout" section in the commit
> message.

I applied it to the rnull tree based on v6.10-rc3 [1] and ran some tests
with rustc 1.78.0 and 1.79.0 without encountering any problems.


Tested-by: Andreas Hindborg <a.hindborg@samsung.com>


Best regards,
Andreas


[1] https://github.com/metaspace/linux/tree/rnull-v6.10-rc3

