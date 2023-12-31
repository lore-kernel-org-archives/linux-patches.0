Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76248F48
	for <patches@lists.linux.dev>; Sun, 31 Dec 2023 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2X/iCru"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d4a980fdedso7539875ad.1
        for <patches@lists.linux.dev>; Sun, 31 Dec 2023 08:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704040383; x=1704645183; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oMrjXLFyZ7sydj2+FYft9slf8SlVSgmYXTiwv8QTWok=;
        b=I2X/iCruVl7/8MQnlCGN2o1lr/L0vD5slwkJ80PPYwU3zPFGrac7Awx048zU3+tgbU
         XHRDUG1lNiNt06yJ7NIEtsO3U3+g9+PEwTt6LfjpBPHLPJJbfN3PXXE11pr5dttSQ0Xt
         odigXQJfGnaS6X+OdO59RJUFg556lyh9yllvemBCGf9sSIvtUl21XyRY6syHIb/aB5sm
         M/isH7zQ1Ir8xqlQR/mlf84r9cbwwMfRnTVbl6pr1v4qToTarSXiz3INMqAc1sJzKsVx
         JZyE1ay6glPCMuHPUD9tlQ+5Vc6ki/pjbkuU4z7JrqkXStdA5iM45UAkzBvp8Q7SFxxB
         FhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704040383; x=1704645183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMrjXLFyZ7sydj2+FYft9slf8SlVSgmYXTiwv8QTWok=;
        b=Q15IYHTH1plDigIPbDWcJrPGidoN75e6zbvmyNlYHvsAxRCEeS9ikeiMQ7T4CCJhB0
         +ZwLTlZ7jIhZG79nbZGVi52WEFPsxdzpkoyMn8PwKyzgvzpRexBtONoZ9sZEDBH4aMYY
         GUoQ/p1jAZ8dtsz8UKNm1rQ7WOmePdd6VLHifAdX/cOPJmqNNYlf4/C0xUl/YODZwzFN
         vvibz8Mp2yKC7IvZV5owhj7R8d6A41hqnygYaD8UNqZAeUPh12NVXjYWiJmnlbCH1lsL
         foHjkZZGqGwqvND4nQ4M/IIPyNChaC+cbbRacMKK2bXYzHjVZpiOI42lkxhc+EgBfxZd
         aABQ==
X-Gm-Message-State: AOJu0YyaSvgXrHeHzI09qrwxXuoNg89/NPrlmI3x7qb8M8CNOIZ6pNFp
	cX0K12gaTHaKRNw2tdEwDL4=
X-Google-Smtp-Source: AGHT+IHfurOYCOL7l5tsZ46Xzsi1qIHnQxh8Vlgqm97Wr86HJCTMy+dEkHLpy1g4RXFqDeH2HcgQoQ==
X-Received: by 2002:a17:903:41c4:b0:1d4:575c:45b0 with SMTP id u4-20020a17090341c400b001d4575c45b0mr15276162ple.91.1704040382878;
        Sun, 31 Dec 2023 08:33:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s5-20020a170902ea0500b001d45f92c436sm12005130plg.5.2023.12.31.08.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 08:33:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 31 Dec 2023 08:33:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/112] 6.1.70-rc1 review
Message-ID: <92966cc2-7726-4a31-ae4c-5d1b0a5dd0e8@roeck-us.net>
References: <20231230115806.714618407@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>

On Sat, Dec 30, 2023 at 11:58:33AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.70 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jan 2024 11:57:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 544 pass: 544 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
