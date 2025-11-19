Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A4135E549
	for <patches@lists.linux.dev>; Wed, 19 Nov 2025 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763555709; cv=none; b=S5XdFUNwtCCRlZVHRmcPWufzJ+4LkSq7egaWWVad2jrmQmi6kSeBNUsFh3d7iCKv/l6BTrY71bvGzvqjhpbOsrng8rFVD/ZJuwMeX9For8UQmcF4kjQ8GboHyAEYdmnokhFDAs5r+/L5GHVWyJU+7SR17JdWKIxz8rm6XnvHyXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763555709; c=relaxed/simple;
	bh=j1rlv8XfDgLSGIQBRzeVLRjfYKobf1S6pgoVP38xJ5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P2zIq9/F+JjAW2Hk3bQe/umefG7u3Ik3wmCb6bcKkVwaNSWsh8oOxmQrdIr9yYT4QgFbFuqzaGh1pBHMo6bM1XhhAXLFQt07ecYMI1j8NowFI6FbEz2alLbNuQ4uLwBVsMVFfn0Yvl4nv2O8R8ogmuP6yYr3KVHoci9/n7c5/+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZuY3CwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZuY3CwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542F8C4CEF5
	for <patches@lists.linux.dev>; Wed, 19 Nov 2025 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763555707;
	bh=j1rlv8XfDgLSGIQBRzeVLRjfYKobf1S6pgoVP38xJ5Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HZuY3CwNOEOEH6rrbmvY1AKbe6ZCNV9e7cN3E7leqbp4+uZp8FG5vmySzoSoW0eez
	 HHFlkJSEobbUv73YIs4xENvyr5sIvYA7HPgV4jf0aVYXWncN0EUttRK2wWPBUuBqFO
	 2e3Rd3E1CKBfNJIN/9xO4M8gX7pjQKazZzwCIbC8KEdxoiOeTLLBe86ge7mTlAgmbB
	 4epflCGUWR34B+1ZUajwamrxpOc72+dDiKrhp4Exg5yk4Cbnc9wnFEGu9FmrpWDTw1
	 fHCZy3KK4nxz1iz8ehOflOyqZrW8lbZXTtiA/CmaKdtNQ9OSX7gfCfSOSicnh1uZ9C
	 M2b8Zm/HrkAGg==
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7c7533dbd87so2785151a34.2
        for <patches@lists.linux.dev>; Wed, 19 Nov 2025 04:35:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUXalvzDhrZHrvc/riPTWF8a5Xco78hQ3MmTZx4ZEp67hx6OdlkhGJ012+7hBYSy7+l0y3DWj5R@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3jumTaU5fSH/qO33+aSskWhAh45dib7JqklSH2yno4gjzBa+u
	5CnzIHGCng3IbXt3SVnwAou5DwkK/5yWHMSkRv1KQOqsP7WL7GfJ0jpEdZvOIdpGwGIkD0uYI9v
	a0F0izr8OhPDrLb6MVcZnvbAkLMbw1qc=
X-Google-Smtp-Source: AGHT+IHwQh5tHLbjPd7SeHDteGF0mygwrtLkg8NXmtTJMBVp1WLLQ0Pfu84ieljcC5NrL0bW6iTzsrwaHqG1WmZK9Yc=
X-Received: by 2002:a05:6808:4f63:b0:450:bf48:8352 with SMTP id
 5614622812f47-450bf48860amr5152460b6e.11.1763555705973; Wed, 19 Nov 2025
 04:35:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251119012712.178715-1-tony.luck@intel.com>
In-Reply-To: <20251119012712.178715-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 19 Nov 2025 13:34:53 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0hxsqMFgseYkRvfvGeQ22FQRTniAjP8vwNWYsEfrbkA-g@mail.gmail.com>
X-Gm-Features: AWmQ_blu8v12adL4B9E8PBfVgF66ftMnizrq9Qc0KYEemmxozXEcp5T7oNqaps8
Message-ID: <CAJZ5v0hxsqMFgseYkRvfvGeQ22FQRTniAjP8vwNWYsEfrbkA-g@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: EINJ: Fix EINJV2 initialization and injection
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, bp@alien8.de, guohanjun@huawei.com, lenb@kernel.org, 
	mchehab@kernel.org, xueshuai@linux.alibaba.com, yi1.lai@intel.com, 
	zaidal@os.amperecomputing.com, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 2:27=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> ACPI 6.6 specification for EINJV2 appends an extra structure to
