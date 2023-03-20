Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674D87C
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 17:34:40 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id t5so13049850edd.7
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 10:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679333678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fi1OHs7Bk8TJ5UregfyVR/fDxL3BggpeJfKVN6kZ4QI=;
        b=c2L2skUND35Zzs7yzs+v9YCFVWtAOF30WTMM0rYCJ5oSqJaPyDtwPWJjg0RnZ06wkR
         kXWu+FGxSFDKQZ5MYtqdqMqvqry5RyQn2D9sN6ON08EMFngk5j/vW4/2HraexFSBzhsQ
         dm6BplrRb2PdZVlPAzzyP5HRMvzJxpoTo1bwQsDjK5GPSsfvr5XEYah60dOlJwMHAvwD
         SvxP+mtgh6yNONcimH3ufUASLzdxaxHqcnntdlycxm8FosL5YFtTYaxPRT851OXLNCD6
         c7b6vQaLUW6nz8VE9NkKQ4FrPQxFIQo5fIoEx39JaYfYsGO2GAXgO2ot/GQzCxtFc/Hv
         4d4A==
X-Gm-Message-State: AO0yUKXW3RHZmZ2Z6FXrgRW9w+409QhR9oLqekUZwCVGSBW4LmRTPKqO
	k8Exk9C5VHwkclxN1Ep/5lsgcEtZJ0PJdJ+6C0o=
X-Google-Smtp-Source: AK7set8VIdb1Yu9eY0D5QYIlbOBWUwqbQOyN3a6t4VASfDsjzfQEnk526Z7QjD0NaX1RghsJpAdGThjMbg73BPPMyYI=
X-Received: by 2002:a17:906:1b4e:b0:930:310:abcf with SMTP id
 p14-20020a1709061b4e00b009300310abcfmr4702624ejg.2.1679333678504; Mon, 20 Mar
 2023 10:34:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230314004611.48583-1-tony.luck@intel.com>
In-Reply-To: <20230314004611.48583-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 20 Mar 2023 18:34:27 +0100
Message-ID: <CAJZ5v0hNQUfWViqxbJ5B4JCGJUuHpWWSpqpCFWPNpGuagoFbsQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: EINJ: Add CXL error types
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	linux-acpi@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 14, 2023 at 1:47=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> ACPI 6.5 added six new error types for CXL. See chapter 18
> table 18.30.
>
> Add strings for the new types so that Linux will list them in the
> /sys/kernel/debug/apei/einj/available_error_types file.
>
> It seems no other changes are needed. Linux already accepts
> the CXL codes (on a BIOS that advertises them).
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/acpi/apei/einj.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index b4373e575660..39bee5a067cc 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -584,6 +584,12 @@ static const char * const einj_error_type_string[] =
=3D {
>         "0x00000200\tPlatform Correctable\n",
>         "0x00000400\tPlatform Uncorrectable non-fatal\n",
>         "0x00000800\tPlatform Uncorrectable fatal\n",
> +       "0x00001000\tCXL.cache Protocol Correctable\n",
> +       "0x00002000\tCXL.cache Protocol Uncorrectable non-fatal\n",
> +       "0x00004000\tCXL.cache Protocol Uncorrectable fatal\n",
> +       "0x00008000\tCXL.mem Protocol Correctable\n",
> +       "0x00010000\tCXL.mem Protocol Uncorrectable non-fatal\n",
> +       "0x00020000\tCXL.mem Protocol Uncorrectable fatal\n",
>  };
>
>  static int available_error_type_show(struct seq_file *m, void *v)
> --

Applied as 6.4 material, thanks!
