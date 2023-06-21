Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0100F15B1
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 01:49:56 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-666fb8b1bc8so3907392b3a.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 18:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687312196; x=1689904196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ry3IPi7RV+RVDCpY68V4pGxA3Mva/4700DA+cxVYeY=;
        b=DMtfPyZC9ppzsUwyADd328RctyjiiOW/Y3ulct79Lme8H+P6wRF6DaYZHQoPvcFF8G
         aAelELigiyrzKMV/X5osFvRssKDMC9q5qAETjTq1m96meVG9HbeXQSg2LgFB6lzxtwux
         ZgcL0QQHwfSjdoxx2tbdO5h27rUEA0Sd+mlxSURFPo+OMApafkAwuK4JkEo+BC7Bf7H0
         WTbneI5tz73t8ultanibKKTAUdWVsuMJg5TR5e6IYwGLUIdNAas/p/6NswIHMsHHYbgl
         i7Zqww8AYxsuQpk9OLEQ8WAlN6OLzLWpsfMZIz5QnOup8j85/hue5S+zEdu8BQifr68a
         VKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687312196; x=1689904196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ry3IPi7RV+RVDCpY68V4pGxA3Mva/4700DA+cxVYeY=;
        b=MnqvMk82ebuEEERl99axuWJYAU1f3YU73Pj9eDuZhXMDOb2MfWXPMppt2eZ2vktAa3
         JnW1PAXcg+2dKR8OJx/AULPdiN475mJe95MvovUHoBgzAWtrLH11V9e3tmUvL9nKQDpX
         7BNl9cs9f3EoRUnPnbwPULpvkf59Tq5I+el8suCjGiB0qqlt2dMIV03vPUQViovih1dU
         idPVFpFoNYgWl/iMXRqVtEzNebN8zG0gDImXnPAgWSB32/RM408mFDdC3k+XIxfS+UO5
         NO91YFCQpBp8ChntYFiPuUi9h8xTmk4Ht79hpMfyMUfguwWYXrcy2Ewj4bCRVyb4Cs8x
         7cYw==
X-Gm-Message-State: AC+VfDws+6RwFKvsXNrSivJwrogpLaXSPXBxYX/A4t6BVGjiwia/Xgd3
	FLi17S11PwsY8Q/28TAPhGM=
X-Google-Smtp-Source: ACHHUZ4lYT5DHLkUs+qrcxPEFUiRY53k7N/A8hiFqIl2ggCrARtXsgsjcngVw7L9xc+4eKhYk/zwuw==
X-Received: by 2002:a05:6a00:8d5:b0:666:ad0c:c0f4 with SMTP id s21-20020a056a0008d500b00666ad0cc0f4mr19095048pfu.23.1687312196099;
        Tue, 20 Jun 2023 18:49:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d1-20020aa78141000000b0066875f17266sm1841555pfn.135.2023.06.20.18.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 18:49:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 18:49:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/64] 5.4.248-rc1 review
Message-ID: <ba1c3460-e06f-4884-9ec9-e990629622db@roeck-us.net>
References: <20230619102132.808972458@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:29:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.248 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
