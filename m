Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA92B3264CD
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 17:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776793338; cv=pass; b=IUcPu1INnvsob2seZROs/GFriNEbcXU+vYVxzULPAOSUU8VLt0GYSg95tRZLBF96wH91zEjwmVoPK5/IAXlIRsxfJUkCr1kx3yfvu7rOlaY2djvKRibeyYB135OWoy+EmWIz/jSqI5ZbWJI5VQcQaCTRIbsWWH/CsVWQryItdZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776793338; c=relaxed/simple;
	bh=Of0/EaLDkC3KJoWqOLa6xLXmX35rzEt5z2ujgm6WNGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NSNP8WaurS8sPJthkhhfDAPwYVsjwwgkMg+htuMq3wxzkv/qgUM9VBtZZ1VDdx9QcppNhgakGvxzoNMh2s5/T1rmZ4M9fAjSWy8jd12wz2XbhV66mltRD2csmPe+DsHW+mdkIN61Dk/0Oruka7vnVvvVq5L77gKpEdND3WZYpcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kXrjemAz; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kXrjemAz"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so362805e9.1
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 10:42:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776793335; cv=none;
        d=google.com; s=arc-20240605;
        b=Eu0N3jirYQFJabUvV8BSd4o/7zBzAqA42+TwaoUVN0XcX+l9brxSHxeb/mtSOIotBW
         Gh1vRjHjSJRjOcrM096Zi3W327spSFsMiVGpq+f5jPEJ6URtNm8c/zRuzAovc5gBCl4v
         YaWD7OIZj3Nztw2IxoD86sfcllQmb4LEJ5HAfzVCL7i88A4Yyk57tgxSNwhS/Rg1CXw0
         pu66UzcwWxUi2/CLuO8D2RU4sgo9zt+WnCMEmvI1WzyJzT3GLu7jlNauOKsrwGtWl3pr
         Mv6rZVekBLxNxnS6pVD1SjtfTHA/O4Irne+tGVmPW8y51T0Ot9cVT5wc8RH1hVqnjKSM
         A2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FVLuZOfQ/wAnql5Ulk19piwsQQJoEI+P/OLaiUP9iIs=;
        fh=RL/JAItVO5MyVGEqHHiw/feyZ65JMP8Thwt1ZM1M6dM=;
        b=VKo6GVkv06fvCoWYE+AYSy8yFqe7oqgD4YkxgKnncKhVRYLMBmTgwTHfuTlScLVLc2
         qLukJXSdlzP3zsk5hKUgF7h77nS23izLyqGmYhc6ayOqu32eorHYEQ8vxxPjwrMie0IQ
         t57wK+1BYXZ0+kaxTU9Clx8J6/JN3E8BKsu+RbIs3wu40RgkLzOIwjEnQV09udUSn8/D
         jNbAsGEmXyJQ+4xqjrBaAhQ0bDqDPknp5vMTOnu4CPATKlMe1EjdNj8TwNjSwyYFk27r
         upzPVzos65bgDm6Xflf8lsvjMl8NfWv0WDwdWF7LkKeYuN7F+uLEKre0vRmstO5cpJla
         5AxQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776793335; x=1777398135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVLuZOfQ/wAnql5Ulk19piwsQQJoEI+P/OLaiUP9iIs=;
        b=kXrjemAzp6B9j/bytLEm1Gj8xRfc2XrL0tYjOZ1nF+ZXAA1BLD0MfsEsCq/f000niL
         EdTamfYkTBMNPA8u/7FBoTaMwI94+GU8tu+pPKhKLjIumYtEVKxOWIC9LJzPRRM2LOXO
         JjJIrZmerfLvHKvBc1rsNeoq6NtHOwmPNyOB0QhOmNYuX6QsZaOmJZttixYferKA9hGw
         3WeDaD6v7H4nDo8BkkgPpo24RNRwW9jxlaMHogbu/7wl+fs1tiKoma2cEMF1iZvgw6hM
         8DUf27u0iDUBVY0jNbZwNslYVoiKs01y4fU8R36bYBjNIpY6YMz+vS0Hj1mEtG5HAj3B
         gMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776793335; x=1777398135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FVLuZOfQ/wAnql5Ulk19piwsQQJoEI+P/OLaiUP9iIs=;
        b=mA++SwBuKLHvW1Xa8x7bz/uccCrSNhgO5iWkWSFen0n534xR5ozHA4+TdQGYthHNMJ
         v9sGBDgQyK11I9ek+LaCliq06Q6sIBp1olJ8M1Q9e5E8qBex37pd+qeeoONYLy2i8N8M
         deITc3LadwfEtR1DNoQxciqrLLbiz9YH3nvUg1RzniBEZGnQEMidkIGpW93LFskq/sF6
         C2/yHmDx8nOeL7TSddaGlf+XzL9XeDeh0ONYfftRVRQonYm6ptikCtbBNzS4qJT1N75h
         sAqHMXEZysAj/6zdmkyh7uehVUdTx8wTdOAq3Dt15tPZmB5/e09PJREaElDps551+JH0
         gkgg==
