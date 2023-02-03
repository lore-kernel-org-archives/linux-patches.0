Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C78AD3A
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 18:02:13 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id n25-20020a9d7119000000b0068bd8c1e836so1593795otj.3
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 10:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElhPdy3HZ+tMC66D0gemUG0NJ36awklBIZwajDDuj7s=;
        b=f0AK8r8vs8eozo/g9nuqIK/W7TzHFx8/hO/ZKJ+fWZfQP+Tv3O9nMZj9A3cH/ZhOh+
         JUXUqzbvQBjhduPyOXf0iK3vHMnRAPgoKG2PtrQtgaShqDyYGzv7AH6r3Uie+uGN4bUd
         qkqwoNMd782+neKg69YbNKNj9tyjKX5Fn1WUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElhPdy3HZ+tMC66D0gemUG0NJ36awklBIZwajDDuj7s=;
        b=yh+TIZxXwETTEwxEaOJBZ7+qVFGxakQx/NG0RvCPA7tAhUQHn42al3lDvHxjas31dt
         IZSqI/jfrIrJNxPy+hKrQU+wCHHpQ13QRaB7uKPkpgWuwTjquvx355ziy6MpBq9/WXuS
         Z+hfUIbJI8uv3/RQ44MPv886K4buFH0iVggWmidyAof21Qr8rN0q8rPrDaVK7EKbWnmF
         HCt5LeWKcofqsZ+4ahRBumfw++lV9nRsW1mY8EKXlICvix4S7ZS/pLI+CXzzPp88jmuz
         2NEWHTVEfgygN6BBxuzSG0iWiUPp6Hu2uW+T+o5Uxpd3j6R4t479JcCFmDhKqH+Mjo4O
         9JRA==
X-Gm-Message-State: AO0yUKVk9Zwfo5BZEQQGzQBqMkEzTUIG36kWKgvLBXZfdqnynOjN019v
	f0zT67E9g/e22vrfpugGYCwZ9g==
X-Google-Smtp-Source: AK7set+RTVC00E1jPHi1Tlxiq2+cviCtfF+wr4WU3fLv/XOzfcmGOLhrWp4yINiCB07leT5sNOplkA==
X-Received: by 2002:a9d:758d:0:b0:68b:baa9:cc95 with SMTP id s13-20020a9d758d000000b0068bbaa9cc95mr5339413otk.5.1675447332290;
        Fri, 03 Feb 2023 10:02:12 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id b9-20020a9d6b89000000b0068bcef4f543sm1382571otq.21.2023.02.03.10.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 10:02:11 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 3 Feb 2023 12:02:10 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <Y91MIjq1Bgyq7jHr@fedora64.linuxtx.org>
References: <20230203101009.946745030@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
