Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DF328E5
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 17:39:27 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id u10so10744204vsu.13
        for <patches@lists.linux.dev>; Fri, 18 Feb 2022 09:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0NhB1xsVCUvvgT8xA5VIM+U/pg8RDe8EADZNUdbmpw=;
        b=LQlGKbvYmoghEDOz5mAfbSZPQkv9R6f2PjO4g3ZFPDnIXwP1lLVPJ5YIbRGtI7uAtx
         iqeVrwXL3aFY+U3ilfBt9nIAXyEAkLvuaj0j2O6q+oL1nMYnzyM3cfxm5WdnEM6Rr+Yw
         AyVUuarJkT+7aDv1gxDQMrtFRE6TueKIeUiiCTmeLHNx+iEWOgdDvCwV2+C2ExC8MjT9
         Qf3RSPskYUcr1y2ZqortgdG723i6PYuX+f6Abej0MKG9zikCic40qsCz45QuCAtv6v5A
         4jJh4U3Wi1Dk6QHBouD0TVocOYoHNB6/XeGapQbTLlh25DgLOsTCIbG5svtly19Wvsb0
         VfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0NhB1xsVCUvvgT8xA5VIM+U/pg8RDe8EADZNUdbmpw=;
        b=NCiUWqYXVq2hX9qkNLBob76XwsuRZNcOsLyufif/eZkHgyFhnkYt/Nx+zVosTf3E1U
         GgS9nHH/RS9JFxYUphlE2e+jo3oWKQRuS+0UJ2ahNjk6YOjhwTaIQX5kwqT+omHRcSVH
         N74KE1JRZtpSbCTTBzKWGUNmCEn2yTMYZFTDDnwF1ySRH934loG39NtOpFeuDxubqfp4
         p3CxQv4qKmgQgM5j45YrNKDF1jVPkvLvmCDRe2LrbYIJO9CLEsG9BO9/KCwwBrAfpn9y
         2ea0eNdwPCBxFZKHfhIFHEpj1y+KPDuyCFEAjmSIJo60NSdGarlB03OHFPzy9v5m76p/
         NUoQ==
X-Gm-Message-State: AOAM532rzfCCy3gpdnMp9FDKHiCKcqnQM/Mz0DaDp137ox9BCsLwn6nw
	qOVExoPXjCJG/fqY4od3TCa/R3TVHJorKcbQ6MhqVA==
X-Google-Smtp-Source: ABdhPJzPtL5T94v2FfTMvYe30S9B0+OgBIA4Vcx+QVmdo52/ZERaYyOJ9hOhkCyysOd3cQ7mW/ZjrMqjQKZ6iI+XVHE=
X-Received: by 2002:a67:c081:0:b0:31b:8d09:7e25 with SMTP id
 x1-20020a67c081000000b0031b8d097e25mr3768382vsi.42.1645205966074; Fri, 18 Feb
 2022 09:39:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yg54nse5qNQO3sbW@zn.tnic> <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic> <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
 <Yg/FyrvLWhZHB/UC@zn.tnic> <CAPcxDJ72dMOpbKXxyb__OeMaEyjYSPtsL_ubVsKOuRXefAQ3_w@mail.gmail.com>
 <Yg/UUHuVvd9AOJ94@zn.tnic>
In-Reply-To: <Yg/UUHuVvd9AOJ94@zn.tnic>
From: Jue Wang <juew@google.com>
Date: Fri, 18 Feb 2022 09:39:14 -0800
Message-ID: <CAPcxDJ5aB131SqXM3S7Etpj_B6AqVcpLJviMsfvFPbUSGjBb_g@mail.gmail.com>
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy instructions.
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 18, 2022 at 9:16 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Feb 18, 2022 at 08:21:36AM -0800, Jue Wang wrote:
> > My concern was that here returns 0 instead the value read from the msr.
>
> You'd walk into that code only if you're doing MCE injections. In that
> case, it won't read or write MSR_IA32_MISC_ENABLE because the injection
> code writes into the injection mce struct only.
>
> So it won't disable fast strings when you manage to inject the exact
> error type which triggers this erratum.
>
> I think that's actually a good thing - you don't want to disable fast
> strings just because you injected a particular MCE type.

Ok, makes good sense.

Thanks Boris!

-Jue
>
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
