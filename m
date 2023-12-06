Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B96EB4D
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdZ4i4hG"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5ab94fc098cso44711a12.1
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 10:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701888257; x=1702493057; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHSa1Vtm8ENnFSKNRrC+G4CYG5pTSbLbNbW2JCCKIyk=;
        b=XdZ4i4hG9Sh6S1am3+knp7OitIyKSTk/TE3YCdbGZTZMFYdqfEZralSSgWE+PB9MDg
         2p/QcycWobR3drQfdbZQQLAgjbhTTgg5jn+qs3NH9B3knybbo/djyNs8b1J+uQvHu6Qb
         NpLEQDyAqaZfuoCHRihqyCrDIrdLFWGoaFQkObqUcpJhViljDRw1lxLD9e+jmXyXHP0q
         ke4Ofr0nGoeBJGQml5TBMZMG3SFV2NKCV4Z7JTP31qJVm16RBKelfA0ncav17E+dlXEE
         rxn47PLxzeIFeIOOxR2k9eD2DNqUug/Xcg6LHzOq1cCKBEE39goOTUS5EaiFTHDpdAUG
         89Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888257; x=1702493057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EHSa1Vtm8ENnFSKNRrC+G4CYG5pTSbLbNbW2JCCKIyk=;
        b=vR4yvsuG8fftR6Y9K9qwaoKGe+D8N0SiMc9ZYUVESli3jwmTzb5cVD11IjM0hb4A6v
         PWHEahs2h68I3oK6oNFGvy1uyLtkG/Rv3581yIMbamjcVh/M/fF/a5v2pLt1kLxrnQdo
         7Y95QvcdVv9lCjpANdm5vM3qwNN9s45QA5WMch0yKy3ZnCeGxvzmjdIy7eUljzKM1AE2
         lcDoVkPawZcOGoJdQEGG8wxm6FJJwgNdGH6Wjb6sKAc7hFUCvcNPQbMBNT3l8EBpv+JT
         2zw2AMPfAPwEyNP/2JCLmuyW4malMUTrYmmgkirTkdHJ8Td2a1KiJo2Bi73ZTuCg9HIm
         jETw==
X-Gm-Message-State: AOJu0Yzjydp8LCSu99SYan8OdGMyWfm1aJNNDTJAX9m6MOFgWfrNERTZ
	LXE5bmEZhEwrIC4utKMqZk4=
X-Google-Smtp-Source: AGHT+IHjMMG40c19XWMzxRNZfxX9z6pZGjdTjpYc/bi0Fn6rgDx96b3o/qc747OkC+HKXk5fee5m9w==
X-Received: by 2002:a17:90a:3185:b0:286:6cc1:27e with SMTP id j5-20020a17090a318500b002866cc1027emr1072645pjb.73.1701888257483;
        Wed, 06 Dec 2023 10:44:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ok17-20020a17090b1d5100b00286d905535bsm177903pjb.0.2023.12.06.10.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:44:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Dec 2023 10:44:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 00/90] 5.4.263-rc3 review
Message-ID: <b34bbb33-5521-48aa-b32d-958d8da140a5@roeck-us.net>
References: <20231205183241.636315882@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205183241.636315882@linuxfoundation.org>

On Wed, Dec 06, 2023 at 04:22:16AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.263 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
