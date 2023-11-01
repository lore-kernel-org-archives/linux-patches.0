Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AF110F2
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 04:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DRpXkx8J"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-54357417e81so7750a12.0
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 21:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698814200; x=1699419000; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhQrGrRiXOP6T/LjlMKW+7pqde7WtEKCtrVNN6uAKIY=;
        b=DRpXkx8JScKsSSGLjQFH6n9rzl/ATh19a1qXpWjqQJHE2++Z530OhMCPRDgSZTmnFT
         /oHIqQXb1Vz7+7jFE40NgpSYeISi5T7Zcei+7n54bW0o76T3sSwqlfVr1/h40VtCg/+D
         /IkG1Rz2Q7+ZA9cF7S5rPdGBGI/BVQahtLNowRp3tcmQCL9qQOYAz9tVNo84iu0vNnJi
         UHzanHWfBP9gtaPmKoEPjme7ugdnKaYFDK+dRa5/z3EdsNOqBnVJ4g7OIN+NrKhgEyK6
         Fy/KNCknkZ324tGH38iVQ/l+q4Yr8YdM0O8C/p+jD+O0IC1BGHHJ0mNh0e3MDe9vDig7
         AmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698814200; x=1699419000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhQrGrRiXOP6T/LjlMKW+7pqde7WtEKCtrVNN6uAKIY=;
        b=w6DPqJT++aebVcP+EKCo4vWohiKUkPkM5eVNqGw96jF2G6GolxwtSnLILp0h1lKiq1
         QShoao0/DOiHZyKMMnHoffVP1k7LsU9Kx2epnUg0dqNwUbobm8YuLU8qOLFzJdqcN2z4
         JNP+W6sUzcuhvC+RXq5hB2w+ReBTumsp1Ca4aPA8vCED/UzBe0qSktb2oF7RshhCbYKm
         iH6k6yc1B4tAFOn2qg/9dE6kle72Gv8TL8z6xZHsQS4yxJ+YRhQyHzPsffL0BWQRLiBQ
         cnsILAox4byx+TZw/q6lfsPhVWQTlq0VdHhjmT6E3Ijv7Du54vYWslbRxcicAZQEhO4J
         Nx/A==
X-Gm-Message-State: AOJu0Yxvj3MJ6uZIJwrCMA7PMuMWGun0efnCz9X5HsWq6Dp+S0xXaEpq
	zOkGf/mwqdAMlJz5P/cLdSsiSRkgnmb+r3KzUl8T5w==
X-Google-Smtp-Source: AGHT+IHxAeRmRNwusd8SDjsAoXM6juVtUd+PfRg+3YUq/OHZ9FhyQX9RugH2kSnb5B3Bir6sLB+JT2x3UIjYR1Fpsdk=
X-Received: by 2002:a50:c04f:0:b0:542:d737:dc7e with SMTP id
 u15-20020a50c04f000000b00542d737dc7emr258881edd.0.1698814199560; Tue, 31 Oct
 2023 21:49:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
In-Reply-To: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 1 Nov 2023 05:49:45 +0100
Message-ID: <CANn89i+YpJ+y23f=b0uByVJCqh1Rjau44vP-saRD60kFG7J4fw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Fix -Wc23-extensions in tcp_options_write()
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com, 
	0x7f454c46@gmail.com, fruggeri@arista.com, noureddine@arista.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 9:23=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
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


Reviewed-by: Eric Dumazet <edumazet@google.com>
