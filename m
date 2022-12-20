Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B64C4C75
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 15:33:04 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id o5-20020a4a2c05000000b004ac6ea6c75dso1754885ooo.8
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 07:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=suyFY8xw9UxN+N9G3efEmh94rT9pPwpzgTHk6VM1Dqc=;
        b=CIleh4Apr8LRwfvI+A+BsYTd8i+SO+iVA99bQOSI4JQAHRn00el5BF74vki3nnnQWY
         banuUqWAjPRDPdL8dzb4s3OqgCEKOyXs818a0XC83NfMZuGCbPaFOPpEAMHFqLwUP8qV
         Tpet8LXYFdPAdlsTNpNOWnJR96Nz/xQep1lubNOKqVFu8YhDdllvDH9mAFVZWQJZzh8R
         cRcduHW6iXhNpJtqbljF+TlwS6TCJjVHC8GfR+bI6rmI22Qubs997URFoo+5G8Qv2A3A
         UXdTuHKLUo5fTvGtBEupnxRaTN2W4HzSEPlAVO2ZNpsnCGsZ+vAWIXMhNKJ69+13h5o7
         4dcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=suyFY8xw9UxN+N9G3efEmh94rT9pPwpzgTHk6VM1Dqc=;
        b=Ls4kUej85TMJacasgODwy5Mv293kh+LMVb4djHAjakGsXpFg2O/xvnkQ2qHnr4kPYu
         4T3qmFxFpgGTH8XCRU8GWMT4/3aTBGKSTo692UOgr2IZPQjyhPYIK+BaFi2jS+88YTTn
         Hs2db/iCOq7qXLuvJPRbd9MQe9a3QzYMswhn76Yu0c06PRkSK2oYj15gZYwIgKp5hQtc
         4Fv1dnnb4ZL3sGzF2im5TjMw4V3nqVJaxOjJcaBNZRaD28EPvGKBit5izVrEywBgUi9p
         z5crjuSqp9sHYGW1ATHZu8wVr/15OcVNnZnMOJR0FE4ML6l/BdePGNDMGkQITO++KbyT
         IA9w==
X-Gm-Message-State: ANoB5pkikjEm0GPMptX5EQOWBCIXSSeljg8RZuEof9oTzg4Ua0XBAIms
	V1tI97y9lZpmuFXigN2BoY8=
X-Google-Smtp-Source: AA0mqf6A884VIUJ2aHIMNtCymsgMVLg/Y+NGc14jOkcXUYSbZVFFvdSEPHpAYHEIkM7ElnSyrNgM5A==
X-Received: by 2002:a4a:d12e:0:b0:4a4:9a57:8eb2 with SMTP id n14-20020a4ad12e000000b004a49a578eb2mr12778900oor.1.1671550383589;
        Tue, 20 Dec 2022 07:33:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n14-20020a4a344e000000b004a5811080dfsm5156134oof.40.2022.12.20.07.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:33:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 07:33:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <20221220153302.GA907923@roeck-us.net>
References: <20221219182944.179389009@linuxfoundation.org>
 <20221220144900.GD3748047@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220144900.GD3748047@roeck-us.net>

On Tue, Dec 20, 2022 at 06:49:02AM -0800, Guenter Roeck wrote:
> On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.15 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 500 pass: 500 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 

Wrong results, sorry. I'll resend once I have real ones. 

Guenter
