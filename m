Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975CF4C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 16:20:42 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id s8so1773652ilv.10
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvy3YpG6fUfsNhQdLT4uSWASabiPlYT3UrmLmjXm6og=;
        b=IdJWNTKxjvxJcywtwglQBUyWbO9cOEP3vGfkHalfnXvaCJjKrJrJZSZ29wxDTRDlX3
         ywh34N/qYtJ9krPU9lR4I263YK14US9Hd9HICz/YiCC0SRWe21lGu43PPpnF291TPT1O
         Dve9OI/LxFbUhEE2eoyGFOEoL4vKayJjrU0qduOOyxtL84OHjLWzulVo0RoAh/PAEcNO
         XKvWi//1jiLMP1Wjk1KglF/AxVS0OMFXzhCQ1/2wd/AgWXYuKXwfGlSk/OmSmlmMPaHY
         4J/+j5YPy59lpldIJGDcFCBHvOHOu9K6Cn6e8uCDTCxTJaSTUAMC3yFzERyUkv8GYM65
         RluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvy3YpG6fUfsNhQdLT4uSWASabiPlYT3UrmLmjXm6og=;
        b=AS7d0nPq0yR+Bm3spyd421Q0VPl/3SduzbFILosiXG+5lyNRSuf25fq7qNbApyDCrJ
         ljQt+HqCj+q+n+IaTExWL/DtWFGaM0j3fxC00JVYVObNc+O5sub5dNSSVCsn42jNriWq
         D9YpYzGTyaCwAYirttflN10NKTAWMhGtO0kcjU7L33v4n369NMDEcqOQx7U1ve9UBPn+
         zdo2/DsIAtUl/J17X5t5J5W6RNS7+Df0jgao1afOq8vHfI9nmIXgY+4663SwwASfuixm
         3dOi9fPU2OgsGVkkhuqg4Xyp2Abc2NCXG+FsqO5BlOnVCE7u8FXfWEsbFyTEuN821nqj
         ziOA==
X-Gm-Message-State: AO0yUKXSJhnmX0PKg47YCS8EGvAap7PPONETs2F7NEUBPix9m7qXNNYP
	PgftI0bIWg0Eo1If4ICg5+k=
X-Google-Smtp-Source: AK7set+NbUBthW2fUIHGs5Yt+sBytF1d2+YkSigavPKpcfVcZkR7jcKCc7F1A+dpadvZPlELHHleXA==
X-Received: by 2002:a05:6e02:1849:b0:316:dc3a:fe80 with SMTP id b9-20020a056e02184900b00316dc3afe80mr2533906ilv.0.1676996441657;
        Tue, 21 Feb 2023 08:20:41 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j7-20020a056e02014700b00313d32f8345sm1926175ilr.66.2023.02.21.08.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:20:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Feb 2023 08:20:40 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Message-ID: <20230221162040.GC1588041@roeck-us.net>
References: <20230220133602.515342638@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:34:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
