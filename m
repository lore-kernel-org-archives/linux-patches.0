Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82623ED5D4
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776276019; cv=pass; b=dHkauOCjLdxKIafTk311jyy3/BHmuczZTlFekuX3Hr5MEXjwMDTKRQSWasLkrZddf/8B8ygnx9Q97znXEO4P380qVHMCW+Dy5FANWcgs1GEFOgdI2efTatkjSktF5Vx14kLsLhfCQrXvAZwDGrWLsMc6PoOs36R/CIlmbEnZF4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776276019; c=relaxed/simple;
	bh=qPQhQp9VdovCFB/WM7hSOT0rza7x2YKPTKKh6DdT8ZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NMCAacC0vGRsVdcuT5HcX/YmNnZE2NBcBQ3zRCnBCT5+clpqdhSPL3JdtHLBJEDUoAu6qXC3zBKIlOPdkNuQWkH2RAvVc9ZfZs7cSU+pKUy2iBDq3EDNkpnjqpjTTZ4+pP28dWVRO4pmjaVp6sYaYEI1qjmDRiWYT6h8PlfJ2Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QU7qQu0S; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QU7qQu0S"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4887ec3d8e7so34875e9.0
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 11:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776276016; cv=none;
        d=google.com; s=arc-20240605;
        b=g8KOYWIuL0FshUL9Empye418QoLzEhc9csC/Wo4QDrR7sWK/djd1KduEj3kKQs+8lX
         UMHvCr3dpWyF/5FP7vwcLwSCl94zmdx3dZtm37DEKzukW3kJSWSxLzzIVAyATDRqHLQB
         z8EtqJXRbk39LARGqH2L09mvLmheY6B4yz7jgNbmh3NCOfOXvMaBRA2gj8bBRdZSfPI5
         EPdDGmf6wCAdiypf8KBc4rS3UIcGSikWF3iT+f/HHukWF4sFCC35i9WTZbJK64+GLFfa
         pIXc+oy+XWjXR72McvrCKROwBRSd9Md7U6fFNQAxp6hFHkfGQW94psZZzOOO00QOEW3N
         FpQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7k+/a5yHkocf0kBDbxZdsG9VDQvYFZJUscJs/+UC0is=;
        fh=8JH3coA1i8HOg1P6Uhpp8PTLaF59vT9S2lYMDwslTYA=;
        b=U9koyp6bo2Jufz0NqU6TYQIFm5lF7MrUraEE4M+vL0g3NZ563OXfO6ru+wUuVjlDkn
         DbL7oQnlKzXPQojMox4ScEcfxu75/wXSu2Se9oKCGvXI8Vr4+RS1sbjhTg168vjqgkbT
         tdAr46gEPfbnK8BitfnEHTAclkol174x8KQ79bPvyhlDzj5d7qm35yqqlg4fx0Zl9C7v
         t8PWLiFVR6kZueDskiYNRhzZU7ktOq0xl/SiHAHjacnRTUFNedfNWb7bu8tLitbfZV2U
         2rHCc0da5Lc3/NM31UsNp8ws/e3STwyHeu9eGUd2/9X2XrTqzMHWfiXxE9kIq2d3GmVP
         33Ow==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776276016; x=1776880816; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7k+/a5yHkocf0kBDbxZdsG9VDQvYFZJUscJs/+UC0is=;
        b=QU7qQu0SVpX7H2/olTJEvkLVU1HmCEk08M44FpRXfKQ7b9mhtoLvvIjRpvOpFKNG/q
         tnVtbtfmV7fG+NthLOvVk3WRs4tVxEynOX8c/NObMiCoEMMnAigLGxnpmUp2xWuPJ0VY
         4bLjM6O+8JERd02dS8aq54/Tx7zHRfu7ed1utGAJEsLLEr/xOTbwLjP1aEolAhwwxc0L
         JW0M0XEqDpVepR6RnAdl1N0S2IJk+02oZ6zzEyPeXI+90dAn9Lf9tvof5NJE0wbZNqR8
         I21pbdQ+A/P4ZthG7y8lRuwpumdxr+Lk2YgpYNf/TE94Rx4hPzPh2gOOISAIJZCG3Wkf
         pPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776276016; x=1776880816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7k+/a5yHkocf0kBDbxZdsG9VDQvYFZJUscJs/+UC0is=;
        b=aN++Q9YanVTYRJPBP7Ch+7YozlmzJim0prHgfd8CC40I5uL+9umVxOWhZIqoFN9xO1
         9TN/jxwlaTyDCKDOgU0kul7ZqQik5G4mfE3UErGZxK+o4eDvkNGQHWWDlbMgveWJJ4bZ
         RSSP30u/8Z3WD4Kjs9UDZoaFlIPSqeYflSvDLJZIl+6E+9M+CxBgmBKCuWAM4zrIz+F5
         qdFbPjeQHauHFgGk0K7SlPRuk+PdT44U7TMoYPhe2p4tv09RpNnAjwWytM5nxIn4zAsF
         7ESKOJTjy/wv/mk5YIBENc8bx+TP61UzniReTlwdpBP122gl6zs/Msdy9TrXp9zNnDZ5
         xrNA==
