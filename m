Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946300;
	b=dYUB365j16kQ2fSXB15S2jvKWHy9EK2xCYLT6pEXXREwUeJrRx13lxd15m5CILz1V8l6
	 p42ZymkG7evmvLx9ch69v8hazTq3a5ec0LiukVz61a9edAbSSn7om/BLgo+VtFKjlqZ7Z
	 nW+OvsQl1ap27c096s6wrA+epHvaxT/BnHnFwxJYPsVZ6DjNHdHKBBIIlgyETjisTNZnD
	 E3EfsZjU9mouBIDmT6uCCSnR64c9cgAzCDpZyY/6HRTgvJR57/ULzxLmcY0T33swbkuIH
	 OR/Kf1GuvWMd/FElOz23hDKogdvAeJoeyhj9v5L1HQHTo4uuMuFBevNWdMpUAqmnhkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946300;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=5enhWdhIl/MgTPhFKTcfC8/saw2N4Zy++fA3QwojwsE=;
	b=nSulGfGWFOF95X9elCL7OS3XHcQETNA5bkD4aoKciC4Wpk5ipPptWeSgX/5+ZSQb+Le+
	 cN6HVaYdixvqWzpG8a9tgTyvjBRyowsLFQ6E719PT9dwg/e0x2zaLwI3kScrxH5nSNy2u
	 kY2pO+0qbL2PDu/imxVrU6fuMXVpa0+TjTdwDJ6vyXyIuKp3mgTToDxWJinLoCljU+WEF
	 mDFtFq/h43MpC6X29qTDXmw4nt/ToQhLv0CLcIUkwKj83yC3Ff9l1u12mMQ9IkCHTJ1Ev
	 yfT5Gec0UOI6KbeFDbSj6QuH2ZddNuq9dSJNPU42rzqIxtbzF3FvpaTvdLyoOjZu5KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BePDgzGu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7378606A329
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BePDgzGu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F2B1F0089F
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793946299;
	bh=5enhWdhIl/MgTPhFKTcfC8/saw2N4Zy++fA3QwojwsE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BePDgzGuUht9kJ8Wj5OzX0+Nke0USjqiu+KTZPt9h8N+oXzBWiyPD2SbBOVyizgTr
	 BmbFvT0Oi6hdsv9DKI3i95FoIudtBrP+3evVnaSaZeu51AU+VgSnYYskH8vfxIjM0s
	 VLPvpmgptdBwW+kQbkJ/ck92TFlHLb3J5sDTvdDppwApjH8QOfPzsZFVO2uNs06Jhv
	 zeZ7Gi1nr/MbNLkgUCihb+SyHlAEaKaVc3VjjSqqU0Wi0rBdRA9tId2VC65l9Oyioi
	 zY3JXYlqIySA1GBvtAxXmpKDSdiDj7m8GQjKCLOHtYLs5TY5vCfRqHaPRDCq/IVxz0
	 DFn1JZrKlEcUQ==
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso87809f8f.1
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 22:24:59 -0800 (PST)
X-Gm-Message-State: APuU4Z9e7V1sRZ99RlaU1DPlBt3l8FRvsPtRXPmzeeB1phfqCAqizEX9
	/c05G7dP153wfdFaU2tgeDhJWbieR2KyroqwGNgiGeAxfbG4HKya3PLAAhwfuwi4YJBDjss4AIz
	xetqovAc1CUyUY4uTHxQTD5PYxUw37zU=
X-Received: by 2002:a05:6000:4a06:b0:48d:f034:7fcd with SMTP id
 ffacd0b85a97d-49278a136fbmr3201746f8f.51.1793946298013; Thu, 05 Nov 2026
 22:24:58 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029202624.2685097-1-rdunlap@infradead.org> <20261029202624.2685097-5-rdunlap@infradead.org>
In-Reply-To: <20261029202624.2685097-5-rdunlap@infradead.org>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 6 Nov 2026 14:24:45 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQ_OP9mDS-cR+hyGfKPWG8fm4=sNFD8Tqx563YusNE7mQ@mail.gmail.com>
X-Gm-Features: AclHuK-pqlKlsbGKcVWXGwPpboaBVUs7kbsV02O8Yfve_qJtRr0DTGLvw3Nd9fM
Message-ID: <CAJF2gTQ_OP9mDS-cR+hyGfKPWG8fm4=sNFD8Tqx563YusNE7mQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] csky: mm/tcm: add missing prototypes
To: Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 4:26=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
> Include <asm/tcm.h> to provide function prototypes that were missing:
>
> arch/csky/mm/tcm.c:109:7: warning: no previous prototype for 'tcm_alloc' =
[-Wmissing-prototypes]
>   109 | void *tcm_alloc(size_t len)
> arch/csky/mm/tcm.c:124:6: warning: no previous prototype for 'tcm_free' [=
-Wmissing-prototypes]
>   124 | void tcm_free(void *addr, size_t len)
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Guo Ren <guoren@kernel.org>
> Cc: linux-csky@vger.kernel.org
>
>  arch/csky/mm/tcm.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linext-2026-1007.orig/arch/csky/mm/tcm.c
> +++ linext-2026-1007/arch/csky/mm/tcm.c
> @@ -2,6 +2,7 @@
>
>  #include <linux/highmem.h>
>  #include <linux/genalloc.h>
> +#include <asm/tcm.h>
>  #include <asm/tlbflush.h>
>  #include <asm/fixmap.h>
>
Thanks, I will queue this patch.

--=20
Best Regards
 Guo Ren
