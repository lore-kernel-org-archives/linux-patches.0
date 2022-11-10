Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E781E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668114402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R4TGKeMnEv31xPKczYfKOippJw82dvGW/S5AmEWifME=;
	b=ZxSR5mrTH7AUyNTils9nOX+y8gILvj0jvYU8HxnJ5rKVLOwTnHVo/BWU63wt2YH/X63mTs
	5bZs4sQWhIBCCvkHEbBbKtW6O1laq+vsZTDf8CwF7CQxU1zAgIjoUMucoSln/lj/buJTQK
	WosH2kuqFSaiCmb4Ymyz6G90aFzq5UA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-230-l7KwhN3fPNebTrrtcDJxZA-1; Thu, 10 Nov 2022 16:06:41 -0500
X-MC-Unique: l7KwhN3fPNebTrrtcDJxZA-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a0564021e9400b00461ea0ce17cso2294509edf.16
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:06:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4TGKeMnEv31xPKczYfKOippJw82dvGW/S5AmEWifME=;
        b=HoffkTZ00RNtnKKnK0y/OHWYe6ndSorP+ewhzydAiBDJQN0r2/b67do001dIT9s1S/
         ioSuHk/nAI6tQ24SkJFy8AQYOhKftw0G9l3HomP5Cgu2KkyCu7oqe+LEKWdkQSwIvyY6
         cMPlAWAzSaw31ldBeew/WeCveWPCxvMuuT55G5UMxaTca9EEqZ8W6IlEWKPBVOfqiypY
         JZkEaKcCBW8Fp0Ma4cZvkB5OxBAXIx/XbltleiueVplz2tjngnnY9VmlGA4jUt/+r5yP
         dv8e5+nSArY82GirLyMVtpyZZHHiz9nrUMDq1gcQpaQVnH6QHJ/vr4V9qKQuUkSFjqNV
         8OSQ==
X-Gm-Message-State: ACrzQf3trPMlG5QaiJLzNvWzZSScjNNdfFzu0I8m1NRvt8ZF8Kefm6dY
	itMI2zzYM7G+jjMU9AH4Tkc77BUVW/BurBuUsNxx/3imC1IgtC46Js8ENnkR/5XkI4aqMWG+ExJ
	0Vi8cRYJElyQSP+Vkkw==
X-Received: by 2002:a05:6402:298d:b0:461:9513:5081 with SMTP id eq13-20020a056402298d00b0046195135081mr3545847edb.106.1668114400131;
        Thu, 10 Nov 2022 13:06:40 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7PRff9VEziFrK4YiBV839Tq5PmH0l4Xgj8GL6gRlSdLWFUeKMLPE8kTCDj57d/NuN8NCq5tA==
X-Received: by 2002:a05:6402:298d:b0:461:9513:5081 with SMTP id eq13-20020a056402298d00b0046195135081mr3545833edb.106.1668114399968;
        Thu, 10 Nov 2022 13:06:39 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id b8-20020a0564021f0800b004611f5efea8sm298654edb.17.2022.11.10.13.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:06:39 -0800 (PST)
Message-ID: <7b455034-da93-3392-223c-76e6a592ae74@redhat.com>
Date: Thu, 10 Nov 2022 22:06:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 03/14] platform/x86/intel/ifs: Remove image loading
 during init
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, ashok.raj@intel.com, tony.luck@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com,
 thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com,
 sohil.mehta@intel.com
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-4-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-4-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> IFS test image is unnecessarily loaded during driver initialization.
> Drop image loading during ifs_init() and improve module load time.
> With this change, user has to load one when starting the tests.
> 
> As a consequence, make ifs_sem static as it is only used within sysfs.c
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Suggested-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/platform/x86/intel/ifs/ifs.h   | 2 --
>  drivers/platform/x86/intel/ifs/core.c  | 6 +-----
>  drivers/platform/x86/intel/ifs/sysfs.c | 2 +-
>  3 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index 73c8e91cf144..3ff1d9aaeaa9 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -229,6 +229,4 @@ void ifs_load_firmware(struct device *dev);
>  int do_core_test(int cpu, struct device *dev);
>  const struct attribute_group **ifs_get_groups(void);
>  
> -extern struct semaphore ifs_sem;
> -
>  #endif
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index 27204e3d674d..5fb7f655c291 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -51,12 +51,8 @@ static int __init ifs_init(void)
>  	ifs_device.misc.groups = ifs_get_groups();
>  
>  	if ((msrval & BIT(ifs_device.data.integrity_cap_bit)) &&
> -	    !misc_register(&ifs_device.misc)) {
> -		down(&ifs_sem);
> -		ifs_load_firmware(ifs_device.misc.this_device);
> -		up(&ifs_sem);
> +	    !misc_register(&ifs_device.misc))
>  		return 0;
> -	}
>  
>  	return -ENODEV;
>  }
> diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
> index 37d8380d6fa8..65dd6fea5342 100644
> --- a/drivers/platform/x86/intel/ifs/sysfs.c
> +++ b/drivers/platform/x86/intel/ifs/sysfs.c
> @@ -13,7 +13,7 @@
>   * Protects against simultaneous tests on multiple cores, or
>   * reloading can file while a test is in progress
>   */
> -DEFINE_SEMAPHORE(ifs_sem);
> +static DEFINE_SEMAPHORE(ifs_sem);
>  
>  /*
>   * The sysfs interface to check additional details of last test

