Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5CF641
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2A6u/Ar"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3b2f507c03cso3013847b6e.2
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701139885; x=1701744685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W6uV7n3X6HVLF/lWIg26Jp+5T1ga/ib38IAe8pZ1ZMY=;
        b=k2A6u/Arcq2AKmO0QkNa11ktG61L4T9uqvQywZepskw3G0/NHwytLyPNdpCyLRyBVU
         QqyBCJHbN0iORArKep6CsYpAT6TX9boOf2PADZmvw/tiVaxPC9XacOv2+I7RU3iKYNiM
         7bAXt8xpw9oDYyNg6oKuBeRpxPgHChAwPRZdgVF5GqZi6QHL9egFLUYYNpjiZ93q2Q86
         QkA7Pyaclb3R4Bw6H8SAT8KcI2K9CxHYYceLm4Dc7rnU60aGW9lO74Fc6VT+Ki+MlaTp
         1zOAgjuuAoh2NnBYhefzMDI9uS/e1+DSeQVdPYzAx1UzpCzRyoApxD+IVOi7K6Ki88ap
         nFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701139885; x=1701744685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6uV7n3X6HVLF/lWIg26Jp+5T1ga/ib38IAe8pZ1ZMY=;
        b=MZctyiRbspAq+3mJUJztvGpE2W5s/vHhajYDphvOhh6v0LVW+qsfscgYVnguuaRHmV
         tJDrMXkjHa70Rw7p8u4nZAzCddOwBQbwmAqk/ZwvLiEplkOgpwllI3XFJwD34Ac2rG3m
         vCVaSZa/TyiRze/xs7nf2FjQnrox3Ldc5U6E8QL+qds3eldA0DmBT7wbo727z0BB+ecl
         Cf5mpYKcGCzF+bonr5/ts/yzXwsnggElLoCbkLTkkA2vDICy62PxJKkIqignKkaWLcBf
         Z+tZvP/R9lrEPJoL4Zjwty8/LR7ugyQnrd+oRHU10W6lyjqeoPFQ90bRfrke9RDPFhv2
         eAHQ==
X-Gm-Message-State: AOJu0YwUzGKc0stgyAleUBiWGSHThWMxnvKIfwPW0LU4iud3ZecuCSEF
	0lK4BFxxyaKghrjLWbL/4ZY=
X-Google-Smtp-Source: AGHT+IEIc3+IcUWJtvyCPpyFZr95hglIiRWuef0qXvSKUbQfwJ24tMT9W5hOehFavJMwdZE4Ve0MAA==
X-Received: by 2002:a05:6808:2181:b0:3ad:f866:39bd with SMTP id be1-20020a056808218100b003adf86639bdmr18616249oib.27.1701139885358;
        Mon, 27 Nov 2023 18:51:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m23-20020a056808025700b003b29c2f50f0sm1695999oie.18.2023.11.27.18.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:51:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:51:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/92] 4.19.300-rc3 review
Message-ID: <bed5d4ab-0367-46bd-bec5-3234a8f3cbf4@roeck-us.net>
References: <20231126154323.146332656@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154323.146332656@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:45:59PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.300 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 

For v4.19.299-93-g263cae4:

Build results:
	total: 147 pass: 147 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
