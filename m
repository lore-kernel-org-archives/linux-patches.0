Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40727708
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 21:12:26 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id v17so69800plo.1
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 14:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SIubiPo7zT5JJe+L0CchJwTPpEdYLEw2sGAtp4350gs=;
        b=CnB6/zwTWr3MfwsAQZrhc9un2x2CcquEJn9y9MBorfQM7i78853QvADCeolFY0bc0e
         iYfdfH++uJHK8GwANGol7IStY/laYsTMdnlKzfvrYJ9qLYO0IzDena0YckpY/LDfqxmy
         ylwLVRM5xRZWalbXojFg7qMp7cdA/ruYqA0YmwOtcSF+OWcRLb0uPhP4xaxG4n1j52So
         GK7AIebmbcO6uXFGWSGF+sIkKiLFm6agGwZIhG/G9BCP/pOG0tUmbxOnCMBsS+kWYeWx
         IWUoOju9ClNC7I0LSEIloD5EwxZ16z/yLU2IyrEOKqaTKVWU+5es6mPiIzc9b/cTQ8wY
         wvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SIubiPo7zT5JJe+L0CchJwTPpEdYLEw2sGAtp4350gs=;
        b=Ba5ilJpADJL/0woMQKPAEr/ppggAwphg9IKu3FKZ2D4p0zuaV+2JozXsqAJk7uqIPS
         fzTKy+AfhkAHPXu7EzABZThiiIcqC9hQ3yvXgOj/bvGbMxFxaCMIfugXzGsp1WA85xZL
         Kc2c12M8j7Fk5pVY1C6jYMN09cXArKhc3mpg+Sdl9KmR02w7KORnk68j/tYoEGEejOAl
         T8oBRuUvgWvzQfjzI9YrQtn2B/bpox+WMypnoFNPCwc1eCrI6MwUxWC3Zip8A0tgc4sH
         3j0iLVmjrISmw18YSI08Uy3qYLgQnQnxIPsYm9oN4yhpp0OYqbyuAyX6mNfG+ktdCKaJ
         AuvA==
X-Gm-Message-State: ACrzQf3coStX2YblIUofuquBVptu/f63bHAzIcA+INIeHhgmXdN+Vpfi
	CDIK2w0acDPhkdmB7fNDHhU/gsgG6tQ5G4puXxI=
X-Google-Smtp-Source: AMsMyM4YZX18r4YFJQuWrrBszdVvGlOIfto5QLEius64s8tg50mFMIPYT4/u+gUPDqnMRgfRlZcilBoc+qmwqpBb4qw=
X-Received: by 2002:a17:90b:3144:b0:215:db2e:bc6e with SMTP id
 ip4-20020a17090b314400b00215db2ebc6emr1855922pjb.12.1667423546267; Wed, 02
 Nov 2022 14:12:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org>
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 2 Nov 2022 14:12:15 -0700
Message-ID: <CAJq+SaBVDr99kcJ-XacoGc0Ah9Ur1eOim1jG1Jf319Q9Qh0Jjw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
