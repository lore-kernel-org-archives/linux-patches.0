Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734DE7B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 16:38:53 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 141so24945308pgc.0
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 08:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ElQLm1bEEQyEGfnTuG8KWGBTmNlKMxnd1pxdVxQfdlc=;
        b=C9BK4foCMALXszUpeGRdyt/EPpDmXUmv9gUXHKhxhbNHvEt0pi9wx3/si71AntsU7Z
         xDaNR4xzWvkh+K8laG7LKl/RfCdLnTJQc73N46yGMbROy0wD/sPnNhYNb2OjrbQ7c+yp
         qDnifb++/ZwBcAaPlfbD7GKzXuqPQChZloivW/IDAM2QZMp1oJn5FlqKnVCr3B0sVkzh
         SbL8BjhVmIco2n4nWs/ZxNzPtKOXsWrrnYsgmGM8gtwdBDg44fFP65yf2WSk+KumCnWx
         5KQ1ihPFRAhMY0mTydlyUfRnsY1YidE6xs6Mf6nfleNxByeN3EYk9NSflpt1eYbMT+Gz
         +l1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElQLm1bEEQyEGfnTuG8KWGBTmNlKMxnd1pxdVxQfdlc=;
        b=P2/cI4znAqxrLmX4eGXx5KjBMtDCuC6How0sNAmJzwPPiBMUMs8+fXxdR+BPRkS9Oy
         s/KLRRKQb9lk+CbcX2y4ftZsGgmlA2SEDg21W2jcEnlHhfLSqGF+TEgFwvVIMXpGj/44
         c9vSQogmD7mVXDiPRLZGwXTOkBA+ssAQfGQh5BpcFUL4qtPnk7xSNfDwpi7TJnsqkAbQ
         TtbiON+GhB9YPbeu/jpQEGESpBdLYpicHaE0KaXixJ6deL+7KwnEzdHGoMiygKX7l+d9
         y6vTURLXet8B1dhnbd3Bkv/bpLhUaDWXN54D9Mrw4PIhJIMfFZ7JoLDRavTjnZLxrnGs
         ABmQ==
X-Gm-Message-State: AFqh2kpftvXqp1Nu2gCrmUJEWUD7xDhO8H7QfU09LWGzYhzKMD9d3HPi
	AnjmGmLMX+W/Bp3RRtojbb/R7ziJzBBju4C7aLc=
X-Google-Smtp-Source: AMrXdXuj4Set7eAlseRnIV1xV5bdym0f6Rg+/GJ16smJ3j4Mf/IJPNpvWeGt2soVY5rmLrgtUpEhWPf7qjkb4uY3IfY=
X-Received: by 2002:a62:e40a:0:b0:580:8b92:ecff with SMTP id
 r10-20020a62e40a000000b005808b92ecffmr748474pfh.4.1674059932918; Wed, 18 Jan
 2023 08:38:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124526.766388541@linuxfoundation.org>
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 18 Jan 2023 08:38:41 -0800
Message-ID: <CAJq+SaBwSL+chM14Dod7qZRSuYSS+KE4GAPrsQi89OpcOp-t6w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
