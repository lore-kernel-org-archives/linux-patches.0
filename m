Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F54D194AD5
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 23:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742857811; cv=none; b=kDrj+nly4UcRAD7fEOJcPrAQq+kYN30HXZEEOF1WaZ4jI2HiB4kdVXDRHz8gE46wNRQ9DuscUuLdmth4/8JHtRMwRDomhfhOSdJMfYsiSSOQZa1uc1xYhzeX4QqrmQl8sbT06r3UQ9KHpk7goaIsUH1UafGbAuyVGxf7NmZEKG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742857811; c=relaxed/simple;
	bh=9I8KQKYlVXXDa2GWgnH9sokfNCoithb5dsrUI8nor1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lFZ8ldjik8GKAYeJ3UZY+du3YDQj7rzNb8lKRRw+aFiRjO2BsHEHRSAAUsg4E3n0xDALqRpqJoMYPIsriuOx9dglqnBSHJaFSILDAkIxsNtFIZbMaDaOgCWgmfohnc/XRHI4OdRKIYQMrEB8oevFgBeFk+WXvQrALrEpCgrEo7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bP0/nNXh; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bP0/nNXh"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff73032ac0so1376366a91.3
        for <patches@lists.linux.dev>; Mon, 24 Mar 2025 16:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742857810; x=1743462610; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9I8KQKYlVXXDa2GWgnH9sokfNCoithb5dsrUI8nor1s=;
        b=bP0/nNXhDu1D+fcWCLYodPEjKOw+eZ+eTf40A7ZqZ6BYxPRkjM7UPWaWX05eOHqDqF
         CQG8388umIrVqvpZahc5VTFuKc3mzzrpv7K7MQJa8pFNDrSlgPQgxXvkGcpBk8ShEBGI
         yUim+p0XeU8eoHVMYJKSCbLEQ+YOHzznSIIzrqiqeKP9jYSYzPM8tidkXRmsXZhXb7JO
         a/hNnLnRttUf5d2YnzV5tmaZLiHoRbAABA6R3W/PvJHgr1z4ad6GdUoXpEE/3LNY9AMK
         va2oPKY2E9PEsOiTJ9c4bwrvINs/wr7A4byQXmB1ph9hPk+7WUqFpfxBTeuF5Fy8tqX1
         2+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742857810; x=1743462610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9I8KQKYlVXXDa2GWgnH9sokfNCoithb5dsrUI8nor1s=;
        b=ocq1qggce5etX+bs009cKXhcnbsI/rvaI+K86zQ271hThYYma9DU718SMyLJqXi0il
         +gHmgke/LcmZwu8YtBtO6WXW2iyteQdwCjLDMaJsZNYJhEi1WGpvvrCiy+ZXM8Zd8BAj
         yM7wj7287OMreLzW2WlStrAaMtb6mUfFiS6sQOdiiUIQDgXemEBGW6AV2kj9pmhShzsd
         Km2SxCmYzru7A9c0noTvP0//7gAsDsMXB4ahuSs3jVrdTCkfe2Gmd+GMAdf+o54cOICm
         pTQkD4N2kHlznoRx/2b9107FB2GXwNv2QjxtrwxkYoI+zSsK78QlUlaw/SJSarmhqT25
         AGFA==
X-Forwarded-Encrypted: i=1; AJvYcCVVR2Km9v0rGNt0xFfjr0WTX5aVjt5qeWV8rW7J7Av3oec4XDRUtsOXp41MLZ0hT7ADnjAw6d3r@lists.linux.dev
X-Gm-Message-State: AOJu0YyXVQgU9Gi+UAMoYwt3MPpMMBttgFfF69p8ujaRJvCN7x+WXi7o
	H0/7ooQ3MCWN9Yi/VP1ebvFbjlwsrgmOUb4xY18RDkOozdm7LlLh8Ad8p+HiB6fVKkSQt273jSu
	RetwaLyA+YkFCu4do2u/57VJfrYU=
X-Gm-Gg: ASbGncv25wSkZ+ehTG39tYYBkR1KGu+caNbFD8ZAfJXab0vaC2g4yoeRNkKqSW0dmD4
	h7cQASouIOieCSpwM1uB68/qS0XyJBMD7Ki/VDeQzb8PICVPMOXIbW8wm5cAV5UBRh/0uwDG7hh
	kXXhpw/jxDaB/ejG4eTibVI97PMVl5eP4HQiNP
X-Google-Smtp-Source: AGHT+IHiw5wJimpAjJws1j5GfyzNNmvdTmtt+Gdtx8BghKlWqDwaQomsOsLGjrJpvBuh7t+if89qAAVbaQkJFUfRQ3U=
X-Received: by 2002:a17:90b:1645:b0:2ff:4b7a:f0a4 with SMTP id
 98e67ed59e1d1-3030fef4ad2mr8519928a91.3.1742857809561; Mon, 24 Mar 2025
 16:10:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324210359.1199574-1-ojeda@kernel.org> <D8OVATSS19YC.1GXZRNM6TBA0X@proton.me>
In-Reply-To: <D8OVATSS19YC.1GXZRNM6TBA0X@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 25 Mar 2025 00:09:57 +0100
X-Gm-Features: AQ5f1JpnGCnEckuxVoIN7plR0rZlCRqSBHxkP_kvLOHPlP1ckzapWMGe-fd5zW8
Message-ID: <CANiq72ng_ABVR5ihxMeN5Ast6Lu0-zxkgjnKzbtn4j3ghFKgZg@mail.gmail.com>
Subject: Re: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 11:59=E2=80=AFPM Benno Lossin <benno.lossin@proton.=
me> wrote:
>
> Not sure what you mean by this, but I think we need some way to disable
> it for some acronyms.

I meant that maintaining the list in that file (i.e. globally) could
be a bit painful if we get a lot of terms, but I guess we can find
workarounds for that if it gets bad.

> Reviewed-by: Benno Lossin <benno.lossin@proton.me>

Thanks!

Cheers,
Miguel
