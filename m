Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D58B1EA98;
	Thu, 22 Jun 2023 16:53:51 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6b45cfe3110so5310575a34.0;
        Thu, 22 Jun 2023 09:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687452831; x=1690044831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8yYMEX/t8Klnote5y9PwMV4v/R5Zq9BMnCmr1KijqA=;
        b=Pt1nXkO/26/fQa155yjH3pyzn/SzDu3Ys72LfiAAiA8CfR5SeaxYWJASav/l6pUjtS
         ZUXeytL3yArUtBMuoMxRoCIx+/FL1NrxI2W3mFvKZm2J4MyDyRxqPNZ5CuZcPcc/HEaC
         ywe/1ATR5kfk9gUWiazxzFWlf6qDUU6T2z+AY/eK0KhEg40G3Ac79NRNwvmbhgKXwxjv
         vkgCkhwSKVNxTFyd8enD+DvHPdCiIEaFtq1ZyTLZ7sMfN1jruh4TMaq0tSWEqhBKMI/K
         55objcP8XfnkQJB0xnc+yNYP/bFVnGQUG31lNeHvoB8H8wXdlGfWWnvQ+1P2vV73cHLm
         N8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687452831; x=1690044831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8yYMEX/t8Klnote5y9PwMV4v/R5Zq9BMnCmr1KijqA=;
        b=bOFWGknkRqh7bN8ILpeDn4ORUFjiRzrWV+7oqgPX8cTDUDK5hX4BA9/PlmDpHTIgym
         qGsrAuktHOfeXj5LqaMTQzVWntoCiMV+Fs0Q8HVIkPr3aa6n27j8HCJIVl6ONaRde7nF
         bpjUDhi3NLdqDhNm8XUY2J/lb9fVO2ZB/T/qJvPtygLMl4HOnI5SUjK0bAjJgNc6bDh2
         /y3cpefu6d28Lhy4x88wzAHKW2tlW90IXz/7K5RevlYNQtdnA4acRkQgaAm8NKYj7+Zg
         8SQm2RnWR8qFSxtYAJ62park9fvC8JZcQ1wFA07hYag8Kow6RacIFle0vPp3Xj0hwr2x
         jIGg==
X-Gm-Message-State: AC+VfDxa2evYpo+/LkAz8VyVm3Jiv6MU8S8pQV/4ESQyM49AqvemWmQ1
	XmfjkkiTGcPk8ZHuPtWRN+8qZ39wH8qCeJ5hZEE=
X-Google-Smtp-Source: ACHHUZ5wJu27nrivTok6qs1B5hPokhBnncL+1s3kNTj874MuSDplDrZIaOADSQJQsgir26+dJQ0jdGdQR5JUGcopGA4=
X-Received: by 2002:a05:6871:4f18:b0:1a9:8484:40d with SMTP id
 zu24-20020a0568714f1800b001a98484040dmr15092643oab.23.1687452830873; Thu, 22
 Jun 2023 09:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230622-mips-ralink-clk-wuninitialized-v1-1-ea9041240d10@kernel.org>
In-Reply-To: <20230622-mips-ralink-clk-wuninitialized-v1-1-ea9041240d10@kernel.org>
From: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date: Thu, 22 Jun 2023 18:53:39 +0200
Message-ID: <CAMhs-H_aKYGrCYemyOoNk+nHzDfmAU+BoV2pA7eauZ+k5PhGEQ@mail.gmail.com>
Subject: Re: [PATCH] clk: ralink: mtmips: Fix uninitialized use of ret in mtmips_register_{fixed,factor}_clocks()
To: Nathan Chancellor <nathan@kernel.org>
Cc: tsbogend@alpha.franken.de, sboyd@kernel.org, ndesaulniers@google.com, 
	trix@redhat.com, linux-clk@vger.kernel.org, linux-mips@vger.kernel.org, 
	patches@lists.linux.dev, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 22, 2023 at 5:56=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns:
>
>   drivers/clk/ralink/clk-mtmips.c:309:9: error: variable 'ret' is uniniti=
alized when used here [-Werror,-Wuninitialized]
>     309 |         return ret;
>         |                ^~~
>   drivers/clk/ralink/clk-mtmips.c:285:9: note: initialize the variable 'r=
et' to silence this warning
>     285 |         int ret, i;
>         |                ^
>         |                 =3D 0
>   drivers/clk/ralink/clk-mtmips.c:359:9: error: variable 'ret' is uniniti=
alized when used here [-Werror,-Wuninitialized]
>     359 |         return ret;
>         |                ^~~
>   drivers/clk/ralink/clk-mtmips.c:335:9: note: initialize the variable 'r=
et' to silence this warning
>     335 |         int ret, i;
>         |                ^
>         |                 =3D 0
>   2 errors generated.
>
> Set ret to the return value of clk_hw_register_fixed_rate() using the
> PTR_ERR() macro, which ensures ret is not used uninitialized, clearing
> up the warning.
>
> Fixes: 6f3b15586eef ("clk: ralink: add clock and reset driver for MTMIPS =
SoCs")
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1879
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/clk/ralink/clk-mtmips.c | 2 ++
>  1 file changed, 2 insertions(+)

Thanks for the patch, Nathan!!

Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Best regards,
    Sergio Paracuellos
