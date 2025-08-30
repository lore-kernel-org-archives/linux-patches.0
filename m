Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121D2701CB
	for <patches@lists.linux.dev>; Sat, 30 Aug 2025 11:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756552087; cv=none; b=T8mtoEGQOvWtE7sSI+va/bWHunQobPBz4ccA1RRLJh4unWMs38V6+WigN/Wfk45fW/OE2CMqdmuFMC3i8ZAVX531IpZqxTQrNEtIXuxcyr5IzAKeA24rCYogsQnMnCQ2EFjA60nXTOGhhtwsCXn1U+bI5AzU+Unyu6YswWONz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756552087; c=relaxed/simple;
	bh=DC07IAJNLS87gP6QZ4GAcetAKm85JzcJ0eqYsCK5qmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3JC/aTkeOfboEaoeLMzIEiAGSCY+Z9GPEsy9Ld3MSNiEufDvuibStiDuU41reSAaSXpayOi1kdi6cRmJzEK5fkhul1cNw5I1ImYwbiUIuc80yO1xg1l+et62LN1FPwJ7hYlERwoQMFeGBZViKUDVTLjVVf2vce+Ben0Wa1dLHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nFR7ULZF; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFR7ULZF"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2488be81066so7269725ad.1
        for <patches@lists.linux.dev>; Sat, 30 Aug 2025 04:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756552085; x=1757156885; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DC07IAJNLS87gP6QZ4GAcetAKm85JzcJ0eqYsCK5qmw=;
        b=nFR7ULZFA9fIQEgkEwhnBleUzKhqKRGfwfsSyjm9KnwHfZO1kmjjZimfYqYm+q3aik
         1szzCLpWRsX80FYGJyqGBl1jvtiqlNlH8LkHbpvMcsfqgTzl+Xx77uuT/pn4730Oq1jk
         xr9aOFp70MmjMDrYGbf2mc1LiQ+8VqIHEzt3ZoyX34m/okQXtKgJNux6GyzVg/uia7dB
         hWmKvblKx2tnj27+XURa4z71KFUU90V0WLpvzQwMJE8WcyGmNgvy3tX9xCvcZh4H0qXw
         qM/Flad49fDPCY/fJ3OLp84z2Y8xzqYd5twBsHgLQDa3Y36UDlxE+rJdYnOM4ZoBmdNJ
         OZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756552085; x=1757156885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DC07IAJNLS87gP6QZ4GAcetAKm85JzcJ0eqYsCK5qmw=;
        b=SvyCQNJERuX9X0uGksp2+AhWjexSJCFT3eIjHzkYJRptU1GEb/kwktejrgKjWzqebY
         CY8VQCKk+M+pzUg94C7Uk+YoHR9io7ipOb58iqTPH6CRmZ0VygAROAEZRn+c/RsG9ZZs
         bAJhsrPN583yoLzak0lJoHVbTkM48Naut5aivQwvbRK8omndtDRmF62WB851/1fvFbR4
         VLxWNl5Wew9I1zi0ItP4qlbezYzHcYECZ7taM8tKlrvvvOFSXL6b3U3UQeYQB+/vbciQ
         Qfgg45KcM5XnGDbbOprK8fQ86jY2KPRBBLHgwIqrh5K1rGjd0GeF26W4WpYCG/pjlgM3
         i7Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWmB4N8cB6bPLQMR6Vv8rqD4ous0S87tqVVtYTFwq1j6o9mWRzpHvJKrHkK87f+rDCXsilyqrZL@lists.linux.dev
X-Gm-Message-State: AOJu0YzSK8TGqZoPuCsSTKHHVqHINMIoXHxN8TnBJFCDytogxgFrivZg
	Wi8XQOqBHwUcE9pE8dmC20DI8CyJmLyZX3jcFGuCKtkDDmtamIQXj/kq2j9PxMH71su9LZA4hxk
	UqhyLqQSJ3Xwf2uaLcuH+fhC+C0nCOpg=
