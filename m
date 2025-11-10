Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEFC2FE585
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762776262; cv=none; b=kR2tl/zPkkDBGbt4+cdJLvvet1mxlDeKW0IZouc97yjYz/SIU4Hl9ewsydCRI5JB3lEFn1lZDlobPuKEJIU0nYpdlxV915LrYW2FaIlN8Cq6KDNJ+loZMpAUjxjV7R1SbnuVCBu9aXwkMQDIpmSxc1+FYtnVjA6+XBPzvPJlV+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762776262; c=relaxed/simple;
	bh=eEgXHGzlAYOJl5c6fOfboUSe/VxaQBrlFhhrVppwDjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hAb7kyJKCrcc0rLi00jg8YinAlrphSFmgS75esq7rhoD8KTfedximjc4hNvmR2JT1ZdhCe5E2vJirxWe7X42Z0c7cyIoW8pAAhN7UHkJOElGfC8ieoQzDh7PT6umcZtdxriDKKNUUlyNK84ErT5pnYxMpjgb5y+rDBpZrlB9q2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXRqoSrw; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXRqoSrw"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297ea4c2933so678465ad.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 04:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762776261; x=1763381061; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eEgXHGzlAYOJl5c6fOfboUSe/VxaQBrlFhhrVppwDjc=;
        b=UXRqoSrwgRhiyd2tlIuuzeWSCx6pHvZW+Fd4mRMlteBtzxvCcZOXCbbtTJngCwwCS7
         iHiM+iVaoYDXtHJ10eAXs/0GlY4ruUFpgaUXn3MUP7PMGq9LSAc6pjiPzSrT8sNgtPik
         VYp/WBIenZqjqLW5HUfo8qXY+xLmfmSfkkUhogNHcVpZsp+i4x3to/lbivPKd7QTTIAJ
         s3hDq0eWfUp7POG1uNkl4lmsqF62o6kH+ApEUVBJLV3m3ega/bqyQlgewf2+y05oFTJr
         oCfPjiK69J5f1XlWYohmj3hSt/kZXStF0hIaplm1/+FJHgxVKp4Ekam85Ho6w5oa+OyK
         Sf4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762776261; x=1763381061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eEgXHGzlAYOJl5c6fOfboUSe/VxaQBrlFhhrVppwDjc=;
        b=nvknqvf8rILbYhuPJ2HDXnqwyX06ls2n2kors6VZ84sXA3S+gn4Fb3zg9tMoix7H8W
         xYWPcrRnkzj5FYT5DmPpe8c0OIi24iSmi7jdFMIqwXtGvkF46bxAp+tvc7SEWG0Pjg06
         H897LQpQFYUSbt+sGnZM1/WPg+5ck21oTXsgDyuSq/JFRJdqHNLRAGDX9MTDsos+Y0zD
         qus2fmqd7/oRyFrzzA/8KGtNBLGlupRI2Y0WpCSejCdVHd6MxTs/AcCyzRKXhUgdXr7a
         Omm3DWz0qEbH5d3tyX2Fyz935/rUQBKAfprxkW1Gxy3Q/wjrRA79n4QcvHqiEfeThgm9
         kINg==
X-Forwarded-Encrypted: i=1; AJvYcCWDKVOnCSr5VlmgifDD7V3Ak6IfXGfbP3YQZ3eZLJuqNsUctvpXQ4+yIsPH2ga5guqaBfAV9wqr@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3ACRgsgX9fsOR0d+DtTfd/wljaQ+z3wG0kEWw59bDRY+M8dYQ
	4aTPv9AG6h43pzb0Mkm89jpt/puh4bxftwmoOMO2CI/JFYrD0qumo1PQJU4iQOOZuUR3ojoOZyx
	gufzoReZeprjOap4tGKDCWf19mOY1twI=
X-Gm-Gg: ASbGncthT29Yj0oGwMY+upy9MfW6fHAlUeJ/Chhxxuxh48KG5Ot0cG3atjJ0cJuSP0F
	r2Vc2pHQQskhtkP4w3An9TmS8wqbvowd2UbhcxhuFDtTTYxU32jVHzPUsXHVtGgdDZZZ8XptZzb
	ILYPOusKeSF63KKDkicXtYgmn+mzycDLcgYuhSIyu3gzwX3kGPGY+Vm//UnuKX4Z7srEkOTlX7R
	1Xciot1ik90U2m2YueNmHXdCMCdW+53yhGRINqsKJKrH/LoHlpNrmHWdYocIwugFYybwnx9suX3
	+Xwqk/sioGJzv84jYMGwThXfrsjOSJPqUzdAASbSxRCXRu9nJuemp2BIghWyQh6aik8NFN0R6Xu
	krWoYLcQZcA5yKA==
X-Google-Smtp-Source: AGHT+IExnxjKRMhBvCvd9Nw1Vzpg0dilgRX0ilaQeygPAtmrJ/VO92XIw2N3ZJ7sb6hS/zOwLVLxlgfmv0VAGSAIzy8=
X-Received: by 2002:a17:903:230f:b0:295:70b1:edd6 with SMTP id
 d9443c01a7336-297e5643e76mr52737955ad.3.1762776260815; Mon, 10 Nov 2025
 04:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110113528.1658238-1-ojeda@kernel.org> <aRHSLChi5HYXW4-9@google.com>
In-Reply-To: <aRHSLChi5HYXW4-9@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 13:04:08 +0100
X-Gm-Features: AWmQ_bklNKkIpzDaIt0BmvJnv6iHBReLEFoejSD6lCAMShx-lppQSbZzdpW8AeA
Message-ID: <CANiq72n29SUnmm3Dos_NvWbxW-vuX2Y2j7AAYROpa6ruQWguSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: allow `unreachable_pub` for doctests
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <raemoar63@gmail.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 12:53=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> Maybe we should also allow disallowed_names in doc tests?

Not sure -- I thought it may point people to try to come up with
better names in examples. On the other hand, for abstract facilities,
it is true that there may not be good names anyway.

Cheers,
Miguel
