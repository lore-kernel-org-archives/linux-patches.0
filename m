Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EE52D02E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEspMKYk"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28041176e77so4549685a91.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383176; x=1699987976; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Q9inq432z5oHT34bxyt1VbDMPDDlVXPXNahD98Qs5U=;
        b=HEspMKYkSb1EMxj2mCIAcyZs3OMix03tBNvwIsG9CvHn8EBzP5sWrbu5XDA6Ge+IMD
         hEdVU0/1ayFtnOH/YZ2Q8F5kjnJhUJUnmzgHN81qn+30c0/USzhshyXcESq24qIX9wn9
         x3Y9XXUBcmqVv+YW5nPs16linkB9TFjR6nyTrgHlRXPMDkXNsi2i/N295/4ATByPaC++
         DpHbJmsCWInzBy0O5u7rToQE+2GVAfsNzOmEcU4MOzt2ZKOYxB/A6a7Q9HL1XDi7XgEL
         rZApvzKUQ7ZIZeq6DZZJRN5H+G1qT5YxfYvlCKnZh4KV50lPUWrGHAg+MjdkaqgncMNb
         MpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383176; x=1699987976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Q9inq432z5oHT34bxyt1VbDMPDDlVXPXNahD98Qs5U=;
        b=XP/Cf0mBRxDoEn8flTLNauaH7swuE49Nn97skh6ntUCOuUJPX8oJySkLk/3x0iwu0/
         +6HA2xQBkNfmRwHnzNnz0q6/feXafMwzwbpav6qhyHghgncnUVTgP6Op0Pw46QkLeZ6B
         uYFRv7pJTtpZC4fW3IUY2JbtQlmCTfLqkPyYiQk7rkomaLjpymMmeCRVlOd1nDlADxvK
         MYPF03SoifR6Sv1SbMQ79Gfw10NNhEQHwq6oN/2eZlsZV/L/F9U7DIYwSKDksDC0Gwr8
         SetIU8y8PetoFdf972gAL9fVQqZEBpXBTHMSck16Y6Qo5l3enJWpbPq2GtrKra+kga84
         hyeA==
X-Gm-Message-State: AOJu0Yy+75X80mtNZPkrYAROgxUmxPbEcNdaAMQixAe7COSGXi71y0iG
	XiziCOEhu4hK7IEWMzGFHKg=
X-Google-Smtp-Source: AGHT+IHMutGErqmrSjLk4urZUIoQ/J7YGHYvEJ+VyeukMn/gyM9fYHXc07S3NGbPmRSlIqORI2Re+w==
X-Received: by 2002:a17:90a:c90f:b0:280:256c:abae with SMTP id v15-20020a17090ac90f00b00280256cabaemr21310466pjt.40.1699383176083;
        Tue, 07 Nov 2023 10:52:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7-20020a17090aad4700b00280fcbbe774sm152993pjv.10.2023.11.07.10.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:52:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:52:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/48] 4.14.329-rc1 review
Message-ID: <3b7a2cda-412b-4875-9331-74112119e0af@roeck-us.net>
References: <20231106130257.862199836@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:02:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.329 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
