Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5BB1E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668116051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGq2aqvFk/urSwdIN4KIfJO6NUgNb1K5ak9OotOPtfU=;
	b=T3DhtYOMOwiWUsy78RrNNU5kLY6a5CldfrtOFphAYRnkVems+WgvvqRVStlWijQ7gDqVGl
	RMPf3KtKP5B7SzKhcwncdGmWiardPoWIKXv2HNbKbUYTLH5D2ClSVGVAluPEtGsW7SPert
	C/YEFz1cF8IU6kqKFUhS/psAGyhwJRM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-c7V_2sxvMR2KNaiasU1hmw-1; Thu, 10 Nov 2022 16:34:09 -0500
X-MC-Unique: c7V_2sxvMR2KNaiasU1hmw-1
Received: by mail-ej1-f71.google.com with SMTP id qf25-20020a1709077f1900b0078c02a23da3so1932214ejc.0
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGq2aqvFk/urSwdIN4KIfJO6NUgNb1K5ak9OotOPtfU=;
        b=C4HI3ppyoFVEIZ4q5bIBQSSCwSxR3dBv4oVsllPPTOSanFzLMBmnn+5Pn6ZDrEqJEQ
         YbNjzfo5m6G0of/+tiCfIiEky0l7xB9GInmBEASJCaOY369u9tArS7Q3FLYLdmBPZBm4
         b3bDve4y7H4SjaeRTN2TEfczJLETlZIz0B5IxbSDSGN6nFstP77yTr4NwPNTGx5gegxd
         YzO4LayBOZ45EaVLaXbxL/hnDKqcorRsPCpFUfNcnbcV/feWX0h0+s6qvjkyU1NxWlJ/
         78GMd8nQ6oBqts4myy9kSubGyPlJNHNlgenXvDrJE4h1Kc2LvaivRUjsrHXz6X5LOG/G
         w6Wg==
X-Gm-Message-State: ACrzQf34H5m/ohbB8334/VKsjEykAYpk3+CXH9vC2XchSob68V91KuZP
	/sx9LiHXIgdi2YCaGM2zmFw73guCCFerB3iKEi41nfvsphff3qE08qkuo7QU5ARTHi0Am18WCsi
	9bP2YzTaICGIgRXP+FA==
X-Received: by 2002:a05:6402:c8d:b0:460:7413:5d46 with SMTP id cm13-20020a0564020c8d00b0046074135d46mr3579568edb.47.1668116045462;
        Thu, 10 Nov 2022 13:34:05 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4GapEdBzGG5QBFJAeIp0VGj5YCHVjerCZbIsaJ0p+/SU6lOYT9dCpExb/V2/Jl3tN20W345A==
X-Received: by 2002:a05:6402:c8d:b0:460:7413:5d46 with SMTP id cm13-20020a0564020c8d00b0046074135d46mr3579556edb.47.1668116045249;
        Thu, 10 Nov 2022 13:34:05 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id lb17-20020a170907785100b00734bfab4d59sm139507ejc.170.2022.11.10.13.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:34:04 -0800 (PST)
Message-ID: <72b7481b-8b69-d091-a097-ee6c9fbb92f8@redhat.com>
Date: Thu, 10 Nov 2022 22:34:03 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 14/14] Revert "platform/x86/intel/ifs: Mark as BROKEN"
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
 <20221107225323.2733518-15-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-15-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> Issues with user interface [1] to load scan test images
> has been addressed, so the following can be reverted.
> commit c483e7ea10fa ("platform/x86/intel/ifs: Mark as BROKEN")
> 
> Link: https://lore.kernel.org/lkml/26102aca-a730-ddf8-d024-2e7367696757@redhat.com/ [1]
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/platform/x86/intel/ifs/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
> index 89152d46deee..3eded966757e 100644
> --- a/drivers/platform/x86/intel/ifs/Kconfig
> +++ b/drivers/platform/x86/intel/ifs/Kconfig
> @@ -1,9 +1,6 @@
>  config INTEL_IFS
>  	tristate "Intel In Field Scan"
>  	depends on X86 && CPU_SUP_INTEL && 64BIT && SMP
> -	# Discussion on the list has shown that the sysfs API needs a bit
> -	# more work, mark this as broken for now
> -	depends on BROKEN
>  	help
>  	  Enable support for the In Field Scan capability in select
>  	  CPUs. The capability allows for running low level tests via

