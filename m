Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37073224F1
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bRPQEIId"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5a7afd45199so49394457b3.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 11:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698171142; x=1698775942; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E3EYlEUXN/TtJ8i/q/rreox/HAhcUMuzowMifNS8GMc=;
        b=bRPQEIIdFZKv4UcL7wLgD+GVSZmAD2aaY/A7lOMnlk0azuCg2woxXvxS2KFCwdpQO1
         /ZbC8Km5sxc9zyjHm70dZ+ouTvGomRkzqSWz5FVgJ0TCTp9rU4+daxeiT9w+OSq7uStI
         qOSRpmw6hbv1LqzDqMdt8imKZKpyluQQH9eLRw7I+lY8Njki7pdu0iol3ns7ztJraRP5
         L8DTIfPkC+J6tDQuucHUqGo0/vqIzULLn+bRu+UV8MHfCZJ1hFNAtkXQ67lqYqmG2kOx
         Dpw/FV4iFMaHBPDDilpr6S6plLoGFrSxfvwsL5+Bq8g0DzrWmxCpO1i05RLHGzv7syp3
         T7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698171142; x=1698775942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3EYlEUXN/TtJ8i/q/rreox/HAhcUMuzowMifNS8GMc=;
        b=cNSt972XxLopXYkvILEpgB0z74W/8kPLLmPlzQEsvgfIUrwaHzs44ft9KMl9Sb43c6
         /cMaURBYurk/x39qzWcc7CEUCB6Pe3M2D0Y+XO74Efk1xWfFQv/PlAmqbLdp6Ja/w/CQ
         gMsqA8WcXL21jARpOmIGeoHUJ9theWwzY1t+qPTwy+bllDTRSZlqirgzOfwIqBGz1xbu
         wwT6lrPnJRW4YNN5f1lTTI10m1yKiduQUcRV1kD5SFHklF+Kq+m5R6X2mLNdAAaVPd7m
         gMHRdpW/gvw7TXV0TZtap1Pt/WUIDvthgMTwkl3DW42w8r48RsJ/gaqSaSSL94B9Q41k
         D8xQ==
X-Gm-Message-State: AOJu0YyNO6DdkbumHoP/iyRlHxoxsIetBfl8+IrSTugFoG5Og3rSR/I2
	SyeaLC8EsMf0f2SpeAiWYyA=
X-Google-Smtp-Source: AGHT+IGOfSgpOJ9UZkmStpd+Lyqgg4laPuyKw/q+P0QvkoKNB+/BPcz58iI8PlfdndlRRhfF14/lZA==
X-Received: by 2002:a81:8415:0:b0:5a7:dad7:61dd with SMTP id u21-20020a818415000000b005a7dad761ddmr14071882ywf.20.1698171142163;
        Tue, 24 Oct 2023 11:12:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o188-20020a8173c5000000b005a7dd6b7eefsm4245315ywc.66.2023.10.24.11.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 11:12:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 24 Oct 2023 11:12:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Message-ID: <458d7cf1-3e6d-467a-be84-5053f730533c@roeck-us.net>
References: <20231023104833.832874523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>

On Mon, Oct 23, 2023 at 12:53:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
