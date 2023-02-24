Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EA117C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:47:59 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id b20so7831810pfo.6
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 19:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YvnJfAXN7dbI96u1aUOT8Uz8u1lD2ldVL1eF7bXvzTA=;
        b=TZaziYMrTFJ/Emv9HOlF+iPYrj/mP7EZltBXnnJBhkLJXZlhenIFz0VeZuZxB6kNOo
         hsNE1TQy4Zvojni8+OMNjNgX8YE3a7YeU9BRzyWADX3MgGtD5x0feifjW8NFPRlLJipJ
         35ZyYOz6V9816hVGgZTm65Z0pComE9sGtvJ8YX9aL5aNFG3xZnWWTMa5umj/NcdNA29J
         UN0bnW5bRKeizDw8Mj54lALifB+gtHsIWqGwAeMppkVh/2NgrOd7i5amH2q6paQd4KIL
         Ik+nLrQ2Lyl7UvzoApnzEWXwYHjP1RV1608yPr3sydcuSK/g7tSOh7rPW3ouEksl3sUh
         O9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YvnJfAXN7dbI96u1aUOT8Uz8u1lD2ldVL1eF7bXvzTA=;
        b=GozIdGleViY9MoT/1rNn+BarIc3eVBVaL5g5YVt6b1CVop+gNOEE4uGVg48fYpPqyp
         xHXuV90qVZPuX76vnFSQ9/h4rBi132ZC1Anq9X8RVlTyeAX4gvuKeYiUXUVIytAScTrw
         8qkoC6CPcJhGc4onlGaaIdsWW0rZ7bd7yUJsy4XHwxfY+B66Oqg0tG3CjD2e143AIjyH
         qExcsu0gjjZ4AmHhY+gqA+/YXMZp6LSKbhe1cZQ8YM8GDqL6kQPqcQnGyDKBBnFG0Edl
         JWK2mu9vpUO7Q8KVkxCLj4S8iVwPsSzLmRwQ9VPE/lRx3P7ODqZBp5Oa/fvm0QMEkyJl
         mQog==
X-Gm-Message-State: AO0yUKWp31sbP8ctyd5RLwnabewVFOcY/l0ucwpf1Gjj4eXzILHPUmii
	Qp2Y4jxPseAyZVPj3Pz2fVliB2bcEQdV1MYZksHnEg==
X-Google-Smtp-Source: AK7set+4E3qR7YRqGWtswOJsb0v1VH/9DZqSi2xOqMlQBKbZalsC7ksSWhaJHGLddEjfxmY1fXyfL1g8iqLGEjnpbCE=
X-Received: by 2002:a63:3ec3:0:b0:4ce:ca8b:ddc with SMTP id
 l186-20020a633ec3000000b004ceca8b0ddcmr2447500pga.1.1677210478555; Thu, 23
 Feb 2023 19:47:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141540.701637224@linuxfoundation.org>
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Thu, 23 Feb 2023 22:47:47 -0500
Message-ID: <CA+pv=HN-M8Pp+qY7=nsi4tXOjtFuL5nhTyUQ3chtR+GZvDf3cg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
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
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

5.10.170-rc2 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
