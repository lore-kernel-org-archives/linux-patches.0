Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01AE273D7
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jVZ0pxNS"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-35137ab766dso103035ab.0
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 06:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696514071; x=1697118871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ew9CTKew+cNKDMIx1MC3uW3wssgAAZXIEhM/ZHhaWJ0=;
        b=jVZ0pxNStIO+Gupb1lSGyN13/0UDFStcatyc/kiHEJcLtiYi0egfZd4Ao9Q34G3JtJ
         XQusOZQu4brnVSCf5W1mmVuKDI6/aJEf9fh/oN/H/NG2Pepk+2QrBgm+omqbgLw1JBSt
         vQuk9bsjhKGeyTGJTGwjqjXZN/53HV4T499sA9L7+SWEgrQfg+1A0m177rw0ICUsxZBY
         DZrwZloHBlNLTQ9bO5KNC489QmGMXS1yuNBoDQTf3AjDlt4R+awBIbPmH8r7gTMBp4wC
         W1gX3DNSxxtHEbi28G2qgL6PeFFjftkKdfMC1A0rNVnH7ChhcSIbnq9WnFAvqGioftoS
         M7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696514071; x=1697118871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ew9CTKew+cNKDMIx1MC3uW3wssgAAZXIEhM/ZHhaWJ0=;
        b=Y1JH+RM9pwoZlwDZwG3DJfhLtewkCbPo2QLc480v1k0NLY/F2hEbv2SApQpctbKcVW
         5u5yXyCt1YZ2PUXCrnU47Xubx77p4KwCnfg3WibzJM+fLWk01ptHSNFrnEhdI45mc6JP
         zy9WjooJHGbpfekBukV8pYBgfUxIo+ByTjqAJfJf71Hw87cg6CRRd4ehxJazPnffeE/J
         NtEWrB8jPRYSJZUjR9paAN5t1EI6wqzkoExj2Aq+xn4yKw/lRhfETnlWKOQURI0WTJXm
         aHQe8azMDpDoLQaDi3RgeqJ1kjtIIMNJ88WLbb16lVJY0CO6Vyh81QokKP5FKTmddSs0
         ZosA==
X-Gm-Message-State: AOJu0YxRCVNyH6vtCCdoAhmdgHc0K9g7Ep/YCsHujo9+hDBxNwJbVYwW
	Dhr3DkEiC2f9oqptqLgvTHHlA1yub4MohzaFMWAqKw==
X-Google-Smtp-Source: AGHT+IEEpGtcQmmMc7Y4hT3qxAHVbBwnHipMfrrp4VL2FyrhIgPoNA5lg0uZ8fMpf6SuuSR8a5DqyNPv+lFAdbbSKeg=
X-Received: by 2002:a05:6e02:1aa7:b0:34c:b016:ede5 with SMTP id
 l7-20020a056e021aa700b0034cb016ede5mr104452ilv.26.1696514070717; Thu, 05 Oct
 2023 06:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230928191350.205703-1-tony.luck@intel.com> <20231003213043.13565-1-tony.luck@intel.com>
 <20231003213043.13565-9-tony.luck@intel.com>
In-Reply-To: <20231003213043.13565-9-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Thu, 5 Oct 2023 15:54:19 +0200
Message-ID: <CALPaoCh0BJSiMG5GjCsFYQDbrUO1q31VCpo403+A4EX0KkJ-TA@mail.gmail.com>
Subject: Re: [PATCH v8 8/8] x86/resctrl: Update documentation with Sub-NUMA
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

On Tue, Oct 3, 2023 at 11:30=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
> per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
> their name refer to Sub-NUMA nodes instead of L3 cache ids.
>
> Users should be aware that SNC mode also affects the amount of L3 cache
> available for allocation within each SNC node.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> ---
>
> Changes since v5:
>
> Added addtional details about challenges tracking tasks when SNC
> mode is enabled.
>
> ---
> diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/=
resctrl.rst
> index cb05d90111b4..222c507089a5 100644
> --- a/Documentation/arch/x86/resctrl.rst
> +++ b/Documentation/arch/x86/resctrl.rst
> @@ -345,9 +345,9 @@ When control is enabled all CTRL_MON groups will also=
 contain:
>  When monitoring is enabled all MON groups will also contain:
>
>  "mon_data":
> -       This contains a set of files organized by L3 domain and by
> -       RDT event. E.g. on a system with two L3 domains there will
> -       be subdirectories "mon_L3_00" and "mon_L3_01".  Each of these
> +       This contains a set of files organized by L3 domain or by NUMA
> +       node (depending on whether Sub-NUMA Cluster (SNC) mode is disable=
d
> +       or enabled respectively) and by RDT event.  Each of these
>         directories have one file per event (e.g. "llc_occupancy",
>         "mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
>         files provide a read out of the current value of the event for
> @@ -452,6 +452,23 @@ and 0xA are not.  On a system with a 20-bit mask eac=
h bit represents 5%
>  of the capacity of the cache. You could partition the cache into four
>  equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
>
> +Notes on Sub-NUMA Cluster mode
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +When SNC mode is enabled Linux may load balance tasks between Sub-NUMA
> +nodes much more readily than between regular NUMA nodes since the CPUs
> +on Sub-NUMA nodes share the same L3 cache and the system may report
> +the NUMA distance between Sub-NUMA nodes with a lower value than used
> +for regular NUMA nodes.  Users who do not bind tasks to the CPUs of a
> +specific Sub-NUMA node must read the "llc_occupancy", "mbm_total_bytes",
> +and "mbm_local_bytes" for all Sub-NUMA nodes where the tasks may execute
> +to get the full view of traffic for which the tasks were the source.
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

Sounds better, thanks.

Reviewed-by: Peter Newman <peternewman@google.com>
