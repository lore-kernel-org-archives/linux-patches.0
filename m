Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E883F33981
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584923; cv=none; b=E2FwJz2yeQ4NN0kdyEsk+OwDiLr3rfqjeQmnYiIQaHd2RKl3TrmrSP7Zm9e8Md7HQBSN0K6ivKB28b9+MQs5b3xNc2jcUU8ABr8nkiaVEs+hrE3IEUYOl1rV519TkOK38TUhTfTvF7lYjBfsQjtVHeiZvEZQJWhnWCFpGlobU8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584923; c=relaxed/simple;
	bh=vHzOMj9jD9kuxpfdw0bcPVwZ1W+/Pn85ztnlnrksZHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O9d0zSN0cBSJpiPucLEGFGaUspvgBA3zo1d2e8wWY7yqXkcx/HzgBJ/o5JKBX/62HuNsyWFp+SSfUaVpntrn8y+A8bkcd3QUWaOlKvv3wIJysAi0/qNOzhqdmQ4RRK6cAnwjDZLgfHBYVOOZPvLWhajN97+4dnjIolUjFmNnuyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=Z7m32CLl; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="Z7m32CLl"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6dbc5db8a31so25582217b3.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584921; x=1728189721; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHzOMj9jD9kuxpfdw0bcPVwZ1W+/Pn85ztnlnrksZHk=;
        b=Z7m32CLlInTHftvL9jK8zO/futBa1nqvPPxZZPwvboCra/iwoCEWeXLy28YyYiwjgW
         PHgJDaYugTVwHLFAPqo+TbfmWQBps2S+F031w7/QPQ75gtiuGssZOXX/tDLxNJcX8mOy
         KzbKnPm2LQWCCUqlC3zG4LOsjJNGZivEF29d2h003IrzmZtTlHzhI/mbzLXw0nk+zjcX
         VOM/0Wr7jm4zBXYanLyf9ZBs+6GV+Uc6Ka3W+8QtD04QAWVgRiV8/b6QPhnbiPpB4ap8
         vI8CnD1Nr1AB/AlOBb2z5M8oXJaSRrhTMpqhITfgOMQlzt03rmyMh0kPJbPIK2Cy506c
         Eoqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584921; x=1728189721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHzOMj9jD9kuxpfdw0bcPVwZ1W+/Pn85ztnlnrksZHk=;
        b=T0J6ppjv9SzZMV4njszQ8xKgitn9wdNxO93D/Hf3/myLUtevOuaY4sUJhzmlktEzBH
         7ksyQczYycZmQ1j+ZtPhpN8DSZgglh6wgcJgG1E3YrPGsjyBlayjUgiDBUq0hZNPwUtN
         DzTHdG4hI3Xbsh8dixHu8sOb+ZaZsXWB8HxhMyBtWDHlq7D7zf9bppPoCKKQsKVVsSfF
         Wr31lVW5edZpAkfsCZG7rUbWr66i94g45NDJIT/lFFkBNj3NE3QYv/Ax5QrOPO/d/RXB
         4cTl8sT68MRO+qa82N9YU8Oo+RW3I9nJiWrvcP0cvE7IknOebW4n1c6S6VV9SYoqwho6
         PWXA==
X-Forwarded-Encrypted: i=1; AJvYcCV+xqb7yFu2tmQCaiD0x/inuGsFISDptxSTmynI0G7ig700StrBbpDmxf4fQZywy+YQ1KdoZzSW@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz2BKUYQpa07/orgUhbBZkAHpOkVVZJsA0PnH1k7qy5V2lVPSy
	zIm1KwykCrT5WlRaIpMh/rKBgB6VjDX43EW2vEf6IVGYHsHjXmkcnesb/84zTfhyxA/0r49MGfZ
	K7yhAaXJp+8brhyWz9r9/KWGYfzjB3fFrMynVVA==
X-Google-Smtp-Source: AGHT+IFvrDAqZx5NgF8LGfqkqSWrF6ZyKve0RQW2JLbiFzouK/e4QQP+LYMhrvl/TomKpgf5kQZo16BsN5iCCk3XejQ=
X-Received: by 2002:a05:690c:700f:b0:6e2:2e8e:7a20 with SMTP id
 00721157ae682-6e22edded73mr82279697b3.13.1727584920951; Sat, 28 Sep 2024
 21:42:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-11-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-11-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:41:50 -0400
Message-ID: <CALNs47srxg41krbHiZmv0cVuHNj-SQ8_NFzxpnnHM8GeBFKhhg@mail.gmail.com>
Subject: Re: [PATCH 10/19] rust: sync: remove unneeded `#[allow(clippy::non_send_fields_in_send_ty)]`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Rust 1.58.0 (before Rust was merged into the kernel) made Clippy's
> `non_send_fields_in_send_ty` lint part of the `suspicious` lint group for
> a brief window of time [1] until the minor version 1.58.1 got released
> a week after, where the lint was moved back to `nursery`.
>
> By that time, we had already upgraded to that Rust version, and thus we
> had `allow`ed the lint here for `CondVar`.
>
> Nowadays, Clippy's `non_send_fields_in_send_ty` would still trigger here
> if it were enabled.
>
> Moreover, if enabled, `Lock<T, B>` and `Task` would also require an
> `allow`. Therefore, it does not seem like someone is actually enabling it
> (in, e.g., a custom flags build).
>
> Finally, the lint does not appear to have had major improvements since
> then [2].
>
> Thus remove the `allow` since it is unneeded.
>
> Link: https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1=
581-2022-01-20 [1]
> Link: https://github.com/rust-lang/rust-clippy/issues/8045 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