> the end of the existing struct set_error_type_with_address.
>
> Several issues showed up in testing.
>
> 1) Initialization was broken by an earlier fix[1] since is_v2 is only set
>    while performing an injection, not during initialization.
>
> 2) A buggy BIOS provided invalid "revision" and "length" for the extensio=
n
>    structure. Add several sanity checks.
>
> 3) When injecting legacy error types on an EINJV2 capable system don't
>    copy the component arrays.
>
> Fixes: 6c7058514991 ("ACPI: APEI: EINJ: Check if user asked for EINJV2 in=
jection") # [1]
> Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/acpi/apei/einj-core.c | 64 ++++++++++++++++++++++-------------
>  1 file changed, 41 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.=
c
> index 3c87953dbd19..305c240a303f 100644
> --- a/drivers/acpi/apei/einj-core.c
> +++ b/drivers/acpi/apei/einj-core.c
> @@ -182,6 +182,7 @@ bool einj_initialized __ro_after_init;
>
>  static void __iomem *einj_param;
>  static u32 v5param_size;
> +static u32 v66param_size;
>  static bool is_v2;
>
>  static void einj_exec_ctx_init(struct apei_exec_context *ctx)
> @@ -283,6 +284,24 @@ static void check_vendor_extension(u64 paddr,
>         acpi_os_unmap_iomem(p, sizeof(v));
>  }
>
> +static u32 einjv2_init(struct einjv2_extension_struct *e)
> +{
> +       if (e->revision !=3D 1) {
> +               pr_info("Unknown v2 extension revision %u\n", e->revision=
);
> +               return 0;
> +       }
> +       if (e->length < sizeof(*e) || e->length > PAGE_SIZE) {
> +               pr_info(FW_BUG "Bad1 v2 extension length %u\n", e->length=
);
> +               return 0;
> +       }
> +       if ((e->length - sizeof(*e)) % sizeof(e->component_arr[0])) {
> +               pr_info(FW_BUG "Bad2 v2 extension length %u\n", e->length=
);
> +               return 0;
> +       }
> +
> +       return (e->length - sizeof(*e)) / sizeof(e->component_arr[0]);
> +}
> +
>  static void __iomem *einj_get_parameter_address(void)
>  {
>         int i;
> @@ -310,28 +329,21 @@ static void __iomem *einj_get_parameter_address(voi=
d)
>                 v5param_size =3D sizeof(v5param);
>                 p =3D acpi_os_map_iomem(pa_v5, sizeof(*p));
>                 if (p) {
> -                       int offset, len;
> -
>                         memcpy_fromio(&v5param, p, v5param_size);
>                         acpi5 =3D 1;
>                         check_vendor_extension(pa_v5, &v5param);
> -                       if (is_v2 && available_error_type & ACPI65_EINJV2=
_SUPP) {
> -                               len =3D v5param.einjv2_struct.length;
> -                               offset =3D offsetof(struct einjv2_extensi=
on_struct, component_arr);
> -                               max_nr_components =3D (len - offset) /
> -                                               sizeof(v5param.einjv2_str=
uct.component_arr[0]);
> -                               /*
> -                                * The first call to acpi_os_map_iomem ab=
ove does not include the
> -                                * component array, instead it is used to=
 read and calculate maximum
> -                                * number of components supported by the =
system. Below, the mapping
> -                                * is expanded to include the component a=
rray.
> -                                */
> +                       if (available_error_type & ACPI65_EINJV2_SUPP) {
> +                               struct einjv2_extension_struct *e;
> +
> +                               e =3D &v5param.einjv2_struct;
> +                               max_nr_components =3D einjv2_init(e);
> +
> +                               /* remap including einjv2_extension_struc=
t */
>                                 acpi_os_unmap_iomem(p, v5param_size);
> -                               offset =3D offsetof(struct set_error_type=
_with_address, einjv2_struct);
> -                               v5param_size =3D offset + struct_size(&v5=
param.einjv2_struct,
> -                                       component_arr, max_nr_components)=
;
> -                               p =3D acpi_os_map_iomem(pa_v5, v5param_si=
ze);
> +                               v66param_size =3D v5param_size - sizeof(*=
e) + e->length;
> +                               p =3D acpi_os_map_iomem(pa_v5, v66param_s=
ize);
>                         }
> +
>                         return p;
>                 }
>         }
> @@ -527,6 +539,7 @@ static int __einj_error_inject(u32 type, u32 flags, u=
64 param1, u64 param2,
>                                u64 param3, u64 param4)
>  {
>         struct apei_exec_context ctx;
> +       u32 param_size =3D is_v2 ? v66param_size : v5param_size;
>         u64 val, trigger_paddr, timeout =3D FIRMWARE_TIMEOUT;
>         int i, rc;
>
> @@ -539,11 +552,11 @@ static int __einj_error_inject(u32 type, u32 flags,=
 u64 param1, u64 param2,
>         if (acpi5) {
>                 struct set_error_type_with_address *v5param;
>
> -               v5param =3D kmalloc(v5param_size, GFP_KERNEL);
> +               v5param =3D kmalloc(param_size, GFP_KERNEL);
>                 if (!v5param)
>                         return -ENOMEM;
>
> -               memcpy_fromio(v5param, einj_param, v5param_size);
> +               memcpy_fromio(v5param, einj_param, param_size);
>                 v5param->type =3D type;
>                 if (type & ACPI5_VENDOR_BIT) {
>                         switch (vendor_flags) {
> @@ -601,7 +614,7 @@ static int __einj_error_inject(u32 type, u32 flags, u=
64 param1, u64 param2,
>                                 break;
>                         }
>                 }
> -               memcpy_toio(einj_param, v5param, v5param_size);
> +               memcpy_toio(einj_param, v5param, param_size);
>                 kfree(v5param);
>         } else {
>                 rc =3D apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
> @@ -1132,9 +1145,14 @@ static void einj_remove(struct faux_device *fdev)
>         struct apei_exec_context ctx;
>
>         if (einj_param) {
> -               acpi_size size =3D (acpi5) ?
> -                       v5param_size :
> -                       sizeof(struct einj_parameter);
> +               acpi_size size;
> +
> +               if (v66param_size)
> +                       size =3D v66param_size;
> +               else if (acpi5)
> +                       size =3D v5param_size;
> +               else
> +                       size =3D sizeof(struct einj_parameter);
>
>                 acpi_os_unmap_iomem(einj_param, size);
>                 if (vendor_errors.size)
> --

Applied as 6.18-rc material, thanks!
