Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6D51FDE;
	Sun, 10 Dec 2023 06:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqaoGpBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46F7C433CB;
	Sun, 10 Dec 2023 06:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702190317;
	bh=f4J07cs/v/dEud5COvTxeWJSCG3sw0khndP3TOKc6ME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CqaoGpBzgeXYkMpVJ2qWZ5tkk09Gf0unItMoQfQs5rSCSJZMLQDQHIqUm/9b+Lrvj
	 49DkQ3OPMjR/i9KE1hq2bd5qm6K6cmz5f6aM9dpp29oTdENeZQrNFkYMwmi3Cuzdhc
	 hPZrVW4F0SiULkTlbqiaquzprP8tW/gBMjlrxTluScDAfD7D4O2kEWsbiKlnL867ff
	 kEzREVvxQAk/GTd/pZlEBTKF65KJyyK16nYdClBW3mbC65NzVKVor1fWYK7eMtcoi+
	 hArsYY+wflHv5V5PdwT6/hK6rJIRVXDgPCRzXr/8aj4uzCOqE3E6PcmAk367y81Q8m
	 T3MR9Qf+6qcpg==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1f055438492so2547704fac.3;
        Sat, 09 Dec 2023 22:38:37 -0800 (PST)
X-Gm-Message-State: AOJu0YygsUrmlrwllxbYFy1+qY9D/uanvWYhXeAOvU/3saAfh1+VGgvE
	mmYLtMUKaij2dw2pspaB2HIfQmOthApW1Tj9tJs=
X-Google-Smtp-Source: AGHT+IFOD+sUTuoV9xyfBhxWx1/VGTbS8HqdOkH18ZV+mM42FcGpkKNvZ/SKVUkz4BG7/+aQx+ByVPiPW19OTqeUyJE=
X-Received: by 2002:a05:6870:80b:b0:1ff:bab:7bde with SMTP id
 fw11-20020a056870080b00b001ff0bab7bdemr3397089oab.50.1702190317344; Sat, 09
 Dec 2023 22:38:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205-maintainers-kbuild-clang-tools-v1-1-a646a1985300@kernel.org>
In-Reply-To: <20231205-maintainers-kbuild-clang-tools-v1-1-a646a1985300@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 10 Dec 2023 15:38:01 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS+iPy9_zt5ma1fE9tKF9OP+skU876b6q5MaPeKy0j_aA@mail.gmail.com>
Message-ID: <CAK7LNAS+iPy9_zt5ma1fE9tKF9OP+skU876b6q5MaPeKy0j_aA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add scripts/clang-tools to Kbuild section
To: Nathan Chancellor <nathan@kernel.org>
Cc: nicolas@fjasle.eu, ndesaulniers@google.com, morbo@google.com, 
	justinstitt@google.com, linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 2:06=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> Masahiro has always applied scripts/clang-tools patches but it is not
> included in the Kbuild section, so neither he nor linux-kbuild get cc'd
> on patches that touch those files.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>


Applied to linux-kbuild.
Thanks.


> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 788be9ab5b73..cd9bf44dc1b3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11526,6 +11526,7 @@ F:      scripts/*vmlinux*
>  F:     scripts/Kbuild*
>  F:     scripts/Makefile*
>  F:     scripts/basic/
> +F:     scripts/clang-tools/
>  F:     scripts/dummy-tools/
>  F:     scripts/mk*
>  F:     scripts/mod/
>
> ---
> base-commit: 33cc938e65a98f1d29d0a18403dbbee050dcad9a
> change-id: 20231205-maintainers-kbuild-clang-tools-93666b423b02
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Best Regards
Masahiro Yamada
