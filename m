Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79D12573
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 16:04:28 +0000 (UTC)
Received: by mail-oo1-f52.google.com with SMTP id v62-20020a4a7c41000000b004a0a214dfbaso2471931ooc.9
        for <patches@lists.linux.dev>; Wed, 21 Dec 2022 08:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJmsn58xKPbGHiKrj82Ko5wI0bke7L5N3g2n349swQQ=;
        b=VKZh8Z+o5HVhAYyL+Km4C+pZUd+tLLpykKq2K/NWLT0ihGl9RzIOi5JSJAcyYXbrbr
         t5eUzkVG7RqeD9P5pckYLyBQYGRLG36GEjIUPTJJqHneXFr3ZcS4nkHwNvOCqJO44CHj
         sbXsoUOqo6DrXBuRI1E4Kj/ceWeGFfg+MFf/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HJmsn58xKPbGHiKrj82Ko5wI0bke7L5N3g2n349swQQ=;
        b=xjpK30gxAZvEU78tPdCc9FxUUpFy2bZ5ftxG5tR1z44M/M5CnFpJEK9Sz+mvJBota9
         VIuc2sT/5vew0tr6urE1MjIhxd4qWb3XNEO0XtRPCuxMJpI9tX5+1idLS2eAhiIJElRE
         FAXCXVBFALYqsKXGwWv29a/OGRUq7cKUlQaSa0Z4/ALF4UIRpiJ1keNJcNW8v3EdfBO5
         G1N+U68F9lyAc1HOMQHGtGKyzk8WlPhaSMgp/2Fn0Y3xRLNTdx9fwUmLvMUcaJnfDZe4
         6gygONDpFY7K57pOh9mRHcRNy1wWgTm3A/IFzs0OmEIB7I05E+bCnjCQsLv0X4P2ijyd
         Mjmg==
X-Gm-Message-State: AFqh2koNzGVd9SHU3hOC4f33NaFbHEGwTJTTaM4V4qAtiiZfWawMfK79
	HRy66MWiIaLuXxrgQ7CMOmFZVg==
X-Google-Smtp-Source: AMrXdXvFCPfGpZRQD5dV4PjhY/izAVNd9gTVAqDtT3zxjxX8W42bImEfLYj6CVX1qzV+cfy5caAGYg==
X-Received: by 2002:a4a:43:0:b0:49f:8720:d5b2 with SMTP id 64-20020a4a0043000000b0049f8720d5b2mr1070027ooh.8.1671638667751;
        Wed, 21 Dec 2022 08:04:27 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a11-20020a4ab10b000000b0049fb39100a5sm6205846ooo.37.2022.12.21.08.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 08:04:27 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 21 Dec 2022 10:04:25 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <Y6MuiZJZ/6wLsXpu@fedora64.linuxtx.org>
References: <20221219182944.179389009@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
