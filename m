Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B65A7C
	for <patches@lists.linux.dev>; Thu,  3 Mar 2022 08:14:40 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 132so3875556pga.5
        for <patches@lists.linux.dev>; Thu, 03 Mar 2022 00:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ISlWWlirLRCfRuygLCDpsxrSlB4F7uzE5cIMR4QLuec=;
        b=UuzTuUci6aK6ow1N3IaTsNO7MQ8a6Nrzw+5mQsqg3df+XZJhIZdmlJOI6kc6LDmtnA
         CmPj8spfKFgFMcZ0Df6n05cWcoeoNoWH5rO6k8MFV4f4g2rfhqoxZ9XpwvuPETpiYqw7
         W9LICq6mA41eGxZ3IZ/DHaB+ze3JJS5sEQCV5fApzEOOJU5n6MGRSqSz4BUCEH/sUd+0
         6GeYIzAAB3V2MIdt5XNPU5Cc1Hgh5JKCdoGaPf/qgw9U80RNUBRfXzTzAk52694KriMH
         k415d8/DJ0RZAOlFYjyUn33QqAJz+n8Mx/8vWZduCRJC2ZztCtJtLwIPjqn6ddZ4/tMp
         Vd5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ISlWWlirLRCfRuygLCDpsxrSlB4F7uzE5cIMR4QLuec=;
        b=B+m42KQbmQd3F6bUmZsGmSSSgtSrt0buFYEGL5GLh57SB8ZP8GZeuK7x4/y+BBbhBy
         Mn6VtkIQgkj7l3MWBk6+/AMvIJ0NpIa3b7HrJ45NtPZUCWf0t8tEIN0T4TuLbCvL14q2
         RKlKBI5WOtsJr/thL++O905D6KjGf419dFW8Wwsl31NbsR5qZv+0mrNcUd56/8J0tToT
         A6ZuGAJvcIeJGzU5hWMb4sf3kVG4+HYeMCTa+uHroHoLtXMgzo3Ejbz8057mbKjmCuwj
         dvK8XnHRqZjuRXbYJTNG4TicI7vS8u8PzxB7T+P5wLEsbmJ8V6QZoJxlecqn62Juiet/
         8Vig==
X-Gm-Message-State: AOAM533Xmyz/sdJuX4SAMFhLNAq1JXD/WEN16D0TwU+1oK2bH985bZtl
	Vhw+NZeKOE0hElY1Qe+68Ns=
X-Google-Smtp-Source: ABdhPJxcNkKpsuJjHdwFnkDb4TH/wt2cxpWJ35c6lExQbrgrQ00nw8YUMZseH1O+SPJfCQ/57hMpUA==
X-Received: by 2002:a05:6a00:23d1:b0:4f4:76:4b69 with SMTP id g17-20020a056a0023d100b004f400764b69mr22058010pfc.29.1646295279600;
        Thu, 03 Mar 2022 00:14:39 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a0d5700b001bc3c650e01sm7792755pju.1.2022.03.03.00.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 00:14:39 -0800 (PST)
Date: Thu, 3 Mar 2022 08:14:33 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>,
	Marco Elver <elver@google.com>, Mike Rapoport <rppt@linux.ibm.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 6/6] slab, documentation: add description of debugfs
 files for SLUB caches
Message-ID: <YiB46Z9od9aF61iO@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220302173122.11939-1-vbabka@suse.cz>
 <20220302173122.11939-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302173122.11939-7-vbabka@suse.cz>

On Wed, Mar 02, 2022 at 06:31:22PM +0100, Vlastimil Babka wrote:
> From: Oliver Glitta <glittao@gmail.com>
> 
> Add description of debugfs files alloc_traces and free_traces
> to SLUB cache documentation.
> 
> [ vbabka@suse.cz: some rewording ]
> 
> Signed-off-by: Oliver Glitta <glittao@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/vm/slub.rst | 64 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/Documentation/vm/slub.rst b/Documentation/vm/slub.rst
> index d3028554b1e9..43063ade737a 100644
> --- a/Documentation/vm/slub.rst
> +++ b/Documentation/vm/slub.rst
> @@ -384,5 +384,69 @@ c) Execute ``slabinfo-gnuplot.sh`` in '-t' mode, passing all of the
>        40,60`` range will plot only samples collected between 40th and
>        60th seconds).
>  
> +
> +DebugFS files for SLUB
> +======================
> +
> +For more information about current state of SLUB caches with the user tracking
> +debug option enabled, debugfs files are available, typically under
> +/sys/kernel/debug/slab/<cache>/ (created only for caches with enabled user
> +tracking). There are 2 types of these files with the following debug
> +information:
> +
> +1. alloc_traces::
> +
> +    Prints information about unique allocation traces of the currently
> +    allocated objects. The output is sorted by frequency of each trace.
> +
> +    Information in the output:
> +    Number of objects, allocating function, minimal/average/maximal jiffies since alloc,
> +    pid range of the allocating processes, cpu mask of allocating cpus, and stack trace.
> +
> +    Example:::
> +
> +    1085 populate_error_injection_list+0x97/0x110 age=166678/166680/166682 pid=1 cpus=1::
> +	__slab_alloc+0x6d/0x90
> +	kmem_cache_alloc_trace+0x2eb/0x300
> +	populate_error_injection_list+0x97/0x110
> +	init_error_injection+0x1b/0x71
> +	do_one_initcall+0x5f/0x2d0
> +	kernel_init_freeable+0x26f/0x2d7
> +	kernel_init+0xe/0x118
> +	ret_from_fork+0x22/0x30
> +
> +
> +2. free_traces::
> +
> +    Prints information about unique freeing traces of the currently allocated
> +    objects. The freeing traces thus come from the previous life-cycle of the
> +    objects and are reported as not available for objects allocated for the first
> +    time. The output is sorted by frequency of each trace.
> +
> +    Information in the output:
> +    Number of objects, freeing function, minimal/average/maximal jiffies since free,
> +    pid range of the freeing processes, cpu mask of freeing cpus, and stack trace.
> +
> +    Example:::
> +
> +    1980 <not-available> age=4294912290 pid=0 cpus=0
> +    51 acpi_ut_update_ref_count+0x6a6/0x782 age=236886/237027/237772 pid=1 cpus=1
> +	kfree+0x2db/0x420
> +	acpi_ut_update_ref_count+0x6a6/0x782
> +	acpi_ut_update_object_reference+0x1ad/0x234
> +	acpi_ut_remove_reference+0x7d/0x84
> +	acpi_rs_get_prt_method_data+0x97/0xd6
> +	acpi_get_irq_routing_table+0x82/0xc4
> +	acpi_pci_irq_find_prt_entry+0x8e/0x2e0
> +	acpi_pci_irq_lookup+0x3a/0x1e0
> +	acpi_pci_irq_enable+0x77/0x240
> +	pcibios_enable_device+0x39/0x40
> +	do_pci_enable_device.part.0+0x5d/0xe0
> +	pci_enable_device_flags+0xfc/0x120
> +	pci_enable_device+0x13/0x20
> +	virtio_pci_probe+0x9e/0x170
> +	local_pci_probe+0x48/0x80
> +	pci_device_probe+0x105/0x1c0
> +

Looks very good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

>  Christoph Lameter, May 30, 2007
>  Sergey Senozhatsky, October 23, 2015
> -- 
> 2.35.1
> 

-- 
Thank you, You are awesome!
Hyeonggon :-)
