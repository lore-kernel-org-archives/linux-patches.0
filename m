Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E998912F38A
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383599; cv=none; b=skwtnG/okF4oyQR1JDTpwoV5jN8kh1QsR2RW0irl9AGO1eBSRoDAWr+07fxmKsnCh6NSVtc5JjjEuH00aG1xd2S9JdTfqS+/DXZ8I48kVTVTLlP6NNfRIyGdJ2IEhGU/+1e7k1frPilf6ptyU6E4EY8pZB9B/DU8n4gIpAxPH3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383599; c=relaxed/simple;
	bh=uOV5MCWT9pDoDGzplATxiEhOJo8GdM18dNDgTj0skJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+x7CDb/qNQJDjPNqss4DB8pzliHTOnwelnmNndbbGMKh6NQJNt05apnsp2JSJlOVxC4LPe2gHYtHl7HAN77uFOLFSAJUMYQ+0xcvpTG2ivTvdPkEXcyVO126Wu82td24cZk+kFROljzdR771/wP/wxyZtgHh08WtcFqvk5sEFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cFM5FqBf; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cFM5FqBf"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-78a5234377eso83974085a.2
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711383595; x=1711988395; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/M+RNRaHQeXuCFayOM1dYEtW20x69QDnHCFDaOPJPF0=;
        b=cFM5FqBfcNQ3Byw0r4INSZPn0qfEQtsuhl3LvmHVLyhIjQn8smCnXUGiV4T7jersxo
         ouFP68PX2UmcTKoAKnkwskgbOQVo5w+bK2HepgPYfvArf8T/CnhZis2P+jKnJOps8KNg
         E3on467CEnYJNWnAJ1UE4Skw+AzUE6c9kzrEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711383595; x=1711988395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/M+RNRaHQeXuCFayOM1dYEtW20x69QDnHCFDaOPJPF0=;
        b=ZgvfgOrLBIAv4xD7je8bZNV5qGfEJKwHMdSGzmn+GuFUTLa7cOB9Cz1BVTOXlOtKTG
         ncs1Pyr5UeEd8vAScgFAvy8FScvXMHD3uQOqW/fxkrRq/5W1gMBdmkHfnd6EpTC9xYjo
         4e7A5rCvSEGhCVWyq3MuyJPJElOvPwygO3xsTNE/GcMjYzC6fXsYon/PFe0TSGaF2Gaa
         RkUixnSv5+hlOEOvtUQgEy4BKzOQO2xullrQzxrR/8J9sACpKIc8BTBHNCT5IgAz23z3
         4JnKltXN/qbWThaTmEWHMcA0ml+yKiWWLIRzuYsV2D9pZLE7alh+QzJnlDE9MyU8i/kr
         TbFA==
X-Forwarded-Encrypted: i=1; AJvYcCV5+eK7laLZow6aEFuoydrmOsU/ubooKjjk+9ZHfG2B9Bm79AYwcQGUmk0QfwtV6ieLBlUwTZ1kjMSEmYzEnqsfuFdVYIuqSw==
X-Gm-Message-State: AOJu0YzUDObZEOE1/webWLotzpNDky8zOKgFYCZA6qeAlhNYgyxbHqSg
	7VjJW9r8Y2sP/d3KBt+rUhmD9m1vWjW9RQS4AXh7z8m6bBJTAwP9qfGhx9n0HIssGSdvwdDT2UU
	=
X-Google-Smtp-Source: AGHT+IEeq5vZANtPZx662GgTYNRJ+ecFN9CuSpOvtJcDCvijA50g1jndoKy2vYcD66yoKcQ318WCcg==
X-Received: by 2002:a05:620a:22ea:b0:78a:5165:8b93 with SMTP id p10-20020a05620a22ea00b0078a51658b93mr5103070qki.14.1711383595411;
        Mon, 25 Mar 2024 09:19:55 -0700 (PDT)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com. [209.85.160.177])
        by smtp.gmail.com with ESMTPSA id q3-20020ae9e403000000b0078a48172335sm1939979qkc.24.2024.03.25.09.19.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:19:54 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-430d3fcc511so467921cf.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXEQuQ/TsoC1JJzKrws5HBAxENH0fFgeM/HKzb4SUgzjddmY8qsFruJVS4ivSn67rvRn0D4Xm3zXKm77Z0e1ENNZhxJuGUG/g==
