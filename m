Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E14190
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 22:53:32 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id v10so1513724iol.9
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 15:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8oRFDkjTItmRARF9MPboyy5pcC53D8DFiO7r4AdLOx4=;
        b=Bd7/3V61PyyseMyST3POk/iFFLs64mcNtbzneGvgXjwAHwoN787AWd0WkqLWJjPuea
         5z/MBP8WbYF8fdGz+tNmL7FgRsUIX4a2JjqxvtEslsvAL8Z4njloFPDndQMkLTl1xVc2
         NdvndADX1rsLdLPYVN9WvYFn8aHHIGI0LnoTveiNMXERXKEV47iGwFLQyMW46uuOeEzJ
         YOzByngT3mNfjkFKtppIJ38MwPabqkBn1zbanif+wLmKRxyh/Wz8F+WJcXUcMoT8qU69
         cEFSfaDGBgLL4kfeJuM74OLZ+ebCNT4SWshVr9XjEBC2x2Cy1PEm46MhKa7UvjmhLasw
         Ia0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oRFDkjTItmRARF9MPboyy5pcC53D8DFiO7r4AdLOx4=;
        b=FOY+dRJSdjpJHH9URDokun/b1x4+fBhSSwYczp462Gaw+xJwrvQqzao80LAb3sYhsN
         /j6cIUmJZ3f9AirqceEw6AVq0umAFmkrBY6oUsjzpDdhdyYB+Myc8JvcAPLCDdewChe5
         2fl3RxOU4DvWQGGPE8zm5DszLMNv0u5DMVuz3ZIQ968s/u+HJCX1+xJgHq0VrdtNIqbi
         wQ6uXOKdH5eoAVvDtpwGkwl8ALSoKQPO75lH0AkGKfBycI+bS6xtD/0Bao16RgghqS7Z
         cIS5VDvEozNO+2wylYKTKdvBBRgN7sv9lt6ZWHhT5N9pdnfEZ2CtwUqb8W0Sj2Oc7mER
         itBQ==
X-Gm-Message-State: AO0yUKWuCDQu1xv1GdU8L8Fc4jRtuJXCetEEQLVuyVn8mX8wp85daY8n
	6YldvbKISC54BnltmEfmmds=
X-Google-Smtp-Source: AK7set8TbvIiZSVTbzgAzem48+HVV7SREKPoXRfSJh69O43NHm9hgkjAEBeUv0X7fxe5D4kNPO+Phw==
X-Received: by 2002:a6b:4a18:0:b0:743:7742:1bc2 with SMTP id w24-20020a6b4a18000000b0074377421bc2mr364810iob.16.1679007212010;
        Thu, 16 Mar 2023 15:53:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g13-20020a02270d000000b0040306bfd949sm181096jaa.21.2023.03.16.15.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:53:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 15:53:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Message-ID: <8cbf73b6-f9d4-42d4-9dea-545caa558958@roeck-us.net>
References: <20230316083335.429724157@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083335.429724157@linuxfoundation.org>

On Thu, Mar 16, 2023 at 09:49:41AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.310 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
