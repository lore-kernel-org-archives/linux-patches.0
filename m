Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A220E030;
	Fri, 10 Jan 2025 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736515996; cv=none; b=nrywVx3SLDOkgnpMSiektnOYavjQ/RkyrkOoIhvdBIWDQqGi1hFthltHx6QbeZrgJrzd3vcvkVlIWKyl+a3wio2O71+BifNEsLl1/Wa9vMxjEOs7Vfe5OkLoF+xceVcMHDn2YCRbmBDrGDzOMZXehIjMMD/bKZCGUUyhhCszMns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736515996; c=relaxed/simple;
	bh=nQEOacSZS3HRlL/jjO6nY71eeAaLs8aEo20XtpX46ps=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WeKP72dsieI5h8ooudJ+2x/5Le3skODtad93Zn9ykTDZBrH4xO9hpJVzb0jGvZvD5xChkhDnvb+2NQrQDwOKlq3hVwny+qNApkVhYF+5pe7lAmlht8wbMkPgJW971h9poA4wNCIoYE2cpLueACLzMaPgLRzfwhHiJY5+Uh9Imzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwziI8k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwziI8k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C3FC4CEE2;
	Fri, 10 Jan 2025 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736515995;
	bh=nQEOacSZS3HRlL/jjO6nY71eeAaLs8aEo20XtpX46ps=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GwziI8k4IAJHJiXOZX4Ly2oKDY1wIeYf8GPyXcSSk4wNux+MZPfKn0y3amG4yThDq
	 /ztyGBZLOoMORvneBWuGno88MWwKWNo7JQ+321FX1QCGEYmzrQVZm+bFI5jmPwK7//
	 GP1qM5CjVgJ6YELKAzTFIrfkWog8LjOe6aJJwOxICmZnPOjddKR2xzzvV4nqJG0XqT
	 rrAstBDUPNd2esofeKrmACGmst5y5yU3CZmzWy74IKgdtJDRBs4fgnAAngLpqcBx3C
	 RwuFYuAkN2sd9NqDnKfGYPoFhQxv7NxYzWUDUgZJK+FXpBaEKoM6WiXa0haNNsJEK7
	 H2fvDfznE/Y2Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,  Wedson Almeida Filho
 <wedsonaf@gmail.com>,  Alex Gaynor <alex.gaynor@gmail.com>,  Nathan
 Chancellor <nathan@kernel.org>,  Nicolas Schier <nicolas@fjasle.eu>,
  Boqun Feng <boqun.feng@gmail.com>,  Gary Guo <gary@garyguo.net>,
  =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>,  Benno Lossin
 <benno.lossin@proton.me>,  Andreas Hindborg <a.hindborg@samsung.com>,
  Alice Ryhl <aliceryhl@google.com>,  linux-kbuild@vger.kernel.org,
  rust-for-linux@vger.kernel.org,  linux-kernel@vger.kernel.org,
  patches@lists.linux.dev
Subject: Re: [PATCH 3/3] kbuild: rust: support `W=e` for Rust
In-Reply-To: <20240519211235.589325-3-ojeda@kernel.org> (Miguel Ojeda's
	message of "Sun, 19 May 2024 23:12:35 +0200")
References: <20240519211235.589325-1-ojeda@kernel.org>
	<20240519211235.589325-3-ojeda@kernel.org>
User-Agent: mu4e 1.12.7; emacs 29.4
Date: Fri, 10 Jan 2025 14:28:27 +0100
Message-ID: <87ed1ag5ms.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Miguel Ojeda <ojeda@kernel.org> writes:

> With `W=e`, kernel C targets error out on warnings.
>
> Add support for the same feature for Rust code, but take the opportunity
> to apply it for every Rust target (i.e. not just kernel code), so that
> it behaves like having set `CONFIG_WERROR`.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Tested-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg


