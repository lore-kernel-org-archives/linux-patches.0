Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946320;
	b=0Gk2Mst+KCtEORB2bj12a348bKOs71JLlhGMJe3aVjJgI5WVpMs5LHyDPIsilRentn0T
	 c/nLACqrC+esRJiUMWnDAC60DxsuGG7F02yXrhd3j5Hp0uJ7R91OdL3fr7h951aqTgsCk
	 TKhdiEfjanYr4ZMqc91r4aX4lO1YpiettTmSvGNMbZikGW/h0sjFbTAmC4+BYPUy9rBjs
	 DRE4vWXa4snBV7lCvzFe9xA12G7DTytTlIA7rp3BCnAVfp7Cp6AAtvk5Lovhj+RL+/VjI
	 2ydqrtixwa1XDmVnqYsVGvOq7ChBqQLaMize6BCqgBxEC7Ex/aDznKFOCho09LQMuFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946320;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=RZr7vf5fgFHKXNA7mJ6w2EfU1zLqlhlVzr0/jpqQKrY=;
	b=lXn61MnvPF0ujTBTUZNDH69uloPd96XhKDeK7O6QDMUtQiZWje7NsOCoBbbCWFJD+++N
	 bjD8WOrMtavd16IFw4qIh1W8HzqG7c6PcB0LSFmdCu078LIIFPxC5sVozSlYrEVuBI6Gh
	 fin5VBEn1eF26riKo+1mZIL6K3u9/IwWdQVdar00eBsnJ0IE8sXmGEgykOBvBPLHhWnsj
	 YAVY+7LoKXEkxZNL54OQ1nEn5hf9qoAW2S4OqSNcGrzkT5Sninb01Zqe6IFxvflv5Z+Bl
	 PerWMTZSogglnzQ8Zvft5lVrxSNVQLRGY6d7pXMftShp9HFSfRx3+xSxuBsL3tbVo+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HwTKaVbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDBC606A331
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HwTKaVbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0681F008A6
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793946319;
	bh=RZr7vf5fgFHKXNA7mJ6w2EfU1zLqlhlVzr0/jpqQKrY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HwTKaVbwq2lbALOZm1YK0BauOlDSkMv/LapAKU2HTo3n758op7IpWv+5yNPJHKs2V
	 v3J3QwQHMLHnBdzQvzEF4Z3VeajDnlLBc4sVMBtR4gJyFX0buYEvM/ZWPcJZ3OqK8s
	 MnENCYLXUGSdA+c21kKI4PIdEsHYtCOcrvqehMyLEvv74mS7f+WnFX78ARtlVJarML
	 tPYIZOUI75R938Mt/2bkBToWm6EC68a1RmA/RqvEb++bui4/8Ee017wYaGQuXv8tPg
	 WlfnwiO7Cb+n3nJvkg+oZnWgaVb1g6xAPqK3X8LwFNKeP+EB4pl+z61YOcicBscysx
	 FeOhcu9H10s8w==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so1975435e9.2
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 22:25:19 -0800 (PST)
X-Gm-Message-State: APuU4Z8zydWLYA+ZWoaoro1IHys/fhjtoVfqjfvZAWb2Z13ArTM+LTL4
	NFCdkGwY+JhVaNTzlVO/Bombq7fO6AYKl5eekjPm2IuJ0FA/Of0ROmjkxzBYkLzQSvsA8q+EQx6
	JifA5utDETrxswk9BfdL+Zwb/itpnXqk=
X-Received: by 2002:a05:600c:34ca:b0:4a2:8c5:5e5 with SMTP id
 5b1f17b1804b1-4b6dd63fd31mr20904695e9.7.1793946318506; Thu, 05 Nov 2026
 22:25:18 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029202624.2685097-1-rdunlap@infradead.org> <20261029202624.2685097-2-rdunlap@infradead.org>
In-Reply-To: <20261029202624.2685097-2-rdunlap@infradead.org>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 6 Nov 2026 14:25:06 +0800
X-Gmail-Original-Message-ID: <CAJF2gTT7Oy-eHz8Qgwx-V6qT5eTAc1g0URWKEnvydaGcztmd9Q@mail.gmail.com>
X-Gm-Features: AclHuK9rmRbqOnJR6vd1YhaPy3N3OKbaJPk7vBUltpQhWwpu-npAYOxMypOFvGE
Message-ID: <CAJF2gTT7Oy-eHz8Qgwx-V6qT5eTAc1g0URWKEnvydaGcztmd9Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] csky: cachev2: add missing prototype
To: Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 4:26=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
> Add a missing prototype to avoid a build warning:
>
> arch/csky/mm/cachev2.c:46:6: warning: no previous prototype for 'local_ic=
ache_inv_range' [-Wmissing-prototypes]
>    46 | void local_icache_inv_range(void *priv)
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Guo Ren <guoren@kernel.org>
> Cc: linux-csky@vger.kernel.org
>
>  arch/csky/include/asm/cache.h |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linext-2026-1007.orig/arch/csky/include/asm/cache.h
> +++ linext-2026-1007/arch/csky/include/asm/cache.h
> @@ -17,6 +17,7 @@ void dcache_wb_line(unsigned long start)
>  void icache_inv_range(unsigned long start, unsigned long end);
>  void icache_inv_all(void);
>  void local_icache_inv_all(void *priv);
> +void local_icache_inv_range(void *priv);
>
>  void dcache_wb_range(unsigned long start, unsigned long end);
>  void dcache_wbinv_all(void);
Thanks, I will queue this patch.

--=20
Best Regards
 Guo Ren
