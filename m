Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5F88C01
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 15:02:14 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id n2so22999939qtp.0
        for <patches@lists.linux.dev>; Wed, 22 Mar 2023 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679497333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oYQM2jTlS604YN00nsC6X2GY/6e0UfH9fOU0JivRqjA=;
        b=BepWEHbj3mt2tBk5UbRdoICuoZOmlUmehPOK+rh8KH6n7Gkz3nDN6yexr1uFBBCN08
         n93JvWdYsFafoBStPlqo7Pfh2+dm6S3wgmHXiRf8EPgjomkKbXnRMWkD+T+9MZ/L9y7f
         keA59Fx/mRmtKbiefe/YRaJL8tq99rW6rsHVf5pKq1dE0fOKaS7QfthYIdv3MOCOfoiv
         dFyBizEhGxWmjyLPygxqW/tLFjKFhub+UAVsofox9zIGFV4H+QEmP9t/V12hN8d3bzY2
         TOq7dLlK/9EdNk259OqeXrnrRCWLZg74+kSBn8lUWYvcCmqMj74T/+yur75BVJFJMjp4
         FczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679497333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYQM2jTlS604YN00nsC6X2GY/6e0UfH9fOU0JivRqjA=;
        b=wXfCkheTzyP9SPwdhJdij8uoieyIWuLH0PoeJPPGTjAb8k62Ihr+pI5orezzSdDxPj
         uhsrirjprvduoxWskaTkdEQL8GHUC2ilHTwcyVVV9Lj20nXFzGl8wsykbPWXftMOYtOA
         VwBtRVjdKUhkbzJxDzkovEJbOslCAPIFY1E1WS20B4QiuEkq+Ehw+yyyMxRa1BKuSh+b
         53QjL0zCgvL9dGBCiDSTFr/G9b7Hp1ivHGQfIc/I6y7buX23g7jEmfnHP/t49FWGZ+GG
         inOCUK8xq0glVMKN8/9syP+fem4nuKbRnrv05xupuK/RU7vykTih8hTNEbxxFWm7qhgP
         I+1g==
X-Gm-Message-State: AO0yUKVrnZmqLY0vYLwhaT66D2Uxl3aqCSmdTGseAPPcA6Sf//aYZIIj
	r0i4Yck/F2gTETX6hsfTwac=
X-Google-Smtp-Source: AK7set+VSdynk8EYuC29vErScyxFanU8Uii9XxtvdSxj02AVCP1dgudhg6cXvrFOxzfMt0SkyJCcBw==
X-Received: by 2002:a05:622a:314:b0:3bf:cfe8:f8f5 with SMTP id q20-20020a05622a031400b003bfcfe8f8f5mr6794567qtw.41.1679497333222;
        Wed, 22 Mar 2023 08:02:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020ac851c3000000b003e37d646221sm3990901qtn.96.2023.03.22.08.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 08:02:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 22 Mar 2023 08:02:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
Message-ID: <ea7d76f4-806d-4643-8339-aced5bf4b858@roeck-us.net>
References: <20230321180747.474321236@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>

On Tue, Mar 21, 2023 at 07:08:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 18:07:05 +0000.
> Anything received after that time might be too late.
> 

It is still Wednesday here, but v6.1.21 has already been released.
Sorry, my test bed isn't that fast. No issues reported yet, but
it seems pointless to send final results at this point. I'll only
report if there is a problem. Same for v6.2.8.

Guenter
