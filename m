Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B651CAA87;
	Wed,  9 Apr 2025 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214928; cv=none; b=XvIcEPIzcC0qVEXCmIgHEimxG6K4MgY4P9zR+Qle59L8tzRAZphYGQgdWjzljdLC6LnXiIjMD9VQA4CdE0yjjsrUhrQKtA5B1sEl7qXcepz7vbq6snxaunv4QVok6f+mTZbZZfjr44poQKbFb1YgwG0HeY510TK7rlf6JIMu9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214928; c=relaxed/simple;
	bh=U136m1ePMiHup/OJWWPTED0TS3OMbL/CgENFCdA9fr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G05rm1QqvYZwvG7FoTcWJiYsBYtlczXt5eO9UXeXPgC5x+D8Yk6dR8Lk3COqaK/xCIN8UpFGcq1I1w+AlQ2EI5GABkddPQTP2/KwLxPxuPa2O2h8a/NcaI9g9fkPU7YamXE3377zufM1CCSqQX/CnMnL3g90LnhXARvGe1VMFDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2BYMjDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2BYMjDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE5AC4CEE2;
	Wed,  9 Apr 2025 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214927;
	bh=U136m1ePMiHup/OJWWPTED0TS3OMbL/CgENFCdA9fr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2BYMjDU7ETSO4yGvcd25H3Zyq6RwlCc++3/am2IjZL28A6K7WqSHm2MTJ4QvNPeL
	 6pBSHesbAsmZTq1CmTTccrgaOrhT15uEAN1xh/Iu4OEPgNtk8G76cTDw27X9w4uWHU
	 DXO79rwEiRJy+ehNXmxOYMSnIT7MDVz2pV/Ae6TvRt7Hpmm91AhY4/6G4KppDp1gHm
	 xv5Muz0jBs9SxM4TZ95oStsU6aPCet9dQnHpHRMSKO429jub75cHkXIqcw+yjNMo2I
	 UULbv3b+cBVKf8/UZZqZBZSkBArkq6c2FlFFpVmnZvHSGJlH7ZEgyE3xskngsgLDcz
	 OdoKJqXEroZvA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/269] 6.6.87-rc2 review
Date: Wed,  9 Apr 2025 18:08:31 +0200
Message-ID: <20250409160831.1243751-1-ojeda@kernel.org>
In-Reply-To: <20250409115840.028123334@linuxfoundation.org>
References: <20250409115840.028123334@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 09 Apr 2025 14:02:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:04 +0000.
> Anything received after that time might be too late.

For 6.1.y and 6.6.y, Rust fails to build with:

     error[E0432]: unresolved import `crate::ffi`
      --> rust/kernel/print.rs:10:5
       |
    10 |     ffi::{c_char, c_void},
       |     ^^^
       |     |
       |     unresolved import
       |     help: a similar path exists: `core::ffi`

In 6.1.y, C `char` and `core::ffi::c_char` are both signed. So the only issue is
the `const` -- we can keep using the `core::ffi::c_char` type.

In 6.6.y, C `char` changed to unsigned, but `core::ffi::c_char` is signed.

Either way, for both branches, I would recommend dropping the patch -- it is not
critical, and we can always send it later.

Thus, for 6.1.y we could just drop the `rust/kernel/print.rs` changes. And for
6.6.y we would need something like:

    diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
    index f48926e3e9fe..c85b9b4922a0 100644
    --- a/rust/kernel/print.rs
    +++ b/rust/kernel/print.rs
    @@ -6,10 +6,7 @@
     //!
     //! Reference: <https://www.kernel.org/doc/html/latest/core-api/printk-basics.html>

    -use core::{
    -    ffi::{c_char, c_void},
    -    fmt,
    -};
    +use core::{ffi::c_void, fmt};

     use crate::str::RawFormatter;

    @@ -18,11 +15,7 @@

     // Called from `vsprintf` with format specifier `%pA`.
     #[no_mangle]
    -unsafe extern "C" fn rust_fmt_argument(
    -    buf: *mut c_char,
    -    end: *mut c_char,
    -    ptr: *const c_void,
    -) -> *mut c_char {
    +unsafe extern "C" fn rust_fmt_argument(buf: *mut u8, end: *mut u8, ptr: *const c_void) -> *mut u8 {
         use fmt::Write;
         // SAFETY: The C contract guarantees that `buf` is valid if it's less than `end`.
         let mut w = unsafe { RawFormatter::from_ptrs(buf.cast(), end.cast()) };

Thanks!

Cheers,
Miguel
