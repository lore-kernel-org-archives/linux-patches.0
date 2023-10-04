Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A40911190
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 09:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696413381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t3llrRzvIKILbc5TgXedn7Q8bVVVp8C9PO7vaMagqQM=;
	b=WZxiRwem8+qZph8AgfBCOg7mnyt+jGZU4aOHstuuci/DB00y/XKtWsYTokXvCFsl1/q1ih
	V4NmxfGhF8UWvl2p32ylXLsU25W46qk8pBTA3q5rUo7ReKCDsXOrfWwbTKHYA42OLaDabB
	WenkZ3YksMM7NyYt2AciMb9jM5xTtfQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-TmDzBwYdNRaxoEooIfG85g-1; Wed, 04 Oct 2023 05:55:58 -0400
X-MC-Unique: TmDzBwYdNRaxoEooIfG85g-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-533ca50404bso1607339a12.2
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 02:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696413357; x=1697018157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t3llrRzvIKILbc5TgXedn7Q8bVVVp8C9PO7vaMagqQM=;
        b=PpvIhdhbREXqQphhVMPCwPOGsTAUS6ExIPMx5J6pI/abOODr30OimTX0Lz+FKEtq7o
         YkhAegb1/70oVlK+ZvA4hurAg4GNpU6EA8pBuifusTsJ7+8embfbGNQOM6gvLiqAf3HD
         ZnRZHOu5kJYKXPRHp43RDpCEwLyguBB9g/IQMSIY+QHc1lO9T9O2kn0yG+dfab0fsRQv
         aNtT4hv3ijc5WNRNtP41VyV9yzDqWwSPMgvjcmXZetyzY6BAPJrb5WLOEzr4imNiqSIj
         mwJt2rNVUnI9aZVT9mXWElnLtLaFuGmVSdv4I00D2ZENe4kQR+imJvrilRdoiuiKjiog
         wIEw==
X-Gm-Message-State: AOJu0YyyuJiNKunPmsCryyQtutDuGEz7HVWY8h4UlsrWBYWYhERlsSsj
	0WuAgg14qK4mYEcJoa2a9DndpgBtR4NVTcYGOmUswWDzyFonE/ihUghTQvRkyzUubGbud5JKpTs
	njAzmUkqpOf42ecJ+bQ==
X-Received: by 2002:a50:fb12:0:b0:536:e03f:62b6 with SMTP id d18-20020a50fb12000000b00536e03f62b6mr1522886edq.30.1696413357192;
        Wed, 04 Oct 2023 02:55:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9V7fiXYUDKWE6UMTUNBgtOKzLLtTO5ZqS9lXx9adtCMpIzRBwm8IhSJIk/MU1t/HJfHyOtg==
X-Received: by 2002:a50:fb12:0:b0:536:e03f:62b6 with SMTP id d18-20020a50fb12000000b00536e03f62b6mr1522871edq.30.1696413356839;
        Wed, 04 Oct 2023 02:55:56 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id dy26-20020a05640231fa00b005256771db39sm2170533edb.58.2023.10.04.02.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 02:55:56 -0700 (PDT)
Message-ID: <bce65f65-66d9-3242-4656-7b2266a0e010@redhat.com>
Date: Wed, 4 Oct 2023 11:55:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/1] platform/x86/intel/ifs: release cpus_read_lock()
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: ashok.raj@intel.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev
References: <20230927184824.2566086-1-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230927184824.2566086-1-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/27/23 20:48, Jithu Joseph wrote:
> Couple of error paths in do_core_test() was returning directly without
> doing a necessary cpus_read_unlock().
> 
> Following lockdep warning was observed when exercising these scenarios
> with PROVE_RAW_LOCK_NESTING enabled:
> 
> [  139.304775] ================================================
> [  139.311185] WARNING: lock held when returning to user space!
> [  139.317593] 6.6.0-rc2ifs01+ #11 Tainted: G S      W I
> [  139.324499] ------------------------------------------------
> [  139.330908] bash/11476 is leaving the kernel with locks still held!
> [  139.338000] 1 lock held by bash/11476:
> [  139.342262]  #0: ffffffffaa26c930 (cpu_hotplug_lock){++++}-{0:0}, at:
> do_core_test+0x35/0x1c0 [intel_ifs]
> 
> Fix the flow so that all scenarios release the lock prior to returning
> from the function.
> 
> Fixes: 5210fb4e1880 ("platform/x86/intel/ifs: Sysfs interface for Array BIST")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thank you for your patch/series, I've applied this patch
(series) to the pdx86 fixes branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=fixes

Note it will show up in the pdx86 fixes branch once I've pushed
my local branch there, which might take a while.

I will include this patch in my next fixes pull-req to Linus
for the current kernel development cycle.

Regards,

Hans





> ---
>  drivers/platform/x86/intel/ifs/runtest.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
> index 1061eb7ec399..43c864add778 100644
> --- a/drivers/platform/x86/intel/ifs/runtest.c
> +++ b/drivers/platform/x86/intel/ifs/runtest.c
> @@ -331,14 +331,15 @@ int do_core_test(int cpu, struct device *dev)
>  	switch (test->test_num) {
>  	case IFS_TYPE_SAF:
>  		if (!ifsd->loaded)
> -			return -EPERM;
> -		ifs_test_core(cpu, dev);
> +			ret = -EPERM;
> +		else
> +			ifs_test_core(cpu, dev);
>  		break;
>  	case IFS_TYPE_ARRAY_BIST:
>  		ifs_array_test_core(cpu, dev);
>  		break;
>  	default:
> -		return -EINVAL;
> +		ret = -EINVAL;
>  	}
>  out:
>  	cpus_read_unlock();
> 
> base-commit: 6465e260f48790807eef06b583b38ca9789b6072

