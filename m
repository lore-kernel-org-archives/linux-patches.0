Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296AA2C80
	for <patches@lists.linux.dev>; Wed, 29 Dec 2021 11:23:04 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id w24so15660900ply.12
        for <patches@lists.linux.dev>; Wed, 29 Dec 2021 03:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B8D9h3oa8OpyqxIH3xe2rIOLYO1p/ntyh/ItEZc2ers=;
        b=WGgAxIa78MQr67iJtQ1TD1NaSUDzL8Sj14e4SvxYWhEN9di3WJIBnUF+L3ExcGr1oj
         QG61NAIFhjT/XTvY0CDIKSy0x2wdhjgp5o3CP/sn9tLZp0iIoIh8BXvPhaMFXpuLfzRl
         ssYONzQtGOvuMs4NA/1vndNqMZ2aeOxJ5COnpBFYJWM3L7v9L5GRfb6CzWNnmn7NDNB5
         Y3k9y/k0SaoD8ZsB9lFCcDRjDybncaD5TD9GRZZ/dYi8Nrw8/TG12zPX6PJi/KX88OD2
         OuID2/9IQHJyO+voFSIrf5Pg524R1rvzzNEz20N8dgdaI7Q3jfQjIb0uJgqdnoHZZxJI
         MBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B8D9h3oa8OpyqxIH3xe2rIOLYO1p/ntyh/ItEZc2ers=;
        b=TvLrbVtIXHXh+Ry1xenBcw+R91tZw0OaFlSdKKx3DiDA2X/1pxtSYFPqWz54R7YPYL
         DUlR6wcvnWShfyVmCxqiHSxnoY8sIm8h7LiqDaLGNBDFLtVA5CfCXJZRhLgaZSi4AOiG
         bUm+ltV5xm2UlYXKIfhSRxoq+qo6X7E5Uobxf/xXaHpX5HSI+WAl6mW4OG2+0fhmU9X2
         VTu71AA4htGcsmWiWsFm77FoX3NCd/INIKdVos++1nAMt6pupMDTRJ1NSDYQ0kRePYJP
         vn5TnIrKegCkSom6N2DDEkgEauZt0GgbOVyUGSx16WOViQwdcdphA6mH0gg2R5sj0rTM
         rK4A==
X-Gm-Message-State: AOAM5332g1gcjJqHRRAWmHRB87Af7UWOktbdK9gvJBVBvhPEaY72BBaI
	aEx7Ik/yHlUQdihC3dDucOo=
X-Google-Smtp-Source: ABdhPJwuzAxU4R0IYSsKh74KLKKx3PviuJjkKN5hUYyTQsDBZbYnOyqmi34FrA9NClJ4Q9W7ZJbPJg==
X-Received: by 2002:a17:902:9343:b0:148:a2e7:fb5f with SMTP id g3-20020a170902934300b00148a2e7fb5fmr27487300plp.160.1640776983676;
        Wed, 29 Dec 2021 03:23:03 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id pf7sm27063114pjb.8.2021.12.29.03.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 03:23:03 -0800 (PST)
Date: Wed, 29 Dec 2021 11:22:54 +0000
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
	Will Deacon <will@kernel.org>, x86@kernel.org,
	Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Message-ID: <YcxFDuPXlTwrPSPk@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e@suse.cz>

On Wed, Dec 22, 2021 at 05:56:50PM +0100, Vlastimil Babka wrote:
> On 12/14/21 13:57, Vlastimil Babka wrote:
> > On 12/1/21 19:14, Vlastimil Babka wrote:
> >> Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> >> this cover letter.
> >>
> >> Series also available in git, based on 5.16-rc3:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> > 
> > Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> > and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> 
> Hi, I've pushed another update branch slab-struct_slab-v4r1, and also to
> -next. I've shortened git commit log lines to make checkpatch happier,
> so no range-diff as it would be too long. I believe it would be useless
> spam to post the whole series now, shortly before xmas, so I will do it
> at rc8 time, to hopefully collect remaining reviews. But if anyone wants
> a mailed version, I can do that.
>

Hello Matthew and Vlastimil.
it's part 3 of review.

# mm: Convert struct page to struct slab in functions used by other subsystems
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>


# mm/slub: Convert most struct page to struct slab by spatch
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
with a question below.

-static int check_slab(struct kmem_cache *s, struct page *page)
+static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
        int maxobj;
 
-       if (!PageSlab(page)) {
-               slab_err(s, page, "Not a valid slab page");
+       if (!folio_test_slab(slab_folio(slab))) {
+               slab_err(s, slab, "Not a valid slab page");
                return 0;
        }

Can't we guarantee that struct slab * always points to a slab?

for struct page * it can be !PageSlab(page) because struct page *
can be other than slab. but struct slab * can only be slab
unlike struct page. code will be simpler if we guarantee that
struct slab * always points to a slab (or NULL).


# mm/slub: Convert pfmemalloc_match() to take a struct slab
It's confusing to me because the original pfmemalloc_match() is removed
and pfmemalloc_match_unsafe() was renamed to pfmemalloc_match() and
converted to use slab_test_pfmemalloc() helper.

But I agree with the resulting code. so:
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>


# mm/slub: Convert alloc_slab_page() to return a struct slab
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>


# mm/slub: Convert print_page_info() to print_slab_info()
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

I hope to review rest of patches in a week.

Thanks,
Hyeonggon

> Changes in v4:
> - rebase to 5.16-rc6 to avoid a conflict with mainline
> - collect acks/reviews/tested-by from Johannes, Roman, Hyeonggon Yoo -
> thanks!
> - in patch "mm/slub: Convert detached_freelist to use a struct slab"
> renamed free_nonslab_page() to free_large_kmalloc() and use folio there,
> as suggested by Roman
> - in "mm/memcg: Convert slab objcgs from struct page to struct slab"
> change one caller of slab_objcgs_check() to slab_objcgs() as suggested
> by Johannes, realize the other caller should be also changed, and remove
> slab_objcgs_check() completely.
