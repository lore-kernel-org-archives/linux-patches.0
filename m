Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE123ED113
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777319658; cv=none; b=t5yeVOg79gPiCGfwUAq4INSvGvEc4mPVblY1t6Glh2u2/GCJaYAPLpYCpBCLL3o49hck9cm6p7RyA2nfbATW6kxkngwln6/F7+NagakYxaUbLLFhBXrhgml0vMYk9Nijb+xBaDolLeYfUzQWv7qnLpe67yjbfy1JBoFS3I9j4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777319658; c=relaxed/simple;
	bh=nZXmcu1dhHyxv3InR7KmHO+Zg5pH5fIBQ+M0+/rPAhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdCzV6KHC8iKJsF93i1clnroy+7afOp6oFn0qekA0qbzze6khA9pZkMOZQkd59Gdw2+wetX2LfNhIABcp/12oP7nO3+IXJ6vlwNaQRx9/IY/GL21yjSmEybcrJpx62dhg9b/dHnV+7QrAM9i7cAuN30rxLDHUhyL5LgPCV6lzDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6a7CRaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6a7CRaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A4BC4AF0B
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777319657;
	bh=nZXmcu1dhHyxv3InR7KmHO+Zg5pH5fIBQ+M0+/rPAhs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r6a7CRaT3piZkzJYMw8uVaHnolT2IXHIvKHgH3RKILRXBQtfIPslxbU/Z9oLMf3VZ
	 YpqXcQ3r8l9zPgFFKkoCLoxA5zVSUmXt+xEKY5HWU2/feq1PwG1ozXv1vXagesWYj5
	 /peuMQL3pO6HVzDKrfLT4oSp7v3Xf0vsSuJ7EzG/nAetW8XRtGK6Z0yWXZgFgztLTC
	 45zoK/7I1vNmCB8X0boJ6n6FC9XJZF4v9oUljq9WNoPhVTad1rgQC53jh2dYBu+nrY
	 Li2p5gg5I6tWVsB2GT0MNp2LQREm7PuZH1NjzHe0qcg21j8KBo7xsYdPgGUhVs8xXH
	 94FYTp8BPswew==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a3d1561e38so8710443e87.0
        for <patches@lists.linux.dev>; Mon, 27 Apr 2026 12:54:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+kpMuG69iRFKmjJAmyBAW5MXXA8RmLpcp9BhMA/ZtcWw7dSrZoMcGiO1iHdrGq/qcf/MVZlZPM@lists.linux.dev
X-Gm-Message-State: AOJu0YyRHxus+Wnvk0y1HRtRiJTiWpbYrle5cSHs0pCsAvwoKv+xzeIa
	oMGZ67bOO4nl9rQjp0WfEF+86MhrxOQuXlV3+0N0MXEoiVLvm/bMDQFXEhm+REC6toDWcBFjEw8
	barrASpBwxfv9c5Lu9D0s84MFiEnO2Is=
X-Received: by 2002:a05:6512:3c8d:b0:5a4:18cb:884e with SMTP id
 2adb3069b0e04-5a7466181f8mr84648e87.26.1777319656250; Mon, 27 Apr 2026
 12:54:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260421150216.11666-1-tony.luck@intel.com> <20260421150216.11666-2-tony.luck@intel.com>
In-Reply-To: <20260421150216.11666-2-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 27 Apr 2026 21:54:04 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0iht9fP5UUwPQUtsdhw=sWrxQ5i_EE-JO+JesBM6m4hnQ@mail.gmail.com>
X-Gm-Features: AVHnY4LwxvcVBvw1VGqWG2qJFg9ZAMmzZdsXzDbX-D0bf8lDLlGYkPR8aypRl6Q
Message-ID: <CAJZ5v0iht9fP5UUwPQUtsdhw=sWrxQ5i_EE-JO+JesBM6m4hnQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ACPICA: Provide #defines for EINJV2 error types
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Herman Li <herman.li@intel.com>, 
	"Lai, Yi1" <yi1.lai@intel.com>, Zaid Alali <zaidal@os.amperecomputing.com>, 
	Jiaqi Yan <jiaqiyan@google.com>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 5:02=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> EINJV2 defined new error types by moving the severity (correctable,
> uncorrectable non-fatal, uncorrectable fatal) out of the "type".
>
> ACPI 6.5 introduced EINJV2 and defined a vendor defined error type using
> bit 31. This was dropped in ACPI 6.6.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> ---
> Already applied to https://github.com/acpica/acpica.git as
> commit e82d2d2fd145 ("Provide #defines for EINJV2 error types")

So you do

Link: https://github.com/acpica/acpica/commit/e82d2d2fd145

which I've done already for this one and applied it as 7.1-rc material
along with the [2/2].

Thanks!

>
>
>  include/acpi/actbl1.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 4e15583e0d25..f72e00517eb3 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -1386,6 +1386,12 @@ enum acpi_einj_command_status {
>  #define ACPI_EINJ_CXL_MEM_FATAL             (1<<17)
>  #define ACPI_EINJ_VENDOR_DEFINED            (1<<31)
>
> +/* EINJV2 error types from EINJV2_GET_ERROR_TYPE (ACPI 6.6) */
> +
> +#define ACPI_EINJV2_PROCESSOR               (1)
> +#define ACPI_EINJV2_MEMORY                  (1<<1)
> +#define ACPI_EINJV2_PCIE                    (1<<2)
> +
>  /***********************************************************************=
********
>   *
>   * ERST - Error Record Serialization Table (ACPI 4.0)
> --
> 2.53.0
>
>
