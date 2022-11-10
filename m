Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340771E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668114536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rt4kniXmvDtyRf2XxhyuEkQ/wRffXIwXWkCIC4bhcac=;
	b=fT339iHcOHmnD/ESxLSidF6QIeJ1C2eoGee1CeR+v4I+SF8DYKKezwWf8ljX/CDKTNZrA2
	IlN9fBwqa885/Dq4HIl8rlt2W4njoUZMi3lddBigs4YXHPntnDgNLM8YUc06Qa8RcMAm+2
	nk2Z+g/3vV1jSRPAZYItnFNca19zAXA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-177-8c06Wd2XNSOwOqqVYIds4w-1; Thu, 10 Nov 2022 16:08:47 -0500
X-MC-Unique: 8c06Wd2XNSOwOqqVYIds4w-1
Received: by mail-ed1-f72.google.com with SMTP id y20-20020a056402271400b004630f3a32c3so2293986edd.15
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:08:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rt4kniXmvDtyRf2XxhyuEkQ/wRffXIwXWkCIC4bhcac=;
        b=OFEJqKIT9xf9W/j4+c6njCEM8fEtUKPNMQ/Xavg/iUxwPRiKPV8YRlJ91lQ0V/b0i3
         dYFU22lg7JoKPCgiqwyqCGHpcOtKq1CNGpVrC9shIa97oeDeqE7SinLs6Qlq+B2+YqOR
         pFbe/hjHMKthhNCdnnfKFDsE2jt+No6RSbU5kdlgntShc8gOy43H3V2UkYdxFFzVnf89
         YRzzraSDzriEWqS/o3bgLvt0H9fXWufj9qoKN1R7KqzFVr5PYZgO7NNMT+cjoe/TM2Aw
         pknj1cTIy1zn1s0Ce4FGrOEYVbaPN8+IW+v99P/SErl2eweno8LnoCt73NpSXG+WNxgf
         eoIw==
X-Gm-Message-State: ACrzQf1RaYs8QLEua0+CGmgxpevbdbx2zxPpQ/ZQPy2Dnw7TdkZuIi4U
	3yQCNn9Kn7jFjk257cqcoktRS+56YF3A2qQCqEd1XUY0R4DDHOaUi7rR3p/6ypE3FMKhR+FbBWZ
	x1/kwbTZxHpJyI/QFrg==
X-Received: by 2002:a17:906:d7a5:b0:7ad:7e81:1409 with SMTP id pk5-20020a170906d7a500b007ad7e811409mr3872972ejb.326.1668114526142;
        Thu, 10 Nov 2022 13:08:46 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5R9MGIA6iINe9cVuByJdambLMksBfYDG46S2j2yR2NF9TYXZxTkjdIpN/wYA2angbORWct/g==
X-Received: by 2002:a17:906:d7a5:b0:7ad:7e81:1409 with SMTP id pk5-20020a170906d7a500b007ad7e811409mr3872954ejb.326.1668114525900;
        Thu, 10 Nov 2022 13:08:45 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id i4-20020a170906698400b007ae9c7b3c45sm130639ejr.99.2022.11.10.13.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:08:45 -0800 (PST)
Message-ID: <64d4dd57-24b3-4397-8704-cc8f156b5012@redhat.com>
Date: Thu, 10 Nov 2022 22:08:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 08/14] platform/x86/intel/ifs: Add metadata support
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
 <20221107225323.2733518-9-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221107225323.2733518-9-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/7/22 23:53, Jithu Joseph wrote:
> From: Ashok Raj <ashok.raj@intel.com>
> 
> One of the existing reserved fields in microcode header has been
> allocated to indicate the size for metadata structures.
> 
> The metadata section within microcode header is as shown below:
> 
>     Microcode Format
>    +----------------------+  Base
>    |Header Version        |
>    +----------------------+
>    |Update revision       |
>    +----------------------+
>    |Date DDMMYYYY         |
>    +----------------------+
>    |Sig                   |
>    +----------------------+
>    |Checksum              |
>    +----------------------+
>    |Loader Version        |
>    +----------------------+
>    |Processor Flags       |
>    +----------------------+
>    |Data Size             |
>    +----------------------+
>    |Total Size            |
>    +----------------------+
>    |Meta Size             |
>    +----------------------+
>    |Reserved              |
>    +----------------------+
>    |Reserved              |
>    +----------------------+  Base+48
>    |                      |
>    |                      |
>    |                      |
>    |                      |
>    |    Microcode         |
>    |                      |
>    |     Data             |
>    |                      |
>    |                      |
>    +----------------------+  Base+48+data_size-
>    |                      |     meta_size
>    |   Meta Data          |
>    |   structure(s)       |
>    |                      |
>    +----------------------+  Base+48+data_size
>    |   Extended Signature |
>    |        Table         |
>    |                      |
>    |                      |
>    |                      |
>    |                      |
>    |                      |
>    +----------------------+  Base+total_size
> 
> Add an accessor function which will return a pointer to the
> start of a specific meta_type being queried.
> 
> In subsequent patches, IFS test image file (which reuse microcode header
> format) will make use of metadata section.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>  drivers/platform/x86/intel/ifs/load.c | 32 +++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 89ce265887ea..60ba5a057f91 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -44,6 +44,38 @@ static const char * const scan_authentication_status[] = {
>  	[2] = "Chunk authentication error. The hash of chunk did not match expected value"
>  };
>  
> +#define META_TYPE_END		(0)
> +
> +struct metadata_header {
> +	unsigned int		type;
> +	unsigned int		blk_size;
> +};
> +
> +static struct metadata_header *ifs_find_meta_data(void *ucode, unsigned int meta_type)
> +{
> +	struct metadata_header *meta_header;
> +	unsigned long data_size, total_meta;
> +	unsigned long meta_size = 0;
> +
> +	data_size = get_datasize(ucode);
> +	total_meta = ((struct microcode_intel *)ucode)->hdr.metasize;
> +
> +	if (!total_meta)
> +		return NULL;
> +
> +	meta_header = (ucode + MC_HEADER_SIZE + data_size) - total_meta;
> +
> +	while ((meta_header->type != META_TYPE_END) && meta_header->blk_size &&
> +	       meta_size < total_meta) {
> +		meta_size += meta_header->blk_size;
> +		if (meta_header->type == meta_type)
> +			return meta_header;
> +
> +		meta_header = (void *)meta_header + meta_header->blk_size;
> +	}
> +	return NULL;
> +}
> +
>  /*
>   * To copy scan hashes and authenticate test chunks, the initiating cpu must point
>   * to the EDX:EAX to the test image in linear address.

