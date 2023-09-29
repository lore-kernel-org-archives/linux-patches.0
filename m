Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795F3516D9
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 14:54:33 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4195fe5cf73so309141cf.1
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695999272; x=1696604072; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FBAL4EDpae0eUiRs93XffuRh0a5um0LmWA13bYCfeZo=;
        b=mPjqpRl/J4T/wi4bN0NzMIMhWa8DE0ryxRjzsk0c2d8DIffhHHudI+THzzlOawYydw
         LJyqwUNdMlIWIyhKu9wx8mTZY9fAtH2SO0IW8c44hNHjoARmEmoBSCkgyTOqtELYCqws
         c+8E9YytZ6w33GLGsc8chzYs7NymFdlXEOiy20Wmdk2KqHeXbRp+AtokaNGpGbhjB3io
         GGKdhORDPOGP2nSgrzXvxpmwGhnCgdoj0X90BSznnOXK1S+kiDuSP7dq/FzxLKgb8s5P
         czTWN2wQvfwKy4sDdwqS55bfeCrnK+KXHid7TCJp/tjz7F3ZYy3U4vioZLpiJHIRQQgd
         2j2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695999272; x=1696604072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FBAL4EDpae0eUiRs93XffuRh0a5um0LmWA13bYCfeZo=;
        b=DKGA4iQ3Xh3zgfnOHWSPsWbOwgKqyZLknyL0g78Q+F9RPRFkG4+LpF4672wdqW2QmT
         WT6mZ6SDowYgO1I1lwg34ifIOg51LxbrLX4yn8ZwRfOqiWGAXi8uVuHaEDFI9sK8JGos
         m6em8S6h9Y6rC+kWgLZIJCUfmiAoDoqnOKV0RN8q+T5qZ5DAWVNZpuxhLhpQ9BQjCFgr
         CKCjF/vzdcoFtOqz9I+gcDo9I0DTrqBkTvOaxMlzb8KNdm14hB1NPvDMH/ta+sZxxklG
         +vsKiRsvzcq/tIIgGIwz0jj2Vvu3Q3W5zHxkiMBF+ssOVxwdolDQU62oeV013VA41L1q
         jjGg==
X-Gm-Message-State: AOJu0Yz8Wi0B2NywNVtzRbYRSBlv9qoVXmYwRj388wxi0ZMxDGdlUJGA
	G+TZmf1NsQySQO4Qs1iWcLxNvIhm0hKBgUft8QU9KA==
X-Google-Smtp-Source: AGHT+IHdknSO/VSzS3NkRmSfc1a0t3O7BBzcNPYBrwXaAE1EUNUzAdWqe3maQyYUj8GbUdaFGM+Ua3YJrM7ZZKjlU7U=
X-Received: by 2002:ac8:5684:0:b0:419:6cf4:2474 with SMTP id
 h4-20020ac85684000000b004196cf42474mr337653qta.2.1695999272306; Fri, 29 Sep
 2023 07:54:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-9-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-9-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 16:54:21 +0200
Message-ID: <CALPaoCgPXPF_fn9fh15rW0JWUhxth5wOO51n+oHqibP+a6Qjfg@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] x86/resctrl: Update documentation with Sub-NUMA
 cluster changes
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
> diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/=
resctrl.rst
> index cb05d90111b4..d6b6a4cfd967 100644
> --- a/Documentation/arch/x86/resctrl.rst
> +++ b/Documentation/arch/x86/resctrl.rst
> @@ -345,9 +345,15 @@ When control is enabled all CTRL_MON groups will als=
o contain:
>  When monitoring is enabled all MON groups will also contain:
>
>  "mon_data":
> -       This contains a set of files organized by L3 domain and by
> -       RDT event. E.g. on a system with two L3 domains there will
> -       be subdirectories "mon_L3_00" and "mon_L3_01".  Each of these
> +       This contains a set of files organized by L3 domain or by NUMA
> +       node (depending on whether Sub-NUMA Cluster (SNC) mode is disable=
d
> +       or enabled respectively) and by RDT event. E.g. on a system with
> +       SNC mode disabled with two L3 domains there will be subdirectorie=
s
> +       "mon_L3_00" and "mon_L3_01". The numerical suffix refers to the
> +       L3 cache id.  With SNC enabled the directory names are the same,
> +       but the numerical suffix refers to the node id.
> +       Mappings from node ids to CPUs are available in the
> +       /sys/devices/system/node/node*/cpulist files. Each of these

The explanation of mon_data seems overwhelmingly SNC-centric now.
Maybe the SNC section should be responsible for explaining its impact
on the mon_data directory. Mainly by reminding the reader that domain
ids in the mon_data directory are node ids in SNC mode.


>         directories have one file per event (e.g. "llc_occupancy",
>         "mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
>         files provide a read out of the current value of the event for
> @@ -452,6 +458,28 @@ and 0xA are not.  On a system with a 20-bit mask eac=
h bit represents 5%
>  of the capacity of the cache. You could partition the cache into four
>  equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
>
> +Notes on Sub-NUMA Cluster mode
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +When SNC mode is enabled the "llc_occupancy", "mbm_total_bytes", and
> +"mbm_local_bytes" will only give meaningful results for well behaved NUM=
A
> +applications. I.e. those that perform the majority of memory accesses
> +to memory on the local NUMA node to the CPU where the task is executing.

Not being specific about why the results aren't meaningful, this
sounds vague and alarming.

> +Note that Linux may load balance tasks between Sub-NUMA nodes much
> +more readily than between regular NUMA nodes since the CPUs on SNC
> +share the same L3 cache and the system may report the NUMA distance
> +between SNC nodes with a lower value than used for regular NUMA nodes.
> +Tasks that migrate between nodes will have their traffic recorded by the
> +counters in different SNC nodes so a user will need to read mon_data
> +files from each node on which the task executed to get the full
> +view of traffic for which the task was the source.
> +
> +
> +The cache allocation feature still provides the same number of
> +bits in a mask to control allocation into the L3 cache. But each
> +of those ways has its capacity reduced because the cache is divided
> +between the SNC nodes. The values reported in the resctrl
> +"size" files are adjusted accordingly.
> +
>  Memory bandwidth Allocation and monitoring
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> --
> 2.41.0
>

Reviewed-by: Peter Newman <peternewman@google.com>
