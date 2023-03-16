Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D0E190
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 22:54:00 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id h11so1843186ild.11
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 15:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CpyWpvKljiVZEIVgcwRsLc95PJlS+8X6+ZGw5mu8AUg=;
        b=NjQwuoo0l9k0MYmSvcOqbBoYtEvnCX3yIPogpYJboOjxeATLJ2LJDf6VyuIu+czA67
         lzgvg9HaLp4aDkdiOPLe2fm1Ft/K47j7wLwd00PD74lWZ2eXxLM4rgvqUiXQaSOTibtD
         G7F8rMyDLW1w9QYNDxxsYMze0FYSD/t3Prq6yWX/mUKJrdW/Jxc0RBsAA0K6eBiMdoCQ
         775Bly9svOi4a3PLmriTcC4uPEb9OqdfHhU4EZ/a1rSiWPOz14LpgKXoJ/DFhODNDJXM
         iINArsAk3/ftlxWs4WZGIubFgn8DC5nvJz7NceaOJa+tKT/QJqTbcGtqniFNxthKO1u6
         EX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CpyWpvKljiVZEIVgcwRsLc95PJlS+8X6+ZGw5mu8AUg=;
        b=mH+HykEXSPZ61fib0m1sy6PsS/hxgUktMO5/oINYEa/SfDLbf3wGd3Z9U1XpzkvvpD
         Yhcb2Qr9nnQaigo95JTKC84CVmPhhfudvnjBkkdDhEwSoI/LNfS9qV9WP+ZSK+zYWZzR
         ztJPNs6SbGovXQWYkK/Ip8mkhj/pUhXeISgAjZkdx82ZNU1RMJxatCaI9c/SgZ0JNmFe
         ficArkSKjf93p6tOEQyjpjBBdGj8Ein89YOMyuxitnwZ4fefqiX33EEnyMNguytCPACo
         RxC/3fGyoAN1RPtGA3a9BHjpQcLUdDbFVxxDz3zHqi9oWAOb9NVvawsfkcfIepL5JXQs
         +AMw==
X-Gm-Message-State: AO0yUKU91tDX0rNIHSVxObVsHDiPEIJHdasJTl2AoOFR0KNGmv7CjB01
	fNw1Z/qeQdS9Q9WaiG3Z7y0=
X-Google-Smtp-Source: AK7set+b1pq/XWEVekjZWaW6wNiqyaQos0i6Xgr+WpN3rNn4hIq9CP5YeN4FPVnSAPnTAPlJK8FM5g==
X-Received: by 2002:a92:908:0:b0:318:6d32:b12a with SMTP id y8-20020a920908000000b003186d32b12amr8336879ilg.13.1679007239362;
        Thu, 16 Mar 2023 15:53:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c13-20020a928e0d000000b003157b2c504bsm165097ild.24.2023.03.16.15.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:53:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 15:53:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
Message-ID: <f2a79523-b35b-45fc-9680-e7d0271d21d0@roeck-us.net>
References: <20230316094129.846802350@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316094129.846802350@linuxfoundation.org>

On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
