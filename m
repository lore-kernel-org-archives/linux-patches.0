Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B151C49
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 19:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711998749; cv=none; b=EW8M++H84pU51azm/VrGEFmIahawm++FVVK6mXEgNOfOvngmrPxgaSeKzs7hb5SFp4aU4jSeA9RvbmlMI69g3opFkMcMYHiKV+HHVehZHLSQg6mMCYetuxXWpWshYmNGn45W3EqjPJrlozyL49ohIBIpED38KHq9dG9iEYWbnII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711998749; c=relaxed/simple;
	bh=lZZgdgpRsCAM7XWp90WoIM3pYzhJNQF6JGgYWb3X5bU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CxuSxGmoai4m2iwQrKa9jhy83GTh7clwFT2fEs+65di7rfO1Vs2glgS8bhU6FD1kQifqZPBgbD9Y3DJHNoESGwmYb5k3pavIbdxdJBtWcFc8jWRE6BqVbWVEePuwYI+N9m+K6mIKgu9+8JE3APes/ny2tbnC4/XUen1IbW93aO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X7nVb9Qi; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7nVb9Qi"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a4715d4c2cbso572641266b.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 12:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711998746; x=1712603546; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obzM0IGvE9A6DBXNxjXsovCrfa1fQhH1FBfKC4ISWA4=;
        b=X7nVb9QiFDpjLCnMXR21vc7BoLZGAXp3SGjzsI6qWYoaefVJuOZUTQ0f4zLI+fCoNI
         XOBj+N5JnhvnKV0vipjnn2xvPywETA9ukXwszChAic7BUw0v2oaSGo1psIebUQVJ4G5G
         Lk4JlFvR6YGA4PJjGRCeg3aawPADRypDC0tLomSEXwHeY2wV1DOqjyVMVzFfqGknhBSF
         U7RBHdHcxsk2xad6Z0cHYK9RbWa9yrzaTkovJr6h+fbxdH1eaBLTZGJB3ZLRi2SsWzp4
         As1mh+7HlqzW/GF65hw43IrqDaRwsJh1PSNBWDwjNrWTwRrblOV5H5jRRwGtlMSq7HvJ
         rjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711998746; x=1712603546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=obzM0IGvE9A6DBXNxjXsovCrfa1fQhH1FBfKC4ISWA4=;
        b=EeO3eYVnyVydzhOCriyQMRrW+hZpRaTSTo7WCtgKCfuMcDML4ytn/iGYJGpfG/nSaa
         VAo7a1I3tC7/ccR1uj5ZLou0FqDTnx0BFkeFFqyPeKy5MMMyeKt4dYqQCDlJULdxAm+E
         9pb7xrNspgPsO1a9pSiwq9CifPy3I85JnvlvbN8T3Vb12TcHpeEVBiRP++5tCEZ+ycSA
         9hiTI3TRHLBCgOlD/JLJJv31khKhpSvTBMqxmmIrE/3Q2CtcW3F7M7visnN8fYbHZ39H
         7HIefG8nUi7wetibANzM6vyxXzVVCKpRfZP3ebTnTRyIrljG/lGT/L3hWqI5k4v/Xu+G
         LUKA==
X-Forwarded-Encrypted: i=1; AJvYcCWOnF/MrDgUCmLiF+okCFdhE2lgD+A8YmwKPtS74MaHULkokP/AJ4vT+TtQvA7b0BVAJu/AREnR50PYqPlmAq58E3IvBWIa6g==
X-Gm-Message-State: AOJu0Yy53eyrQg/AJZdYwTYVXoRXkBcGPcA/4Ilm7kCbl6sHJ2KHxPCR
	7l5hOmsEzF574DUpivwng8IymedkhbM0wLwVp6nCprLdTI7MXfyZCf0c4RdGovr56m4Kk3Row5n
	J0bKQ+rAwPm7zoiJY5HtZjvnjLUFGMuP+RLBx
X-Google-Smtp-Source: AGHT+IFrZn3P1g+mO8cYYJQ1aggkfW8cijER2IOdPjsyl9o0cR1x5wATnba0CgmMUUzNstTzMmB5e81d1T6aIF3k/Pw=
X-Received: by 2002:a17:906:cb86:b0:a47:2f8c:7614 with SMTP id
 mf6-20020a170906cb8600b00a472f8c7614mr6155069ejb.43.1711998746014; Mon, 01
 Apr 2024 12:12:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401-bluetooth-fix-len-type-getsockopt_old-v1-1-c6b5448b5374@kernel.org>
In-Reply-To: <20240401-bluetooth-fix-len-type-getsockopt_old-v1-1-c6b5448b5374@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Mon, 1 Apr 2024 12:12:13 -0700
Message-ID: <CAFhGd8q7vomqQ27FRi-Bn4Dn0s-Qp_PLWS_jwLUi4TFC0KSbeQ@mail.gmail.com>
Subject: Re: [PATCH bluetooth] Bluetooth: Fix type of len in {l2cap,sco}_sock_getsockopt_old()
To: Nathan Chancellor <nathan@kernel.org>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com, 
	ndesaulniers@google.com, morbo@google.com, keescook@chromium.org, 
	linux-bluetooth@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:24=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After an innocuous optimization change in LLVM main (19.0.0), x86_64
