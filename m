Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946353;
	b=IME3/9MMHHOJVcfVmCQT6k2zZuPjzXaq6TMkrIWnVSQK+ARLjwbX4885EhVkaaZu/WKR
	 n79sgH3u/hVOA8Tu7lts+tiJYJoamRH3cOt5PgXF8f4OsFLxzdAcufbMfdAo8QjLqg+JC
	 +3KxynupErmTl265eYrPxZVaePvhRy6BTyFjgfxfZYaD9ONyY2Pok9C4QXwz8XtEhN643
	 Q6erk/xFph5A2v+bpJF2hD4cmn1HkoFxlBqumvSyBic2HrO2Tz+m0Gh/usJqj11/MIybY
	 +77dSXZ5v4LtbR5Ud23jd96fP/1GFVHTjoId7+aYY62ODmWXLLz7+jVxyr9QrDmkp8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946353;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=LoE/Xr8/izYD4/vvIzcFkhBICKzSnsZ7xx4rOPMErw8=;
	b=P2XYoNfopDSshkmX2wMXtuX4LbP/N2DYrTIMCALB5csafeu2NbRUFzsZTm0O+a3yClPR
	 na9L4q+Zc7Hr5sde2vUCR8iNmBCJFY2tq+3+Syk8L7iMgbRCFazmMBxxDU8sKhn/21OW8
	 r1KksggSVzeCQwaik6i+zJGuokPTjSdOteCyYkmt3x5T5XTfNAixsHVoUnLi9Fyi9UFZj
	 i4F+Rpd+jIJNuo/gphlrUrf8cB/yJF1rnAJu1w7Mkvao9ghMWvXr/UR4UihlrqCYVmhtF
	 pdM7CCshvmbpBNDKuibfwuQbV6wHiahk+cgzcfYDuIjx+gXaLbrcH0vcc5/nxaWjQEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cg84/qym";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38594606A32E
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cg84/qym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D7E1F008A7
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793946352;
	bh=LoE/Xr8/izYD4/vvIzcFkhBICKzSnsZ7xx4rOPMErw8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cg84/qyms/HGMkCLk6VHbbwNwI7UZ6H65kuE9y39NUV7MjmH7ymBMtoYvXnTNhQ4K
	 z5tNxKGMgxUV5XlswaeNQ0Tz09USqzhloxCkWBsANpzIG7mkeRFqiscaorPvaGKrZH
	 Jvwpa16WlpA780g0q6sK3tgKQKp7j9r8LW4tt1HQ5JYimmXUhuj2SNI4s5002hpV/r
	 vkDNQcg+SeNnuhs+lv6YR5eO8NJ3BtkAyBNuDezE+E5fTU71hrp9gII3ec7hBJXb9M
	 A95NpvZW/j24kKeWHphTddYltmbEucOE5l7YIPdet+p3n2kJ2Tg7RNkxoCIYN5MXbe
	 Sj2hK2Aosw73g==
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so7641805e9.1
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 22:25:52 -0800 (PST)
X-Gm-Message-State: APuU4Z9K+DFJzZxDrSf21vh5/dpcTE1FFD4dTMrdEkutqcDusFif9nBQ
	MTjt3KdRHjw7gwV8EGMqH3LyK/bUSLXuUA93WyNAdc0ad9qB/oLxcaKXLIbynPyJRl1Zz8qJAqn
	X7ddQ288uGxe8oRx+GuWY+/IXvrCvY80=
X-Received: by 2002:a05:600c:8b05:b0:4a1:efbe:529c with SMTP id
 5b1f17b1804b1-4b6dff855a6mr22203925e9.12.1793946351393; Thu, 05 Nov 2026
 22:25:51 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029202624.2685097-1-rdunlap@infradead.org> <20261029202624.2685097-3-rdunlap@infradead.org>
In-Reply-To: <20261029202624.2685097-3-rdunlap@infradead.org>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 6 Nov 2026 14:25:39 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRvP-SgEXawhWGX0aMWWRj_hKSCB6yuu6S4EdZep4BMzg@mail.gmail.com>
X-Gm-Features: AclHuK_Wj8uxCUf42AnyJ_yvgH6DQt83DCJaGh9EAPURAGDaKFJrE7Z36i3Sp_k
Message-ID: <CAJF2gTRvP-SgEXawhWGX0aMWWRj_hKSCB6yuu6S4EdZep4BMzg@mail.gmail.com>
Subject: Re: [PATCH 2/4] csky: perf_event: add missing prototypes
To: Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 4:26=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
> Add missing perf_event prototypes to prevent build warnings:
>
> arch/csky/kernel/perf_event.c:90:10: warning: no previous prototype for '=
csky_pmu_read_cc' [-Wmissing-prototypes]
>    90 | uint64_t csky_pmu_read_cc(void)
> arch/csky/kernel/perf_event.c:878:6: warning: no previous prototype for '=
csky_pmu_event_set_period' [-Wmissing-prototypes]
>   878 | int  csky_pmu_event_set_period(struct perf_event *event)
> arch/csky/kernel/perf_event.c:1197:5: warning: no previous prototype for =
'init_hw_perf_events' [-Wmissing-prototypes]
>  1197 | int init_hw_perf_events(void)
> arch/csky/kernel/perf_event.c:1292:5: warning: no previous prototype for =
'csky_pmu_device_probe' [-Wmissing-prototypes]
>  1292 | int csky_pmu_device_probe(struct platform_device *pdev,
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Guo Ren <guoren@kernel.org>
> Cc: linux-csky@vger.kernel.org
>
>  arch/csky/include/asm/perf_event.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> --- linext-2026-1007.orig/arch/csky/include/asm/perf_event.h
> +++ linext-2026-1007/arch/csky/include/asm/perf_event.h
> @@ -11,4 +11,14 @@
>         asm volatile("mov %0, sp\n":"=3Dr"((regs)->usp)); \
>  }
>
> +struct perf_event;
> +struct platform_device;
> +struct of_device_id;
> +
> +uint64_t csky_pmu_read_cc(void);
> +int csky_pmu_event_set_period(struct perf_event *event);
> +int init_hw_perf_events(void);
> +int csky_pmu_device_probe(struct platform_device *pdev,
> +                         const struct of_device_id *of_table);
> +
>  #endif /* __ASM_PERF_EVENT_ELF_H */
Thanks, I will queue this patch.


--=20
Best Regards
 Guo Ren
