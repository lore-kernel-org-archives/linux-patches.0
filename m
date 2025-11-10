Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDAB3126D5
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781952; cv=none; b=nBkbVglbtR0iJufIfVEri0L8nMXt4DURH9vAkHX0XvwH0fhjV47qopIIJBD5x0kSWPJbBxsyKe0v+4JqrWMjuJRbzdpz16LMpXmYNe9DLhMFO8XEwncFUrzd3nDvq+0im1ruUAun0GDCeSxcb/ZGtVQsVHrldthkhQz3VNE3Jqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781952; c=relaxed/simple;
	bh=JxxNv3zsqMj1Gs4mcPxMIFOWegAIC0ZVsqaUYW8cbJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AacJF9/Y5/Jlv4mbaZYUOLs7+bpDVmAJ8VRrKTNinuk6F+jzGH/Ob5vItTdFWluCWqBHvQABILzw+W4O1H0lsF1yfpzTOnfih/Od/YkTmTRoHcYMuD4UgQuOr2XobWKmUr619g7LL6dVAXOZ2FRPx01E7f+ju6ALaK0FZVXl2ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvreZ5UH; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvreZ5UH"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b87171370b5so266999a12.1
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 05:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762781951; x=1763386751; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JxxNv3zsqMj1Gs4mcPxMIFOWegAIC0ZVsqaUYW8cbJQ=;
        b=VvreZ5UHPZRcXy4sVMD/35hm64RTsi32I86CHha2b9pFzMMKb9GlZmydymUJsOFKxW
         PdzV+NHmx5ciGayf9tIfU30mMftoFknDNUF4rhMx61LZU8HIfcHj5Km902gBQikZR5qV
         vG9yeg2HG4SKTg2N34Dd34fsZADJ7Tm5t+8cNVdv/aNIo9F3yc1VEoiI7+mwUAK9XlD4
         gPp2VOGAUWxn6ErNtSbKnyhDS3ogYuCPn6Lmzudo3EWweiRtBBJz8FJHxVUX8kjGSjFa
         du34SGhn8HBMLJiJlzjmJoO7VNQae0j4ygQpbhyqMHaC2lGRp/OW2E8ppAl2f3rpSd6A
         zVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762781951; x=1763386751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JxxNv3zsqMj1Gs4mcPxMIFOWegAIC0ZVsqaUYW8cbJQ=;
        b=LxDkpoo92mESDbi+evml07d3mDWZYHcO/S4sg9MHhPsONaSB1GQ0Kq8/gQ/EXBA9ZI
         pZgHY2WMXDM54GL1LCTHK+kvlxpM3tZ4jWCr9jCFqbEOCxcaImmq7rTmro5/++jJcang
         NVk4Ne90VM2cO8vC1oKHaObmfbIINbNS/Y3iBLnCynaV0jUoFC5AEl27vozae4ksHOy+
         14pi7ra74lQrq4lZJ/G13CNRux1UiiXOeKHApIp58w2O313DOaIzuUuYJl07A64B0I/P
         hJV9bMpCiEx89buoxswfyGem9PxFq06WCVj1qdNA6ZOhQW9po/7vaL1iICA8WS+55Z6z
         4K4g==
X-Forwarded-Encrypted: i=1; AJvYcCXgduHaQGsslyr1Zdu0ITkiERptOy4iZmk4ahVDKRzd0eGc7ZLP4B6xBDQdVPE7zNKevP3eSdbb@lists.linux.dev
X-Gm-Message-State: AOJu0YxdhR3z7UAKwhsIYUIoq0J7K9ouIXRD4HLH2yNXFxjmBBWUTKmO
	L/BII60LebOu2NiiQuFx5OQYUNHHYVlV0K6uoCmu/upt9DsQq4I9HPgjZDVWi6A9rg+bXzqkmWm
	88Ed1irVF4oGmsZxztD8PRqfQ/Z/ydGU=
X-Gm-Gg: ASbGncuxbC0H0DtNlvk0e4uYRpFeQPOyNtFudD9Z8IXmdOgWZCd3ckrpbYjugNRfMnO
	uRv3XfSmkBQV5TKNcZk7vGvvBff9IcCO6N+DOxcGKpxY4Gzb9ADR5nIf2Uy3/Yaj8ZbJzIbimW7
	U6zM1OS4gzTaUcB4lHo7mVzXoKP+tQ5PZSxebBjYMt4Jdo1qbNx5B8amZUYo+vQQaiD8nboq2Sw
	K2WzzkpeukHmH56zLoa6Nc+lr0Dfallnyypxgpu3KOoKEZK5T/6wDOj7UV2CYOJSeazmxMyzuwr
	uxouwFUCxcfOJX3+tzhu1ZNOQeuxU3CWS368foZsuOiuNqtZ69u28R5cK9hUGhY+bdHdOjZen4N
	Qlvo=
X-Google-Smtp-Source: AGHT+IG/R5OD4pp1OFOM9MYMt9/Bhul+bEC+eJ9Gapoq++XiZ8PPTIp2w0OLJEaZ5ptFkMI9E6aTQfedtmXfsk2hbhE=
X-Received: by 2002:a17:902:c409:b0:295:3262:c695 with SMTP id
 d9443c01a7336-297e5646bd4mr60288355ad.3.1762781950762; Mon, 10 Nov 2025
 05:39:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-19-ojeda@kernel.org>
 <aRHRYbHIfxMQ77eh@google.com>
In-Reply-To: <aRHRYbHIfxMQ77eh@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 14:38:58 +0100
X-Gm-Features: AWmQ_bm55qKIiHG3q93w7SalH37CbhDBzqfQWzONZGIL-nfi2vUYjlTXeaaq0Ug
Message-ID: <CANiq72msN1B8c8QFuH2VK40xXY3=uGiGL=YgAo68o92LTO=kLw@mail.gmail.com>
Subject: Re: [PATCH 18/18] rust: syn: enable support in kbuild
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 12:49=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> This change seems unrelated?

It is needed to actually use them in proc macros, e.g. to build the
new `pin-init`. We could move it to that patch series, but then it
means it is harder to use this series (e.g. someone was waiting to
port other macros).

I can put it in a final patch or perhaps just mention it in the log,
similar to the `quote` one.

Cheers,
Miguel
