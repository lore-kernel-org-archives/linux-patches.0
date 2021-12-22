Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEDD168
	for <patches@lists.linux.dev>; Wed, 22 Dec 2021 07:36:43 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 200so1395336pgg.3
        for <patches@lists.linux.dev>; Tue, 21 Dec 2021 23:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WrvvWhSLi37P9Hu9a/lN3dt16MiGegPkcEW+eWXvnco=;
        b=RKpi5mEKObOsMfFa2Hh3uM3GzsMIBcjoLEKD7cwnOeZVwpA/d0V88BawrYNtOMnFn7
         l9nLVd1NKaLq5pB3voPPj4Z2icjvncDwuZ1uCcPIm6/WMKIxRRSgNH/mDo7gCP9SqWkU
         gYLMtOZHpZ2bc7XcFtJFnIgGuT/WDzmxB2cJqJdB0KPkqVUD86hast7AId9I1sCheseV
         FXPC48nv7polwBlytcx80Ge2CfcadbncgdXZ3ZbZeK1wttQ3MYdrMcX33gMLD2b77cBe
         1XVNoWD64mGKqnHA2cr7yfFsOmBI796jO3rcUEeDFIAJ9d2aBQsqNJ50N2r74mkiVcl+
         IdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WrvvWhSLi37P9Hu9a/lN3dt16MiGegPkcEW+eWXvnco=;
        b=gyDP9vRCFdYgqNds3+uEL/9UVr8MCzLgQq681qnSqahH7HLAIxdi07pYgymV7GmSdt
         +6bgYtF6h2rwYlpui44HHT+Ve6/chzU+0zm+ZRxuPCSAFws0Hx4cYXrYzS3BAuVdknHR
         +tPIrskOoBO7qGcujty3Qg33rgzBdWWfwi+OXBerJCDRSdnv1i/RzMetg83sAaVucZMF
         Z8JUTNDWMwAt0m/bDORyPz0vVPbGIVyYSH+VyhiJ9onINDWwP+gl5a/dlOTwrzrT3OAP
         Axcz6x4rutD1hoTB/06+2r/7SRd5pNwbe5cs1DlZOymC5cv/EfJLkK/7K9yBJpMKIfOA
         ojAA==
X-Gm-Message-State: AOAM530Cr9G0NtIn3h1DURk4Xmvuw+emYaA3SW3N5peTaLVPuTEqghGp
	BvEVleAsNVZR2pwxk2h/3vo=
X-Google-Smtp-Source: ABdhPJyHgWJMD56kcLvcfd7Dna83oWWhHn+FdUZZGPKlzE0fgc8M5z+y33KIsE262NlfnBnCmss6iQ==
X-Received: by 2002:a63:8f06:: with SMTP id n6mr1787692pgd.95.1640158602956;
        Tue, 21 Dec 2021 23:36:42 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id v4sm884943pjk.38.2021.12.21.23.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 23:36:42 -0800 (PST)
Date: Wed, 22 Dec 2021 07:36:33 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	cgroups@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <julia.lawall@inria.fr>, kasan-dev@googlegroups.com,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Message-ID: <YcLVgdpyhZjtAatZ@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <YbtUmi5kkhmlXEB1@ip-172-31-30-232.ap-northeast-1.compute.internal>
 <38976607-b9f9-1bce-9db9-60c23da65d2e@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38976607-b9f9-1bce-9db9-60c23da65d2e@suse.cz>

On Tue, Dec 21, 2021 at 12:58:14AM +0100, Vlastimil Babka wrote:
> On 12/16/21 16:00, Hyeonggon Yoo wrote:
> > On Tue, Dec 14, 2021 at 01:57:22PM +0100, Vlastimil Babka wrote:
> >> On 12/1/21 19:14, Vlastimil Babka wrote:
> >> > Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> >> > this cover letter.
> >> > 
> >> > Series also available in git, based on 5.16-rc3:
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> >> 
> >> Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> >> and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> > 
> > Reviewing the whole patch series takes longer than I thought.
> > I'll try to review and test rest of patches when I have time.
> > 
> > I added Tested-by if kernel builds okay and kselftests
> > does not break the kernel on my machine.
> > (with CONFIG_SLAB/SLUB/SLOB depending on the patch),
> 
> Thanks!
>

:)

> > Let me know me if you know better way to test a patch.
> 
> Testing on your machine is just fine.
>

Good!

> > # mm/slub: Define struct slab fields for CONFIG_SLUB_CPU_PARTIAL only when enabled
> > 
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > 
> > Comment:
> > Works on both SLUB_CPU_PARTIAL and !SLUB_CPU_PARTIAL.
> > btw, do we need slabs_cpu_partial attribute when we don't use
> > cpu partials? (!SLUB_CPU_PARTIAL)
> 
> The sysfs attribute? Yeah we should be consistent to userspace expecting to
> read it (even with zeroes), regardless of config.
> 

I thought entirely disabling the attribute is simpler,
But okay If it should be exposed even if it's always zero.

> > # mm/slub: Simplify struct slab slabs field definition
> > Comment:
> > 
> > This is how struct page looks on the top of v3r3 branch:
> > struct page {
> > [...]
> >                 struct {        /* slab, slob and slub */
> >                         union {
> >                                 struct list_head slab_list;
> >                                 struct {        /* Partial pages */
> >                                         struct page *next;
> > #ifdef CONFIG_64BIT
> >                                         int pages;      /* Nr of pages left */
> > #else
> >                                         short int pages;
> > #endif
> >                                 };
> >                         };
> > [...]
> > 
> > It's not consistent with struct slab.
> 
> Hm right. But as we don't actually use the struct page version anymore, and
> it's not one of the fields checked by SLAB_MATCH(), we can ignore this.
>

Yeah this is not a big problem. just mentioned this because 
it looked weird and I didn't know when the patch "mm: Remove slab from struct page"
will come back.

> > I think this is because "mm: Remove slab from struct page" was dropped.
>
> That was just postponed until iommu changes are in. Matthew mentioned those
> might be merged too, so that final cleanup will happen too and take care of
> the discrepancy above, so no need for extra churn to address it speficially.
> 

Okay it seems no extra work needed until the iommu changes are in!

BTW, in the patch (that I sent) ("mm/slob: Remove unnecessary page_mapcount_reset()
function call"), it refers commit 4525180926f9  ("mm/sl*b: Differentiate struct slab fields by
sl*b implementations"). But the commit hash 4525180926f9 changed after the
tree has been changed.

It will be nice to write a script to handle situations like this.

> > Would you update some of patches?
> > 
> > # mm/sl*b: Differentiate struct slab fields by sl*b implementations
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Works SL[AUO]B on my machine and makes code much better.
> > 
> > # mm/slob: Convert SLOB to use struct slab and struct folio
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > It still works fine on SLOB.
> > 
> > # mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> >
> > # mm/slub: Convert __free_slab() to use struct slab
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > 
> > Thanks,
> > Hyeonggon.
> 
> Thanks again,
> Vlastimil

Have a nice day, thanks!
Hyeonggon.
