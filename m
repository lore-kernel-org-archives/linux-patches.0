Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EAD224FB
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 12:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TTV7/yg7"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3575826ba20so94715ab.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 05:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698238025; x=1698842825; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJxjqRLgdOTokPI2dBdsj6G6P4onvQmQvzd+w/Pmuro=;
        b=TTV7/yg71Y5PnHPp2au5KantIfCYKvjZ9Bbxo+nCR0yLFf+lxMzlko8Hpo+QgFtxCf
         k8WhhtvN4O5O3O/RMMFzju4atB9/9vyhHOHnpn/B2k9LF56Z3cUjQzuv1amiID93B5wK
         Vd9AXzzMyLOSgQA81P2fDygl+QXrHqRrGbosY9MhD3UoVxIjVJ/WV8iLHpfo+K+Q5js7
         gkR6e61H1zpVBbV/EZoy4ghV5sb0hpTO5knB8o5GxdI5xEkUAjpmDkp1RolqMZ4qdxtM
         8Pta5jhR3NX8j0LbN4BvDHNqMK3UxFMSiBuJ13FBLiHgNWwUXGT0q2BAmVBNEuoLPKDK
         7zNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698238025; x=1698842825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJxjqRLgdOTokPI2dBdsj6G6P4onvQmQvzd+w/Pmuro=;
        b=Fsy0PZUyj3hmanD3+naG3k9uHuM0kiB5abjZWFQJ1rkbPdpZxLAeGaFkwTWwYcDmuG
         UBzRhHYen2mIFIIqx7+YA32mLJmkEY4spkG/oQ/9Wm+3MqE1DjOmkm6F9u0AG8xJlchL
         L/02lFjCxGoXuhNTv6vlVUo/bRJRQMVk+JmIgj5WxD3UpO1sA0mbrOOlZT5Zc6h67Apk
         8WBTq02DI/B3YMkFoP34ychtv70tbBllystHNYdtHbjknTIdPCmwJitGPuFE2Ljnd4rp
         8MpX2SJbSxO2dzHURVY8RG8wbglm2wOmc2KKgUcHCvLo5vA0ISC7y+azRY7mGidT241Z
         OoGQ==
X-Gm-Message-State: AOJu0YwdwUpBevFINs2WkCkDpbZn+StkFpZ62yff31nTW7tp4uHnWBdh
	51/2HYMRu5JV/fjdAoHUMzsZk/ipfdN2YXFgF7R4Ng==
X-Google-Smtp-Source: AGHT+IFGpxrkAvVp6+0E7/WqwAn933CD5Xj0OXEGjguHzqWRxId8NLFOVha5htsC5vsrifflo+7QyGx0F73yiS9Alzs=
X-Received: by 2002:a05:6e02:b24:b0:357:cb1a:9621 with SMTP id
 e4-20020a056e020b2400b00357cb1a9621mr218988ilu.10.1698238024990; Wed, 25 Oct
 2023 05:47:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231024181600.8270-1-tony.luck@intel.com>
In-Reply-To: <20231024181600.8270-1-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Wed, 25 Oct 2023 14:46:53 +0200
Message-ID: <CALPaoChftF-H6GauKq4-c_qBJP1GJbR3-ByE5krsaQF4y4y9oQ@mail.gmail.com>
Subject: Re: [PATCH] x86/resctrl: mba_MBps: Fall back to total b/w if local
 b/w unavailable
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Tue, Oct 24, 2023 at 8:16=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -418,6 +418,14 @@ static int __mon_event_count(u32 rmid, struct rmid_r=
ead *rr)
>         return 0;
>  }
>
> +static struct mbm_state *get_mbm_data(struct rdt_domain *dom_mbm, int rm=
id)
> +{
> +       if (is_mbm_local_enabled())
> +               return &dom_mbm->mbm_local[rmid];
> +
> +       return &dom_mbm->mbm_total[rmid];
> +}

That looks very similar to the get_mbm_state() function I added to
this same file recently:

https://lore.kernel.org/all/20221220164132.443083-2-peternewman%40google.co=
m

I think the name you picked is misleadingly general. "local if
available, otherwise total" seems to be a choice specific to the mbps
controller. I think these functions should be reconciled a little
better.

Other than that, looks good.

Reviewed-by: Peter Newman <peternewman@google.com>
