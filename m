Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D7812DDA1
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383579; cv=none; b=MhSWOyXb+C5oR7v4GpP9yDICC4O9Muc/P3jq5Z69xJjw3zD3Lig2AqwAPYhnX5iWb26aDB/3bhWJ9AcASqwpkc8t4O7h9Pb/g0hycnp1beki9j/q9RQmS3a2RWoFf5sJPx8s6JVZUGrQHj191u6s/P3eirUWJgk2Lleg/j8BePY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383579; c=relaxed/simple;
	bh=uh9WFKIeWkaAivfeZSQMhbdOFpPDb/6h8qrwur73QbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fv8LQajGnTr+edHLo/+nREuUiEb6lNuvWzPss9EKOV26lMMlrKoQvpnafpWUY90HmUfaYrvfoP/YFlS7OJYmTXhOTUXn8g9irs2engIwtdLwN9FN1Vtp3zPdxyUIFrCx+xKBFPMFFaL5ghQue7nTtGt755r/DuOMIEopJXPAjJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=XCRSP8Jf; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XCRSP8Jf"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-78a5580333bso74262785a.2
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711383575; x=1711988375; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipKnULZuL+tAFscQ7D07riaZRlX7/8LgeP9Tufvdjpg=;
        b=XCRSP8JfYFpmnrRlQ8c3P4MnRA2228Q9mNcXD35+n9uIJFLBpT5Y73WSKZOxdXcB3Z
         CZWRIWKSxY3fDssrijo4wQBv7B1wXTiddWzLDbTTWe422aToh7kQ/yb/GuhlsI/VoYJm
         1PLEMJ+wf7JcnO7l1E1fuNL+e5cbolKVvI7os=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711383575; x=1711988375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipKnULZuL+tAFscQ7D07riaZRlX7/8LgeP9Tufvdjpg=;
        b=quzDIA7zkxhRYf2Ncvlj1dCzHp9vkkPk5zj24IKIdN6gRpZFVmZ6+a1Xe35uQ6spz9
         SVd5WUcfAfE6wjj5sY2G+6W3eFTnNjYzAddGAO8/uHuOh7shdy7lXVnqhQT57D6NBAqg
         VWFCHIoCjVAyMM9OHBmBVg2umgreu6JKClIfOiRlkj0zwG8rKf6DNHf0hNekg3rrWbhi
         eMu2MkcmwmcFPB8oAKra5EhTrtP1dmCG9zwXaMkCRdQGHLFysS+N0qLTkXPGRlYf/NMY
         xJh+psu74CdZkqEuxLSf1BQ7UpufJdKw+qAm+JtM9ZSHYEP83yx5yCWO1jC+uvSmM5i8
         5Wkw==
X-Forwarded-Encrypted: i=1; AJvYcCVspiryhCC0bYvUGq3SW0buJcxcKfgFDEmji6cRaYAKhVU6ocIYRWWh0OK1cDT0RPCzt/sulrw0kKcVq4hKq2cB7bfJaKIGPw==
X-Gm-Message-State: AOJu0YwQUYFFwoj3B20Esx+A52tW0RhbyNRoWJ4wU9ei5ibmvEx0EHSS
	WagSGZDGQk8BLO39f6v3sQ0u0xI/wJra4t0kKRP68wtL/ohgYnFKI8G2u9KnAJJ+BGG9oCKvabE
	=
X-Google-Smtp-Source: AGHT+IGPW+A4ioJkTf0YpwJ7osRGwQ7Gbw2F9vennXVTNWINUUHWzIR+C5G+93KlCR/XOzU9+HAbvg==
X-Received: by 2002:a05:620a:244b:b0:788:25be:c1f2 with SMTP id h11-20020a05620a244b00b0078825bec1f2mr9618869qkn.68.1711383575371;
        Mon, 25 Mar 2024 09:19:35 -0700 (PDT)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com. [209.85.160.180])
        by smtp.gmail.com with ESMTPSA id l26-20020a05620a211a00b00789e8860ef7sm2226233qkl.121.2024.03.25.09.19.34
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:19:34 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-428405a0205so535291cf.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVftXV/lAgt+z5RGprGGyZq0c8D85LJMhSoUH7SCHuv4m1m2GZGuk7/I6/lXLd6yJjU4Vi3xW6jxuNCO4yj12pUDqYo2mLH3Q==
X-Received: by 2002:ac8:5c0f:0:b0:431:1e00:996a with SMTP id
 i15-20020ac85c0f000000b004311e00996amr1088763qti.27.1711383574002; Mon, 25
 Mar 2024 09:19:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325054403.592298-1-sboyd@kernel.org> <20240325054403.592298-4-sboyd@kernel.org>
In-Reply-To: <20240325054403.592298-4-sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 09:19:18 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vc-oe=JVJmg4w50VB_-AyxNoWe5KotnXPzrXUfgqhpkQ@mail.gmail.com>
Message-ID: <CAD=FV=Vc-oe=JVJmg4w50VB_-AyxNoWe5KotnXPzrXUfgqhpkQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] clk: Initialize struct clk_core kref earlier
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hik

On Sun, Mar 24, 2024 at 10:44=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> Initialize this kref once we allocate memory for the struct clk_core so
> that we can reuse the release function to free any memory associated
> with the structure. This mostly consolidates code, but also clarifies
> that the kref lifetime exists once the container structure (struct
> clk_core) is allocated instead of leaving it in a half-baked state for
> most of __clk_core_init().
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/clk/clk.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 9fc522c26de8..ee80b21f2824 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -3959,8 +3959,6 @@ static int __clk_core_init(struct clk_core *core)
>         }
>
>         clk_core_reparent_orphans_nolock();
> -
> -       kref_init(&core->ref);
>  out:
>         clk_pm_runtime_put(core);
>  unlock:
> @@ -4189,6 +4187,16 @@ static void clk_core_free_parent_map(struct clk_co=
re *core)
>         kfree(core->parents);
>  }
>
> +/* Free memory allocated for a struct clk_core */
> +static void __clk_release(struct kref *ref)
> +{
> +       struct clk_core *core =3D container_of(ref, struct clk_core, ref)=
;
> +
> +       clk_core_free_parent_map(core);
> +       kfree_const(core->name);
> +       kfree(core);
> +}
> +
>  static struct clk *
>  __clk_register(struct device *dev, struct device_node *np, struct clk_hw=
 *hw)
>  {
> @@ -4209,6 +4217,8 @@ __clk_register(struct device *dev, struct device_no=
de *np, struct clk_hw *hw)
>                 goto fail_out;
>         }
>
> +       kref_init(&core->ref);
> +
>         core->name =3D kstrdup_const(init->name, GFP_KERNEL);
>         if (!core->name) {
>                 ret =3D -ENOMEM;
> @@ -4263,12 +4273,10 @@ __clk_register(struct device *dev, struct device_=
node *np, struct clk_hw *hw)
>         hw->clk =3D NULL;
>
>  fail_create_clk:
> -       clk_core_free_parent_map(core);
>  fail_parents:
>  fail_ops:
> -       kfree_const(core->name);
>  fail_name:
> -       kfree(core);
> +       kref_put(&core->ref, __clk_release);
>  fail_out:
>         return ERR_PTR(ret);

If it were me, I probably would have:

* Removed "fail_out" and turned the one "goto fail_out" to just return
the error.

* Consolidated the rest of the labels into a single "fail" label.

That's definitely just a style opinion though, and IMO the patch is
fine as-is and overall cleans up the code.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
