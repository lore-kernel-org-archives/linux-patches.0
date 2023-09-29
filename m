Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61FC513D3
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 14:32:41 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-41958410e5cso391891cf.0
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 07:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695997960; x=1696602760; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJFVcdWCqcDV6qycuab+i81ZPsWdTYGA5ipCa8aCpMg=;
        b=tsmj8BZ7/QAA47QjJuZ5R7F92PU0fJSLmqScSMTkY0zMHq4Z1X1vuwti/JPnbPTeNy
         L/iJJFqt9+OC6YrWXFwuipk17KLi6y+bjxuaqR0LG5/kxLE0/LvWa2UrGMy5QAKkyKpn
         SfACWwVxDl+mpoaiPNAGcGnnHvmcyH29GJ036dVqPtkOF0mJM6imBpXPS/rFfZQTSlTQ
         qSWwRpnwBAFVj2THyDLrsIUpVxC+6oaLbpb392yI6mgobYQi/Hb0ToiQ+EJn2hSX/tOf
         w4N0i7lQta/jpl9TacucS4zh2/olk6xOaTjUUhEQDkrGIs0f0Ro2N/EzQjmYHETBbjRj
         1LRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695997960; x=1696602760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJFVcdWCqcDV6qycuab+i81ZPsWdTYGA5ipCa8aCpMg=;
        b=SMN6cSCNfPZImSEg7iiBllmvqLJvZbUyhkQrAzjcb/K6IAe4Hku9tcX3UNzKMhVURE
         lZu7zBW4z8xKHsJ3PS5ZDJB4zK0C/KI60cKsWaNd2vTHg/VUJuhO/eIbBYcQwKd4jhjL
         3OuNmBgfuWR7in1prC5+zci5qNGs9qJK56sbsyCjByTDhP4Tv1S30EJgG/3zr+8Zj5/C
         OWnwgA8GrY22ESdCaCM2patZDCauc2uK7pSxYeuBpsG0/Oo6klpPvTiUQe9zHZkdEhlG
         RmE1VIu7yxIAtYWzt+1Sey0RqBcK7ZLo1lDfk+l08v4gzEkKZGELx7zDIw9gnUQscrRo
         mVaw==
X-Gm-Message-State: AOJu0Yykyz1CVUj5YPb0s8+EN9wSLWsHf9OpuYY6NBQXq48bMUbP073D
	xdVaZlEP5ZPtTxtD4DVI1ZKe/hxKNi4K1V+OEU9WZg==
X-Google-Smtp-Source: AGHT+IFAwQTjk3G75M/yQUuug/Yw85V4PBTHHuarGfbIzYyACFPixSdSwaUBRfdVtxsTVRDlGbcksaa4RTXqRz4Mdrs=
X-Received: by 2002:ac8:5885:0:b0:404:8218:83da with SMTP id
 t5-20020ac85885000000b00404821883damr1154536qta.1.1695997960490; Fri, 29 Sep
 2023 07:32:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-8-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-8-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 16:32:29 +0200
Message-ID: <CALPaoCjegjOYvOK7a5mVONpm5G6Q-BK-n7-U3EP5mzyhTRL=yQ@mail.gmail.com>
Subject: Re: [PATCH v6 7/8] x86/resctrl: Sub NUMA Cluster detection and enable
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

On Thu, Sep 28, 2023 at 9:14=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
> +static __init int snc_get_config(void)
> +{
> +       unsigned long *node_caches;
> +       int mem_only_nodes =3D 0;
> +       int cpu, node, ret;
> +       int num_l3_caches;
> +
> +       if (!x86_match_cpu(snc_cpu_ids))
> +               return 1;
> +
> +       node_caches =3D bitmap_zalloc(nr_node_ids, GFP_KERNEL);
> +       if (!node_caches)
> +               return 1;
> +
> +       cpus_read_lock();
> +       for_each_node(node) {
> +               cpu =3D cpumask_first(cpumask_of_node(node));
> +               if (cpu < nr_cpu_ids)
> +                       set_bit(get_cpu_cacheinfo_id(cpu, 3), node_caches=
);
> +               else
> +                       mem_only_nodes++;
> +       }
> +       cpus_read_unlock();
> +
> +       num_l3_caches =3D bitmap_weight(node_caches, nr_node_ids);
> +       if (!num_l3_caches)
> +               return 1;
> +
> +       ret =3D (nr_node_ids - mem_only_nodes) / num_l3_caches;
> +       kfree(node_caches);

It seems a little peculiar to free node_caches a couple of lines after
you're actually done with it.

> +
> +       if (ret > 1)
> +               rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope =
=3D RESCTRL_NODE;
> +
> +       return ret;
> +}
> +
>  static __init void rdt_init_res_defs_intel(void)
>  {
>         struct rdt_hw_resource *hw_res;
>         struct rdt_resource *r;
>
> +       snc_nodes_per_l3_cache =3D snc_get_config();
> +
>         for_each_rdt_resource(r) {
>                 hw_res =3D resctrl_to_arch_res(r);
>
> --
> 2.41.0
>

Reviewed-by: Peter Newman <peternewman@google.com>
