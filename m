Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309777B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 03:30:21 +0000 (UTC)
Received: by mail-oo1-f45.google.com with SMTP id h18-20020a4abb92000000b00525397f569fso1090902oop.3
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 19:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RksO9bprUe5tFGfK4HSRowFsGMj7f+lh/jN8XoDWZoI=;
        b=UMZ0+JusnnT6R7rkGWI2kyRnprmuKJXcpPrq9SvQ6Kuj/AfYziL9PDSrtPHo5N/EUg
         fqaf1qvnMR9wPl2bkOGCE9HTH9AlUM5rZ2+O7BOkPklTc1FqygaRmmlFHNbZwrCgn98E
         j+yCDJUCv88p9L4aDdnRsm3o1dYyxJ3pP4fgNrjc3Xaqqbo978eqhk3Ir03OpUgAr4Jm
         8U3QH03BvcakzaRIeiPEuLstLA/DrmsCQtgx8eNXHN5kznfdKXqQdbTumMBPGbJCBb8V
         w8VWAyfZh1KwLB9jmpmxOQDFktCGvMpfsGjvqsBol6TNocHxAePmyXBD4tihcfY/7HWh
         iFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RksO9bprUe5tFGfK4HSRowFsGMj7f+lh/jN8XoDWZoI=;
        b=TuGKR+U3FAqG1GJown901Vi6PwH2eYsKZRTecnphPEpp7bZT4jBUGu96NMcMPBHl67
         BxchbLkmB7SLnf7OqNY4O6gNFpd5hDEnSL5VaeGpQG2QarXbB/wdAv9V+ECjSUd7xd3q
         LMMBn6920DAyFu3OowyMGDrJxtWz4sOh72tTcDbZJ7cVQEBNE+Sg97U46Z7LqmHNCa3+
         Ejg+RBinWxMfOSHEVOefXvCaBlpIdLt13BdeUIeA77TXzylIhKuU/iTYz6+Phot1vwWd
         w5mto9vFoWMTzWd4Y97snrUTUndvG4QmkW8lWrmr94pcgGcC1x2Sgk48/ZO2k7vM4TMf
         NLbw==
X-Gm-Message-State: AO0yUKXtuUfgU9tbg0TKxcd/ySBarOcragyqVkKjiCncSAu3pLrauiri
	hSqvWkJhwc7lv4sU2w3oAAU=
X-Google-Smtp-Source: AK7set9rv+V8xcHFPaC97QsI73P2OKWMI2AvZeD9ZNvXF36nx5hqS7GAMl/SNbseThTP/TEtgiYOQg==
X-Received: by 2002:a4a:bd92:0:b0:51a:186f:88c4 with SMTP id k18-20020a4abd92000000b0051a186f88c4mr11257141oop.0.1678505420249;
        Fri, 10 Mar 2023 19:30:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8-20020a4ae7c8000000b005252d376caesm659775oov.22.2023.03.10.19.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:30:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 19:30:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Message-ID: <335b16e1-3907-40e4-a4ae-7cafc78c41df@roeck-us.net>
References: <20230310133706.811226272@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:42:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
