Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0067A28E10
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Aw4cb7ze"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so14880a12.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 07:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699285986; x=1699890786; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6syFkOkzLnfb93pqUdkybgBOtg/N3wCP/cuWLdw+Zf4=;
        b=Aw4cb7zey8Mk7JYBqoGNHzaw8lb8neKK38c1JdMw2oiZHm784Id6P/A6UFa8Kp/OQy
         KtocOGfE5b2WRKCC0AwrGb0R9giw65xisW1TVyCY0V06FrTBymzGDdL7G04/gewPlbc/
         RJVeSD0g7G5F3CJwVp+Slr2Y4Ay6VrT7eRxg/OWz3i6Uz3OixVXIKAyKO6yZxyTm9ssF
         94FUtLIaJbXDilHt/JfZfUdLe1pq3yNUlowAUshoqbOUDBEu3Y9BcWFK+xwaWLLMMFMb
         GLrKhI/OSVgCg2rc5Yse1BO5yCF70tp/9nOL92M6Kr8ZbVkooI5alTjTmR5D5TXPm71/
         k8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699285986; x=1699890786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6syFkOkzLnfb93pqUdkybgBOtg/N3wCP/cuWLdw+Zf4=;
        b=kWb7RIr5g7QM8s42/pgswqNSOwNPLggsNaMkwosgPQo8jU7RdOT9LQOznzrckfccPF
         ND17zzcRL4B83Z8KsGWkErjvjlgFMcLoM71wbUNzXIqMU4xnv3NcnxrdMqE7Xtx5C9y6
         jdw4f4Jx+ZcfmYnFFgVSo5nvWOd6qda123L3/4LN7xnrZC8W9eXXqbTaIWBQ/k9ghOGX
         C14RmY0FjXSGPt+YMNW43EgLAzYYaCxRsF199yS+1F8ph7zoBulGqos7BlO5KT97K5tY
         BUHi17Kk8slXHp6YOnS0Wm/fylhMN5HLe6uuNqjW3fxDLFstG/xwV9jxggvM75cj0VyR
         slYQ==
X-Gm-Message-State: AOJu0Yw/plwM423z7b7N05Y+XGO5ry3OFouDHFY+cnzEdNrIBnyW8/sr
	apUXBtscmC7jMLXbZVrPiL9PvP6+aMhrMaBFn3/mZg==
X-Google-Smtp-Source: AGHT+IEpYdcYOXsn5hs+ijdf301SEE6NJW2pTTs2hdWOXzeGxp8BhkVC5mqmhfLbIBT4urwWKe2HlDI01ut3Z0gY5g0=
X-Received: by 2002:a05:6402:f0d:b0:544:4762:608 with SMTP id
 i13-20020a0564020f0d00b0054447620608mr211814eda.2.1699285985971; Mon, 06 Nov
 2023 07:53:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v2-1-91eff6e1648c@kernel.org>
