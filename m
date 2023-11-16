Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CA5225A2
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 23:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nc9ifE4A"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6b709048d8eso1294123b3a.2
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 15:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700178295; x=1700783095; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gzRF8uHq6PjJBxbhxhi0V10xOOQOgpxlbEBlX7hXGSU=;
        b=Nc9ifE4Am/jEDy4nj+M+BnOphQ1ROkeOZsqozlLK9TOOJu2zI0ZFi2/1qYYmNMKUBr
         dKnrb1Q0SwOeo9VQ2j+qfPGX3a7ZUSNssxgeGiT/wD2cPmhiHMPjqvJ09p2NA9lkfF9L
         PM0Fcrb2gL3oauVsUMfSG+fhT7bqXSNvbWRHOYrkBu2+/6c9aieC7LPu08JBfe+35CoC
         mOsNNCTn3GaTOKEj3lctdPghhtO4kDl5ZeVDW9iqyx+uzI+nbVAPyyt3J1VI/+77/0m7
         99JuA3G4E2Ft9dtxLpbxWsVSyqyrIjiUpXXqBx5qhZMLwOUsam0QJcRYdBJZqgPFGBeN
         arcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700178295; x=1700783095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gzRF8uHq6PjJBxbhxhi0V10xOOQOgpxlbEBlX7hXGSU=;
        b=F54i0JFYzpXo2t4n3wwC7IArtdbWkwTUw6DgXtk6EGIF3Umrx3TJ1JBGbp5A2YMQV1
         DdCJO0FOn/MD++o/3sP2Rofdu5e1IHlQJgpCcAgAK47astzUxeaEDylCGKAnV6QVYrZj
         m4tIQaUvbbpv6e41cGqhSMOX8AJl2VYrUH4GY758umg7qECTo7fZfEXZBbP0m1Ll7IIa
         O+bmSUEvd30XzMfxxV4TO9/qdYWnMKFHS1ND81zNZQGofzWJNaecNQ2lukTHew9Mz1gF
         aKwdaSE+CqyoeWhEW0KCDS/Em9onPJydQnOp8ruTrJQq0n2Xa015etPdBkqW5MEgGNut
         uF+Q==
X-Gm-Message-State: AOJu0Yx1+Ky6KifUHjW6VBtTa8k8bxw01aYt9Svsf2ByuikZlN7ULign
	RlSDmj047Z8TJXgj/vYHiuHQYHjGVo8=
X-Google-Smtp-Source: AGHT+IFYAXnKf+Mqzf4eTA54yG1aQFbfDgf3fpmvkk8Vo+h1M85WnXVJcWXq3Sm/iRTBr/QF2Xm7kw==
X-Received: by 2002:a05:6a20:3d93:b0:182:119d:2d0e with SMTP id s19-20020a056a203d9300b00182119d2d0emr17452371pzi.20.1700178295271;
        Thu, 16 Nov 2023 15:44:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a8-20020a62bd08000000b006c2d5a31ab9sm284858pff.81.2023.11.16.15.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 15:44:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Nov 2023 15:44:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
Message-ID: <7585d234-ec25-4a75-8283-0c6452e97ca4@roeck-us.net>
References: <20231115191613.097702445@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>

On Wed, Nov 15, 2023 at 02:09:05PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
