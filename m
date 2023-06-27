Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3758481
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 08:43:04 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6b73741a632so2212275a34.3
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 01:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20221208.gappssmtp.com; s=20221208; t=1687855383; x=1690447383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BOVGzv5gZQT5jSubIVXjptuCNnBh8KCPsg9XhVgkYds=;
        b=qF7pe/eTDWwlIOgdKy+XntO9/qQjd/Mo35J0P2G6aB/V6IIrd9y79UGKnpUjW1SBIP
         DAXh8yxBqO7WU27DBOFqa+GHYmHR5A2XkUeR4mrIMD5Zv+H1wzeGItshBFAOO3apHyyj
         wCM74z4snasX0Yvj+t/IRFh30MFV+g+sP3K8nhuWfEbQMKh9V9DRInZMqVBULN6AjDPb
         aPj3PJAVGpTh8CTDD9QX0I37f9hliLikIIxWFZwfZH72kfSc0g4ybzOrZpsKuO65pbci
         CzyrAPBYSFghtH1trdfzg2Avi22EG91JIWxEOqRt+nJ9tb/wnhtXSZYmki7PIQfz5363
         /U3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687855383; x=1690447383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOVGzv5gZQT5jSubIVXjptuCNnBh8KCPsg9XhVgkYds=;
        b=KQLgVt+Ge0b4r5zqPoEga/f1mI0C7DTy8SZLp6PHbqyhtIp7usMhPicLjgqSogVjnm
         RqUDZcjx7lioVDdZED6+wqP+1YccHCuOUTcR66amuBKYWVwQ8aYN0zhxpq8mMwnxD6qw
         zAV0ux67HGIYR/H5i/YKvBeIpGlppUfIqH5V0cz7/CmBU0wsBi6DRurQV/ZcNZsYW0xl
         Bb+8M+IHvELw+Wq50iVIlQRNznkZcKZnM9DpzCL5haujfL1/VH4sasvO49FI9RU/AHZD
         3T8eQ5CG3N4xPVpo583R1pr9dHbF2kmx/CwzW6cPJTIKaXtBHSlRHXmPDkqpKS/zWNtK
         iZAg==
X-Gm-Message-State: AC+VfDyfr5c2NAhqj/OMISwbwljK6PytlStXIEn6vGwSun04vQshFvlv
	CLHWOjwuCVT+eVxKFvk+iDm2dg==
X-Google-Smtp-Source: ACHHUZ4JQjFu848but7CpguQ3QU5A0ATCjQW8MWbCGkjWKs0OiGAU+V/D+opNa5NXRS9EEQGSILlpQ==
X-Received: by 2002:a05:6830:11cf:b0:6b7:574c:82d with SMTP id v15-20020a05683011cf00b006b7574c082dmr3152710otq.7.1687855383385;
        Tue, 27 Jun 2023 01:43:03 -0700 (PDT)
Received: from x1 ([172.58.111.212])
        by smtp.gmail.com with ESMTPSA id w13-20020a056830060d00b006af913c1044sm3422180oti.16.2023.06.27.01.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 01:43:02 -0700 (PDT)
Date: Tue, 27 Jun 2023 10:42:53 +0200
From: Drew Fustini <dfustini@baylibre.com>
To: Tony Luck <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>, Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Babu Moger <Babu.Moger@amd.com>,
	Peter Newman <peternewman@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	H Peter Anvin <hpa@zytor.com>, shameerali.kolothum.thodi@huawei.com,
	D Scott Phillips OS <scott@os.amperecomputing.com>,
	carl@os.amperecomputing.com, lcherian@marvell.com,
	bobo.shaobowang@huawei.com, tan.shaopeng@fujitsu.com,
	xingxin.hx@openanolis.org, baolin.wang@linux.alibaba.com,
	Jamie Iles <quic_jiles@quicinc.com>,
	Xin Hao <xhao@linux.alibaba.com>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>, aricciardi@baylibre.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [RFC PATCH 0/2] Resctrl - rewrite (WIP)
Message-ID: <ZJqhDYLG+/Kr44sp@x1>
References: <20230620033702.33344-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620033702.33344-1-tony.luck@intel.com>

