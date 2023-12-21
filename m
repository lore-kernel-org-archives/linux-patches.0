Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A959360BE
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbkFMwHZ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d32c5ce32eso14591575ad.0
        for <patches@lists.linux.dev>; Thu, 21 Dec 2023 06:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703170662; x=1703775462; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i3USUl9WO2gcOQwDnVCeaBX3q/QuTE9UFOGfxgimai4=;
        b=nbkFMwHZ7bQhk3WQoFBqtXAY1A+jDDHGqQvgIRhxc+6pQJUjEa5lOio0SjxmJsHw5W
         TKB/jG3VDWLHuljshl4Z8i7QALJj0yZVjuoUgd7qsIJ1r6Kmwt3xKPwttF/HXLIFrXlN
         hUbIpT/2wA8BgSKL9RUxfmXFoinVgaDnMgSpzxLlXQhKey3L/8dyP7LmJzJVuxXt5nPT
         ty1hY5k85rsFYT3lD+NNOpfep6oINfo9KvDU0F9rngF9NIAxn+aum2sP6kEsbaNsQy9X
         4Ax/gijMkgM3ZdVsi22NVVqU1T04Y8QBMNtPrTe2hRq3mxF3Of/URYoodsYv52LArIOG
         6t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703170662; x=1703775462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3USUl9WO2gcOQwDnVCeaBX3q/QuTE9UFOGfxgimai4=;
        b=pDtfOi6c1EtNEJ98Q1zlE4rLJhSPr3pphthC5jH3snr//QS2Ys5o3Sn8qyeUDQug5c
         i1mCgNas2HBR1CXYfsAfxWSSlSvLJsw+Pq9DTD7qVmkFRqhQCmFFfkvzg1fBTajbmpjj
         sAxgFKxcTdAelCMHCp5fuwEw4UJ+Chf0DDHmIIbHkWLPQhceV5YqTB7rf2rhnEAeb43W
         1JSeia+tqMTg1uUkNNKuIhnjUTp18pTn4nrHp09KvbLzi7CzZwLBlGLihKkFuVP1oNej
         r0DUeruDkFnNeiQ1GF/EYc3WnwbjUht8Y3HAzSAJu25/0r/wuZRhdjaMZqIKE5lSLZ+e
         JnBA==
X-Gm-Message-State: AOJu0YwLOP+y6cXQ93L2ofJCXCc/w2pT9SV2+F7UmwczaVzl/UvynzjI
	0PYC9Ro5taicMHztflyXZ3Y=
X-Google-Smtp-Source: AGHT+IE5wFdUULiCY8ELFxZqWGyGPK5/+XMGldnySVulFribOOOrmtJkIkISv8i7aleKcpl8MtnXpw==
X-Received: by 2002:a17:903:22cf:b0:1d3:cc75:63a4 with SMTP id y15-20020a17090322cf00b001d3cc7563a4mr973865plg.21.1703170662197;
        Thu, 21 Dec 2023 06:57:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b001d07ebef623sm1750024plg.69.2023.12.21.06.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 06:57:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Dec 2023 06:57:40 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/159] 5.15.145-rc1 review
Message-ID: <9307d019-b0ea-41ed-a559-2fb14022295d@roeck-us.net>
References: <20231220160931.251686445@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>

On Wed, Dec 20, 2023 at 05:07:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.145 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Dec 2023 16:08:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 525 pass: 525 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

As you may have noticed, the two day response time isn't enough
for my testbed, especially if all releases have to be built and
if there are multiple release candidates.

Guenter
