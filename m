Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B21EF0AE
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 22:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742856841; cv=none; b=fAWdwGfPPU2n2NASgnswQOFUY0Wu0KgYM0u3n5p5NUCx12kSV4fMmRe9l3M+DsUMfDBYKQOB62TN9qa/PxV/rn5+ygkoTWzfNV8Y/u7MS9awZ8ylX3k5Yhl3gAu6Mz0yXfKefZWIascOUuLmihldaVc8UiqF85Hdfg2t6s/FWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742856841; c=relaxed/simple;
	bh=Pn0AGGzSeqNfWHLY8AhjCZdz1VG8MO6qul3p82EqjDs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NvOpNx8cgJXyc9WafaZvwcknICUPrkvC3LcGAgVdysd0dmVYOw60ZLPNkOHaUre0JXsiciQFz6hGsCBYdoLQkbYAmuEIsQ3OW9AuZvrIA9B0KamMaGqGbULlz0btOBOAHa0gVWvMRmsCQtQu/n5UuH9AJYQxpKzF4Pam6dJDJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=iE7qo37P; arc=none smtp.client-ip=109.224.244.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="iE7qo37P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1742856836; x=1743116036;
	bh=yaV/DCUdOc3Cm1Ubw865d7CG3nJIk8LhbWqXmh7MRvQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=iE7qo37PSTN7YrlKH/VHM9g2A3kUW1FbYeA8aOnXAH5M8862tbYlp8wG345DUjhja
	 VpCSXt2tQ4GJXlqpY2I0GUhx5u6b74hmfDgCJqqSrI2hpVg5dLnxt3VLNZRaMAsZ/e
	 WnosEtRAX2p9rBWUkGrkYct7mXDbzypaowFvFL9h77KvzZWlbgDPW6clsiE5foahEP
	 r1BayvA+UerORyaYNC7he2j8D1yC8xKGvIymzZOFbw3gQSvPltHBqxjq9r4W8Glj3p
	 q7PS4icbbhGYGHQ5Ore4pTh/LOnZYsNGQFX62gE2K1sFAfm/VJcz3pM/im6Iu4JRAc
	 LUi2rulnj5FVw==
Date: Mon, 24 Mar 2025 22:53:49 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 07/10] rust: pci: fix docs related to missing Markdown code spans
Message-ID: <D8OV6JF1S63H.NG5CXUZDQQP6@proton.me>
In-Reply-To: <20250324210359.1199574-8-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org> <20250324210359.1199574-8-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: 88024eb59a9f355de344d17b88fd4fbc46014edb
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon Mar 24, 2025 at 10:03 PM CET, Miguel Ojeda wrote:
> diff --git a/rust/kernel/pci.rs b/rust/kernel/pci.rs
> index f7b2743828ae..99413607c2b6 100644
> --- a/rust/kernel/pci.rs
> +++ b/rust/kernel/pci.rs
> @@ -115,7 +115,9 @@ macro_rules! module_pci_driver {
>  };
>  }
>
> -/// Abstraction for bindings::pci_device_id.
> +/// Abstraction for the PCI device ID structure ([`pci_device_id`]).

Wouldn't "([`struct pci_device_id`])" make more sense?

---
Cheers,
Benno

> +///
> +/// [`pci_device_id`]: https://docs.kernel.org/PCI/pci.html#c.pci_device=
_id
>  #[repr(transparent)]
>  #[derive(Clone, Copy)]
>  pub struct DeviceId(bindings::pci_device_id);

