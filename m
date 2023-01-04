Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103A37F
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 01:38:49 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id r11so28496408oie.13
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 17:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xiJceqXb+ErDMJE6RdkUBkKlMsVUevK6KQODTOQeNE=;
        b=cgocR8kJne+v2LfJ1M+39Y+WFnzR2RfHzix5JcICL0w/SQ/MTmRVI3zy6as3846VKB
         UJ4rET4SgdihgeQ6qQQUYg2UDjq+ulOE5hBTCCGB3rkZN2Tv+QLCNr5FgjwLvVE7wung
         hSrD9nepNh0YS/faWkd5pRNUkBLvJmu01BWGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7xiJceqXb+ErDMJE6RdkUBkKlMsVUevK6KQODTOQeNE=;
        b=jOP9UqZib9qV7HO8UU7Gy9sE3C5HmWGOi+TweaO8bQvGGq5vPX0TL9EX9sCx8bU3kv
         JIaTnJBxIB6HxBcDKzEVFHDYTduLKmp8EPNfRHeCW9tZC57jOzFP5DQ2Gd5eFgQ1e2tD
         6KVzJRXYvhDrjf74z57EXZOlDyS1z61LNIWIDAyVt6rQtAunIFrYIj9/QvM5HKrQ5KCq
         HLT7Dg2kCvR+y1QO9jBF4xBFXUBJ63KC2g4C4jmO85frjdPIa0UKpSkq9jwKfEyttMqn
         oN5SrqMecX5Ri8410+I7Zcb9oxdVtnt9PuS61HZMklkbb6hq5WLs+3D3p828XV93JFvw
         Cubg==
X-Gm-Message-State: AFqh2kq1+ZRxiSsKKmGew7oTTfA00kjYV4T++N6rce+vgxQmCQ01m6a8
	TVlYqfWIxaDHEJoYi/zcedU63A==
X-Google-Smtp-Source: AMrXdXuEEiqD7YMLDJRG/moqiOTIvlKBHn0RDaHAY+4JnbJkovH7LLd3AlM4DQiO8DdZIIDGhE5JhQ==
X-Received: by 2002:a05:6808:2020:b0:35e:46d9:21bf with SMTP id q32-20020a056808202000b0035e46d921bfmr28869075oiw.17.1672796328975;
        Tue, 03 Jan 2023 17:38:48 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id b66-20020acab245000000b0035b4b6d1bbfsm13559979oif.28.2023.01.03.17.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:38:48 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 3 Jan 2023 19:38:46 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <Y7TYpnlZWQHBa1Lm@fedora64.linuxtx.org>
References: <20230102110552.061937047@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
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
