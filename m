Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF612CA5
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727583492; cv=none; b=a5n43P5eSR4lFQAEb5wExc4JczqQg5OF2nGvBgj9S0ieof/QBYNMdfEkGp6nucfYXdwuQBWzhDNNPH/CzV1xA4mqXGmQlkQTo8jDVifS2ibr4UXuK4GRBw3Af+iY1LUTe+AJ+rHbYw2cfOLvIQt9hrxtVzcpY6AKOsjz9NoRobE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727583492; c=relaxed/simple;
	bh=FMIGLf+Y9vF5aJ2DZoLFX9IXpQMyVobrCuEt6UgGFo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bvx0U76mvxCD5ay0j/lmDZJFcwb//1zX7lUtoqAFbIyZyuHmfKhUX+lCTY+VAIyl1SFlJA41zSqdhKY8iyFxl/Fcg/xM3U2E3g1+0xILn1sgdtuVAs2pMirWBx6z5fb1zDVqgFQpwvTsmx0Grr2R2YFyvhsHn8iO2MnnjsgblHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=b6WjHY9V; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="b6WjHY9V"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6d9f65f9e3eso28782087b3.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727583488; x=1728188288; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+m8AqonS+5wkQ0t+OwfdrCfKeL0zOxEqCmb5hKElDc=;
        b=b6WjHY9VonjoDnhYMqAQ1noAUTrtTSeoYKZhZ205kBm8Y8/65LZPJzT0GboDGlKj76
         NCmHguhCLqE+MG5Dy8RdK29WO5Af9L4BezUyvom/XddFmmU0wr/TuYhJ26RhI6v8o12Y
         3o9BNlNmp73sdazCV1bGOcb0+3PhJepEthKQcg3MG4zajUD6oMPR6TfhZh6WkptQeyJQ
         7hyv9G2E7wC9bDJ9zGyM0/IPJw+FNMiOFrWnnsgfGTxYT9UgR64M1HK65wNEbadQhqYS
         FFTjA/PcB2HvSf27S/siJCw7oFx2bvl+UleSeM7niF8hY7FwlMU2ijgv4w7JCCvfkxXF
         A7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727583488; x=1728188288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+m8AqonS+5wkQ0t+OwfdrCfKeL0zOxEqCmb5hKElDc=;
        b=ZP+VMISTCyX1SYG7lppeGqcDukeufbjSRJDvjvmbJ0QEjaavRdFFa4eS4eahK2K6PR
         PNtStMW5CacftvHP/5VoD8D2+z8DFN1FxrlEp57GcY00e7qH+/c9k4muFfxs6FKamdYV
         01znXk5A+h5UMFzaSTwTk6CYALN0CWGeFuZm2TAUi5mtBbK7pPESX8wa8fJ+FI/OxH2z
         4CV+mauDaXHDG7ADMzAzD40tyUHWCsOjOucnHLVVaBs8/UjMvWHZyG1jbMLitgfKZAFC
         4RXV4FelYOp8FKqE0UNUFQ410x0DA5eWpKQXDKnmmWhM6gePtlGUOPhuQb62MLDEOOg/
         qyhw==
X-Forwarded-Encrypted: i=1; AJvYcCW4Ed5lgUfN3O62XgPOs7LqN1oyvltpNGom5H9tqb2j0TqazpcFuLPvYiSbln9NjolC5D+qd9Jw@lists.linux.dev
X-Gm-Message-State: AOJu0Yxx/rY0KYiftoHxwBg9zRu4xYykpHUboY+4iyecmRC/+VaxqmYu
	leott0RwQZS6EX3PSh1rsihxrHDbBnug04CT9gp6vUWRQbIOpLnlq4/s04qsiHAZDl05ikWCcA6
	c7V0lAEM+Q6D47V88sOf0fNgDP9zFw0eKPr9PYw==
X-Google-Smtp-Source: AGHT+IHG+ttejnUk0zyaZpRqlfVcERFzFnZe28OrhK/N94BnvFQjUgcmlw1DztcdaSHGiLlQpGJBubePZGpNHYH6Hi0=
X-Received: by 2002:a05:690c:39a:b0:6be:92c7:a27e with SMTP id
 00721157ae682-6e2475e2d1emr59019207b3.28.1727583487761; Sat, 28 Sep 2024
 21:18:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-2-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-2-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:17:56 -0400
Message-ID: <CALNs47sLuQU3=kT_eMi_kR1_Ak-75P1S+-G5sewop8J396EmoQ@mail.gmail.com>
Subject: Re: [PATCH 01/19] rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Perform the same clean commit b2516f7af9d2 ("rust: kernel: remove
> `#[allow(clippy::new_ret_no_self)]`") did for a case that appeared in
> workqueue in parallel in commit 7324b88975c5 ("rust: workqueue: add
> helper for defining work_struct fields"):
>
>     Clippy triggered a false positive on its `new_ret_no_self` lint
>     when using the `pin_init!` macro. Since Rust 1.67.0, that does
>     not happen anymore, since Clippy learnt to not warn about
>     `-> impl Trait<Self>` [1][2].
>
>     The kernel nowadays uses Rust 1.72.1, thus remove the `#[allow]`.
>
>     Link: https://github.com/rust-lang/rust-clippy/issues/7344 [1]
>     Link: https://github.com/rust-lang/rust-clippy/pull/9733 [2]
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
