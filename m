Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3A8AD4E
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 22:55:06 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id h83so1512637iof.8
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 15:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PDqnB+25WEIFzAeTWsEfLXtQkDLmmzfSU2WMJi3b5vk=;
        b=SjD6DQTFYTR8eR/RCg2fEP58wOpRuZc7For4KxoDsGPwcUe0vdW1gn3piLoecF/aJr
         6V0W60hwXJzc0dPTomk8bP31xuybjTM/zyH6KmI0P/hnXTV2hWhxh4oCJqhxAiDtsgiR
         xBRg9hYy0xRc9/wyx760qNYMRSeLClt/4RfgAt+zano+3c/RJJW7lcwVAtFALAMXxre6
         933GXFqkKeaQDw0REjOlbxJ2MgZr8dMTivYKVL69oZY4xz8E/iM9vFW7VgszuFtNIJ2G
         PmnFtLFtAimwQkNigmop6Fj8CV2sRH3VwokTV2xPXZiXgNeIDfGwyvdbgo2gpUBkmFe/
         t9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDqnB+25WEIFzAeTWsEfLXtQkDLmmzfSU2WMJi3b5vk=;
        b=Q3CzLHfUe446zYV6gSCvwBHAFzyjLz8x6Y5VHegunR1dTpJYBlGfloHf7hVTbWY2VT
         tiCr/KTeNk20pOnrRqx9JTbmMBJU0EPM9OnTI/fuSwxVQQh+wD8CUG9agTpJsHq66xdC
         wXS8UiwqDRsO97vwqGDUu3X+cdAcZ1+0908+Qydm9rAR5gW2UoRacxOX23Km++flsJgB
         NR45lFfUVEh0DCbumOZPDA6JenjAPP3LNx8rMIg/QWDIHQobL4wjPoSv9YEMJox7OIZC
         sd2/4AauaEwyQ5fG72HMYIZcT/Jh8Hnin/uh+LwGtFhvI9OGMaxIwscgBxyLR0SR4EcP
         7OVg==
X-Gm-Message-State: AO0yUKU6rEocA1FfNel6dW77kFuB2dKUf/p3823Uj0vIhwknatE5a7rx
	WOHLUVKExD4RH8+dCdrEbY8=
X-Google-Smtp-Source: AK7set9HjK+eyqNRseAzK7Inyl24iZVywoa1PB8Z42F9aFHg0OvQgLdrN5eis1t1z7rBakYHol6SdQ==
X-Received: by 2002:a5d:9a91:0:b0:753:876:5bf9 with SMTP id c17-20020a5d9a91000000b0075308765bf9mr380727iom.6.1679007306041;
        Thu, 16 Mar 2023 15:55:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p66-20020a022945000000b00402e2521635sm157695jap.163.2023.03.16.15.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:55:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 15:55:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <fe42245e-7f7e-4506-812d-e128bccbe3f9@roeck-us.net>
References: <20230316083443.411936182@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>

On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
