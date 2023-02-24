Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F31DD2E7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:46:39 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id z2so15544726plf.12
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 19:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/JfVS6gSRN9xdENO2plX3s3LFcs3qMQlJW27g6ZvzsU=;
        b=ZTEyjiTH+zXzYH6wSkCTrUOxnZHFWUgC2WuZrjzfVC7d5SlVwvIREtWWOZfGb7HvEe
         cuBApiMHt/oHw6gvpv9WQMb6AWfssrQ7RcU82VKS+fCgXgH0IwYzstsz+2AHFjnIqNIZ
         LfCJNEZ2opvJTJ1VV5gEFHFybw7wJRGZEl5DlBNnzdWBj4F+7Bceu42nZEoAxFQNoItm
         c7hY25NGX13iN9cUPUeVnr0ffeZn+LU2BPzrSSne1qxlLvcszgNGV69hjnfa62y3shzQ
         mehn/vic7u7506BpAF1bpnI0J+gtWxx5ztQgrF9Stncp1QYhhxSUkXchgg9+TDMNEQFF
         +qoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/JfVS6gSRN9xdENO2plX3s3LFcs3qMQlJW27g6ZvzsU=;
        b=rquC/qOZn9kW5m/ZJ7c2JZ43x1lwx1c5CJj83jKoeXm08qOu4Gx/KBuGJY4ibLjm2f
         PhTurUR3J01hNx/blAGjuWYAt25zsOqRKhA+2qz7GwugHDwa9kIPGkg9AkdELWgdIU93
         ZUyTovB4+0brziUvyFX7SKEjr9/sA4z264eJB4/+FmEFvO7OUR6Z++mwzGEBTxM9DVYy
         IkWGx6I8OElIebGZh1FnJKzaSbey0Mpv1I+ZWCNpt/6VICWcoyQC9xctdPsJNdLtnd1l
         Is6B9IKuhJzGB9jWCKm/394a9cLW1OuzvJBmCsls86G6aPwRUwR/BeDkRBWB11EZkXYv
         RonA==
X-Gm-Message-State: AO0yUKUBei9A4wsEqsb7KqjcgYMaUI2aQNiJB/+jKZzvYoUG1ZV166cn
	8r5SWYsEEhm39kQ0KQ/cdbPvMkoY8nqnJgxrMRz4Qw==
X-Google-Smtp-Source: AK7set85GZscAWYYUGouXn5Qr4Vng0Gl/yEz+Tbv5OH3JedjpuQ26qMIoJKnYHhBJU8VHI6Na/mSs5dHeh7VN0oqbG4=
X-Received: by 2002:a17:902:684d:b0:19b:f946:e57d with SMTP id
 f13-20020a170902684d00b0019bf946e57dmr2467075pln.11.1677210399139; Thu, 23
 Feb 2023 19:46:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141538.102388120@linuxfoundation.org>
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Thu, 23 Feb 2023 22:46:27 -0500
Message-ID: <CA+pv=HNryt092838xJmhop5501kCWaHsvEreYaDBJviTB_JVpg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

4.19.274-rc2 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
