Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD311107
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 01:29:03 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id b16so391996iof.11
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 17:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677806943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HkH3s+ZPeSK2ETwzaKsgHIZ992yhpPipIE8vUYZJw2Y=;
        b=RtfAOKC+mJNSD/uhNtJYRRI9TVyniOecmxhygUNLsTlaAFt8o75McIkhfCuG1rW9yF
         Uu49DVgmOaXWXV/+FlLrzwcn+yZPcBszhAv0xhhDB+EQbaK/zMwZd4XiFl0bwtT/a/jI
         MbePKAf+imN1TZs67X2OA6iyc9exqnkUcNIj9GCCrkZZk6+u+Bx7qWzmeqdORb4KMcs2
         2lUCc01qYCOA6TF+FYbI+mWbxjkX++ywaACupJufsXDZWQDkdt08weZ+tDECOlH5LTO0
         DaBiqXEIau/+OlaWhKbLBlhlCI8KanEkkiBJ/xQkal7I8hbWWLmCyCdD17Y6ImpqXJCr
         CTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677806943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HkH3s+ZPeSK2ETwzaKsgHIZ992yhpPipIE8vUYZJw2Y=;
        b=UlJ4EQjIyAdwOfq6/pUqlxM9eGr1NqVBB5imdT01l+sUJ2mQgPZ4g1963ssk1oMU1D
         gS6thLK30kwV/OgMG8mn2Rdmq2RsaPXS8DlnBQjx2rNz/rbvCJFgvY6XZpa+EBMAwu8Z
         QvjIsWnvzmVHLdxn+uvyki4NmMbzpqXrVKdqjPhqLDqn9tCCu6tUW1i6aNnhfSqzmWjc
         BLl8Xj3redqQzMmb082Cvpo9+ETBL3/rxDvXJ73q55elvLl8GVZfdaBmSHKCu2kLisMy
         pni1y257TtjkvZLVfur91zwCJlpR88NieGFZU0Peq2bPKui0Lu1lhzr+6SHQSz1sIHG/
         bTrQ==
X-Gm-Message-State: AO0yUKUnQO8hBgXFnVyc7kG3wXAHF4n0y8adoQer+3GGpnRAt8Vktsul
	GJI1Qe65rnnhSG8Le+jYqok=
X-Google-Smtp-Source: AK7set+8vJqsimfDBLj2Ki24EIQx+jOP3oQ1Vr3i5u/Tlq52h7zM7Ku53IbNYgTBunG8ag8NOxaCbg==
X-Received: by 2002:a6b:e415:0:b0:74c:bf8f:4c88 with SMTP id u21-20020a6be415000000b0074cbf8f4c88mr8409207iog.14.1677806943078;
        Thu, 02 Mar 2023 17:29:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m10-20020a6b7c0a000000b007456ab7c670sm293056iok.41.2023.03.02.17.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:29:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 2 Mar 2023 17:29:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
Message-ID: <2ac79950-8503-4e7b-addd-dc1e31abbc5e@roeck-us.net>
References: <20230301180650.395562988@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:07:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