X-Forwarded-Encrypted: i=1; AFNElJ9oQeKOAae0xr7gN1WMRGLr+tSieos30vFFJrFX/qjtC0fpH9ZtItEoKat7Prd9ZgAGk/jI8PFh@lists.linux.dev
X-Gm-Message-State: AOJu0YxjX+kzhisiBVsDdEh2bxIC4BaHfkngoeDaQ988Cngu+vIT8eds
	BFy6YuAIY0z7VhxFggkKNaPqtg5xZ+Kd519JkggAuJvP2D6PUfA6HsTwpjfHfkPoUmgGLggFYpg
	9aZqAp/aI2eSAYkHT0EwUov+0eAlx3XaijyyO4FK5
X-Gm-Gg: AeBDieumF6xskzYAJLF7L6iHhy4F1bVcMobYuVvMZXP/z+I3KrikdYurzZd3AtQOW9C
	E8/lK5Wh4P7kqFkW4MdxjXMuOlnNyDhvHic72G+gVhqXcQWjnsMX7htrPwZiSByUlIg2Vz+wTT2
	t70LBl+vnvgv8NT/YpJQUvxRY+fjx9TeiNj0Yb9KYJpbO0f/3EY15MPJusBSdDIWcjTyylzPfkd
	3mGsUixaWaWVryJTKaZk/87A2l59wJ1ONzvLhoAWOLKozsfGtFJGv8O8tt1BkyCNRwylCYFav0y
	kvxCegAV4dtl+4Co75RlKFwcNIh6Nls8FJhmI+Zm8fgRumSskWM4cRonR/wvzSvbUsu2
X-Received: by 2002:a05:600c:35cd:b0:477:86fd:fb1b with SMTP id
 5b1f17b1804b1-488f4b0baaamr15375e9.11.1776276015887; Wed, 15 Apr 2026
 11:00:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260415173735.24437-1-tony.luck@intel.com>
In-Reply-To: <20260415173735.24437-1-tony.luck@intel.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 15 Apr 2026 11:00:04 -0700
X-Gm-Features: AQROBzB_XFGZq9Z8O_w4jVm1Y0Hi5-1B2wXoFxak3HfWQOe7OzTU8T44AQs-lJo
Message-ID: <CACw3F522f6p-x6MEU8t7CEoU1P=PtU8dKy7opKjH8sOecdF1kg@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Herman Li <herman.li@intel.com>, 
	Zaid Alali <zaidal@os.amperecomputing.com>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 10:37=E2=80=AFAM Tony Luck <tony.luck@intel.com> wr=
ote:
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
> Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
> Reported-by: Herman Li <herman.li@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>
> V2: Add "Fixes:" tag
>
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

Hi Tony, just a nit: for readability would it better to introduce a
macro for BIT(1)? like ACPI65_EINJV2_ERROR_TYPE_MEMORY

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

Anyway, the patch looks good to me.

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
