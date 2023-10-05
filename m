Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABE228E28
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bswIMH9z"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-351367c1c24so85925ab.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 07:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696516084; x=1697120884; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ybf0NvxyfgOVHv/GEAtcS44ETu+aNcIhjMUXTQXq/oo=;
        b=bswIMH9zuthiECFYEXVxvGpPaOyh0u+LX9vZlCv9ODCYvV/LCc8nTaeuVCUa7W2VJi
         hzg+hP5/NYaZN9mTtvzenM0Wq+gkXdV1MtapdfBukIwbmNatZz0s29eA2FyulEJJNXwg
         ldTanrWxfIIU8mQF6dD5jp4Y5toFZaxEO/SgTwzuwnqTbFtRGE4Tx9XDaDthr96vl3Zt
         UqIe2U9jncxLVZaACaczWdzkaVB3bPLDgKOkLa5tOarEFA+qn8/aaxKP1zYfeoih+WWh
         TZldwKkDogz13eULPoHfbfHRehG8NpLungsWwxy9ZeHK1UAt4H1lpAkfzUSjdE85/0bX
         KkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696516084; x=1697120884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ybf0NvxyfgOVHv/GEAtcS44ETu+aNcIhjMUXTQXq/oo=;
        b=MePbf/cnHNO+OP3lUs5fFGtWdRALtNSL7QisuB8sgEHoGcJ3EpWD+ePyo5jR5B0xCL
         weKaUQU63tye3CAU4M97D+baQXVoMv1HqT3guOxFUO3Tl+R95WhdLbrO0ZTPf7Omz88E
         nZIxrn+Y1xav1uP6gdzG+tMucMQPLQLsFxYt8M+5ehBRNPYOE0oSohar3+ks0B17J9Wn
         WmwXZY9k00b2PGEPMqpTiskhPhdk/PYDyxQt29oaNOeEjqRBiivtg0L/2gPwYMhHv7kt
         KsrChztRc+4PXvt3lfxsJa+9Ac/Mwpp+yR5b8Y+nHY/ZiJqmi33xYCobFbEDV7E7IhmG
         B8/Q==
X-Gm-Message-State: AOJu0Yx1z3cbnhSie/gL2BgxU53lqOJnYsn5I1VCSsiz8Bn6GCylF7Nk
	Kw0sm4Ab/2jrVQBUVzWT5dd5iU17+g/LXx3Aqi4JCg==
X-Google-Smtp-Source: AGHT+IFvw6IhRVN0H3jLFsLkccwcXRU0R1gonoMQf+gJvBTEY0T903zokI27tID8lLZZIeAVp3qcWUQFrGbYz0QRbi4=
X-Received: by 2002:a05:6e02:2141:b0:34d:f90f:d42a with SMTP id
 d1-20020a056e02214100b0034df90fd42amr124815ilv.1.1696516084281; Thu, 05 Oct
 2023 07:28:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230928191350.205703-1-tony.luck@intel.com> <20231003213043.13565-1-tony.luck@intel.com>
 <20231003213043.13565-2-tony.luck@intel.com>
In-Reply-To: <20231003213043.13565-2-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Thu, 5 Oct 2023 16:27:53 +0200
Message-ID: <CALPaoCg7ov97uSKk8K4O5_GFKvnHSCSK79g-boPMQKhziS49hw@mail.gmail.com>
Subject: Re: [PATCH v8 1/8] x86/resctrl: Prepare for new domain scope
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 3, 2023 at 11:30=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu=
/resctrl/rdtgroup.c
> index 725344048f85..04c164f6d39d 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1345,10 +1345,13 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_reso=
urce *r,
>         unsigned int size =3D 0;
>         int num_b, i;
>
> +       if (WARN_ON_ONCE(r->scope !=3D RESCTRL_L2_CACHE && r->scope !=3D =
RESCTRL_L3_CACHE))
> +               return size;

Thanks!

Reviewed-by: Peter Newman <peternewman@google.com>
