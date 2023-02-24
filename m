Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E73AD58
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 19:05:40 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id b20so29292pfo.6
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HykiGP0bNNdihBWrRC8kDEBoQUKEGDmR5MQwZWpb6iM=;
        b=XmuEooqbVnFwDcjO2G4cLl9j4gn4PiEMo/wrSQ0reIrW5iDF+uD8sUnfI36tHs+AgH
         CJXhxOdal525riy1Nne8pwId0nugIFC9V6qd2gO3WadZAsKvCdetCpgxZmfPutuhzthU
         M9zLT9KehOfnZT3CPUjzmMcJGwfaudHe+3tmub9uLOIBfSiao6tdMqno70OsVWtFQz/o
         nw0J0/aN6Hr5DcBncwqhkDwNv3u3XdTdmii+ZwonEGQornlVLLP5ajOSU4RTWDMnh0Ij
         YU2JsI5A6itdFyMQPSiag+5UxfrI5ZlhpX/LE1JQx09gg8UZiVGtgXQoRdm30DA56QQo
         dojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HykiGP0bNNdihBWrRC8kDEBoQUKEGDmR5MQwZWpb6iM=;
        b=XeGfZOs0xJG2Cy+Ji85Jw/0DfH3cnkCXTzjIZNJR5eYlNBzdMcMBgzpWGRwOyHnWVS
         P07SczHUtHmCAbdNRX8eB3f+omYusX7mznpGSFCI6hQubmkHvhdaiQR3PX/wmH9K7tjd
         cRJSRdwmGG345Ziy0u8KzpFaIoKJpkSD9zv8monHB6wi+5RwiLNa67jVrWSt0Bv0DKCs
         ZSGqaIUv3aLVRPl4YD8bNeu0V4Aj3vJ0UhbhDE57HC4j6P5Wr6PnvBTc+bmmn4HriZyp
         A9KGcjKBCO3gRpUMFiDWwAUswKXenAue3RvIVjHTwxxLpOgYoMBRuJefLDOMNN5LXh0r
         4AeQ==
X-Gm-Message-State: AO0yUKX56x/pWFRikTZdv3mtdU7cxmeq/uniCNlToQpqrtJWnP2cnSpo
	CTWHkdf6euFw3YhLN7rAQAVXmFLzb/pZP0kYrgA=
X-Google-Smtp-Source: AK7set+Xd4sG2F75wprBCCONYAfJHr/dNcnLeof3gcRnFa+YIrlJ4neRUtfL7dxYgDlMGnSf9lJ7rMWhn9XAN1eXNqE=
X-Received: by 2002:a63:721d:0:b0:4fb:935c:67f with SMTP id
 n29-20020a63721d000000b004fb935c067fmr3226190pgc.0.1677265539938; Fri, 24 Feb
 2023 11:05:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141545.280864003@linuxfoundation.org>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 24 Feb 2023 11:05:28 -0800
Message-ID: <CAJq+SaCAjsMBrcqAkQU4y=Noh4PvrCMdB5SUVhAsD71byFBWyA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc2.gz
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
