Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13117F5
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 05:42:08 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bf7423ef3eso21283485ad.3
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 22:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692769328; x=1693374128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXFrwzCPZpjmPe0jGsBW0zhL8FGGi+rHIxlG2RCSp3M=;
        b=bJKxut98Ui2Y1Bx/fpRIH+PT+xE1csGkWBraZJROmoRxrHZMdN/0jrs1zVxB3ltcJC
         TCk9naGgcQacCJvQhzNEMM083hxxk8v0Ebp85ME1acG2JOw3wtabyZMKgCqYhMn3Bk3w
         161ToNQM4B2/mnJ6WFY/RiW6QIZ89NB+GMuvsQbdoi3CAM0D4tS1xtn4PK46B8DVDZMU
         KPm3nJgdPpgTZ7mLMGAqvB8TDzqujlsFe+cL/AoESyBWu2B56hmePHEnNVGIE399rdkQ
         a5/G6IMABrH5yQIOPDp1lFwd5pDIAGwTPehqgPF0NzmCgGkVpXKHasc9A1gh0hqP61lI
         f32Q==
X-Gm-Message-State: AOJu0YzIqRy1vnqq3KM3up7pNI5Av5FVs99nDeP1ahNttAizK9jIWVPI
	ZqGfWfd1d7FTDX+aQo0uLEo=
X-Google-Smtp-Source: AGHT+IHwWwyNqcwGFCJcai2/Zp8Qf19N7YHZ3EX/92MJSUq1BAhBTsJMXS48VcMQTbv2Y9ewFWaqQg==
X-Received: by 2002:a17:902:6b47:b0:1b8:b3f0:3d57 with SMTP id g7-20020a1709026b4700b001b8b3f03d57mr8432370plt.31.1692769327722;
        Tue, 22 Aug 2023 22:42:07 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id jw15-20020a170903278f00b001b9d7c8f44dsm9962498plb.182.2023.08.22.22.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 22:42:07 -0700 (PDT)
Date: Wed, 23 Aug 2023 05:41:46 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	KY Srinivasan <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Michael Kelley (LINUX)" <mikelley@microsoft.com>,
	Tianyu Lan <Tianyu.Lan@microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] x86/hyperv: Add missing 'inline' to hv_snp_boot_ap() stub
Message-ID: <ZOWcGnu7pqA4m2Ar@liuwe-devbox-debian-v2>
References: <20230822-hv_snp_boot_ap-missing-inline-v1-1-e712dcb2da0f@kernel.org>
 <SA1PR21MB1335C1D74D05A582D90EA1A9BF1CA@SA1PR21MB1335.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB1335C1D74D05A582D90EA1A9BF1CA@SA1PR21MB1335.namprd21.prod.outlook.com>

On Wed, Aug 23, 2023 at 01:00:55AM +0000, Dexuan Cui wrote:
> > From: Nathan Chancellor <nathan@kernel.org>
> > Sent: Tuesday, August 22, 2023 11:26 AM
> > [...]
> > When building without CONFIG_AMD_MEM_ENCRYPT, there are several
> > repeated instances of -Wunused-function due to missing 'inline' on
> > the stub of hy_snp_boot_ap():
> > 
> >   In file included from drivers/hv/hv_common.c:29:
> >   ./arch/x86/include/asm/mshyperv.h:272:12: error: 'hv_snp_boot_ap'
> > defined but not used [-Werror=unused-function]
> >     272 | static int hv_snp_boot_ap(int cpu, unsigned long start_ip) { return
> > 0; }
> >         |            ^~~~~~~~~~~~~~
> >   cc1: all warnings being treated as errors
> > 
> > Add 'inline' to fix the warnings.
> > 
> > Fixes: 44676bb9d566 ("x86/hyperv: Add smp support for SEV-SNP guest")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Reviewed-by: Dexuan Cui <decui@microsoft.com>

Applied. Thanks.