X-Gm-Gg: ASbGncuBbTFLCOip18KciVwxTkjpUSFB8PHupOJz2SaMxiP7fnx593+JCjb/NlhALI0
	ebDfETdrwfNzo8HY+Re49qEb6mfNlFyEfJMsBT/5kbnDYOTbv07AvU8ZoC/vXLyAD3Nnd1pVKo1
	5N8uQI0S+3tYfJBzmQOw7ervUF6m0VXBWNjbPrbo7rgyXwrhboO3MTn9iXOdghsZA+BgEZ8bWpF
	YWQVQaLSdVZ9wjyTG9PWpop7g9FQ+nEncpABcyoLm1PqUg8lHhUl9fWshldWgpInDhpXTZwjPDv
	HLd/v8D43JSRnaQuYBl3jRUho/g4C85qaiLT
X-Google-Smtp-Source: AGHT+IH5ZNvD4l8TuAzdnDz24AupViHRUbZNq8TFYy6umeiXqfTUMOwh+H66Ull3ujqV3KdwuMCRZvo1OnXw8eI5Pfs=
X-Received: by 2002:a17:903:1c7:b0:240:8717:e393 with SMTP id
 d9443c01a7336-2490f7591bdmr39162875ad.5.1756552084948; Sat, 30 Aug 2025
 04:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250829192243.678079-1-ojeda@kernel.org> <20250829192243.678079-4-ojeda@kernel.org>
 <CANiq72k7_GbFwRxW5vikF_SpiNcNm7Ff0oe6jyYX_voDg92QFA@mail.gmail.com> <2025083032-barmaid-rising-a977@gregkh>
In-Reply-To: <2025083032-barmaid-rising-a977@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 30 Aug 2025 13:07:52 +0200
X-Gm-Features: Ac12FXxtE1MzAIWtlE3GhZGNxnNcK1rhQ_lrX5csjRmJrEow6fqjYBmIW6jipio
Message-ID: <CANiq72nAagBBPhyU3XdETMKBuFPbMMRaSTStWPpyLnByYPP=+A@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: error: replace `WARN_ON_ONCE` comment with `debug_assert!`
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 30, 2025 at 8:28=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> If you wish to state that CONFIG_RUST_DEBUG_ASSERTIONS=3Dy should NEVER b=
e
> used in ANY shipping Linux system, then yes, we can carve out an
> exception for this (we do that if lockdep is enabled as that should
> never be in a running system, only a development one).

The config option is meant for development purposes ("debug"). We
don't control all its behavior anyway, because the compiler/stdlib
will also add many assertions (e.g. for unsafe preconditions). So, for
instance, it could easily have a non-trivial performance impact.

For the same reason, it will also change behavior depending on the
compiler version. So, for instance, new assertions in new compiler
versions could have an impact that is not seen in previous versions.

Thus, for this particular config option, we cannot guarantee much, and
the help text already states "This can be used to enable extra
debugging code in development but not in production.".

Having said that, I regularly CI-test our main branches with the
option enabled, and it has worked fine so far.

So if a user actually run with such kind of asserts in production,
because they really want to crash on anything and everything, I don't
see why they couldn't. It may really be that it actually stops an
important exploit from going on. Of course, it may also be that it
elevates a trivial bug into a denial of service elsewhere, but that
risk may be worth it for certain users.

In fact, I would say it is a good thing that certain specialized users
run with it enabled, because then it means they may find potential
bugs for others, and that makes everyone safer in practice.

But I don't know what exact constraints the CVE system puts on you, so
it is hard to assess what the best wording for such an option would
be.

As an addendum: the fact that the compiler is involved is a bit
tangential -- we could have our own "debug" asserts (or "extra
paranoid" asserts) that are independent of the compiler, and we could
have a separate config option etc. But, of course, in this case with
the compiler/stdlib involved it means it is harder to
blanket-recommend for production.

Thanks!

Cheers,
Miguel
