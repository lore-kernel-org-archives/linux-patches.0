Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE918F5F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 20:19:35 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-9788faaca2dso789158566b.0
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 13:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686601174; x=1689193174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WHocG4UQ3ecO0uydSymSh8iIsvcAoTFn78fAzFQKDjI=;
        b=gn7OLV895i9gRAkGix/1SL6oMaVp7CcSdGVgqiI7pCIuwI9xq7tDHl+Zsko2VJ0+ys
         ZrvOF/RUpQzlZLO+MrhB9B9u9fmNmDk7nEwHBhYXvU4b9LXw+3rhxf8yFrfRxVSaB5IG
         wu8f4L3cXfELhPUag82nphdxHQUGijHHBrDy5OW3C/GzT2AWXB7i9mccox28O6nVq/3B
         n1Buv53uYvq3KcsjJgaGa86LZgcEUQW5BuKtM+fFDyd6ieaNcX4bNVcTQO59e0/ZE9cd
         JTdU1UBI1pMk0YHyM8p5+mAuIP0xEGe9Nhc6TYDBd39DBiXs/9P5Fy5rTAfAQGjsG6JD
         bI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686601174; x=1689193174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WHocG4UQ3ecO0uydSymSh8iIsvcAoTFn78fAzFQKDjI=;
        b=bJyYfq1PKcIYsG1G2//9C1Rl0OtHXFeMZ6AlQs0uSzThyOVZtHFDL9E6vd5Ymcm+UM
         s5CoawRydPjNVi1X4YtPfnhDWuKkn0NdvVebK6Ajc5QoQKvo9nxrZAYJ5EuonHorfPb4
         tyQs2K2ijXsUtt15tdPaWMvOKXPZ9dzxa/RCALZizggiGIImNdF6E5R6FBoh4njv6uBE
         5dcOAIi10Zjq1CMyU71i3oB9iHqCtgCiqPwOPUu9b1Zks/wSRN7sbA3sCSU20ZtNctvy
         isMuS+7lltpPVyYcS9ew2WboXEoX39MJ+Lt56KScfZoYjEYO7f7KIewCARPHhlrZHiUQ
         24gA==
X-Gm-Message-State: AC+VfDwQsCwvxM/bvo96w1iLSib5U+EWVOrOBZVmkeX47M53UwmWx91C
	5j8/hN9UVvc30mG650a6EnunHu2u8poEiLQXxQM=
X-Google-Smtp-Source: ACHHUZ4cRAMZbJC2dU3z1dP2Wh3awz8FhOBUlEqWVkrUeV6VG5nx4Njtd4uT80JB8Ow56uhN1rg8qESSC9moCMwYHfw=
X-Received: by 2002:a17:907:3da0:b0:982:2278:bcef with SMTP id
 he32-20020a1709073da000b009822278bcefmr2406503ejc.60.1686601173890; Mon, 12
 Jun 2023 13:19:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612182332.371003-1-sboyd@kernel.org>
In-Reply-To: <20230612182332.371003-1-sboyd@kernel.org>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 12 Jun 2023 22:19:22 +0200
Message-ID: <CAFBinCBpVcpWaxrOC0AKXbK9saUSoArVeH1yM_P-h0YQ0UsR8w@mail.gmail.com>
Subject: Re: [PATCH] clk: meson: a1: Staticize rtc clk
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	Jian Hu <jian.hu@amlogic.com>, Dmitry Rokosov <ddrokosov@sberdevices.ru>, 
	Jerome Brunet <jbrunet@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 12, 2023 at 8:23=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wro=
te:
>
> Sparse rightly complains that this symbol is supposed to be static.
>
> Cc: Jian Hu <jian.hu@amlogic.com>
> Cc: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: Jerome Brunet <jbrunet@baylibre.com>
> Fixes: 84af914404db ("clk: meson: a1: add Amlogic A1 Peripherals clock co=
ntroller driver")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Thanks for providing a fix so quickly!

Jerome, I think it's easiest for Stephen to apply this patch directly
to the clock tree.
In my opinion there's no reason against this since our own patch queue is e=
mpty.



Best regards,
Martin
