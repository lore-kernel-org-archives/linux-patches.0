Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946334;
	b=kodG3u9mRS7uyAf7uLSLWryby7Lroy4eQwb40m9tgnwtFhDyMjth6dIAoG95SphWmVgG
	 frc/xZ+lDrrr/hh+ECJ87NtGIQ7mfd63L8G/usDvVaW74M3F8ZPaQ9KNqXHckrxzNQ9Z0
	 6YaLQ21lH3o0tuwWokgbcpcSs75zCydyduICV01wPMZVn5fAr/gkjAMlqucY0ZmGB8oBN
	 v5lg/Q4c+ik+T9sZJP6jkpm5C2clWfUJLVP3xe6PgZUwxYPmLZf7mcf1y5Sm2bMUMEazk
	 cS8/BasjoIypQFIoUKsJ3YS7i6YRg1d/VENW0ZRkQIF44w8T+Kt/BlhWJK1LACtzUxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946334;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=yh6Y7BZ84cxtCnoU0AticnfysmrdXRcXWUIexGoTN0g=;
	b=xXu3cvyDEUQNhdSZFp/4M21nnDtRxWPBFpqp6LvBTsSO42iBZOTqTQY1gNzHu78ZVagx
	 A4vZyndQc0InLAZlUs2HIfILes8uv8JV86sCnhr7tOSGvpJPjBcsoWIB6spRksASy3iGN
	 q2YxH2U5bpZwSwriJ9ieljowjRavP9nCIwQ0U1NAPm4qHlBd/G8sCYyPZFsyanuNu4Vpg
	 p36HoyN5cphFlb2ZqsrogGvERDZd4VWyt3K32ZrPtaCTyB79vNSC4b+DjUr6X/KNAuXeW
	 CVVD+lrQ4BNuAGGnLYCWZsZDF/bGByzsfDCTPEOJoJKHq16VCPmqxVQtxWtNblELjXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABeSUjkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93379606A332
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABeSUjkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABD91F008A3
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 06:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793946333;
	bh=yh6Y7BZ84cxtCnoU0AticnfysmrdXRcXWUIexGoTN0g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ABeSUjkdomXJlRp7OLxtnwqoEbxd50k36saBTReHLXk7wNcTEpjheYev6c2DOl3Ev
	 u9XcUHi7pI8nT27gWz2PDVbFZG++fI7ee19hFVeuDfSIYDrFvz3nIakk1SQouYl7I+
	 UQRweX56pYHUxt42PYDhwjnQYjQ9EEe+UsqZ2iivjdQu4FAE7T9DP5zFFpQ+QAK3jG
	 HCJahhsOQ+rX6IaVNGvrorCWVyeghlCjarVR9xMQ3+V4xx64d9ixsOjY+K5vc+DYph
	 7J5b/7xWjmGMe5O5BkaSZHoymzH47Pn4jPpjKbDZwrexlDzzwIt5M7bubVsIwwXgkz
	 ajlXJqe/a6lxw==
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-49318428d98so45840f8f.1
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 22:25:33 -0800 (PST)
X-Gm-Message-State: APuU4Z+IF2gy1KlG/c9fio/8osfcqtLYbCB/B+53RvNzdN9zXtV4+jMa
	HuBY9eH8FsyoIR5TtL1hkz3z0LIWRU8RrlXrg6579yJSXgTbbTGIMbhdwkmLPZsRkmI2vl3477i
	H/F5gmb1YXXGGlnXGMKRgYO9CHqBzq2U=
X-Received: by 2002:a05:600c:1c23:b0:4af:c210:5b3f with SMTP id
 5b1f17b1804b1-4b6df3fd28amr22873545e9.24.1793946331804; Thu, 05 Nov 2026
 22:25:31 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029202624.2685097-1-rdunlap@infradead.org> <20261029202624.2685097-4-rdunlap@infradead.org>
In-Reply-To: <20261029202624.2685097-4-rdunlap@infradead.org>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 6 Nov 2026 14:25:19 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQwaH15YmgDtKg9uXcnAMmt3=Z3Scperjh=4+PerR-kew@mail.gmail.com>
X-Gm-Features: AclHuK8cgp4i24_xILUa4Qvec3rGOwQhNh1y33xNaaVBpsFMlgn5g6m_fQeuDvk
Message-ID: <CAJF2gTQwaH15YmgDtKg9uXcnAMmt3=Z3Scperjh=4+PerR-kew@mail.gmail.com>
Subject: Re: [PATCH 3/4] csky: kernel/process: add missing prototype
To: Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 4:26=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
>
> Include <linux/cpu.h> to provide a function prototype that was missing:
>
> arch/csky/kernel/process.c:90:6: warning: no previous prototype for 'arch=
_cpu_idle' [-Wmissing-prototypes]
>    90 | void arch_cpu_idle(void)
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Guo Ren <guoren@kernel.org>
> Cc: linux-csky@vger.kernel.org
>
>  arch/csky/kernel/process.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linext-2026-1007.orig/arch/csky/kernel/process.c
> +++ linext-2026-1007/arch/csky/kernel/process.c
> @@ -5,6 +5,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/sched/debug.h>
> +#include <linux/cpu.h>
>  #include <linux/delay.h>
>  #include <linux/kallsyms.h>
>  #include <linux/uaccess.h>
Thanks, I will queue this patch.


--=20
Best Regards
 Guo Ren
