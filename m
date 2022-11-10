Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F411E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668114296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESV0EBIfdSkKVU9C1MpNbQrrf3Hjd+qZEwZ6K/0lz/0=;
	b=Rqat9azifWp4aOWJcrg1KWrXnS7wZ9SEDVgndDrIx/jJZGn+KHT16Q1vl4LWKaHNOMoXdl
	jL+BPoFKaiNpQn71kBFP16aLB2Ebd0l5bZuUGYzP94vqrl0m5fmCPROIKpWvrhOFFwrEuO
	Krpau/C38MQiJ3V0luSV0iPp0sGw8jM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-17-sDH6lEPdN36ux3SBvqryHg-1; Thu, 10 Nov 2022 16:04:54 -0500
X-MC-Unique: sDH6lEPdN36ux3SBvqryHg-1
Received: by mail-ed1-f71.google.com with SMTP id l18-20020a056402255200b004633509768bso2277907edb.12
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ESV0EBIfdSkKVU9C1MpNbQrrf3Hjd+qZEwZ6K/0lz/0=;
        b=FiFBdV1Wkj1g7aanKrGq2kUyYv5j8dslvXMJE64UQbT2FCuM1Rowp1tPzH3BYsxwAR
         YmjeBhs04icSlpd9+ZZBRq90PJi1qPngYz+WUWe3Bl5e5C/XwU82lMnwm8+WvUh/H3Yt
         y22wLOf1x4964JBgE1D3fG05yLCIBmGxH8ryEsZCUyb9ECVZiG+1M5nIcAQzomE/VwH5
         Bu8aZA4MRzgOiBoom6Jjeq0LAtWKxkfBZsmOnkKz9Pku5Ujf3i/5pwdZSQJdBpf9PS3V
         JGRtVDn2GOau3jB5RaB9lpeW0a0TMt5tKYFsycvfm75xnvyKQcHHYgN7xR6BjwJl/Pbd
         AKKQ==
X-Gm-Message-State: ACrzQf3qXbxKMJc1DmizPvVZQiiXbRv8lH7Rwea9TBsESZP3NWzTFVsh
	p0ceaq4HrOlsP9PofFDE96EtdOUX/uUBMeXLDOI4mefpy0XzQDCX3XkfSsVYqK4KwsPNKXIgsQz
	su2nCuE2c8vBz+phTRQ==
X-Received: by 2002:a17:906:2743:b0:78e:1046:c52a with SMTP id a3-20020a170906274300b0078e1046c52amr3947079ejd.713.1668114293745;
        Thu, 10 Nov 2022 13:04:53 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7RVJLiRUIkFjzfkOCm1t81pUWwfRE35mn+LHOh9gGPoY+OKEbHC0q7S17LQtUVgd7GMW9JYQ==
X-Received: by 2002:a17:906:2743:b0:78e:1046:c52a with SMTP id a3-20020a170906274300b0078e1046c52amr3947055ejd.713.1668114293544;
        Thu, 10 Nov 2022 13:04:53 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id r18-20020a1709061bb200b0078d4e39d87esm98563ejg.225.2022.11.10.13.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:04:53 -0800 (PST)
Message-ID: <6107283a-ec3f-9873-9f1a-e43a3e5808ea@redhat.com>
Date: Thu, 10 Nov 2022 22:04:52 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 02/14] platform/x86/intel/ifs: return a more
 appropriate Error code
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
 <20221107225323.2733518-3-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-3-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> scan_chunks_sanity_check() returns -ENOMEM if it encounters
> an error while copying IFS test image from memory to Secure Memory.
> 
> Return -EIO in this scenario, as it is more appropriate.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>  drivers/platform/x86/intel/ifs/load.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index d056617ddc85..89ce265887ea 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -157,8 +157,10 @@ static int scan_chunks_sanity_check(struct device *dev)
>  		INIT_WORK(&local_work.w, copy_hashes_authenticate_chunks);
>  		schedule_work_on(cpu, &local_work.w);
>  		wait_for_completion(&ifs_done);
> -		if (ifsd->loading_error)
> +		if (ifsd->loading_error) {
> +			ret = -EIO;
>  			goto out;
> +		}
>  		package_authenticated[curr_pkg] = 1;
>  	}
>  	ret = 0;

