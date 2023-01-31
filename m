Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9398F4B
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 17:14:20 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id m2so10761825plg.4
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 09:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4nqIRb3CtIvsLWjhKFGitAAchcs6/A+iijKpPzMEf20=;
        b=esKZbkF+UfWixaDAie55c2MJdOTDm9oVih+CmeGPR7r3+csDzm7cpyFt2RCBUPYaVn
         i8zUgvvSZp+AegcSYhk+Rc4a+JpFelAY0p0+2nRY+40GyBDr1u5zjP2Me2LUvObX84Sy
         XsBiNcsNlnye0P3ASXAK25hIGSuBA6ZI9REwjq96/zf3GUyLLN/3Ko0iW59zbAukTk51
         hjrwkBWV5IbVqI9khnEn0q9GNyMdzRtg0Z6569B1ceCvlnmpRCV3JJ278TGoKoGgBEAw
         FtbwfqrqEp621R/SG2tcDTNd7SMRZTSeFv+vvHEUXYPEZr1v5iphUuJ9NsKB7OjzR5P/
         hYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4nqIRb3CtIvsLWjhKFGitAAchcs6/A+iijKpPzMEf20=;
        b=XT8hdXC4G0KJkkM4rAD/7RrAvObk7zwJSNCOmt182OaAa9jxzq0fYF6Gdc1yqupv2T
         YRjIu4tKicxHZzXc4miD8uHjTSx+mQbqD7740Ivs6gpKnwTJJUKhXzZQ7fVELxDsAUI/
         3/USrSYJ0pqUKBhGYOEXl23gG02D8uBrwUEqioY2dxVtNTR9Zb3CdRNxZ6b/iXjPaDrW
         QqT6XZjb6gjSQbMs68NLpDizFeR9kPoVd4t7pBlZV7F/IP0fgvQkLoWf65RvGouhDxt8
         6u7N0TVjsbf4ro9Nq6d/NC//Y+CVr+b61WRDhQCpaeP05qciL+1GrwjJ3uQ5aC5+ppAS
         R+3w==
X-Gm-Message-State: AFqh2krIcWCQXy52EtE86DKpsReqlM47phs/9vL64g/DJwKfawI5keZI
	BXqHO3WBD7Qu+kol03vTURIc3MYOYscEoVdcs2c=
X-Google-Smtp-Source: AMrXdXtohwPAALWuxhqUE6eYe5s+7Zi2PXZvgqQm8RrpisbZQ8STLX/g8ewISBiT17eZ211IKbZFdJvRtobOqDr5Td4=
X-Received: by 2002:a17:90a:6342:b0:229:4c59:3eeb with SMTP id
 v2-20020a17090a634200b002294c593eebmr5783010pjs.51.1675185259668; Tue, 31 Jan
 2023 09:14:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230130134306.862721518@linuxfoundation.org>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 31 Jan 2023 09:14:08 -0800
Message-ID: <CAJq+SaDC_NRoom_vdiVT=JoXuBqGurhbyNfo28qsFXQDZ3ipZQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
