Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB0933D2
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 17:28:21 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id g23so1906065plq.12
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 09:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yrIkiViylEgVu6ZuHAgyOCheYiQrsg59YN+MI+nDprE=;
        b=c0ufZIq2sgNi3qTiU/Xmc7FOpFVXquc1lNGuLhG1Q5T8HOKoPQ22tbICHXW2MGIBQB
         1uGGRYrhwJHffT7seCIt+lRPOawH7rwRpYmuksI4NOve8pG6TGuccYvJM8U4OQIWyyyV
         GQioQmFqrlXwhNBA1IckELxRi2d0MZxBNHbD07ItF4/D920V8nlhy5VSGLcY962huHMB
         Sxe6jvArbrnNBM25wRnTaeQElrJKRdjfUZLFA0kVvn6GjBHsz0AS9zK9dylqqoFqtiJf
         M4ayUZAvqzYbCQ+dS5uvLl3/BFz0J5kVgHZcIQ2igN+RF7HxXUoLID4cJTflNo29xPM3
         DatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrIkiViylEgVu6ZuHAgyOCheYiQrsg59YN+MI+nDprE=;
        b=b8U641XlSxjIbudfXS86BdbAvibFEFPQmeFbn3joojft0ONsGh/Xf1EINOzHU1TbmU
         elWsOzx43tf0lMoW3FbJi1Kv5MBQEkUMQgNHqJRMhy4bNYs3sWpwwRt6jqqrGqeIyPs+
         +LFk2SKOKN7vbwR13ZgTM4ctxtolbI3tmtfstZ4ryLvO1kjVSuHRXQCfq9v9uwsC5UhB
         4SJfbZUkfn6dumAgMv4qLCmw/JUxD+PCzTiLrF7Jr5VvCjVius07e9eTmfUeyOZnbIGq
         ofwBazeKDpT5KNBKQCNWtVHaK3ptJ4eyJosaD5ZXoFxhQY8ZePEyvhRjBhj+fEG+JPLl
         Hzsg==
X-Gm-Message-State: AFqh2kqOoU13QuJNwX20du7nEi+5mucmdlunflhbVsttsyKfc8k59KNb
	cQZh+tjWdRrDZbfxeGboqNILrxd7PBZlv3Crq6E=
X-Google-Smtp-Source: AMrXdXuecLOQ3peFwfbkliYpXmwQqXfiKu4JVnPUtGOEQ8OaH8Vw9YJ0/wHazgyiQahR7HS/wLEAMDErgVMcjh9ecHo=
X-Received: by 2002:a17:90b:4fc9:b0:226:85d6:e6fc with SMTP id
 qa9-20020a17090b4fc900b0022685d6e6fcmr2997258pjb.12.1673458099034; Wed, 11
 Jan 2023 09:28:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230110180018.288460217@linuxfoundation.org>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 11 Jan 2023 09:28:08 -0800
Message-ID: <CAJq+SaB6HWg7PJpMn6+k_mrumTOh8CK3qFKxmcE=csTZrn+29A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
