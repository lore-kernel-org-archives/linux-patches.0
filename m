Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399717EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:17:40 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-794c7d95ba5so93646639f.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628259; x=1694233059; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mw3WQ4EC4hkue+S466kVN/YtcO9/qE8SLLorSsW+qHo=;
        b=HfGbJ9BgFTETkGkQZT22OduEVvTvMRvv6fF64IhwuZciZYSYXpbHHZo7MBu4HcgvFs
         MDprvwK5nJDk7InG/Go6lBi4cZuUM4wx4dDoltWbiHoBjU9ee9L9Xmq5b123kY5pUVWx
         LNZ9Kin+N1TV6cJ4+Q0X4DdGrLrWik1c8p5Jst00WgMRn3jpkIUzTrQ8pgPmz2Frstnc
         5ZIIfgJ+EfbxL0slqym/xfuWOfZcbAhig1GbsE2I03Xb6McEzIi7I8yQtXOqRIgOoEaY
         F5yT5RmQNaFnedlQyswrXhkVdMp30Fa02CPVOdy3LtBnnuIkwXrbi4c9mTKHbDPIOoVw
         Bf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628259; x=1694233059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mw3WQ4EC4hkue+S466kVN/YtcO9/qE8SLLorSsW+qHo=;
        b=RH7ZMHCdZzaG3gwrmYKhf8BwWbvRpqXJuZ+H4CEeBLFMb2TdDYxgLj0QbHUwkU47t3
         RqHaZpYtiqDwMnsH+wWS8mnYSF40genKiJ/ywQjV/OsDZe7uUEuWAK8qqg5sP8pbSrTv
         TlI7gnZXDyYvhviwdTEdk163STVakVihcbl/ZSH2R+kZY3+33L2KQjmkp0cY6fvrwEA7
         U0v3gHE8cfO/zDuruggJZUD7+ETwdgTFgIJbh9kD2F5GG0agHFimF9dGZJ5nGSqDjcAa
         QpjIHyIUILqKuIhZIg3jFG1noaBgg2ovsuv+xv8CicBhMFHMiVuxyq7klXmROqt416Qz
         YONA==
X-Gm-Message-State: AOJu0Ywf6EaCYn4TDW11gclFF1/5gg92oQgqinFaODGJ5w/DKgnpCJpI
	OzZhNeHR1agcwEndKvKgZHoi98bSR5M=
X-Google-Smtp-Source: AGHT+IHcOuWKNbo8LOHiD5iaCC0XwW0kguiWD8wPHfoyYoYGjbfwo+8xNebv+8juZU3rkX9b2sfCEg==
X-Received: by 2002:a6b:da16:0:b0:783:4bc6:636e with SMTP id x22-20020a6bda16000000b007834bc6636emr4432916iob.21.1693628259544;
        Fri, 01 Sep 2023 21:17:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d6-20020a02a486000000b0042b2d43ee3fsm1532196jam.82.2023.09.01.21.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:17:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:17:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 0/3] 5.4.256-rc1 review
Message-ID: <f5105d70-2801-4f49-a62b-bfac59bad9b7@roeck-us.net>
References: <20230831110828.874071888@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110828.874071888@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:09:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.256 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
