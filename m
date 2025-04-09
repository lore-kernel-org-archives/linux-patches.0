Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369A25291E;
	Wed,  9 Apr 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744215053; cv=none; b=p6u5qt9EdXwtMiIf8UNB/wEH02yXiOsVspm6bYdDp5WUiWEBguQfii3mHYnX3+0Q/PKLYOAO0O6vEPd/8GFrYOOrBrIjpCyqmV3MFTYfTS3Ss8KlrhmlDUAsE52qFaEnhTcFL2iCCduvGWiUjI9FWXzLmf9/8dWJYm/b5t1UEHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744215053; c=relaxed/simple;
	bh=4XkQ2SWqN1yArGEfXIrrxztPbMbkaDy7ww8hcwGwosk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJur2LnhcR//JlMM/ks/i0IhptWOGw+Emyak/r2gSA40qqsbPvfO2lSnOl0tzzpWjUm3q3u5euqTqVGktAYJPGTVcpVLfqlAsUGhDMHAIx9WwW9josUZtk0OcY0xPonLa59ShOhg9h/1kMYwlEuIq9gv3722QGUCDDH0ARI8jdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJqsBxsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJqsBxsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49860C4CEE7;
	Wed,  9 Apr 2025 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744215052;
	bh=4XkQ2SWqN1yArGEfXIrrxztPbMbkaDy7ww8hcwGwosk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJqsBxsgyLLaaV7kIhO7tGwT2AKJ8fU7TmUrVnLcRpB4GSf9O7w6XQzwt56kLoe9U
	 p4/tL9h256uvvy0ynfJURZOUVabPQ8ah9iCkoR854qjqZDDxCAhRPedUG8D4ywQFMq
	 Mdwx8oUxZ2YfAOOZ7nIR+qR6RLY1TK+You+C8pvv+ZSGvwPktHFrarYEYYiCTPtKrE
	 kDg2RtiGnnLWRSTHl6IzdBEiNj7nMuixe5GXL+g7suLI6uxbycwgJCFUkKNK7aowET
	 FKl4OFheV49TqDn2Iadf1HmRSWy8srA8Hecpy5j6NTZWRwu3ioASrUuCDAObwZk8zz
	 ZX2e3ZBEqHDIQ==
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
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
Date: Wed,  9 Apr 2025 18:10:34 +0200
Message-ID: <20250409161034.1244178-1-ojeda@kernel.org>
In-Reply-To: <20250409115832.610030955@linuxfoundation.org>
References: <20250409115832.610030955@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 09 Apr 2025 14:02:32 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 205 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:02 +0000.
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