> allmodconfig (which enables CONFIG_KCSAN / -fsanitize=3Dthread) fails to
> build due to the checks in check_copy_size():
>
>   In file included from net/bluetooth/sco.c:27:
>   In file included from include/linux/module.h:13:
>   In file included from include/linux/stat.h:19:
>   In file included from include/linux/time.h:60:
>   In file included from include/linux/time32.h:13:
>   In file included from include/linux/timex.h:67:
>   In file included from arch/x86/include/asm/timex.h:6:
>   In file included from arch/x86/include/asm/tsc.h:10:
>   In file included from arch/x86/include/asm/msr.h:15:
>   In file included from include/linux/percpu.h:7:
>   In file included from include/linux/smp.h:118:
>   include/linux/thread_info.h:244:4: error: call to '__bad_copy_from' dec=
lared with 'error' attribute: copy source size is too small
>     244 |                         __bad_copy_from();
>         |                         ^
>
> The same exact error occurs in l2cap_sock.c. The copy_to_user()
> statements that are failing come from l2cap_sock_getsockopt_old() and
> sco_sock_getsockopt_old(). This does not occur with GCC with or without
> KCSAN or Clang without KCSAN enabled.
>
> len is defined as an 'int' because it is assigned from
> '__user int *optlen'. However, it is clamped against the result of
> sizeof(), which has a type of 'size_t' ('unsigned long' for 64-bit
> platforms). This is done with min_t() because min() requires compatible
> types, which results in both len and the result of sizeof() being casted
> to 'unsigned int', meaning len changes signs and the result of sizeof()
> is truncated. From there, len is passed to copy_to_user(), which has a
> third parameter type of 'unsigned long', so it is widened and changes
> signs again. This excessive casting in combination with the KCSAN
> instrumentation causes LLVM to fail to eliminate the __bad_copy_from()
> call, failing the build.
>
> The official recommendation from LLVM developers is to consistently use
> long types for all size variables to avoid the unnecessary casting in
> the first place. Change the type of len to size_t in both
> l2cap_sock_getsockopt_old() and sco_sock_getsockopt_old(). This clears
> up the error while allowing min_t() to be replaced with min(), resulting
> in simpler code with no casts and fewer implicit conversions. While len
> is a different type than optlen now, it should result in no functional
> change because the result of sizeof() will clamp all values of optlen in
> the same manner as before.
>
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2007
> Link: https://github.com/llvm/llvm-project/issues/85647
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  net/bluetooth/l2cap_sock.c | 7 ++++---
>  net/bluetooth/sco.c        | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 4287aa6cc988..81193427bf05 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -439,7 +439,8 @@ static int l2cap_sock_getsockopt_old(struct socket *s=
ock, int optname,
>         struct l2cap_chan *chan =3D l2cap_pi(sk)->chan;
>         struct l2cap_options opts;
>         struct l2cap_conninfo cinfo;
> -       int len, err =3D 0;
> +       int err =3D 0;
> +       size_t len;
>         u32 opt;
>
>         BT_DBG("sk %p", sk);
> @@ -486,7 +487,7 @@ static int l2cap_sock_getsockopt_old(struct socket *s=
ock, int optname,
>
>                 BT_DBG("mode 0x%2.2x", chan->mode);
>
> -               len =3D min_t(unsigned int, len, sizeof(opts));
> +               len =3D min(len, sizeof(opts));
>                 if (copy_to_user(optval, (char *) &opts, len))
>                         err =3D -EFAULT;
>
> @@ -536,7 +537,7 @@ static int l2cap_sock_getsockopt_old(struct socket *s=
ock, int optname,
>                 cinfo.hci_handle =3D chan->conn->hcon->handle;
>                 memcpy(cinfo.dev_class, chan->conn->hcon->dev_class, 3);
>
> -               len =3D min_t(unsigned int, len, sizeof(cinfo));
> +               len =3D min(len, sizeof(cinfo));
>                 if (copy_to_user(optval, (char *) &cinfo, len))
>                         err =3D -EFAULT;
>
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 43daf965a01e..9a72d7f1946c 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -967,7 +967,8 @@ static int sco_sock_getsockopt_old(struct socket *soc=
k, int optname,
>         struct sock *sk =3D sock->sk;
>         struct sco_options opts;
>         struct sco_conninfo cinfo;
> -       int len, err =3D 0;
> +       int err =3D 0;
> +       size_t len;
>
>         BT_DBG("sk %p", sk);
>
> @@ -989,7 +990,7 @@ static int sco_sock_getsockopt_old(struct socket *soc=
k, int optname,
>
>                 BT_DBG("mtu %u", opts.mtu);
>
> -               len =3D min_t(unsigned int, len, sizeof(opts));
> +               len =3D min(len, sizeof(opts));
>                 if (copy_to_user(optval, (char *)&opts, len))
>                         err =3D -EFAULT;
>
> @@ -1007,7 +1008,7 @@ static int sco_sock_getsockopt_old(struct socket *s=
ock, int optname,
>                 cinfo.hci_handle =3D sco_pi(sk)->conn->hcon->handle;
>                 memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class=
, 3);
>
> -               len =3D min_t(unsigned int, len, sizeof(cinfo));
> +               len =3D min(len, sizeof(cinfo));
>                 if (copy_to_user(optval, (char *)&cinfo, len))
>                         err =3D -EFAULT;
>
>
> ---
> base-commit: 7835fcfd132eb88b87e8eb901f88436f63ab60f7
> change-id: 20240401-bluetooth-fix-len-type-getsockopt_old-73c4a8e60444
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
