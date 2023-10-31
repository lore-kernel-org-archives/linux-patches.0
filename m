Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5715127440
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 21:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0ZrEQmeC"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-32dc9ff4a8fso3828488f8f.1
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698789002; x=1699393802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GKyb1hV1vtUSZDqLnTgdX5n0+OXLN+juvNSKnK7I5Q0=;
        b=0ZrEQmeCbQHLio4EVjfM04Rkq9dm1LM+Q6jE35xZPdxJH2yc1zLmreXBBpC6a2obdF
         vzEaw7PUr5II9td+pAQQl9ojfgmTIIH5yeXluk8O8/vlVvPoRr3//plwRNQzJGHU0FOb
         rxccmVvzJ5DfWfBU9F2WBXkQPSDA/3A98fYl19QGxtAsXBCicXUYiM/QS9ljH0MXfOG7
         UxtfDyQjAlc37WIPlJ2ZsraQ9T1F2bQU08UPkEbXZdzugkJwEp6ArBAiyluMa61J11It
         PeJ0306G413JNUssiisaTEhwgzQ3Io+imDtXw+xHOQEmQQ+dQY3C7QP2dsLD26Uxxjfb
         KcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698789002; x=1699393802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GKyb1hV1vtUSZDqLnTgdX5n0+OXLN+juvNSKnK7I5Q0=;
        b=ldPWtEYRGIPjsR80jeng0XymFDtr4gpLVYqaFJonY+kN09lHWG1FQeJM9Pt6brE4uG
         HBTThB6bD7Qb3GrkAulJJWmuoc07K3Pq9tKUbRoo1q+9QAzKY8CKj/TtEAW8fwcoWiSS
         7f4PYQxOBhEDNrqvgyh/ZxwKmaTIalq071XIw/UvyBglZv1CrlauCklGo1jn7lHMN3U5
         L20pPLDuOGEufAMFY1n3edhiGDdyk1/XMQN0hars3WCSYeuiDe/2q2CnpyvDX7JZ60JV
         fjfPqpDPFSwrW6A9cY5npa9zKuRjAA1OBLWoq3CvgtYi9LJs+IwqdHFKdJOlnFcvEbwG
         W2vA==
X-Gm-Message-State: AOJu0YylDpa/gl4hRf1z2E4cQyKH3tU3H8pOxZGiNiIuSYFqePYSZ9hB
	w0pl2ZrqUt9/1AgfMxCzAOLpmUVAFIrnSgPzTrP9Vg==
X-Google-Smtp-Source: AGHT+IFryCasodoGUQr+d/4GX14lqOug/C63+v0x+SVaHw1GimgEBCDcf3pc/kFUY3kFJsdoKLmo/dqwwMQDTEbCNHk=
X-Received: by 2002:a5d:4fc9:0:b0:31f:9b4f:1910 with SMTP id
 h9-20020a5d4fc9000000b0031f9b4f1910mr9964196wrw.63.1698789002364; Tue, 31 Oct
 2023 14:50:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
In-Reply-To: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 31 Oct 2023 14:49:51 -0700
Message-ID: <CAKwvOd=CsF8B2i6f6d95J=n3zAZ7P2+bddBGBt0st=Q-f-OniA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Fix -Wc23-extensions in tcp_options_write()
To: Nathan Chancellor <nathan@kernel.org>
Cc: edumazet@google.com, davem@davemloft.net, dsahern@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, trix@redhat.com, 0x7f454c46@gmail.com, 
	fruggeri@arista.com, noureddine@arista.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 1:23=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy) when CONFIG_TCP_AO is set:
>
>   net/ipv4/tcp_output.c:663:2: error: label at end of compound statement =
is a C23 extension [-Werror,-Wc23-extensions]
>     663 |         }
>         |         ^
>   1 error generated.
>
> On earlier releases (such as clang-11, the current minimum supported
> version for building the kernel) that do not support C23, this was a
> hard error unconditionally:
>
>   net/ipv4/tcp_output.c:663:2: error: expected statement
>           }
>           ^
>   1 error generated.
>
> Add a semicolon after the label to create an empty statement, which
> resolves the warning or error for all compilers.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1953
> Fixes: 1e03d32bea8e ("net/tcp: Add TCP-AO sign to outgoing packets")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Well, at least ISO fixed that in C23...I found it annoying. One day we
might have nice things.  Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  net/ipv4/tcp_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index f558c054cf6e..6064895daece 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -658,7 +658,7 @@ static void tcp_options_write(struct tcphdr *th, stru=
ct tcp_sock *tp,
>                         memset(ptr, TCPOPT_NOP, sizeof(*ptr));
>                         ptr++;
>                 }
> -out_ao:
> +out_ao:;
>  #endif
>         }
>         if (unlikely(opts->mss)) {
>
> ---
> base-commit: 55c900477f5b3897d9038446f72a281cae0efd86
> change-id: 20231031-tcp-ao-fix-label-in-compound-statement-warning-ebd6c9=
978498
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
