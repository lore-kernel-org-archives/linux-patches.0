Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4726FDC
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgjdVXW2"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6d9d59d6676so4469587a34.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 09:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702402444; x=1703007244; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L0z2AT1BJQCnr747Qe1roJ7ZoVnIRvZI+JcfC+nIFJY=;
        b=VgjdVXW2ODPMDB9zrcc92xghbnCSvkVX+J9ssqEeQAN+2Lu8/yhXjYOEiVNJN9n5S1
         RrY5e0abwGVEvjhi6gWCgXQjEoItkyME0lopyIXvA26A/iHieJE1mnFCT5T5xbmMfBWf
         oP7qTB1Ec6lsL3Qx+QgjsejEVsJSHSSywEhu3fm/POsc+kZEOSxrmRTW0+ZGm+KP8GeH
         gOeTqRGkmOrsPqa8kCiunzvJ8O3V1xceVI8F4uVTAm7iJUJ66n3uDJgs7XYKjzU96Jma
         wRZjfGoFjdGN8E3dILGcohUvVitCfMphbd2QdpCw2noKpj/0hVvzZjyhTwwdE0qopbTK
         fbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702402444; x=1703007244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L0z2AT1BJQCnr747Qe1roJ7ZoVnIRvZI+JcfC+nIFJY=;
        b=KnWjo/fn4TaEAgno3wzzpiibPizJ0mhwkte4eTA1WqKVg7nKxQ3vm+0qprMMXmIwHP
         vIgyR7a5E0HBtwEED2O8xxnGMzJiav2F7sdOCMfEq6uXhQMAKD1Kpl592fF1Jyy/5jQH
         4hOKLf4w/287TG1cHENwg84D3bcfcTAbJfbRwWZDLyzVGeqTcQ8112B3zv+N5ToLlEKM
         Mzf1lLL4v6DCrGJCd7wGO1oLltCPlfN6bun9scUR0Giu4Baj9cTrxtjdxGFzXPxYTC+f
         NLb2b2AvsP6GiGCl6nTMwrvPg5og9LHaF9fZ5Q3YiabxXuuCkrNqI/YQ213JJigfSfD5
         QhPg==
X-Gm-Message-State: AOJu0YwHQf2RC+v94Ss3wtCUqJ32LBfXAgc7o5AlfmID0j0GpV9YMXIS
	p46cBn3uKElA3Fu8Aq2xD0w=
X-Google-Smtp-Source: AGHT+IFCiLt4rwoXp6x0bRjRpea/9EBC/0MF+xgyL2PXBDccmn3cy84+U+frpTFB5Idvb9FJiO+44A==
X-Received: by 2002:a05:6870:4153:b0:1fa:fe4b:21d0 with SMTP id r19-20020a056870415300b001fafe4b21d0mr8077857oad.47.1702402444232;
        Tue, 12 Dec 2023 09:34:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ps5-20020a0568709e0500b001fb33181cfasm3180566oab.55.2023.12.12.09.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 09:34:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Dec 2023 09:34:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
Message-ID: <a461d8ce-cf28-4840-af5c-6c7895c300e5@roeck-us.net>
References: <20231211182036.606660304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>

On Mon, Dec 11, 2023 at 07:19:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 545 pass: 545 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
