Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4042D1E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668114244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1QfUTLoo8KZyk/UmwYhDRfw7upAhiWcoYA8QgblVYZo=;
	b=bW7sPqc/VVLpo72102naRh/hnY+loZM3QYP81TMFkSa71Ov+FdLMjT3pYyo6j0EvW9Y35y
	GHbggD877VoudtEV6YDJkIqr3lrieUSxL61saGYs6vGD2sDyMenZXOdn1nBWM1DT1vWPje
	I1wXEes2GLY6v4Fn17J+oWSA2P8icXY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-160-aBXyHTRGP2aKN5qQu2g6zw-1; Thu, 10 Nov 2022 16:04:00 -0500
X-MC-Unique: aBXyHTRGP2aKN5qQu2g6zw-1
Received: by mail-ej1-f69.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso1876698ejb.14
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QfUTLoo8KZyk/UmwYhDRfw7upAhiWcoYA8QgblVYZo=;
        b=CeVnFYWXGFp24Bwiym/3oGsg+QMj5k6uza1ojYHKSuI3XDaHynK9cJ/FHcXfeb+9vp
         +NLshpEerq+QyWg7/D7woqYal7LsQKiI+LAi9wQF1piUFaKX2iTukA4QkTC4UrVeV/Wz
         heQ3WcHWby1SmKf8ptnvTxGuLn7Qsz1Q+KgU3I76pAQHk5I+IezrvM7BwLAF8y85SuV9
         sxL7nkLfrpKp+wXea7dovPwPTf15mTLy0fcW8bqlrR8CTaAC734KG8+A9EO/e3Q+f2mo
         59iLdgEnugzz2VegEVVOzl81pcEXXhIY5M9ApjvghkyW13YMwoImzaztAXgvJ51+xUyk
         v29w==
X-Gm-Message-State: ACrzQf2A6aWTV46zirNEo0P3xv1xMCcfS/NqHNP51NZ6fx88LoqfI4yr
	7mWiqgBMGZOe4/5dC4QLsJve5k60Q5r3zHjQ4QEOIk5K4ESvyE0b1snvevTKEvx8ZvfamKt/C+H
	pR9EUJWpXkpPGLkfzoQ==
X-Received: by 2002:a50:ec8f:0:b0:461:f919:caa4 with SMTP id e15-20020a50ec8f000000b00461f919caa4mr3484891edr.255.1668114239099;
        Thu, 10 Nov 2022 13:03:59 -0800 (PST)
X-Google-Smtp-Source: AMsMyM60lzCeZXfSRx4OZ88TfurkkBOoWJgHUAZxFcNaBDri3o3LrZKlUiOtI33RvYqQwthK2FbxCg==
X-Received: by 2002:a50:ec8f:0:b0:461:f919:caa4 with SMTP id e15-20020a50ec8f000000b00461f919caa4mr3484876edr.255.1668114238922;
        Thu, 10 Nov 2022 13:03:58 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id oz36-20020a1709077da400b007ae4717bef1sm155820ejc.15.2022.11.10.13.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:03:58 -0800 (PST)
Message-ID: <6798b3bc-125a-220d-3f37-71dcdf522f0d@redhat.com>
Date: Thu, 10 Nov 2022 22:03:57 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 01/14] platform/x86/intel/ifs: Remove unused selection
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
 <20221107225323.2733518-2-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-2-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> CONFIG_INTEL_IFS_DEVICE is not used anywhere. The selection in
> Kconfig is therefore pointless. Delete it.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/platform/x86/intel/ifs/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
> index c341a27cc1a3..89152d46deee 100644
> --- a/drivers/platform/x86/intel/ifs/Kconfig
> +++ b/drivers/platform/x86/intel/ifs/Kconfig
> @@ -4,7 +4,6 @@ config INTEL_IFS
>  	# Discussion on the list has shown that the sysfs API needs a bit
>  	# more work, mark this as broken for now
>  	depends on BROKEN
> -	select INTEL_IFS_DEVICE
>  	help
>  	  Enable support for the In Field Scan capability in select
>  	  CPUs. The capability allows for running low level tests via

