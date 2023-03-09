Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BECAC28E
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 19:53:09 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-17683b570b8so3442367fac.13
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 11:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678391588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvMVuj1YYfAwGHDiRte1xIKNtCoI7g0aNfnni9Ql/Lw=;
        b=WqAgLHW8B0jrm/YOu7zDvVQ5aK4NBR3+MzQkrRkeeFyN0skUylsiQX9KKfQ3P43tfP
         PLCPBvc9qleOMaESQRGFYgjzc0JseN3+aPI7Cxo+53CcbuITtxzMMo7OdH+bvsG8SkQK
         E6QPDphMq6BqUg5wu6O1OFxlZIuooYm/C8miqR3oa9benAXKQX0AVUvvr9pKFZkAkP49
         0OCjC2tbUZAvPDGKWBRry8E5SDdE20up3gL36H6k0FwItaF3jJNQfGcmpH6iK1ayinfh
         wKwmPP/ltTBW81LnXIipeShGqiKqJp+WiTZ/+f4Dap2oYY4OKXtMX2mNj0eOr5FeVhaK
         MV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MvMVuj1YYfAwGHDiRte1xIKNtCoI7g0aNfnni9Ql/Lw=;
        b=kq77djYXavFbwX/P65Y/rg0pJ19AMNFienlJQNISEH2imb0eoZk3NTumWfFKSmicVW
         mE8Med/YGFuR78QCWHT5AWlRZ3ZwqF/wDGexKYTAn+t0NyKWzWSSq78IhbJdTYnVJqW6
         RYdeBEoPcom80HCc8LIiwknXFdF3ybwhG0tcpMx2FjwKXdvWnOnwLs1ZAbR0DGby3/bS
         Dt98j1bdYKwXAfSezylX7iUdnvJSRI5/8PKp/+TFYFgrOfgpc2HJ4oG8IzsPX8xvaQUp
         LiOTX2ACdctGwjsZ+1xIdJsDfyHtl1BRa1m35RfMGRBbhUP8TYSGn7QQmwu5uwxbLWva
         9D9w==
X-Gm-Message-State: AO0yUKXhUpaCE+vri7akKALFTv6eLwgtj6pnZdKHa6K1RKdCPix4caXS
	ODks+CxXAdw/coShu8Wxe58=
X-Google-Smtp-Source: AK7set9ywH0iPXbx8MLsKKqviQkeTLzJRDrBRAxLuJBw8HSmq7UChKtBfFkT18N9TWB3movRkBUPdg==
X-Received: by 2002:a05:6870:7394:b0:16d:eac4:7b5f with SMTP id z20-20020a056870739400b0016deac47b5fmr14214221oam.48.1678391588740;
        Thu, 09 Mar 2023 11:53:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a18-20020a05687103d200b0017293fa734asm98142oag.48.2023.03.09.11.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:53:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 9 Mar 2023 11:53:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <2816288c-1701-41bf-ae66-53cf5d2a9fae@roeck-us.net>
References: <20230308091853.132772149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 516 pass: 516 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
