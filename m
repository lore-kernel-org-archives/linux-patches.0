Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53207134D3
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 17:24:30 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-563f8e8a53dso1605446a12.3
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693243469; x=1693848269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DH5Pw+Nwtjtpn2RlWDLRV4PLv534RmiJ+ccVLunffaM=;
        b=pNg4eGBNuZU4MjoKe5+HwtXKrM2X1biBf0V+NuWovRIv6ZESWJ52o8VHP4ry2WYXQm
         51cOOFQ/Dcj2nlLA/xapoR38GfIo6MnlQqAq13QCLKIKtwNNNwHk87/7V46n7z/yexcS
         WrcO+xy9sbXGnnaLfvf254Q8LDCbHecvWbR3aeyGgCJnkvy8j8oX/vERrDHHNuzgtxfA
         gg/AGZIvsTMBHR6kIdzwc1jL9tHn6RMdxaDnIvfUzhHMSq/C+QLSqG8jMrilJzyF7MsT
         Bk0mLGiE8fhQLqLvMyFWCVSiyky3CN4+YQXGC58jQFKWSpUbln6KGyNSydCy83qmVViY
         4SWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693243469; x=1693848269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DH5Pw+Nwtjtpn2RlWDLRV4PLv534RmiJ+ccVLunffaM=;
        b=F/CvKNfC7CpDkNfHGrnSDOxI5OIwUvzubHAc6QWPKZsEK6kdStcNaZfI5ngXL/9Gv2
         wve30mTJ/6MeXYnN5KA/H5f/ZWGPHgUnXYXaZz8TR4RFZVvj0K6UptADVENs/CUFeGKf
         5mcnOaQGVOLxSKZgSOrNCaZiSuGjCINzbOa+dNGF0Rj7uXRJ6p2auIOQYq1hmg1ngMcp
         8+Tyho/rVxNQgxRrk3FpejoHrQjPmeiVx0V4v4VcxA5dGo2Rj+5ufl/yjohxHbFpkgW5
         V+uK7qYaI9q8R1xGix2AKk/B77MGAqVg6htRlR8X9UK0yrov3ASvyCp0BClwaXF67uBC
         qnEA==
X-Gm-Message-State: AOJu0YwrN67ShM/EU3mIEPqnJ4Aa16O5cillkgFnUn1YJr4PBHH+q9fl
	ls1y9fPamUBIxr39x4hSFQA=
X-Google-Smtp-Source: AGHT+IGaAIVkKliPxSEirGIzxTAM3xU/hfjAL4uB3WLrRpgkso8PKdU5F/PUUFmn6v+c3BpaIplIlg==
X-Received: by 2002:a17:90a:748b:b0:26f:a34c:90e3 with SMTP id p11-20020a17090a748b00b0026fa34c90e3mr14857713pjk.31.1693243469388;
        Mon, 28 Aug 2023 10:24:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a1a4700b00263f446d432sm9864248pjl.43.2023.08.28.10.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 10:24:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 28 Aug 2023 10:24:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Message-ID: <a47b63cc-174f-4de7-987b-16a6264ce42d@roeck-us.net>
References: <20230828101149.146126827@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:13:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.193 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

v5.10.y also needs commit 4ea6fa2cb921 ("mhi: pci_generic: Fix implicit
conversion warning") to avoid

drivers/bus/mhi/host/pci_generic.c:276:25: warning: implicit conversion from 'unsigned long long' to 'dma_addr_t'
	(aka 'unsigned int') changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]

which is seen since v5.10.192 when building images with clang.

Thanks,
Guenter
