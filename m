Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD23B21
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 12:18:30 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id 139so7187833pge.1
        for <patches@lists.linux.dev>; Sat, 26 Feb 2022 04:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJhNwGmR4jfl5BmmAkHAR/2s9Nf7V6bWaoI62Ajwb1E=;
        b=QeWEBbB+BRiDiiLwwGDHXZHYm/35Mzts/HYOGduGciqxZ9XMrm9nAW5ih19tXkvlKf
         /DquCpH9n1YjyBaTQDYP0Dnc1vds+8gjLXIaO2CJqIpnmiTpJu8mgut1xS/PaZhAYxyS
         0cOQHw2KDtEA7zF41LHKb/XOkk5mRa5BrDgy+05yAjqQDSiooriHlIfk2JiijiVftazu
         l5oIl8W2xSa0R13ejhIQuh4B+zsfVJRLgBCq71dsfmlh/QglMWbMrHTD1rIYIT0ttNBZ
         RtFpoaZDnwT1IE7794XabOkr7k4gNzXBGKGMTTRvMamr9YQ5Es/gI0FveJ7B+IFGBc0e
         7YTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJhNwGmR4jfl5BmmAkHAR/2s9Nf7V6bWaoI62Ajwb1E=;
        b=4/gjmc5wmlgXfBE2txZsOxXv1ADWCWmLVCq/bbuA/WMoK8wen0lVecQEFBEoB/8rg1
         nkpUtwu69VWcHCU64LI5+fh95ezEYzpIT34vvprzpOVlpaPL+Xvy/7R780cTAQqiluA8
         D7A7o3WPO5akttbjm1IilBuZpR6DQ8N5izfUNRDG6RyZ99JyC/MH0gqanzZb89CGZWvr
         SWfLFPnpYks/PWiKqVgX9L71s5OeMTrOipRX/OuISuB3QfZsQNiUahbDDO9sTBLsqMP4
         Qas9njhGL2W4WkzWPP+mkUGmAf9BwTqVRd3jJ/Hk0kd1SOyVyXJtRuxpNJwZR7HJHpgy
         EL6Q==
X-Gm-Message-State: AOAM533Qr1STEwesI7jiMJKH9fydRCzgVcPkU72+nh5fOEXOwkzhMWdT
	m3YIXzTeZOlEcdUCM3AoV4o=
X-Google-Smtp-Source: ABdhPJzaV4QlMzXBsxfzUWbJYpevhsZoCQG5fPSFD+RKMhVDCtVrsai5Mo62+S8HJ3RjzYkBnSq4OA==
X-Received: by 2002:a63:a1c:0:b0:341:760a:1b03 with SMTP id 28-20020a630a1c000000b00341760a1b03mr9830351pgk.484.1645877910197;
        Sat, 26 Feb 2022 04:18:30 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id gl5-20020a17090b120500b001bc5d44f233sm11496433pjb.52.2022.02.26.04.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 04:18:29 -0800 (PST)
Date: Sat, 26 Feb 2022 12:18:24 +0000
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
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/5] SLUB debugfs improvements based on stackdepot
Message-ID: <YhoakP7Kih/YUgiN@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220225180318.20594-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225180318.20594-1-vbabka@suse.cz>

On Fri, Feb 25, 2022 at 07:03:13PM +0100, Vlastimil Babka wrote:
> Hi,
> 
> this series combines and revives patches from Oliver's last year
> bachelor thesis (where I was the advisor) that make SLUB's debugfs
> files alloc_traces and free_traces more useful.
> The resubmission was blocked on stackdepot changes that are now merged,
> as explained in patch 2.
> 
> Patch 1 is a new preparatory cleanup.
> 
> Patch 2 originally submitted here [1], was merged to mainline but
> reverted for stackdepot related issues as explained in the patch.
> 
> Patches 3-5 originally submitted as RFC here [2]. In this submission I
> have omitted the new file 'all_objects' (patch 3/3 in [2]) as it might
> be considered too intrusive so I will postpone it for later. The docs
> patch is adjusted accordingly.
> 

This problem is not caused by this patch series.
But I think it's worth mentioning...

It's really weird that some stack traces are not recorded
when CONFIG_KASAN=y.

I made sure that:
	- Stack Depot did not reach its limit
	- the free path happen on CONFIG_KASAN=y too.

I have no clue why this happen.

# cat dentry/free_traces (CONFIG_KASAN=y)
   6585 <not-available> age=4294912647 pid=0 cpus=0

# cat dentry/free_traces (CONFIG_KASAN=n)
   1246 <not-available> age=4294906877 pid=0 cpus=0
    379 __d_free+0x20/0x2c age=33/14225/14353 pid=0-122 cpus=0-3
        kmem_cache_free+0x1f4/0x21c
        __d_free+0x20/0x2c
        rcu_core+0x334/0x580
        rcu_core_si+0x14/0x20
        __do_softirq+0x12c/0x2a8

      2 dentry_free+0x58/0xb0 age=14101/14101/14101 pid=158 cpus=0
        kmem_cache_free+0x1f4/0x21c
        dentry_free+0x58/0xb0
        __dentry_kill+0x18c/0x1d0
        dput+0x1c4/0x2fc
        __fput+0xb0/0x230
        ____fput+0x14/0x20
        task_work_run+0x84/0x17c
        do_notify_resume+0x208/0x1330
        el0_svc+0x6c/0x80
        el0t_64_sync_handler+0xa8/0x130
        el0t_64_sync+0x1a0/0x1a4

      1 dentry_free+0x58/0xb0 age=7678 pid=190 cpus=1
        kmem_cache_free+0x1f4/0x21c
        dentry_free+0x58/0xb0
        __dentry_kill+0x18c/0x1d0
        dput+0x1c4/0x2fc
        __fput+0xb0/0x230
        ____fput+0x14/0x20
        task_work_run+0x84/0x17c
        do_exit+0x2dc/0x8e0
        do_group_exit+0x38/0xa4
        __wake_up_parent+0x0/0x34
        invoke_syscall+0x48/0x114
        el0_svc_common.constprop.0+0x44/0xfc
        do_el0_svc+0x2c/0x94
        el0_svc+0x28/0x80
        el0t_64_sync_handler+0xa8/0x130
        el0t_64_sync+0x1a0/0x1a4
-- 
Thank you, You are awesome!
Hyeonggon :-)