On Mon, Jun 19, 2023 at 08:37:00PM -0700, Tony Luck wrote:
> Back in April I posted some RFC patches that added a "driver
> registration" interface to the core resctrl code so that additional
> resource control and monitor features could be added without further
> complicating the core code. Link to that discussion:
> 
> https://lore.kernel.org/all/20230420220636.53527-1-tony.luck@intel.com/
> 
> Reinette gave the feedback that it would be better to base the module
> registration on the resctrl resource structure. Reinette also pointed
> me to work from James Morse, and some additional discussion happened
> here:
> 
> https://lore.kernel.org/all/ZG%2FMZVrWYrCHm%2Ffr@agluck-desk3/
> 
> James provided details on where ARM's MPAM has similarities and
> differences from the Intel Resource Director Technology and AMD's
> similar implementation. Drew Fustini was also pulled into that
> conversation to comment on RISC-V CBQRI.
> 
> >From those discussions I believed we need a do-over on the core
> /sys/fs/resctrl implementation to make it friendlier for architecural
> variations. Here's what I have so far.
> 
> =========================================================================
> | N.B. This is a general direction check. There are many obvious        |
> | rough edges (e.g. some careful thought needs to happen on locking     |
> | for the files in /sys/fs/resctrl that are "owned" by modules that     |
> | can be unloaded). I'm mostly looking for feedback from AMD, ARM and   |
> | RISCV on whether this is a foundation to build on, whether some small |
> | tweaks could make it better, or if this is still going to be really   |
> | hard for architectures that have radical divergence from the Intel    |
> | model.                                                                |
> =========================================================================
> 
> First patch is my attempt at architecture neutral code. All mention
> of "RDT", "CLOSID" and "RMID" have been expunged. When creating a
> new group this code calls arch_alloc_resctrl_ids() to allocate an
> opaque "resctrl_ids" value.
> 
> Q: I made this a "u64" because that neatly allows storage of both an
> x86 CLOSID and RMID (in a handy representation that matches the bit
> layout of the Intel IA32_PQR_ASSOC model specific register). If other
> architectures need something more complex it could be a "typedef
> resctrl_id_t" ... there are a couple of places where we would need
> a comparison function.

This works okay for RISC-V. The Ssqosid extension defines a 32-bit
register sqoscfg (see chapter 2 of CBQRI spec [0]). This contains a
12-bit MCID field (similar to an RMID) and 12-bit RCID field (similar to
an CLOSID).

> 
> I broke the code into several source files that handle different
> sub-functions of core code to make it easier to navigate. Much of
> the code here should look familiar as I did a lot of
> s/rdtgroup/resctrl_group/ on functions from the original resctrl
> code.
> 
> By itself the core code is useless. Cannot even be built as the
> controlling Kconfig option "CONFIG_RESCTRL2_FS" must be invoked by
> a "select" request from architecture specific code that provides
> the necessary "arch_*()" functions to make everything work.

I would like to try to rebase the RISC-V CBQRI resctrl RFC [1] on top of
this patch series instead of the mpam snapshot branch [2].

I had a patch in my RFC that added config option RISCV_ISA_SSQOSID which
selects ARCH_HAS_CPU_RESCTRL and RESCTRL_FS [3]. It seems I would need
to change that to select CONFIG_RESCTRL2_FS ?

A patch [4] in that RFC adds the "arch_*()" functions in
arch/riscv/kernel/qos/qos_resctrl.c

thanks,
drew

[0] https://github.com/riscv-non-isa/riscv-cbqri/blob/main/riscv-cbqri.pdf
[1] https://lore.kernel.org/linux-riscv/20230419111111.477118-1-dfustini@baylibre.com/
[2] https://gitlab.arm.com/linux-arm/linux-jm/-/tree/mpam/snaphot/20230406
[3] https://lore.kernel.org/linux-riscv/20230419111111.477118-11-dfustini@baylibre.com/
[4] https://lore.kernel.org/linux-riscv/20230419111111.477118-8-dfustini@baylibre.com/


