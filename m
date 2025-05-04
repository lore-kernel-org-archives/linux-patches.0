Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A55151990
	for <patches@lists.linux.dev>; Sun,  4 May 2025 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746379866; cv=none; b=MduizkiXjDNl9T4UuMnqEuxHAHE/JLESMd61RPCMUTDzOAwTMEdS+PddFqoKuRXSWwzKvpdFZoz1PPuHS9l7FJDUyJZb0AvwfNxv9WS54V/nIOj0Uetn3Veu5GjgplDx+tIKBWXOX7rWyq8+PVKuwujQ+obanBP+ehUNU52MMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746379866; c=relaxed/simple;
	bh=T3U/9FuOE2xtfOj0tUx2Kuhmdtf7tLVJexcbxbRimKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bICt6TOxPGstHzucwF3Nq4IzSqrGjtVg7J3uRBzhiukgFkkbKAG1gWbovORFq5mxARuSbTluZgoL33qGlw9tkbNk12vBnQS8E+DNmcALVJsUv7qBkmXqq2O6mJJ74M5zSP2f9Ksf9E+aACS83PBh4JedKSxl0o1vjkf2yMxfLi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVhv34JS; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVhv34JS"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-54b1095625dso4409598e87.0
        for <patches@lists.linux.dev>; Sun, 04 May 2025 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746379860; x=1746984660; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MAjfptIMQwKjMkK2caSxzARquP7ADDmjnSLYI6Zjxw=;
        b=AVhv34JSxR2vH2IfU5TFfhY4/UxjeSQxrP2wOD0y6ZEpI/DaZFl4Sm9tD/CLqfdeE/
         oGDPq8eEyG+fIB7qcUxVFpQaWBEm5lDRgBtuS6E59/KlFpdowFO9Xmpyii52vM/FVy3J
         aD8XT4KOfjl9gIbUzNcS9R9d8ZB6R0/yyCjN1FaRUPJXXyp71zJIFBbrZPCnxCgN/it3
         Po+Zs+cFbjK73bsUmshGJYyDXbBRzEIgepiHQ9cX/6oLAOP1GM3Sbw/eFhERcfh0Q6Ga
         piwsK9ndPAjgSXOwuS+FDa2Leuh07Af3ute1DR8xUaKtsbcHGU1s/grduMucT+otJkt0
         aQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746379860; x=1746984660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MAjfptIMQwKjMkK2caSxzARquP7ADDmjnSLYI6Zjxw=;
        b=H12zjzgJLe4PwpSSPR3D1rCZi57DYZpDhgtINAM66Ss9W2/Cgzfj9IQGbCyrMf2101
         scKUNob0G/lplu59cny8zPZzHEpdtgP1G2mljRns7hShyQSnFn9A+HAQi0IlMZXsow5/
         hU/zYx4/5iw3BNVWt0Bzboin2z/LZ6NvKkM5CwclXrBplIAJiHcpUAz2LcJbcWC5XWAF
         5F8YiI7yL64JmJb/4L7mM2UMqEUL3av7bAYHBOofKtwSsPBqj2SMeWPHd/Elg/DFnBLA
         rysvDLbk5btjhl8Cyv2iJ2ifzOz3zekaqvfFLDnWFSKiVR1ENkPcZyDvA6E05xIVQypk
         EZ9g==
X-Forwarded-Encrypted: i=1; AJvYcCXSP1Xu7FFNkhdwW3piJE/ZFdy9JXG1UmO54lMstDAP1rGtLUzufLpQuihg4pqsX4PcgquWr7Ba@lists.linux.dev
X-Gm-Message-State: AOJu0YwUSt8/yUhrD+bzuyHZR5egNqbRfeYtMkAnTQGDRWfSKmPSS52B
	9+92P/c0bqIepCXIJNA1XOYVPbnh2Q+jKvd8YVQEwhkEQV5hLq5pnuqbNhRAC4TQ5H4FhRzPYtT
	oH2qHPPuPFFo8qAAJQtTzC7g3xZ0=
X-Gm-Gg: ASbGnctV1s3y1Lx7TJUzG6wsFNlQYrKPEllpqHr0UGfqm8oTtwCheSgDLqdqXRLh+xQ
	T0jrPVeqBn4ZtTtJ0wQx/sewaBsaAx8yON5RM+Drb8oVgaFjQ6mhbq1IbM9/eBHg0LMzFYcpcSQ
	a862rhjUNXnjaEmFyF9WwrfUDu77exG/cJRxeE/K4GeqpZU7Qgooirn8A=
X-Google-Smtp-Source: AGHT+IGk67ZjNfI5JRZk1E9sIkaiWYoh/CFeHhNDrNSEmUPefy9/YpSuJCSkf4tQjbpLx1hp8nibAzsjUmqph/UNhtQ=
X-Received: by 2002:a2e:be9c:0:b0:30d:e104:cb74 with SMTP id
 38308e7fff4ca-320c5fd2023mr23540791fa.41.1746379859507; Sun, 04 May 2025
 10:30:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-5-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-5-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sun, 4 May 2025 13:30:23 -0400
X-Gm-Features: ATxdqUH6DCMZhtsVocCllU2SKUNfgzC5NnOkbEXIh3IhAUh31vvSHfK6t0f55C0
Message-ID: <CAJ-ks9k=uxxumgEU84-54u8OxxJVBsUprGk7Ht31ndoumHB95w@mail.gmail.com>
Subject: Re: [PATCH 4/7] rust: str: convert `rusttest` tests into KUnit
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 5:53=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In general, we should aim to test as much as possible within the actual
> kernel, and not in the build host.

Is that true? The build host is often easier to work with. There's a
number of host tests on the C side that exist precisely for this
reason.

> Thus convert these `rusttest` tests into KUnit tests.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/str.rs | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
> index 878111cb77bc..cf2caa2db168 100644
> --- a/rust/kernel/str.rs
> +++ b/rust/kernel/str.rs
> @@ -6,7 +6,7 @@
>  use core::fmt::{self, Write};
>  use core::ops::{self, Deref, DerefMut, Index};
>
> -use crate::error::{code::*, Error};
> +use crate::prelude::*;
>
>  /// Byte string without UTF-8 validity guarantee.
>  #[repr(transparent)]
> @@ -572,8 +572,7 @@ macro_rules! c_str {
>      }};
>  }
>
> -#[cfg(test)]
> -#[expect(clippy::items_after_test_module)]
> +#[kunit_tests(rust_kernel_str)]
>  mod tests {
>      use super::*;
>
> @@ -622,11 +621,10 @@ fn test_cstr_to_str() {
>      }
>
>      #[test]
> -    #[should_panic]
> -    fn test_cstr_to_str_panic() {
> +    fn test_cstr_to_str_invalid_utf8() {
>          let bad_bytes =3D b"\xc3\x28\0";
>          let checked_cstr =3D CStr::from_bytes_with_nul(bad_bytes).unwrap=
();
> -        checked_cstr.to_str().unwrap();
> +        assert!(checked_cstr.to_str().is_err());
>      }
>
>      #[test]
> --
> 2.49.0
>
>
