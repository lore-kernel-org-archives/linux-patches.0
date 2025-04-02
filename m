Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E35223817D
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 11:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743592414; cv=none; b=T/UJRMcGFVVvwo6K0TksVJyAWd6ikTYk2Q0SoUAClCgMF2/OOg136Bq4QlkRSdUcK422Fqwtw3F05Bqq2ZAz9kARHWePtaLmuywbeP2YvLJ3uDgZ5w//7nVNEs6AOtP+MCatxoWfcHuUEy9VqhIRQwiw56xr0wLw7NmbMg2/VbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743592414; c=relaxed/simple;
	bh=Va3/UmUACgg9LWpe5gv41c299SYu6ixHTt7HBmtP6Xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W+Hf/78YDQ0PXrDgxXW6U8gk07f1NVczWZqmonfZrIp0iCGkVX1C/xkMO7TCLEmcs/FMAQ9UBmktMkxL4z9uAHmheQQJqJSXAArqYoa0yCcE41/VxHI1zW8OHfuR6fYBl+2YGLsWuJ8+NkmbnYVDLQZOUY4fpmqbWtrNot/QNkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kEBKS8Tl; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEBKS8Tl"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff53b26af2so1439160a91.0
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 04:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743592413; x=1744197213; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Va3/UmUACgg9LWpe5gv41c299SYu6ixHTt7HBmtP6Xc=;
        b=kEBKS8TlgEZld6Vsn0iCXKDOf8r2Ba4kHF+C+9JecmGbIwTLdknLiLuD8lpg7t0qID
         GzzFdoYbtBraWuxTx03KOQC1Nz2aJNhtI2Nx1T/bYyBndLZqne8B1ttrMNppd6krvVu9
         uMfa9n61IkzcOVBsLtT8aKtnto/C6EuHGzbE6Ehxl9V5VJKsyDM1W8MuyDL213Zyl+V9
         hVo0nEgW+mrDMc6s0QWz+FtrOl72AguFAqF8J82WagYx4PQj4xS5NUAzZ5kve4ygkX7U
         267/W9jtsalY+bOYbyKMfdnc61UO1frjZrkuafB9k2312zkRlV43O2ZiQWFtDsE5lOeo
         4rcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743592413; x=1744197213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Va3/UmUACgg9LWpe5gv41c299SYu6ixHTt7HBmtP6Xc=;
        b=t7UrFOMqnQkUZnOww1gIVP7kguyalYHcR/kCeeZILHTZtvzX6n6QDsEwwmRae6Tc5J
         WoKJ/9YpCXny98GOm+s4lRGxkSBJRWIdpY1AwT3vPBJGUhbpHO5qm1RcC7RJiGkaca5J
         Wp6l2AN4hA1RY1Pm62VZyePXhzrTvI+FFlvT16fD82oBfpF9TsrAjhaAZ+19XjgueP1w
         xo1hpDxcyPeirekxSuNuc43V1r+5ra+8QfDZUpq11DLf918j3iF0Kkl+dTfGTed67P5L
         6mr5XzwNRu7h7dR+I0Fndr/sD/PdX2Qzc5Zo+rzDzMJe2ZMJM3JGQFHz+Iz2VwF6pJ9o
         Mmsg==
X-Forwarded-Encrypted: i=1; AJvYcCWr8LAfqxAh36736+Z0kT+3QlkvNlKjETgWS+/AindVRRsslGytXFOOhns6L9szNztVTIlRwPDo@lists.linux.dev
X-Gm-Message-State: AOJu0YwziQIrEOpZFFUddKd0IWhlZSpn4kBVEXlw99JlizHafh4vdZty
	3DsuThFPiSVgL2A3q6vmLC88nZ4NBHNJs3/SLjlOhdiotqqFYeFrGloiD3xjyEMm5Ej3eqw/9rm
	phzPydzwVXdfOglqnXz88dSa3qho=
X-Gm-Gg: ASbGncsj3gGk8EtdogSCHQh4my0UCJ+VqNqr2JEEGuRzsve5zj1ELGw2nMri0xSLe8a
	mnsTv2bIe0BRJGk2mP7SSOVaqCDn0h01jR5KskOWZpke85PmFlZOH8C7KX5h6yLWiq8CqYp71uW
	48U1bx6IXckYU8VUhwLieSNeZ55mbm2jxmsUl2
X-Google-Smtp-Source: AGHT+IEBkCp90LmZJMzNSuCw1qE0a9pZT4uHJuwEA4vfFgxDMgFpQvGkHWwdLKVCzAdFlWhEtA0WoxxQ02iDMVwiUrw=
X-Received: by 2002:a17:90b:3e8c:b0:2ff:6666:529d with SMTP id
 98e67ed59e1d1-30562e93988mr3236432a91.6.1743592412698; Wed, 02 Apr 2025
 04:13:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
In-Reply-To: <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Apr 2025 13:13:20 +0200
X-Gm-Features: AQ5f1JppUI-5RQRrcETk_cSydGCYdkJ4HjopUtEovoKCf5jbtrY8bK8XDJmnna4
Message-ID: <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 1:53=E2=80=AFAM Benno Lossin <benno.lossin@proton.me=
> wrote:
>
> I'm not too sure about this change, if the loop is longer than one
> screen, it makes a lot of sense to have a `continue` instead of `()`,
> since one might not see that there is nothing after the `match`.
>
> I also think that an explicit `continue` is nicer from a expressability
> standpoint. So I think we should keep them.

Yeah, I feel similarly. It is sad because the lint did find other
cases in the past that were useful.

If nobody else cares about keeping this one enabled, then I will send
the alternative patch. Hopefully we can re-enable it at some point in
the future.

Cheers,
Miguel
