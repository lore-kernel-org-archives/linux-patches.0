Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1B67F
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 12:47:50 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4007b5bafceso397691cf.1
        for <patches@lists.linux.dev>; Mon, 26 Jun 2023 05:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687783670; x=1690375670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vyEDqjnLut49ARt31W5hpg3PmjCUAUxnPXi+41gN+q8=;
        b=FRdAoSSh5TQTJl4OqCbbCHsE22mVG6Ok5OCrn5MKeK9kHtq19PJVM8DiZyrC3F9WR1
         m+sAiS7q08Pg26fdbJNUqSUEvU4s7vs3CerZVVemANxcC2JLYHWTTPU9KKFyUOaP9Dhi
         2RuzdRpWzOs57WG+Ych5/DQx5tsVNKd23Fzhgrqoc6UULqtnmt+RZ/DGUkN4Sx/rqLr8
         LcB1VJjSnUFrmUQOx6Mze0kNLJnuoaruY7QRt52ABqThUO8APi9mfloEAh602SmPLt9M
         TbSIGp5jx/iyXRjh+1QT75JKoBGehEg+mDrDwjLHPWke4MMOAWkb/K/0b0WVJQx7YLGu
         +nVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687783670; x=1690375670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyEDqjnLut49ARt31W5hpg3PmjCUAUxnPXi+41gN+q8=;
        b=FevWPWzOAP0TWKPKj+D5yvpNrGQlgfGAvkeAx5bsShDhDuOzRMiH75VNmL7MONRYkS
         Udr/EZVAxsKYfvkn1GphLYY3TMubye297pdYlpDjoiVvi7g6/6126HB/MT9vGraq5yqg
         8kX1GYgsm1cVbkt0y8FcoPm76LAMz+h5y1800hc7EtoozzssP8X3rKMpoUG9OLYuP9i2
         wfcAQ0Ajz060UbgTV9VsmII6j3XH++ZtGPuFRjs54jo8aDj/JyKTCV3N9wMwV/tfuNDr
         EeWKIg6vgGHUoVibTPqLYvJvYsrirL1reQPV3ztz42Fa7mhz4vKrAtU2quhIHLmFdHtO
         oYyA==
X-Gm-Message-State: AC+VfDwfTy0t5L/R2OEKaezCuGlBndjPejVz+9Wuut9Gdc8rgnCD2UgJ
	Cy1nbqSJjkNAP8JGMVRGK2XIgRmi7JmXZHLkSHeztw==
X-Google-Smtp-Source: ACHHUZ491LjK2ZJ8DT1B1XEsv5vgGnY5irD3vwsmbd6T7VFu6qmyS/3Aybli2welLnSM5TpKJT1Voijj6VeAHGptqkU=
X-Received: by 2002:a05:622a:134b:b0:3f3:75c2:7466 with SMTP id
 w11-20020a05622a134b00b003f375c27466mr334768qtk.8.1687783669742; Mon, 26 Jun
 2023 05:47:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230621174006.42533-1-tony.luck@intel.com> <20230621174006.42533-8-tony.luck@intel.com>
In-Reply-To: <20230621174006.42533-8-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Mon, 26 Jun 2023 14:47:38 +0200
Message-ID: <CALPaoCi+A5TxoReh=HRMsRKYDWb4eQ-NOB75Lj9674L6aV0T=Q@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] x86/resctrl: Determine if Sub-NUMA Cluster is
 enabled and initialize.
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Shaopeng Tan <tan.shaopeng@fujitsu.com>, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, Jun 21, 2023 at 7:40=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:

> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctr=
l.h
> index 255a78d9d906..f95e69bacc65 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -35,6 +35,8 @@ DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
>  DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
>  DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_key);
>
> +DECLARE_PER_CPU(int, rmid_offset);
> +

I assumed that declarations in this file were those needed by
__resctrl_sched_in(). Now that rmid_offset is used when setting
PQR_ASSOC, would this go somewhere else?

Other than this and fixing the MSR update, the series looks fine to me.

Reviewed-By: Peter Newman <peternewman@google.com>

Thanks!
-Peter
