Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41531CF8D
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695040345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8L41GDnIhY69bJ3ItERiXeNx/v3dOVoNSZWSaM0kuxI=;
	b=LWzaq6tAepj6U4oQEdRFYNCqgFxGb7deCa2/cYYTYj55ee4l2qAwdJRMwXPMUd94Hs7CaY
	Mjph49US60E9HowxLWIeoJSILs+pduoHgHHjMXSp4j+RqaSaufIZJRwl3L7Gdyv1uhFFj6
	pdE7UagjjR1kb41duJ36zdGNSa5AjLo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-Yi4QqhHPPta2O5_-n8dtqg-1; Mon, 18 Sep 2023 08:32:24 -0400
X-MC-Unique: Yi4QqhHPPta2O5_-n8dtqg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-501c7c4059aso5054060e87.1
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 05:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695040343; x=1695645143;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8L41GDnIhY69bJ3ItERiXeNx/v3dOVoNSZWSaM0kuxI=;
        b=k8WiUB3AlPFCfPIDLiX5Lcp1uzoJgtpK9YDmLR7Xg0kLVIo5KfRc6tvofax0OV1D6X
         5D7iln2Zcl4Ju2WYLc42jwYIAr6g47GxDN0y8Gq3u/idZVHGInI7/ZktwKeGhTeRwceg
         elZds/C9tzdHAVLMfZQhDFcDksyDnjOGhV0UCR/0cz04BDHRIH9ZuI0jLWvwmKQv/Fsl
         E9TLPkrC2JLn5NAhbM3I97wLa/uyUwI4EHU99zWihYp1FPfpDo4Vt9d4lQwAQgGMAaVk
         efYYHvJxvAS5ovZEabnr7CyT7b55mYPSurtpVLdX3slD01GwQbtkrvkKoj06ydVToRYt
         oTEA==
X-Gm-Message-State: AOJu0YxCCJOwYwT2eBlKat6NeJAWQl2wSdJ03NOLjjPmoVx6w+9scKV+
	r4TOXWjgjOYOVKfJAxM7kcZWv5JzhtiRJS8zm/AfUvtilu3abNoGmD2zNCZjHUa7k04OfURnM3f
	yek8AJ3G6sQG/eKgK4g==
X-Received: by 2002:a05:6512:33c8:b0:500:7a21:3e78 with SMTP id d8-20020a05651233c800b005007a213e78mr8709092lfg.55.1695040342817;
        Mon, 18 Sep 2023 05:32:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNqCVOkBF4pHzlcyjxj4AjUg7UdWxj/KWzodQ1NOSfj9e+Yc8/+2YgWvzpvG5JuQGfplf38Q==
X-Received: by 2002:a05:6512:33c8:b0:500:7a21:3e78 with SMTP id d8-20020a05651233c800b005007a213e78mr8709060lfg.55.1695040342456;
        Mon, 18 Sep 2023 05:32:22 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id cn10-20020a0564020caa00b00530be302f08sm3373855edb.49.2023.09.18.05.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 05:32:21 -0700 (PDT)
Message-ID: <ec68c553-1a12-6e33-b732-fd51d89cd439@redhat.com>
Date: Mon, 18 Sep 2023 14:32:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 00/10] IFS support for GNR and SRF
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230913183348.1349409-1-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jithu,

On 9/13/23 20:33, Jithu Joseph wrote:
> This series adds IFS support for newer CPUs like Granite Rapids(GNR)
> and Sierra Forest(SRF).
> 
> There are changes in the IFS image loading and test flow to support
> these new CPUs.
> 
> Note to reviewers:
>  - patch 01/10 adds a bit definition to arch/x86/.../msr-index.h,
>   hence x86 maintainers are cc-d.
>  - patch 05/10 modifies an existing tracepoint, cc Steven Rostedt
>  - Rest are localized to IFS driver
> 
> Jithu Joseph (10):
>   platform/x86/intel/ifs: Store IFS generation number
>   platform/x86/intel/ifs: Refactor image loading code
>   platform/x86/intel/ifs: Image loading for new generations
>   platform/x86/intel/ifs: Scan test for new generations
>   trace: platform/x86/intel/ifs: Modify scan trace
>   platform/x86/intel/ifs: Validate image size
>   platform/x86/intel/ifs: Metadata validation for start_chunk
>   platform/x86/intel/ifs: Add new CPU support
>   platform/x86/intel/ifs: Add new error code
>   platform/x86/intel/ifs: ARRAY BIST for Sierra Forest
> 
>  arch/x86/include/asm/msr-index.h         |   2 +
>  drivers/platform/x86/intel/ifs/ifs.h     |  47 +++++++
>  include/trace/events/intel_ifs.h         |  16 +--
>  drivers/platform/x86/intel/ifs/core.c    |  14 +-
>  drivers/platform/x86/intel/ifs/load.c    | 159 +++++++++++++++++++++--
>  drivers/platform/x86/intel/ifs/runtest.c |  68 +++++++++-
>  6 files changed, 273 insertions(+), 33 deletions(-)
> 
> 
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d

Thank you for the patch series, please submit a new version addressing
the various review-remarks.

Regards,

Hans