X-Forwarded-Encrypted: i=1; AFNElJ+P9GSZHFsMhBLDSk3cpu5R5Zkf7/L/yEU5jN15UsmVoePYKNmg/elK7RY22fE7vLDdt+c+9fiD@lists.linux.dev
X-Gm-Message-State: AOJu0YzeeriDMZzJrcGyDX3dZMjSaVSAaPB7iliSnpimrDaBo0+o+lBC
	QT6HJESVoNTbGPgdE1i5qrXQEkXVI3krNz+8269l2XoQS7QAcBdwIn5spOvbNqZlaOObpK2bu/l
	DMO1G83o6ppXXGe04s0efUNC7wPXt08uYaukCGzjL
X-Gm-Gg: AeBDieuaABiaZDcpaz/O71/TcPpbROXEKyNoIs8CqO2G+UnMOrXgDysrH6brIj7aLTb
	Lfm+tDKojdowMw/9ioPsXTFu1VVjH1fYX8zXiomc2tzlIjSXfMBivu2PQFcWO29Lbr0xJsfcvjp
	NXXu9BN0Ad21ph4JSZZvvqEhZrAdXWGyPi2hVByn4LIlbwoWONvhgaD0Bew5tsQxvJDUT7uJuox
	aimPHB9GLQs+8eBc0ZsyC366IT5INvVl3F8yVEUwXp8Td+ZJDZaKbU88zkywHUjGRYMqE4O/EVT
	lQAdDjpSZddk/gdkjRGXyRdecoJFTkQ0MQIogeTQqdvpt6N64AlmD0BI/Ao=
X-Received: by 2002:a05:600c:1992:b0:485:1a54:9407 with SMTP id
 5b1f17b1804b1-4890090506fmr4929315e9.0.1776793334852; Tue, 21 Apr 2026
 10:42:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260421150216.11666-1-tony.luck@intel.com> <20260421150216.11666-3-tony.luck@intel.com>
In-Reply-To: <20260421150216.11666-3-tony.luck@intel.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 21 Apr 2026 10:42:03 -0700
X-Gm-Features: AQROBzBZMQqdOr7KbeHRPze1igkhothHr2ycHmyOAVwdZrAjsgR6OGfZhruDgUM
Message-ID: <CACw3F50yER64HyCiPW_oRH_WaZgT1knvi0_qk_mdr1Y-vxmGEg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ACPI: APEI: EINJ: Fix EINJV2 memory error injection
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Herman Li <herman.li@intel.com>, 
	"Lai, Yi1" <yi1.lai@intel.com>, Zaid Alali <zaidal@os.amperecomputing.com>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 8:02=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> Error types in EINJV2 use different bit positions for each flavor of
