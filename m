Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37381FBC
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 11:04:52 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id u3so905865uae.0
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 03:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wnrwfiCPx7vL+qz/J1ZaOtVtgqhukwB1qeXvDIQyZGo=;
        b=oxTdMXY9RjdoTFpjfLHxRYwBYx2BDlYAdVzmsIWSIppFdAgcmhtjbRvQ3oOxN7i7t1
         zL7pc46FSr5hcUBefjrWpSGoUaUIDoMdgQGlJsRsJ76ZYt+LOnY3rP34yhAa+93TtOVV
         LP9k88clQFViMdEILQJskXeHjynXHNd6iq/RbpJyZGusBlntR2SfxmcDm5z7V71vRxYW
         E5xDX68zdZKhglajGdbuQAbih6jwrY9DECDOL/ODcMbQZ6aVqm52zzkXkQ6pHUIWrV3N
         eV/V/6tEw9XAn1Nbcq2jJ/Rt2EsOZMk1Jvcwq92FpI1I8C0etXaqITKCDT79j6UB7gTY
         MvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wnrwfiCPx7vL+qz/J1ZaOtVtgqhukwB1qeXvDIQyZGo=;
        b=aIpnJYj7+voZGDguh2g1D6HQ23h3wyR66NlMTrX9pgz8Oy7/lGFtFtYMNzvBZjmqyo
         hXjLGtmt1J0x8ul4tXfPFtl3DRo1N+WF8eVtEJuGQ4oSNNh189uUkoYgCQcRpEkopBn3
         LE4y+jHWrU9u0LFN9kg+BdCqjbx2MuzgfxLkGQ9r3ue1pDiQ88Z7mLUdA8fYyMsdZJL3
         ua6sS9A4BqyQ8DmvYR3d4+kJH6eMIqsv3Dh2Guw7zsu1EfpYf47oD8sEZZVBQ/10a9+o
         KTYFXILNHIRIQbMi2GjijxRrnsDYUUUhGwrosrMemwQCB53hKG5RxN93ITgPKE5dfOML
         qmjw==
X-Gm-Message-State: AO0yUKVANp2jeAkLM+vso2XFxkIdfwHEk3G07+4xby0wqnfRvwNrc+zR
	qzI3eiUgQesc5Dbfcqz/WSnMp+LLATqeav2rh7f2Zg==
X-Google-Smtp-Source: AK7set92aeZ/0wrMCHop1qBlba0EQ1xdx/6wHYhZYAkDlHH+pESAFsHybxatTahoAeHp/QIkKSBkQhCILu7YGoc5iDk=
X-Received: by 2002:ab0:2059:0:b0:5e3:bece:86a3 with SMTP id
 g25-20020ab02059000000b005e3bece86a3mr1478802ual.48.1675422291331; Fri, 03
 Feb 2023 03:04:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203101015.263854890@linuxfoundation.org>
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 3 Feb 2023 16:34:40 +0530
Message-ID: <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Following patch caused build error on arm,

> Gaosheng Cui <cuigaosheng1@huawei.com>
>     memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
function 'devm_clk_get_enabled'
[-Werror=implicit-function-declaration]
  297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
      |        ^~~~~~~~~~~~~~~~~~~~
drivers/memory/mvebu-devbus.c:297:6: warning: assignment to 'struct
clk *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
      |      ^
cc1: some warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build link, https://storage.tuxsuite.com/public/linaro/lkft/builds/2LDxPVbsGpzKKtYLew33pC6wCSc/

--
Linaro LKFT
https://lkft.linaro.org
