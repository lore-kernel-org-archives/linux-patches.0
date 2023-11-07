Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3174AA20
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 03:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YPySdm6d"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4078fe6a063so24005e9.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 19:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699328663; x=1699933463; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DP2Iv5ELrzaYeydQncBJF2e6SJXKbOLGVt01FUaqFHY=;
        b=YPySdm6dAur3ftXGh+hAhMe6Ai5VmzPMWB/y+NH6elFFCUSRdNY6ebQ/YmI0hg6KgM
         jf0RVePXw299PMOQ1JsIfXG90YP9TeLc/6hFfF4Ju1Z/7BAMzDxy6szMF4wsE1yOw1nw
         uVwsSNyahZLZyMqz8sQPfv0R6Fdn/MJOgZl9Xw+N/drZ0rJNgx95j71DZsG9sfdr/YZJ
         yk4+6RzwWBgcvKdLChmXvUFe9/Zc1Qda6mb+oL3NLESHSeYA7lE7+Yp7HOLdx2K/HeDb
         uwhj03trX84fly87pMTIkDQoFwbQoz4GgeIrTYcFvGpCzA34AF2ovCSypbjGA52g4coH
         GbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699328663; x=1699933463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DP2Iv5ELrzaYeydQncBJF2e6SJXKbOLGVt01FUaqFHY=;
        b=QgIQa6KNN7tXv7/kn3CR3Tb24PTfVCAJHUwHrr4B9oKXZzNsi9qbY2LRlBKNP3HK4P
         LZTcRvrX1eSnVxh7AUntJJNRAsz2DLkCY7zOi3tinldleBS3p19YblGlICoVNhyuIn4v
         nIsZv97OqlehBduCp+C4a96O/+IBz27K5IOS7y3Wr9813xmmcfnce+a0ouqTXNv4OUdN
         MkBebR6mMoksYuBs+mTNoTBWXX2z6JT0zP6kZdaGNtUUGN/yVgtbtz2GCjpc89ahFOkQ
         lA8QUAujGJtHCOWQR+5xN+EagsfKUkwM+EnZB+eCx3u2N9Wk+FaXYrwoWmbVeNHEl8h1
         Hn2Q==
X-Gm-Message-State: AOJu0YyXfdN1LjP2eye46o4sjTNm3frMoMupNr/XXcMz9Mx60GVj0jsZ
	EMJeXW+EZKAsH/7Ux012tXuym8cjjRsqi+y/jBcNHw==
X-Google-Smtp-Source: AGHT+IGr1YusOCrM9bnppsDzO/xFTrsGhIsHdn6pdF3Q6lPJRBaX4KJY4IqfIL0/XIRV040XF8zD5jzk0UPeSFTaFPU=
X-Received: by 2002:a05:600c:1ca7:b0:404:74f8:f47c with SMTP id
 k39-20020a05600c1ca700b0040474f8f47cmr3856wms.5.1699328663197; Mon, 06 Nov
 2023 19:44:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v3-1-b54a64602a85@kernel.org>
In-Reply-To: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v3-1-b54a64602a85@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 7 Nov 2023 04:44:12 +0100
Message-ID: <CANn89iKzVACROr7gzR2H3HPEQfVjctiXyiUswc-zyvN-06p3=Q@mail.gmail.com>
Subject: Re: [PATCH net v3] tcp: Fix -Wc23-extensions in tcp_options_write()
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com, 
	0x7f454c46@gmail.com, noureddine@arista.com, hch@infradead.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 10:14=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
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
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1953
> Fixes: 1e03d32bea8e ("net/tcp: Add TCP-AO sign to outgoing packets")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v3:
> - Don't use a pointer to a pointer for ptr parameter to avoid the extra
>   indirection in process_tcp_ao_options(), just return the modified ptr
>   value back to the caller (Eric)

SGTM thanks.
Reviewed-by: Eric Dumazet <edumazet@google.com>
