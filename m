Received: from mout-b-110.mailbox.org (mout-b-110.mailbox.org [195.10.208.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E96AB3
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 12:59:15 +0000 (UTC)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-110.mailbox.org (Postfix) with ESMTPS id 4NRL0Z5J26z9tBp;
	Tue,  6 Dec 2022 13:52:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nyantec.com; s=default;
	t=1670331134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IRHVWafY0jHFpHspwEKtI6JUKd/uH2AFkVef11b8k6E=;
	b=N1xBqdYrP8dXmghzKaLbcLdLpkNG0cHbYgPfiCrvtwz9ibdMcruKlyZtBPyty5mVKHwcqy
	pfJsynIP4ubyQGY4nqSPTJkyzhkAhscw1SRYmyIdc7oRGIk5fjr44FjSrWCgY1dgYHb1xH
	gcumJmjWkTPCn46i3XoJNrELOf+f/152w49VMwTXUfHL/ZJXB3F1mQFCOHeTze87OOXo/v
	QwEPSGjXzPKSIeV/sN1Dx++F2UTspoUue1RM278N7FKKDjqEkg/INJhewJ0XQI96v93o9Q
	j7wuTFiOP7ESEf2xjBhgJxuCrqJJKh7Gh4jxiTyORgH/M+D0MV4pBnoCEvQ0ug==
From: Finn Behrens <fin@nyantec.com>
To: ojeda@kernel.org
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Viktor Garske <viktor@v-gar.de>
Subject: Re: [PATCH v2 09/28] rust: error: add codes from `errno-base.h`
Date: Tue, 06 Dec 2022 13:52:07 +0100
Message-ID: <8D86E171-0030-4A3F-BE87-9B9FB9E79213@nyantec.com>
In-Reply-To: <20221202161502.385525-10-ojeda@kernel.org>
References: <20221202161502.385525-1-ojeda@kernel.org>
 <20221202161502.385525-10-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4NRL0Z5J26z9tBp



On 2 Dec 2022, at 17:14, ojeda@kernel.org wrote:

> From: Viktor Garske <viktor@v-gar.de>
>
> Only a few codes were added so far. With the `declare_err!`
> macro in place, add the remaining ones (which is most of them)
> from `include/uapi/asm-generic/errno-base.h`.
>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Viktor Garske <viktor@v-gar.de>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Finn Behrens <fin@nyantec.com>

Regards,
Finn

> ---
>  rust/kernel/error.rs | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index b843f3445483..861746f2422d 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -17,7 +17,40 @@ pub mod code {
>          };
>      }
>
> +    declare_err!(EPERM, "Operation not permitted.");
> +    declare_err!(ENOENT, "No such file or directory.");
> +    declare_err!(ESRCH, "No such process.");
> +    declare_err!(EINTR, "Interrupted system call.");
> +    declare_err!(EIO, "I/O error.");
> +    declare_err!(ENXIO, "No such device or address.");
> +    declare_err!(E2BIG, "Argument list too long.");
> +    declare_err!(ENOEXEC, "Exec format error.");
> +    declare_err!(EBADF, "Bad file number.");
> +    declare_err!(ECHILD, "Exec format error.");
> +    declare_err!(EAGAIN, "Try again.");
>      declare_err!(ENOMEM, "Out of memory.");
> +    declare_err!(EACCES, "Permission denied.");
> +    declare_err!(EFAULT, "Bad address.");
> +    declare_err!(ENOTBLK, "Block device required.");
> +    declare_err!(EBUSY, "Device or resource busy.");
> +    declare_err!(EEXIST, "File exists.");
> +    declare_err!(EXDEV, "Cross-device link.");
> +    declare_err!(ENODEV, "No such device.");
> +    declare_err!(ENOTDIR, "Not a directory.");
> +    declare_err!(EISDIR, "Is a directory.");
> +    declare_err!(EINVAL, "Invalid argument.");
> +    declare_err!(ENFILE, "File table overflow.");
> +    declare_err!(EMFILE, "Too many open files.");
> +    declare_err!(ENOTTY, "Not a typewriter.");
> +    declare_err!(ETXTBSY, "Text file busy.");
> +    declare_err!(EFBIG, "File too large.");
> +    declare_err!(ENOSPC, "No space left on device.");
> +    declare_err!(ESPIPE, "Illegal seek.");
> +    declare_err!(EROFS, "Read-only file system.");
> +    declare_err!(EMLINK, "Too many links.");
> +    declare_err!(EPIPE, "Broken pipe.");
> +    declare_err!(EDOM, "Math argument out of domain of func.");
> +    declare_err!(ERANGE, "Math result not representable.");
>  }
>
>  /// Generic integer kernel error.
> -- =

> 2.38.1
