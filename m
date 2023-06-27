Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB137E6
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:33:05 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-66767d628e2so2783403b3a.2
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901585; x=1690493585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EgbDvvzUv8QtDJ40QzJnjKKZJrxnC6hVW/NOrwNS2pU=;
        b=TqkuFqpEAF0j6gP25gYyRdHaLlwMeoiRRSwcxhnP374icarclcMhqDNNbOUBGMBHDr
         mj7nhH27KJ8iWXR6Md2/vwfaMe2X6LnQlQV/8SRFuvtVyhdZ5unVkN2DrRKsR45sOBD3
         grl35H4Sd8xFopz6ZN4MFyshcTItPMDWzWwV/+JxB6N4SNfd2M1dKjyfIZlwWG8wtv2w
         Gb5FpJbI+Fu4K2evQ410eCdJiM1AUgbg3MAej7giGricDUMEfIG7e4G8+Dfu7qEn7i+Q
         PSrLxSUw45gF3IHDQjcJRzyMJN4/kAsPdE/Mm/UjR1sEi7hXlHBBHq9I/s14AjCQhqk2
         J6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901585; x=1690493585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgbDvvzUv8QtDJ40QzJnjKKZJrxnC6hVW/NOrwNS2pU=;
        b=Z43YIPKUSJdZWp1qnzAlsxjNHNsRp92YLPQIh2WhlVUMC6ZZLgXXi/c67tN9198YfC
         lD6wYF7Q8wKYPfr26IfvMQHglTbxb7qc9SRfwmo5KNvBdGOW3/RUlp3sfq4oOPviZA7y
         L00cWpsk9MIiny+ShCKQrgK+JtwKiS+dGgQoHpiQtkTDWnKD2DhPzIRKSKPOkWvrTuSZ
         IMEuZfTvW3Qq3APDpXhAEPAuAeb/V3F59bLNU94XWOpehL6XaQ5k/Z8LKiLnrb4RHqrb
         pI9+IMnJ35T/9FzsBehh+2PyL6likqdDm+jmkmFf2bB11GU2MdPOfpsToESaCsqpDWvC
         iz5g==
X-Gm-Message-State: AC+VfDwvNUbqAgtfHUuewQ3f2ol4uwQ3q6+oQfZ0DyFx9xVk8+ZHISeL
	fT4522Z+xAJm8Uwo4hL6pks=
X-Google-Smtp-Source: ACHHUZ6e0+9xPrHdfZ2likvnrI0ojEz5hwqfheQVBPRJqYJAGeVWASjQhE0hLpAmsMsVkrcOro0NkQ==
X-Received: by 2002:a05:6a00:3909:b0:666:b254:1c9c with SMTP id fh9-20020a056a00390900b00666b2541c9cmr26761263pfb.27.1687901584729;
        Tue, 27 Jun 2023 14:33:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z19-20020aa785d3000000b00679efed4108sm3111394pfn.33.2023.06.27.14.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:33:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:33:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.3 000/199] 6.3.10-rc1 review
Message-ID: <b772d50a-118c-41b6-99d9-e97d38d3c9b0@roeck-us.net>
References: <20230626180805.643662628@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:08:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.10 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