> injection from legacy EINJ.
>
> Two issues:
>
> 1) The address sanity checks in einj_error_inject() were skipped for EINJ=
V2
>    injections. Noted by sashiko[1]
> 2) __einj_error_trigger() failed to drop the entry of the target
>    physical address from the list of resources that need to be
>    requested.
>
> Add a helper function that checks if an injection is to memory and use it
> to solve each of these issues.
>
> Note that the old test in __einj_error_trigger() checked that param2 was
> not zero. This isn't needed because the sanity checks in einj_error_injec=
t()
> reject memory injections with param2 =3D=3D 0.
>
> Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
> #Reported-by: sashiko <sashiko@sashiko.dev>
> Reported-by: Herman Li <herman.li@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Tested-by: "Lai, Yi1" <yi1.lai@intel.com>
> Link: https://sashiko.dev/#/patchset/20260415163620.12957-1-tony.luck%40i=
ntel.com # [1]
> ---
>  drivers/acpi/apei/einj-core.c | 45 +++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.=
c
> index a9248af078f6..1f3fa2278584 100644
> --- a/drivers/acpi/apei/einj-core.c
> +++ b/drivers/acpi/apei/einj-core.c
> @@ -401,8 +401,18 @@ static struct acpi_generic_address *einj_get_trigger=
_parameter_region(
>
>         return NULL;
>  }
> +
> +static bool is_memory_injection(u32 type, u32 flags)
> +{
> +       if (flags & SETWA_FLAGS_EINJV2)
> +               return !!(type & ACPI_EINJV2_MEMORY);
> +       if (type & ACPI5_VENDOR_BIT)
> +               return !!(vendor_flags & SETWA_FLAGS_MEM);
> +       return !!(type & MEM_ERROR_MASK) || !!(flags & SETWA_FLAGS_MEM);
> +}
> +
>  /* Execute instructions in trigger error action table */
> -static int __einj_error_trigger(u64 trigger_paddr, u32 type,
> +static int __einj_error_trigger(u64 trigger_paddr, u32 type, u32 flags,
>                                 u64 param1, u64 param2)
>  {
>         struct acpi_einj_trigger trigger_tab;
> @@ -480,7 +490,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u3=
2 type,
>          * This will cause resource conflict with regular memory.  So
>          * remove it from trigger table resources.
>          */
> -       if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && para=
m2) {
> +       if ((param_extension || acpi5) && is_memory_injection(type, flags=
)) {
>                 struct apei_resources addr_resources;
>
>                 apei_resources_init(&addr_resources);
> @@ -660,7 +670,7 @@ static int __einj_error_inject(u32 type, u32 flags, u=
64 param1, u64 param2,
>                 return rc;
>         trigger_paddr =3D apei_exec_ctx_get_output(&ctx);
>         if (notrigger =3D=3D 0) {
> -               rc =3D __einj_error_trigger(trigger_paddr, type, param1, =
param2);
> +               rc =3D __einj_error_trigger(trigger_paddr, type, flags, p=
aram1, param2);
>                 if (rc)
>                         return rc;
>         }
> @@ -718,35 +728,30 @@ int einj_error_inject(u32 type, u32 flags, u64 para=
m1, u64 param2, u64 param3,
>                       SETWA_FLAGS_PCIE_SBDF | SETWA_FLAGS_EINJV2)))
>                 return -EINVAL;
>
> +       /*
> +        * Injections targeting a CXL 1.0/1.1 port have to be injected
> +        * via the einj_cxl_rch_error_inject() path as that does the prop=
er
> +        * validation of the given RCRB base (MMIO) address.
> +        */
> +       if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
> +               return -EINVAL;
> +
>         /* check if type is a valid EINJv2 error type */
>         if (is_v2) {
>                 if (!(type & available_error_type_v2))
>                         return -EINVAL;
>         }
> -       /*
> -        * We need extra sanity checks for memory errors.
> -        * Other types leap directly to injection.
> -        */
>
>         /* ensure param1/param2 existed */
>         if (!(param_extension || acpi5))
>                 goto inject;
>
> -       /* ensure injection is memory related */
> -       if (type & ACPI5_VENDOR_BIT) {
> -               if (vendor_flags !=3D SETWA_FLAGS_MEM)
> -                       goto inject;
> -       } else if (!(type & MEM_ERROR_MASK) && !(flags & SETWA_FLAGS_MEM)=
) {
> -               goto inject;
> -       }
> -
>         /*
> -        * Injections targeting a CXL 1.0/1.1 port have to be injected
> -        * via the einj_cxl_rch_error_inject() path as that does the prop=
er
> -        * validation of the given RCRB base (MMIO) address.
> +        * We need extra sanity checks for memory errors.
> +        * Other types leap directly to injection.
>          */
> -       if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
> -               return -EINVAL;
> +       if (!is_memory_injection(type, flags))
> +               goto inject;
>
>         /*
>          * Disallow crazy address masks that give BIOS leeway to pick
> --
> 2.53.0
>

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
