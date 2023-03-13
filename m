Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCD828F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678719754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ytv42m9QWKbJ/ZLfHwR9HdA9Autu6K0kWVrGy/ImdIQ=;
	b=iOaVQVo8/GKJ2zszQETYHce6aj7YJrLCLs7oRzkWzagyHUFAtHvZU7vEKvByxbq8ox5ED4
	TDCDXFOKBeHmjVjnPsXJpLhYo/mxNuDI3SJxW/CgpgeO/o0X7shCWiugyRCpm0yvEKY3Hp
	evs3Fv+w34SxYHQU1b22D743+zvbQ3w=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-VTXlKOjEP86MyHyiiaoObQ-1; Mon, 13 Mar 2023 11:02:33 -0400
X-MC-Unique: VTXlKOjEP86MyHyiiaoObQ-1
Received: by mail-ed1-f72.google.com with SMTP id k12-20020a50c8cc000000b004accf30f6d3so17435487edh.14
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 08:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678719752;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ytv42m9QWKbJ/ZLfHwR9HdA9Autu6K0kWVrGy/ImdIQ=;
        b=jFvLUhBTAmqf7f2JegbCcE4qD4VQToipWNnLPdfPGdaJPmTYJVxoo8Nsgus6agJCNs
         vGlKMoYzxBB9eY9i2S0ondhXQtDP1WW9tpsWFEsCTU+ZSiXxh1CF/le6HZp4treKnbvf
         AwPph2tMgoXnAVqSEkDEaOqRZEXAZ59gJOyePhpzmQQau9AFvKmTZRLAPxhPLvmiNaB6
         vbXNePIxl+yV972r6iD9lHgQtQYanqNqnNNWkfymlzMjXegH2RgUCRB+XdmphUxC2Ek3
         gGSE5Oi5DWaOegH0xOb295aOEF8QTJMFY4Y9txe2yJjRSexJFF8LTdYh/2ofsxD71p7b
         tyBw==
X-Gm-Message-State: AO0yUKVxgsAZCcC7ryeAfa9S94YXN9Yutz2UiFdP4zxhDdgH2Rf8q/Li
	K2gkVXGXegznfHSF1PZdXaUD2vVcwAu5ixA/NNsTpHrsTp34OrmXTZxWiJv2MojIGnzGgbR2NC7
	zT9Ulk0RxvF+3recPLw==
X-Received: by 2002:a17:907:7f0b:b0:888:7ac8:c0f4 with SMTP id qf11-20020a1709077f0b00b008887ac8c0f4mr37301369ejc.25.1678719752529;
        Mon, 13 Mar 2023 08:02:32 -0700 (PDT)
X-Google-Smtp-Source: AK7set8An3aVV4WnNT9hxgiKWhAdv46b5RvfOThjOYw5to5Y8bLq/2UctAu/n1pVa89F4tB0bReroA==
X-Received: by 2002:a17:907:7f0b:b0:888:7ac8:c0f4 with SMTP id qf11-20020a1709077f0b00b008887ac8c0f4mr37301343ejc.25.1678719752251;
        Mon, 13 Mar 2023 08:02:32 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id xb12-20020a170907070c00b00924916f9c21sm2345305ejb.87.2023.03.13.08.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 08:02:31 -0700 (PDT)
Message-ID: <e4cbc603-ca16-41db-d08d-b5d5250d62b4@redhat.com>
Date: Mon, 13 Mar 2023 16:02:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 2/8] platform/x86/intel/ifs: IFS cleanup
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230301015942.462799-3-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230301015942.462799-3-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/1/23 02:59, Jithu Joseph wrote:
> Cleanup incorporating misc review comments
> 
>  - Remove the subdirectory intel_ifs/0 for devicenode [1]
>  - Make plat_ifs_groups non static and use it directly without using a
>     function [2]
> 
> Link: https://lore.kernel.org/lkml/Y+4kQOtrHt5pdsSO@kroah.com/ [1]
> Link: https://lore.kernel.org/lkml/Y9nyxNesVHCUXAcH@kroah.com/  [2]
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Please add my Reviewed-by to this patch for the next version of
the series, so that I know which patches I have already reviewed.

Regards,

Hans

> ---
>  drivers/platform/x86/intel/ifs/ifs.h   | 2 +-
>  drivers/platform/x86/intel/ifs/core.c  | 6 +++---
>  drivers/platform/x86/intel/ifs/sysfs.c | 9 +--------
>  3 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
> index e07463c794d4..ab168ddf28f1 100644
> --- a/drivers/platform/x86/intel/ifs/ifs.h
> +++ b/drivers/platform/x86/intel/ifs/ifs.h
> @@ -246,6 +246,6 @@ static inline struct ifs_data *ifs_get_data(struct device *dev)
>  extern bool *ifs_pkg_auth;
>  int ifs_load_firmware(struct device *dev);
>  int do_core_test(int cpu, struct device *dev);
> -const struct attribute_group **ifs_get_groups(void);
> +extern struct attribute *plat_ifs_attrs[];
>  
>  #endif
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index b518b661daf0..62c44dbae757 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -20,6 +20,8 @@ static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
>  };
>  MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
>  
> +ATTRIBUTE_GROUPS(plat_ifs);
> +
>  bool *ifs_pkg_auth;
>  
>  static struct ifs_device ifs_device = {
> @@ -29,8 +31,8 @@ static struct ifs_device ifs_device = {
>  	},
>  	.misc = {
>  		.name = "intel_ifs_0",
> -		.nodename = "intel_ifs/0",
>  		.minor = MISC_DYNAMIC_MINOR,
> +		.groups = plat_ifs_groups,
>  	},
>  };
>  
> @@ -53,8 +55,6 @@ static int __init ifs_init(void)
>  	if (rdmsrl_safe(MSR_INTEGRITY_CAPS, &msrval))
>  		return -ENODEV;
>  
> -	ifs_device.misc.groups = ifs_get_groups();
> -
>  	if (!(msrval & BIT(ifs_device.ro_data.integrity_cap_bit)))
>  		return -ENODEV;
>  
> diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
> index ee636a76b083..2007d8054f04 100644
> --- a/drivers/platform/x86/intel/ifs/sysfs.c
> +++ b/drivers/platform/x86/intel/ifs/sysfs.c
> @@ -141,7 +141,7 @@ static ssize_t image_version_show(struct device *dev,
>  static DEVICE_ATTR_RO(image_version);
>  
>  /* global scan sysfs attributes */
> -static struct attribute *plat_ifs_attrs[] = {
> +struct attribute *plat_ifs_attrs[] = {
>  	&dev_attr_details.attr,
>  	&dev_attr_status.attr,
>  	&dev_attr_run_test.attr,
> @@ -149,10 +149,3 @@ static struct attribute *plat_ifs_attrs[] = {
>  	&dev_attr_image_version.attr,
>  	NULL
>  };
> -
> -ATTRIBUTE_GROUPS(plat_ifs);
> -
> -const struct attribute_group **ifs_get_groups(void)
> -{
> -	return plat_ifs_groups;
> -}

