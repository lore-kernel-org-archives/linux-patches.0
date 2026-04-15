Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EAF3E5571
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776272713; cv=none; b=qaK2PSJz2SctaYJ9iIfBi6mh9u6ODy9IbSRH0XgLyU2Vj6j986sl2l5cBwChgZjB+9yfeRBouwyTAXf1RAL2h2+xsQC21ysj6isqvNgIQe9Ny57ulXBR9j4GgrQDEr1McpkA3TEQlbOfQSOGyyca3SOzs37HLuii8H0Y32Hc+is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776272713; c=relaxed/simple;
	bh=zseR0Bu0TzZgug5uMo7sHPglIXJOiw0YP5L9lXvMTY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MiIjbGNvHnaZ08aggHT1J325D1EornfaoeGZWLrPNIvJ/iBtInfHOURoDyO1MsC/GVjskqfKuFBATZPQRYSzK0p2MOLSZk4sIz3qWgCnK49U/3I9qcR6wUR1PG9KCWF3wlAt/L1V47YDy7uDahiqmktVzQ+T/JJNaFWUQjZrccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRnfNmJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRnfNmJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEC6C2BCB4
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776272713;
	bh=zseR0Bu0TzZgug5uMo7sHPglIXJOiw0YP5L9lXvMTY0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WRnfNmJ6xkVv+fcuPrbygWGxSPW8uqh4JTWm2U81iUV+Q4eAfStXs/fTcGrvU5/Ye
	 BmVuJXLIweQz+vmV7w65z4+nwS3sOC5XDDdDhfkG2p6sogN5FpKtyjwDy/5bfAsw0K
	 QPs6tsU3FkhVawZYOMKsNhKyD6HZhavCKuHaEs7XbTBTb3JYCxBvXooQoEVSYOwMQW
	 ov0Mc6HlOceyL7nhiht5UfT20As2vp+ZApfl9aDbins67XhmTWy/975Lr8DdM/39YW
	 iL6uFrZ67Nluk1opRc2wwUnFpuNlSvBAfZemzRyd+M0S61NYK9mqFLRalmRwrAfa/u
	 ZEQy1JkDEF5xA==
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-66ee7b9af94so2546075eaf.0
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 10:05:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+U0B8ZSgOZFVHiFZt1j28NI6jB6Wz13tdev4mz5MJb+QMMrSoqNW+WXCxE3lvBSGtkdHzBcGz6@lists.linux.dev
X-Gm-Message-State: AOJu0YzRZUU6uxa28AUDqobGdUXvX5hx/4CW93SeKaLyzoJqz5qbBSNf
	iISw0CEHo5ZGGm+TzyzgSyxB5hURjUMjIi6V7/JqVV5O5Dj/aEW14dkMpYgZ5bhX8Pxm1XECRAi
	tzQDGu+YG3sjWxOmS2EkrtcAA/utGHiw=
X-Received: by 2002:a05:6820:6201:b0:67c:c44:1e8b with SMTP id
 006d021491bc7-68be84dbb7cmr7618136eaf.43.1776272712624; Wed, 15 Apr 2026
 10:05:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260415163620.12957-1-tony.luck@intel.com>
In-Reply-To: <20260415163620.12957-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 15 Apr 2026 19:05:00 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jLwKG+kOQcgXh0BrkYC5o1+yPjdmpkWFiLqTXtFJvU1A@mail.gmail.com>
X-Gm-Features: AQROBzB-5xK03nTNabzEtUZ78sdZlGYAzyrBXv6d2wZXaLJrCWoQiX0xOXznJ1w
Message-ID: <CAJZ5v0jLwKG+kOQcgXh0BrkYC5o1+yPjdmpkWFiLqTXtFJvU1A@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: EINJ: Fix EINJv2 memory injection
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Herman Li <herman.li@intel.com>, 
	Zaid Alali <zaidal@os.amperecomputing.com>, Jiaqi Yan <jiaqiyan@google.com>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 6:36=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> EINJ trigger actions for memory error injection often include access to
> the target injection address. This address does not need to special
> mapping.
>
> The code to drop the target address from the resource list only checked
> for V1 injection signature.
>
> Add a test for the EINJ V2 memory injection signature.
>
> Reported-by: Herman Li <herman.li@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Can you please provide a Fixes: tag for this?

> ---
>  drivers/acpi/apei/einj-core.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.=
c
> index a9248af078f6..ba0ce71b7adb 100644
> --- a/drivers/acpi/apei/einj-core.c
> +++ b/drivers/acpi/apei/einj-core.c
> @@ -401,6 +401,17 @@ static struct acpi_generic_address *einj_get_trigger=
_parameter_region(
>
>         return NULL;
>  }
> +
> +static bool is_memory_injection(u32 type, u64 param2)
> +{
> +       if (is_v2)
> +               return type & BIT(1);
> +       else if (param_extension || acpi5)
> +               return (type & MEM_ERROR_MASK) && param2;
> +
> +       return false;
> +}
> +
>  /* Execute instructions in trigger error action table */
>  static int __einj_error_trigger(u64 trigger_paddr, u32 type,
>                                 u64 param1, u64 param2)
> @@ -480,7 +491,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u3=
2 type,
>          * This will cause resource conflict with regular memory.  So
>          * remove it from trigger table resources.
>          */
> -       if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && para=
m2) {
> +       if (is_memory_injection(type, param2)) {
>                 struct apei_resources addr_resources;
>
>                 apei_resources_init(&addr_resources);
> --
> 2.53.0
>
>