X-Received: by 2002:a05:622a:1909:b0:431:c35:150f with SMTP id
 w9-20020a05622a190900b004310c35150fmr1202359qtc.14.1711383594159; Mon, 25 Mar
 2024 09:19:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325054403.592298-1-sboyd@kernel.org> <20240325054403.592298-5-sboyd@kernel.org>
In-Reply-To: <20240325054403.592298-5-sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 09:19:37 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Ws-LYcpiitibPBPRhqrbS8rTo_7xtPPw2kA+qBzybOxQ@mail.gmail.com>
Message-ID: <CAD=FV=Ws-LYcpiitibPBPRhqrbS8rTo_7xtPPw2kA+qBzybOxQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] clk: Get runtime PM before walking tree during disable_unused
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 24, 2024 at 10:44=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> Introduce a list of clk_core structures that have been registered, or
> are in the process of being registered, that require runtime PM to
> operate. Iterate this list and call clk_pm_runtime_get() on each of them
> without holding the prepare_lock during clk_disable_unused(). This way
> we can be certain that the runtime PM state of the devices will be
> active and resumed so we can't schedule away while walking the clk tree
> with the prepare_lock held. Similarly, call clk_pm_runtime_put() without
> the prepare_lock held to properly drop the runtime PM reference.

There's a part of me that worries about the fact that we'll now be
doing a pm_runtime get() on _all clocks_ (even those that are used) at
bootup now. I worry that some device out there will be unhappy about
it. ...but I guess the device passed in here is already documented to
be one that the clock framework can get/put whenever it needs to
prepare the clock, so that makes me feel like it should be fine.

Anyway, no action item, just documenting my thoughts...

Oh, funny. After reading the next patch, I guess I'm even less
concerned. I guess we were already grabbing the pm_runtime state for
all clocks while printing the clock summary. While that's a debugfs
function, it's still something that many people have likely exercised
and it's likely not going to introduce random/long tail problems.


> +/*
> + * Call clk_pm_runtime_get() on all runtime PM enabled clks in the clk t=
ree so
> + * that disabling unused clks avoids a deadlock where a device is runtim=
e PM
> + * resuming/suspending and the runtime PM callback is trying to grab the
> + * prepare_lock for something like clk_prepare_enable() while
> + * clk_disable_unused_subtree() holds the prepare_lock and is trying to =
runtime
> + * PM resume/suspend the device as well.
> + */
> +static int clk_pm_runtime_get_all(void)

nit: It'd be nice if this documented that it acquired / held the lock.
Could be in comments, or, might as well use the syntax like this (I
think):

__acquires(&clk_rpm_list_lock);

...similar with the put function.


> +       /*
> +        * Runtime PM "get" all the devices that are needed for the clks
> +        * currently registered. Do this without holding the prepare_lock=
, to
> +        * avoid the deadlock.
> +        */
> +       hlist_for_each_entry(core, &clk_rpm_list, rpm_node) {
> +               ret =3D clk_pm_runtime_get(core);
> +               if (ret) {
> +                       failed =3D core;
> +                       pr_err("clk: Failed to runtime PM get '%s' for cl=
k '%s'\n",
> +                              failed->name, dev_name(failed->dev));

If I'm reading this correctly, the strings are backward in your error
print. Right now you're printing:

clk: Failed to runtime PM get '<clk_name>' for clk '<dev_name>'


With the printout fixed and some type of documentation that
clk_pm_runtime_get_all() and clk_pm_runtime_put_all() grab/release the
mutex:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
