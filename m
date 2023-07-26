Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCF17C
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 02:27:29 +0000 (UTC)
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7653bd3ff2fso638421885a.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 19:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20221208.gappssmtp.com; s=20221208; t=1690338448; x=1690943248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Viglh2d5OeFZB4xvJ6G2it4K8JrKHO/8Dv7RWTjX6kM=;
        b=qiuBPF2hMgALZZur5FAR+HdKzYGyMy5aZ4P02N3w7FWd1Bq1UCB24KYv3PIzmkcwgn
         5jL+7wud0KqGkqddn84+oqqhrKYTN1xB2JXK1F6UxnuCdlSY5ZOT1qOIqulX1RsjL/Z8
         yj36fZTmlZ3DLWqG8W+JgUSduItc0u9Q60U1ymm3J2MXaYg2kilpRR61x6fTwGuBaDi7
         LzILlbb/HJK1siWIEbmUXa68+IQjPCzlYUI0vsPQPXSj4cM9bPulYjGXXSmfd+fT0Wkr
         lcr3/ssxb2Lgj5vA5tRzhnAQmjQM9GKuiVBM0zZTbyi41QuJkedPdVJi3S6GxN4qVIXJ
         1GCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690338448; x=1690943248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Viglh2d5OeFZB4xvJ6G2it4K8JrKHO/8Dv7RWTjX6kM=;
        b=XbmwJ9d/9XumtfmoJbtrztn3vjWPh+OOfru9G7dGFx4ETtwuCqxHDKxWskDHbC46T+
         pAFVo3wWBHRnoO8/IbRdCXVdGX+IZ/u/zxY+5J4qDQUELCo4V5Fq17z4E5qAQaucuGKV
         OHFOWeTo0AJi2yEU0SyefSgWuqLjt6XrdCuLI15Au6nuEg28QWQwpWWrYFBzuoqy5iZl
         M0VSHvDgKUxSQUHCXuVDvAeKqZ61U0h/9HJMRfMyl7B701/7FAd9S3wmWOqoHR7la6vI
         dxMIk88mBMCqrU80EXRkWO0H3M5EAAUA9aYnzRudbs8eh+oA0i0GSnmvTjVkXYfKYukk
         TLig==
X-Gm-Message-State: ABy/qLYKdmaWr3VUoYQ3rTupzxkDyma80zjd1wF+DLKatruuU/QCCLzX
	HF0YtJZlnvFJaR6d2rjpSllYmg==
X-Google-Smtp-Source: APBJJlHoou/JhXl86qfNBbCvOwucbpA2OuUZCVJ3udRUMF0veeQza39o7kfYXYRLWZCd1fWcueXZRA==
X-Received: by 2002:a05:620a:44c4:b0:767:dfc8:a944 with SMTP id y4-20020a05620a44c400b00767dfc8a944mr997383qkp.41.1690338448296;
        Tue, 25 Jul 2023 19:27:28 -0700 (PDT)
Received: from x1 ([2601:1c2:1800:f680:ab7f:7b75:8135:310])
        by smtp.gmail.com with ESMTPSA id d18-20020a17090ac25200b00263dee538b1sm219346pjx.25.2023.07.25.19.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 19:27:27 -0700 (PDT)
Date: Tue, 25 Jul 2023 19:27:25 -0700
From: Drew Fustini <dfustini@baylibre.com>
To: Tony Luck <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Babu Moger <Babu.Moger@amd.com>,
	Peter Newman <peternewman@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	H Peter Anvin <hpa@zytor.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	D Scott Phillips OS <scott@os.amperecomputing.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"lcherian@marvell.com" <lcherian@marvell.com>,
	"bobo.shaobowang@huawei.com" <bobo.shaobowang@huawei.com>,
	"tan.shaopeng@fujitsu.com" <tan.shaopeng@fujitsu.com>,
	"xingxin.hx@openanolis.org" <xingxin.hx@openanolis.org>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Xin Hao <xhao@linux.alibaba.com>,
	"Pitre, Nicolas" <npitre@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	"aricciardi@baylibre.com" <aricciardi@baylibre.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH 0/2] Resctrl - rewrite (WIP)
Message-ID: <ZMCEjZgyi5oI+KWh@x1>
References: <20230620033702.33344-1-tony.luck@intel.com>
 <ZJqhDYLG+/Kr44sp@x1>
 <SJ1PR11MB60832BA425B43CA19C778100FC27A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <ZJ4clUlN2OujgHlC@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ4clUlN2OujgHlC@agluck-desk3>

On Thu, Jun 29, 2023 at 05:06:45PM -0700, Tony Luck wrote:
> On Tue, Jun 27, 2023 at 04:33:52PM +0000, Luck, Tony wrote:
> > I've made some significant changes since I posted those patches. I pushed
> > the latest version to:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git    resctrl2_v64
> 
> I just pushed one big commit with all the bits I've updated so far
> this week. Fixes some serious issues as well as general cleanup.
> 
> HEAD is now:
> 
> afb7cdd4d640 resctrl2: Many cleanups, fixes, and new functionality
> 
> If you've started writing your own architecture specific modules there
> are some small interface changes. Most should be found by the compiler
> barfing, but the new ".reset()" resource function called during unmount
> of /sys/fs/resctrl might be less obvious.
> 
> -Tony

I have access to a Xeon Silver 4310 machine which reports to have
cat_l3, cqm_mbm_local, cqm_mbm_total and mba.

I would like to test resctrl2 on it so I can better understand how it
works. I think that will help me understand how to adapt the RISC-V
CBQRI resctrl proof-of-concept to use resctrl2.

Would you be able to provide an example of how you loaded the necessary
resctrl2 kernel modules?

Also, is resctrl2_v65rc1 the latest to branch to test?

Thank you,
Drew