In-Reply-To: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v2-1-91eff6e1648c@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 6 Nov 2023 16:52:52 +0100
Message-ID: <CANn89i+GF=4QuVMevE7Ur2Zi0nDjBujMHWJayURR9fbcr+McnA@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: Fix -Wc23-extensions in tcp_options_write()
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com, 
	0x7f454c46@gmail.com, noureddine@arista.com, hch@infradead.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 4:36=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
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
> While adding a semicolon after the label would resolve this, it is more
> in line with the kernel as a whole to refactor this block into a
> standalone function, which means the goto a label construct can just be
> replaced with a simple return. Do so to resolve the warning.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1953
> Fixes: 1e03d32bea8e ("net/tcp: Add TCP-AO sign to outgoing packets")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Please let me know if this function should have a different name. I
> think I got all the changes of the function shuffle correct but some
> testing would be appreciated.
>
> Changes in v2:
> - Break out problematic block into its own function so that goto can be
>   replaced with a simple return, instead of the simple semicolon
>   approach of v1 (Christoph)
> - Link to v1: https://lore.kernel.org/r/20231031-tcp-ao-fix-label-in-comp=
ound-statement-warning-v1-1-c9731d115f17@kernel.org
> ---
>  net/ipv4/tcp_output.c | 69 ++++++++++++++++++++++++++++-----------------=
------
>  1 file changed, 38 insertions(+), 31 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 0d8dd5b7e2e5..3f8dc74fbf40 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -601,6 +601,43 @@ static void bpf_skops_write_hdr_opt(struct sock *sk,=
 struct sk_buff *skb,
>  }
>  #endif
>
> +static void process_tcp_ao_options(struct tcp_sock *tp,
> +                                  const struct tcp_request_sock *tcprsk,
> +                                  struct tcp_out_options *opts,
> +                                  struct tcp_out_options *opts,

ptr has a different type than in the caller, this is a bit confusing

I would use

static __be32 * process_tcp_ao_options(struct tcp_sock *tp, const
struct tcp_request_sock *tcprsk,
                  struct tcp_out_options *opts,struct tcp_key *key, __be32 =
*ptr)

> +{
> +#ifdef CONFIG_TCP_AO
> +       u8 maclen =3D tcp_ao_maclen(key->ao_key);
> +
> +       if (tcprsk) {
> +               u8 aolen =3D maclen + sizeof(struct tcp_ao_hdr);
> +
> +               *(*ptr)++ =3D htonl((TCPOPT_AO << 24) | (aolen << 16) |
> +                                 (tcprsk->ao_keyid << 8) |
> +                                 (tcprsk->ao_rcv_next));


                 *ptr++ =3D ...

(and in all other *ptr uses in this helper)

> +       } else {
> +               struct tcp_ao_key *rnext_key;
> +               struct tcp_ao_info *ao_info;
> +
> +               ao_info =3D rcu_dereference_check(tp->ao_info,
> +                       lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk)=
);
> +               rnext_key =3D READ_ONCE(ao_info->rnext_key);
> +               if (WARN_ON_ONCE(!rnext_key))
> +                       return;
> +               *(*ptr)++ =3D htonl((TCPOPT_AO << 24) |
> +                                 (tcp_ao_len(key->ao_key) << 16) |
> +                                 (key->ao_key->sndid << 8) |
> +                                 (rnext_key->rcvid));
> +       }
> +       opts->hash_location =3D (__u8 *)(*ptr);
> +       *ptr +=3D maclen / sizeof(**ptr);
> +       if (unlikely(maclen % sizeof(**ptr))) {
> +               memset(*ptr, TCPOPT_NOP, sizeof(**ptr));
> +               (*ptr)++;
> +       }
> +#endif

    return ptr;
+}
> +
>  /* Write previously computed TCP options to the packet.
>   *
>   * Beware: Something in the Internet is very sensitive to the ordering o=
f
> @@ -629,37 +666,7 @@ static void tcp_options_write(struct tcphdr *th, str=
uct tcp_sock *tp,
>                 opts->hash_location =3D (__u8 *)ptr;
>                 ptr +=3D 4;
>         } else if (tcp_key_is_ao(key)) {
> -#ifdef CONFIG_TCP_AO
> -               u8 maclen =3D tcp_ao_maclen(key->ao_key);
> -
> -               if (tcprsk) {
> -                       u8 aolen =3D maclen + sizeof(struct tcp_ao_hdr);
> -
> -                       *ptr++ =3D htonl((TCPOPT_AO << 24) | (aolen << 16=
) |
> -                                      (tcprsk->ao_keyid << 8) |
> -                                      (tcprsk->ao_rcv_next));
> -               } else {
> -                       struct tcp_ao_key *rnext_key;
> -                       struct tcp_ao_info *ao_info;
> -
> -                       ao_info =3D rcu_dereference_check(tp->ao_info,
> -                               lockdep_sock_is_held(&tp->inet_conn.icsk_=
inet.sk));
> -                       rnext_key =3D READ_ONCE(ao_info->rnext_key);
> -                       if (WARN_ON_ONCE(!rnext_key))
> -                               goto out_ao;
> -                       *ptr++ =3D htonl((TCPOPT_AO << 24) |
> -                                      (tcp_ao_len(key->ao_key) << 16) |
> -                                      (key->ao_key->sndid << 8) |
> -                                      (rnext_key->rcvid));
> -               }
> -               opts->hash_location =3D (__u8 *)ptr;
> -               ptr +=3D maclen / sizeof(*ptr);
> -               if (unlikely(maclen % sizeof(*ptr))) {
> -                       memset(ptr, TCPOPT_NOP, sizeof(*ptr));
> -                       ptr++;
> -               }
> -out_ao:
> -#endif
> +               process_tcp_ao_options(tp, tcprsk, opts, key, &ptr);

ptr =3D process_tcp_ao_options(tp, tcprsk, opts, key, ptr);


>         }
>         if (unlikely(opts->mss)) {
>                 *ptr++ =3D htonl((TCPOPT_MSS << 24) |
>
> ---
> base-commit: c1ed833e0b3b7b9edc82b97b73b2a8a10ceab241
> change-id: 20231031-tcp-ao-fix-label-in-compound-statement-warning-ebd6c9=
978498
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
