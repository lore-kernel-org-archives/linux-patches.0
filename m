Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CB23A7
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 09:19:37 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id w23so12425410qtn.6
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 02:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678699176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93MKTJ9MDWn/ISNqBQPEJ2VlVirpHbQ1K4GLOntiehI=;
        b=rlEA0ETcSyUHcKQJobtYi1UQrzazm3+qY4VxhVcM1WZHWp6UoKzQ2Izab3CjCxA7+c
         WtlHpVASlkXH+YM9KwRl6+6grgGOTmCjBQq45rPLXKU+LTO9wtMPqBuFvO8VL4MY4k5I
         kgYBW5GLz4fdeAencuAeQYCZWBpo/7JShYmyOuSHBJMrVMSH0Atl0AFJkEbqmHn6pxa3
         n5bJd/8OrSRy6yZSH2z5Hf+lFw/RdudG/C1xDIqjKfYNdM2pa+4mfXHsHNP37UxXssbn
         w1vK35BDCu+8l9fiJLiOZGffC+gVqyAamrMpZMjtJgrhw70mbeeZt8VE+XzE2GItp1RV
         IsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678699176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93MKTJ9MDWn/ISNqBQPEJ2VlVirpHbQ1K4GLOntiehI=;
        b=7wGkR7iYE3go6ncL6pxh1x9ItPJWKLG1iF8JjiONpbZliSdMZTeo3HlSApiXsIFotQ
         aGnv+/2HU70f1wEn6uesbEb6XpeiSSLvcgJR/IX8etywDW5Az++IsMZUbEf/FC/lOlbu
         kiGIQfR+4K89ofIEyEHRhfrZlZbB1rfuKP5n/3Uo7bn/r5q4H3CKhkhu+EMuw7vYTJi4
         QuCcAR9zX7/7mYdnG5mZ6Szg36Y4iynCqm7r5ALTmKuIuqOT2IrJ1usXAgvMGDF5BkZz
         fdKLm75Hc6Bgse0eJhsnqdJNt3iSSZD/061vLgLHqb5QIXHU0zWxd+5fzicoABGiCOTS
         mZ9Q==
X-Gm-Message-State: AO0yUKVJvzK26bmQZm0XwhxBS8RgN8JVqbu2nwRYYlZfRpf1LaQ8EZ3O
	BDm0JWiLlu3zM61tXcHJXAtg3ffS2LVqmp4cOCX9cD++oWtMFN36fYtqFg==
X-Google-Smtp-Source: AK7set9VU11box7gOTFGJkfvp8eIs4eJi59Sw1fXt2hbhwVTZ4v59SG61KE4Kh/xDpZsPIzYtucHidOGr02cSM+MI8U=
X-Received: by 2002:a05:622a:4008:b0:3bf:c34b:d45a with SMTP id
 cf8-20020a05622a400800b003bfc34bd45amr3065615qtb.5.1678699176594; Mon, 13 Mar
 2023 02:19:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230126184157.27626-1-tony.luck@intel.com> <20230126184157.27626-8-tony.luck@intel.com>
 <CALPaoCgnOWLdEqKtonNeq+d_Fj0yr3Y7tgwwmAHmuhL5xBhqyg@mail.gmail.com> <ZAtpTl+um3nbCOz8@agluck-desk3.sc.intel.com>
In-Reply-To: <ZAtpTl+um3nbCOz8@agluck-desk3.sc.intel.com>
From: Peter Newman <peternewman@google.com>
Date: Mon, 13 Mar 2023 10:19:25 +0100
Message-ID: <CALPaoCiQMxgjusRzQMWhKJHtB2CYVOp3UaXpwPYYpO4VC+0KzQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] x86/resctrl: Determine if Sub-NUMA Cluster is enabled
 and initialize.
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Shaopeng Tan <tan.shaopeng@fujitsu.com>, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Fri, Mar 10, 2023 at 6:30=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
> Tell me more about your CPU-less nodes. Your fix avoids a bad
> pointer reference (because cpumask_first() returns cpu >=3D nr_cpu_ids
> for an empty bitmask).
>
> But now I'm worried about whether I have the right values in the
> formula:
>
> nr_node_ids / bitmap_weight(node_caches, nr_node_ids);
>
> This fix avoids counting the L3 from a non-existent CPU, but still
> counts the node in the numerator.
>
> Is your CPU-less node a full (non-SNC) node? Like this:
>
> Socket 0 Socket 1
> +--------------------+ +--------------------+
> | . | | . |
> | SNC 0.0 . SNC 0.1 | | zero . zero |
> | . | | CPUs . CPUs |
> | . | | . |
> | . | | . |
> +--------------------+ +--------------------+
> | L3 Cache | | L3 Cache |
> +--------------------+ +--------------------+

In the case I saw, the nodes were AEP DIMMs, so all-memory nodes.

Browsing sysfs, they are listed in has_memory, but not
has_normal_memory or has_cpu.

I imagine CXL.mem would have similar issues.

-Peter
